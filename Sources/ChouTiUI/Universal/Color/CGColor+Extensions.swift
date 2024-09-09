//
//  CGColor+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 2/26/22.
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

import CoreGraphics

public extension CGColor {

  #if canImport(AppKit)
  /// Convert the CGColor to a NSColor.
  var color: Color? {
    Color(cgColor: self)
  }
  #endif

  #if canImport(UIKit)
  /// Convert the CGColor to a UIColor.
  var color: Color {
    Color(cgColor: self)
  }
  #endif

  /// Create a new CGColor with the given RGBA components and color space.
  ///
  /// - Parameters:
  ///   - red: The red component of the color. Default to `0`.
  ///   - green: The green component of the color. Default to `0`.
  ///   - blue: The blue component of the color. Default to `0`.
  ///   - alpha: The alpha component of the color. Default to `1`.
  ///   - colorSpace: The color space of the color.
  @inlinable
  @inline(__always)
  static func rgba(red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1, colorSpace: CGColorSpace) -> CGColor? {
    CGColor(colorSpace: colorSpace, components: [red, green, blue, alpha])
  }

  /// Convert the CGColor to the given color space.
  ///
  /// - Parameters:
  ///   - colorSpace: The color space to convert to.
  /// - Returns: A new CGColor with the converted color space.
  @inlinable
  @inline(__always)
  func usingColorSpace(_ colorSpace: CGColorSpace) -> CGColor? {
    converted(to: colorSpace, intent: .defaultIntent, options: nil)
  }
}
