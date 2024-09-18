//
//  Color+Extensions.swift
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

import CoreGraphics

import ChouTi

public extension Color {

  /// Create a Color from CGColor.
  ///
  /// - Warning: ⚠️ Can crash on mac if the CGColor can't convert to `NSColor`.
  ///
  /// - Parameter cgColor: The CGColor to convert to Color.
  /// - Returns: A Color created from the CGColor.
  static func from(cgColor: CGColor) -> Color {
    #if canImport(AppKit)
    Color(cgColor: cgColor)! // swiftlint:disable:this force_unwrapping
    #else
    Color(cgColor: cgColor)
    #endif

    /**
     NSColor -> CGColor
     https://www.cocoawithlove.com/2010/11/back-to-mac-12-features-from-ios-i-like.html
     */
  }
}

public extension Color {

  /// Create a color with a new alpha/opacity value.
  ///
  /// - Parameter alpha: A new opacity. The value must be within `[0 ... 1]`.
  /// - Returns: A new color with the new opacity.
  @inlinable
  @inline(__always)
  func opacity(_ alpha: CGFloat) -> Color {
    ChouTi.assert(alpha >= 0 && alpha <= 1, "alpha must be within 0...1", metadata: ["alpha": "\(alpha)"])
    return withAlphaComponent(alpha.clamped(to: 0 ... 1))
  }

  /// Create a new color with adjusted opacity.
  ///
  /// - Parameter adjustOpacity: A closure that takes the current opacity and returns the new opacity.
  /// - Returns: A new color with the new opacity.
  @inlinable
  @inline(__always)
  func opacity(_ adjustOpacity: (_ currentOpacity: CGFloat) -> CGFloat) -> Color {
    opacity(adjustOpacity(opacity))
  }

  /// Checks if the color is opaque.
  ///
  /// - Note: This value is `false` for patterned color.
  @inlinable
  @inline(__always)
  var isOpaque: Bool {
    if isPatterned {
      return false
    }
    return opacity == 1
  }

  /// Returns `true` if the color is backed by patterned image.
  @inlinable
  @inline(__always)
  var isPatterned: Bool {
    #if canImport(AppKit)
    type == .pattern
    #else
    cgColor.pattern != nil
    #endif
  }
}

// MARK: - Random Color

public extension Color {

  /// Make a random color.
  ///
  /// - Parameters:
  ///   - includingAlpha: If should randomize the alpha value. Defaults to `false`.
  ///   - colorSpace: The color space for the color. Defaults to `.sRGB`.
  /// - Returns: A random color.
  static func random(includingAlpha: Bool = false, colorSpace: ColorSpace = .sRGB) -> Color {
    let randomRed = CGFloat.random(in: 0 ... 1)
    let randomGreen = CGFloat.random(in: 0 ... 1)
    let randomBlue = CGFloat.random(in: 0 ... 1)
    let alpha = includingAlpha ? CGFloat.random(in: 0 ... 1) : 1
    return Color(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha, colorSpace: colorSpace)
  }

  /// Make a random opaque light color, in sRGB color space.
  static func randomLightColor() -> Color {
    Color(h: CGFloat.random(in: 0 ... 1), s: CGFloat.random(in: 0 ... 1), b: CGFloat.random(in: 0.7 ... 1), a: 1)
  }

  /// Make a random opaque dark color, in sRGB color space.
  static func randomDarkColor() -> Color {
    Color(h: CGFloat.random(in: 0 ... 1), s: CGFloat.random(in: 0 ... 1), b: CGFloat.random(in: 0.1 ... 0.4), a: 1)
  }
}

// MARK: - Color Blending

public extension Color {

  /// Return a new color by blending the current color with another color.
  ///
  /// Example:
  /// ```
  /// color.blending(with: 0.5, of: .whiteRGB)
  /// ```
  ///
  /// - Parameters:
  ///   - fraction: The amount of the `color` to blend. The value should be within `[0 ... 1]`.
  ///   - color: The color to blend with.
  ///   - colorSpace: The working color space.
  /// - Returns: A new blended color.
  func blending(with fraction: CGFloat, of color: Color, colorSpace: ColorSpace = .sRGB) -> Color? {
    if fraction < 0 || fraction > 1 {
      ChouTi.assertFailure("fraction must be within 0...1", metadata: [
        "selfColor": "\(self)",
        "fraction": "\(fraction)",
        "color": "\(color)",
      ])
    }
    let fraction = fraction.clamped(to: 0 ... 1)

    guard let leftRGBA = rgba(colorSpace: colorSpace), let rightRGBA = color.rgba(colorSpace: colorSpace) else {
      ChouTi.assertFailure("Failed to get rgba components", metadata: [
        "selfColor": "\(self)",
        "color": "\(color)",
      ])
      return nil
    }

    return Color(
      red: leftRGBA.red * (1 - fraction) + rightRGBA.red * fraction,
      green: leftRGBA.green * (1 - fraction) + rightRGBA.green * fraction,
      blue: leftRGBA.blue * (1 - fraction) + rightRGBA.blue * fraction,
      alpha: leftRGBA.alpha * (1 - fraction) + rightRGBA.alpha * fraction,
      colorSpace: colorSpace
    )
  }
}
