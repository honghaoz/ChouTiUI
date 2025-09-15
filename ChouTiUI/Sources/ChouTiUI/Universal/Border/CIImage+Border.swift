//
//  CIImage+Border.swift
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

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins // swiftlint:disable:this duplicate_imports

import ChouTi

public extension CIImage {

  /// The content of the border.
  enum BorderContent {

    /// A solid color border.
    case color(_ color: Color)

    /// A linear gradient border.
    case linearGradient(
      startColor: Color,
      endColor: Color,
      startPoint: UnitPoint,
      endPoint: UnitPoint
    )

    /// An image border.
    /// - Parameter imageProvider: A provider that returns an image for the given extent.
    case image(_ imageProvider: (_ extent: CGRect) -> CIImage)
  }

  /// Make a border image from a shape.
  ///
  /// - Parameters:
  ///   - width: The width of the border in points.
  ///   - content: The content of the border.
  ///   - shape: The shape of the border.
  ///   - size: The size of the border image in points.
  ///   - scale: The scale of the border image.
  /// - Returns: A border image.
  static func makeBorderImage(width: CGFloat,
                              content: BorderContent,
                              shape: some Shape,
                              size: CGSize,
                              scale: CGFloat) -> CIImage
  {
    let mask = makeMaskImage(path: shape.path(in: CGRect(origin: .zero, size: size)), size: size, scale: scale)
    return ChouTiUI.makeBorderImage(width: width, scale: scale, offset: .inside, content: content, mask: mask)
  }
}

private enum BorderOffset {
  case inside
  // case outside
  // case center
}

/// Make a border image from a mask image.
/// - Parameters:
///   - width: The width of the border in points.
///   - scale: The scale of the border image.
///   - offset: The offset of the border.
///   - content: The content of the border.
///   - mask: The mask image.
/// - Returns: A border image.
private func makeBorderImage(width: CGFloat, scale: CGFloat, offset: BorderOffset, content: CIImage.BorderContent, mask: CIImage) -> CIImage {
  let extent = mask.extent

  // ring via morphology
  // let dilate = CIFilter.morphologyMaximum()
  let erode = CIFilter.morphologyMinimum()

  // func d(_ radius: CGFloat) -> CIImage {
  //   dilate.inputImage = mask
  //   dilate.radius = Float(radius)
  //   return dilate.outputImage!.cropped(to: extent)
  // }

  func e(_ radius: CGFloat) -> CIImage {
    erode.inputImage = mask
    erode.radius = Float(radius)
    return erode.outputImage!.cropped(to: extent) // swiftlint:disable:this force_unwrapping
  }

  let widthPixel = width * scale
  let borderMask: CIImage
  switch offset {
  case .inside:
    borderMask = mask.applyingFilter("CISourceOutCompositing", parameters: [kCIInputBackgroundImageKey: e(widthPixel)])
    // case .outside:
    //   borderMask = d(widthPixel).applyingFilter("CISourceOutCompositing", parameters: [kCIInputBackgroundImageKey: mask])
    // case .center:
    //   let halfWidthPixel = widthPixel * 0.5
    //   borderMask = d(halfWidthPixel).applyingFilter("CISourceOutCompositing", parameters: [kCIInputBackgroundImageKey: e(halfWidthPixel)])
  }

  // border content
  let contentImage: CIImage
  switch content {
  case .color(let color):
    contentImage = CIImage(color: CIColor(cgColor: color.cgColor)).cropped(to: extent)
  case .linearGradient(let startColor, let endColor, let startPoint, let endPoint):
    let linearGradient = CIFilter.linearGradient()
    linearGradient.point0 = startPoint.point(in: extent)
    linearGradient.point1 = endPoint.point(in: extent)
    linearGradient.color0 = CIColor(cgColor: startColor.cgColor)
    linearGradient.color1 = CIColor(cgColor: endColor.cgColor)
    contentImage = linearGradient.outputImage!.cropped(to: extent) // swiftlint:disable:this force_unwrapping
  case .image(let imageProvider):
    let image = imageProvider(extent)
    contentImage = image.cropped(to: extent)
  }

  // composite the mask with content
  let blend = CIFilter.blendWithAlphaMask()
  blend.inputImage = contentImage
  blend.backgroundImage = CIImage(color: .clear).cropped(to: extent)
  blend.maskImage = borderMask
  return blend.outputImage! // swiftlint:disable:this force_unwrapping
}

/// Make a mask image from a path.
/// - Parameters:
///   - path: The path to make the mask image from.
///   - size: The size of the mask image in points.
///   - scale: The scale of the mask image.
/// - Returns: A mask image.
private func makeMaskImage(path: CGPath, size: CGSize, scale: CGFloat) -> CIImage {
  // TODO: consider adding cache for the mask image.

  let pixelSize = CGSize(width: size.width * scale, height: size.height * scale)
  guard let context = CGContext.makeContext(size: pixelSize, colorSpace: .sRGB()) else {
    ChouTi.assertFailure("Failed to create CGContext")
    return CIImage(color: CIColor.white).cropped(to: CGRect(origin: .zero, size: pixelSize))
  }

  // flip coordinate system to match iOS (top-left origin)
  // CGContext on macOS uses bottom-left origin
  context.translateBy(x: 0, y: pixelSize.height)
  context.scaleBy(x: 1, y: -1)

  // scale from points to pixels
  context.scaleBy(x: scale, y: scale)

  // set fill color and draw path
  context.setFillColor(Color.white.cgColor)
  context.addPath(path)
  context.fillPath()

  // Create CGImage from context
  guard let cgImage = context.makeImage() else {
    ChouTi.assertFailure("Failed to create CGImage from context")
    return CIImage(color: CIColor.white).cropped(to: CGRect(origin: .zero, size: pixelSize))
  }

  return CIImage(cgImage: cgImage)

  // #if canImport(UIKit)
  // let format = UIGraphicsImageRendererFormat()
  // format.scale = 1
  // format.opaque = false
  // guard let cgImage = UIGraphicsImageRenderer(size: pixelSize, format: format).image { context in
  //   // scale from points to pixels
  //   context.cgContext.scaleBy(x: scale, y: scale)

  //   // set fill color and draw path
  //   context.cgContext.setFillColor(Color.white.cgColor)
  //   context.cgContext.addPath(path)
  //   context.cgContext.fillPath()
  // }.cgImage else {
  //   ChouTi.assertFailure("Failed to create CGImage from context")
  //   return CIImage(color: CIColor.white).cropped(to: CGRect(origin: .zero, size: pixelSize))
  // }
  // return CIImage(cgImage: cgImage)
  // #endif
}
