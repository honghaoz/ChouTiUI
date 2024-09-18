//
//  HSBA.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/6/23.
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

/// A type represent the color's hue, saturation, brightness, alpha component values.
public struct HSBA: Equatable {

  /// The hue component of the color.
  ///
  /// The hue component is a value between 0 (0°) and 1 (360°) on the color wheel.
  public let hue: CGFloat

  /// The saturation component of the color.
  ///
  /// Within a specific color space, the saturation component is a value between 0 (no color) and 1 (full color).
  public let saturation: CGFloat

  /// The brightness component of the color.
  ///
  /// Within a specific color space, the brightness component is a value between 0 (darkest) and 1 (brightest).
  public let brightness: CGFloat

  /// The alpha component of the color.
  ///
  /// The alpha component is a value between 0 (transparent) and 1 (opaque).
  public let alpha: CGFloat

  /// Create a new HSBA color.
  ///
  /// - Parameters:
  ///   - hue: The hue component of the color. In the range of 0 to 1.
  ///   - saturation: The saturation component of the color.
  ///   - brightness: The brightness component of the color.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1.
  public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    ChouTi.assert(hue >= 0 && hue <= 1, "hue must be between 0 and 1", metadata: ["hue": "\(hue)"])
    ChouTi.assert(alpha >= 0 && alpha <= 1, "alpha must be between 0 and 1", metadata: ["alpha": "\(alpha)"])
    self.hue = hue
    self.saturation = saturation
    self.brightness = brightness
    self.alpha = alpha.clamped(to: 0 ... 1)
  }

  /// Create a new HSBA color.
  ///
  /// - Parameters:
  ///   - hue: The hue component of the color. In the range of 0 to 1.
  ///   - saturation: The saturation component of the color.
  ///   - brightness: The brightness component of the color.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1.
  public init(_ hue: CGFloat, _ saturation: CGFloat, _ brightness: CGFloat, _ alpha: CGFloat) {
    self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }

  /// Unwrap the HSBA color to a (hue, saturation, brightness, alpha) tuple.
  ///
  /// Example:
  /// ```
  /// let hsba = HSBA(hue: 220 / 360, saturation: 1, brightness: 0.96, alpha: 1)
  /// let (h, s, b, a) = hsba.unwrap()
  /// ```
  ///
  /// - Returns: A tuple of the hue, saturation, brightness, and alpha components.
  public func unwrap() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    (hue, saturation, brightness, alpha)
  }
}
