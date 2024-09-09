//
//  Image+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

public extension Image {

  /// Create a rectangle image filled with the color specified.
  ///
  /// - Parameters:
  ///   - fillColor: The fill color.
  ///   - size: The image size. Default value is 1x1.
  /// - Returns: A new image.
  static func imageWithColor(_ fillColor: Color, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> Image {
    // TODO: considering unifying this method with the initializer above.

    #if canImport(AppKit)
    NSGraphicsContext.renderImage(size: size) { context in
      let rect = CGRect(origin: CGPoint.zero, size: size)

      context.setFillColor(fillColor.cgColor)
      context.fill(rect)
    }
    #else
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    // swiftlint:disable:next force_unwrapping
    let context = UIGraphicsGetCurrentContext()!
    let rect = CGRect(origin: CGPoint.zero, size: size)

    context.setFillColor(fillColor.cgColor)
    context.fill(rect)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    // swiftlint:disable:next force_unwrapping
    return image!
    #endif
  }
}
