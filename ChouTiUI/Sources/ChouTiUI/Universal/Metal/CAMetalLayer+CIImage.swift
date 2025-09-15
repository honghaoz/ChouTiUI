//
//  CAMetalLayer+CIImage.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/11/25.
//  Copyright © 2020 Honghao Zhang.
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang (github.com/honghaoz)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import QuartzCore
import Metal
import CoreImage
import ChouTi

public extension CAMetalLayer {

  /// Create a layer that can be used to render CIImage.
  /// - Parameter frame: The frame of the layer.
  /// - Returns: A layer that can be used to render CIImage.
  static func makeCIImageRendererLayer(frame: CGRect) -> CAMetalLayer {
    let layer = CAMetalLayer()
    layer.configureCIImageRenderer()

    layer.frame = frame
    layer.drawableSize = CGSize(
      width: frame.width * layer.contentsScale,
      height: frame.height * layer.contentsScale
    )
    return layer
  }

  /// Configure the layer to be used as a CIImage renderer.
  func configureCIImageRenderer() {
    let layer = self
    layer.device = presenter.device
    layer.pixelFormat = .bgra8Unorm
    layer.framebufferOnly = false // required for CI
    layer.isOpaque = false
    layer.contentsScale = Screen.mainScreenScale
  }

  /// Render a CIImage to the layer.
  /// - Parameters:
  ///   - image: The image to render.
  ///   - renderSize: The size of the image to render in pixels. If the image is not the same size as the render size, the image will be scaled to the render size. This value changes the layer's drawable size.
  func render(_ image: CIImage, renderSize: CGSize) {
    ChouTi.assert(image.extent.origin == .zero, "image.extent.origin should be .zero", metadata: [
      "image.extent": "\(image.extent)",
    ])

    let layer = self
    let queue = presenter.queue

    guard let drawable = layer.nextDrawable(), let commandBuffer = queue.makeCommandBuffer() else {
      ChouTi.assertFailure("Failed to get drawable or command buffer")
      return
    }

    let ciContext = presenter.ciContext

    layer.drawableSize = renderSize
    let bounds = CGRect(origin: .zero, size: renderSize)

    // if the image is not the same size as the render size, we need to scale the image
    var image = image
    if image.extent.size != renderSize {
      image = image.transformed(
        by: CGAffineTransform(scaleX: renderSize.width / image.extent.width, y: renderSize.height / image.extent.height)
      )
    }

    guard layer.framebufferOnly == false else {
      ChouTi.assertFailure("Layer is not configured to be used as a CIImage renderer")

      // fallback: render into our own writable texture, then blit to drawable.
      //
      // note: below code may trigger assertion failure when the image is generated from a fractional size.
      // -[MTLDebugBlitCommandEncoder internalValidateCopyFromTexture:sourceSlice:sourceLevel:sourceOrigin:sourceSize:toTexture:destinationSlice:destinationLevel:destinationOrigin:options:]:497: failed assertion `Copy From Texture Validation
      // (destinationOrigin.y + destinationSize.height)(451) must be <= height(450).
      // '
      //
      // let width = Int(drawableSize.width)
      // let height = Int(drawableSize.height)
      //
      // let desc = MTLTextureDescriptor.texture2DDescriptor(
      //   pixelFormat: layer.pixelFormat,
      //   width: width,
      //   height: height,
      //   mipmapped: false
      // )
      // desc.usage = [.shaderWrite, .shaderRead, .renderTarget]
      // desc.storageMode = .private
      //
      // let device = presenter.device
      // guard let tempTexture = device.makeTexture(descriptor: desc) else {
      //   return
      // }
      //
      // // Core Image uses bottom-left origin, Metal uses top-left origin
      // let flippedImage = image.transformed(by: CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -image.extent.height))
      //
      // ciContext.render(
      //   flippedImage,
      //   to: tempTexture,
      //   commandBuffer: commandBuffer,
      //   bounds: bounds,
      //   colorSpace: CGColorSpaceCreateDeviceRGB()
      // )
      //
      // if let blit = commandBuffer.makeBlitCommandEncoder() {
      //   let size = MTLSizeMake(width, height, 1)
      //   blit.copy(
      //     from: tempTexture,
      //     sourceSlice: 0,
      //     sourceLevel: 0,
      //     sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
      //     sourceSize: size,
      //     to: drawable.texture,
      //     destinationSlice: 0,
      //     destinationLevel: 0,
      //     destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0)
      //   )
      //   blit.endEncoding()
      // }
      //
      // commandBuffer.present(drawable)
      // commandBuffer.commit()

      return
    }

    // most devices allow shaderWrite when framebufferOnly == false.
    ciContext.render(
      image,
      to: drawable.texture,
      commandBuffer: commandBuffer,
      bounds: bounds,
      colorSpace: CGColorSpaceCreateDeviceRGB()
    )

    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}

private class MetalPresenter {

  let device: MTLDevice
  let queue: MTLCommandQueue
  let ciContext: CIContext

  init(device: MTLDevice = MTLCreateSystemDefaultDevice()!) {
    self.device = device
    self.queue = device.makeCommandQueue()!
    self.ciContext = CIContext(mtlDevice: device)
  }
}

private let presenter = MetalPresenter()
