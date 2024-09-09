//
//  RGBA.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/5/23.
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

import CoreGraphics
import ChouTi

/// A type represent the color's red, green, blue, alpha component values.
public struct RGBA: Equatable {

  /// The red component of the color.
  ///
  /// Within a specific color space, the red component is a value between 0 (no color) and 1 (full color).
  public let red: CGFloat

  /// The green component of the color.
  ///
  /// Within a specific color space, the green component is a value between 0 (no color) and 1 (full color).
  public let green: CGFloat

  /// The blue component of the color.
  ///
  /// Within a specific color space, the blue component is a value between 0 (no color) and 1 (full color).
  public let blue: CGFloat

  /// The alpha component of the color.
  ///
  /// The alpha component is a value between 0 (transparent) and 1 (opaque).
  public let alpha: CGFloat

  /// Create a new RGBA color.
  ///
  /// - Parameters:
  ///   - red: The red component of the color.
  ///   - green: The green component of the color.
  ///   - blue: The blue component of the color.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1.
  public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    ChouTi.assert(alpha >= 0 && alpha <= 1, "alpha must be between 0 and 1", metadata: ["alpha": "\(alpha)"])
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha.clamped(to: 0 ... 1)
  }

  /// Create a new RGBA color.
  ///
  /// - Parameters:
  ///   - red: The red component of the color. In the range of 0 to 1.
  ///   - green: The green component of the color. In the range of 0 to 1.
  ///   - blue: The blue component of the color. In the range of 0 to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1.
  public init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) {
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  /// Unwrap the RGBA color to a (red, green, blue, alpha) tuple.
  ///
  /// Example:
  /// ```
  /// let rgba = RGBA(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
  /// let (r, g, b, a) = rgba.unwrap()
  /// ```
  ///
  /// - Returns: A tuple of the red, green, blue, and alpha components.
  public func unwrap() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    (red, green, blue, alpha)
  }
}
