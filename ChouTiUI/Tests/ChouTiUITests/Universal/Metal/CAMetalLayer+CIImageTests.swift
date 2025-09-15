//
//  CAMetalLayer+CIImageTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/14/25.
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

import ChouTiTest

import ChouTi
import ChouTiUI

class CAMetalLayerCIImageTests: XCTestCase {

  func test_makeCIImageRendererLayer() {
    let frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: frame)

    expect(layer.frame) == frame
    expect(layer.drawableSize) == CGSize(width: frame.width, height: frame.height) * layer.contentsScale

    // Test layer is configured for CI image rendering
    expect(layer.device) != nil
    expect(layer.pixelFormat) == MTLPixelFormat.bgra8Unorm
    expect(layer.framebufferOnly) == false
    expect(layer.isOpaque) == false
    expect(layer.contentsScale) == Screen.mainScreenScale
  }

  func test_configureCIImageRenderer() {
    let layer = CAMetalLayer()
    layer.configureCIImageRenderer()

    expect(layer.device) != nil
    expect(layer.pixelFormat) == MTLPixelFormat.bgra8Unorm
    expect(layer.framebufferOnly) == false
    expect(layer.isOpaque) == false
    expect(layer.contentsScale) == Screen.mainScreenScale
  }

  func test_render_sameSize() {
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let renderSize = CGSize(width: 100, height: 100)

    let image = CIImage(color: CIColor.red).cropped(to: CGRect(origin: .zero, size: renderSize))

    layer.render(image, renderSize: renderSize)
    expect(layer.drawableSize) == renderSize
  }

  func test_render_smallerSize() {
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    // when rendering a CI image with smaller size
    let imageSize = CGSize(width: 50, height: 50)
    let renderSize = CGSize(width: 100, height: 100)

    let image = CIImage(color: CIColor.blue).cropped(to: CGRect(origin: .zero, size: imageSize))

    layer.render(image, renderSize: renderSize)
    expect(layer.drawableSize) == renderSize
  }

  func test_render_largerSize() {
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    // when rendering a CI image with larger size
    let imageSize = CGSize(width: 150, height: 150)
    let renderSize = CGSize(width: 100, height: 100)

    let image = CIImage(color: CIColor.yellow).cropped(to: CGRect(origin: .zero, size: imageSize))

    layer.render(image, renderSize: renderSize)
    expect(layer.drawableSize) == renderSize
  }

  func test_render_zeroSize() {
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let originalDrawableSize = layer.drawableSize
    let renderSize = CGSize.zero

    // when rendering a CI image with zero size
    let image = CIImage.empty()

    // then it should throw assertion for infinite extent
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "image.extent.origin should be .zero"
      expect(metadata["image.extent"]) == "(inf, inf, 0.0, 0.0)"
    }
    layer.render(image, renderSize: renderSize)
    Assert.resetTestAssertionFailureHandler()

    // the drawable size should not change for zero size
    expect(layer.drawableSize) == originalDrawableSize
  }

  func test_render_invalidImageExtentOrigin() {
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let renderSize = CGSize(width: 100, height: 100)

    // when rendering a CI image with non-zero origin
    let image = CIImage(color: CIColor.green).cropped(to: CGRect(x: 10, y: 10, width: 50, height: 50))

    // then it should throw assertion for invalid image extent origin
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "image.extent.origin should be .zero"
      expect(metadata["image.extent"]) == "(10.0, 10.0, 50.0, 50.0)"
    }
    layer.render(image, renderSize: renderSize)
    Assert.resetTestAssertionFailureHandler()
  }

  func test_render_framebufferOnlyTrue() {
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    // when setting framebufferOnly to true
    layer.framebufferOnly = true

    let renderSize = CGSize(width: 100, height: 100)
    let image = CIImage(color: CIColor.yellow).cropped(to: CGRect(origin: .zero, size: renderSize))

    // then it should throw assertion for framebufferOnly is true
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Layer is not configured to be used as a CIImage renderer"
    }
    layer.render(image, renderSize: renderSize)
    Assert.resetTestAssertionFailureHandler()

    expect(layer.drawableSize) == renderSize
  }

  func test_render_fractionalSize() {
    let layer = CAMetalLayer.makeCIImageRendererLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let renderSize = CGSize(width: 100.5, height: 100.7)

    // when rendering a CI image with fractional size
    let image = CIImage(color: CIColor.magenta).cropped(to: CGRect(origin: .zero, size: renderSize))

    layer.render(image, renderSize: renderSize)
    expect(layer.drawableSize) == CGSize(width: 100, height: 100)
  }
}
