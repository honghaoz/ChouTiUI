//
//  GradientColorType.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/21/21.
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

#if canImport(QuartzCore)
import QuartzCore
#endif

import ChouTi

/// A protocol that represents a gradient color.
public protocol GradientColorType {

  /// The clear gradient color. Required.
  static var clearGradientColor: Self { get }

  /// The colors of the gradient. Required.
  var colors: [Color] { get }

  /// The locations of the gradient. Required.
  var locations: [CGFloat] { get }

  /// The start point of the gradient. Required.
  var startPoint: UnitPoint { get }

  /// The end point of the gradient. Required.
  var endPoint: UnitPoint { get }

  /// The `CGColor`s of the gradient. Optional.
  var cgColors: [CGColor] { get }

  /// The location `NSNumber`s of the gradient. Optional.
  var locationNSNumbers: [NSNumber] { get }

  /// Whether the gradient is opaque. Optional.
  var isOpaque: Bool { get }

  #if canImport(QuartzCore)
  /// The type of the gradient. Required.
  var gradientLayerType: CAGradientLayerType { get }
  #endif

  /// Get the unified color of the gradient. Optional.
  var unifiedColor: UnifiedColor { get }

  /// Get the themed unified color of the gradient. Optional.
  var themedUnifiedColor: ThemedUnifiedColor { get }

  /// Create a new gradient color with specified colors, locations, start point, and end point. Required.
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient.
  ///   - locations: The locations of the gradient.
  ///   - startPoint: The start point of the gradient.
  ///   - endPoint: The end point of the gradient.
  /// - Returns: A new gradient color with the adjusted colors, locations, start point, and end point.
  func withComponents(colors: [Color], locations: [CGFloat]?, startPoint: UnitPoint, endPoint: UnitPoint) -> Self

  /// Create a new gradient color by adjusting the opacity. Optional.
  ///
  /// - Parameter adjustOpacity: A closure that takes the current opacity and returns the new opacity.
  /// - Returns: A new gradient color with the new opacity.
  func opacity(_ adjustOpacity: (_ currentOpacity: CGFloat) -> CGFloat) -> Self

  /// Create a new gradient color by blending the current gradient color with another color. Optional.
  ///
  /// Example:
  /// ```
  /// gradientColor.blending(with: 0.5, of: .whiteRGB)
  /// ```
  ///
  /// - Parameters:
  ///   - fraction: The amount of the `color` to blend. The value should be within `[0 ... 1]`.
  ///   - color: The color to blend with.
  ///   - colorSpace: The color space to blend in.
  /// - Returns: A new gradient color with the blended color.
  func blending(with fraction: CGFloat, of color: Color, colorSpace: ColorSpace) -> Self?

  /// Create a new gradient color by blending the current gradient color with another color. Optional.
  ///
  /// The blending is done in the sRGB color space.
  ///
  /// Example:
  /// ```
  /// gradientColor.blending(with: 0.5, of: .whiteRGB)
  /// ```
  ///
  /// - Parameters:
  ///   - fraction: The amount of the `color` to blend. The value should be within `[0 ... 1]`.
  ///   - color: The color to blend with.
  /// - Returns: A new gradient color with the blended color.
  func blending(with fraction: CGFloat, of color: Color) -> Self?

  /// Adjusts the brightness of the gradient color by the given percentage. Optional.
  ///
  /// - Parameters:
  ///   - percentage: The percentage of brightness, in the range of `-1` to `1`. `0` means no change, `1` means 100% brightness, `-1` means 0% brightness.
  /// - Returns: A new gradient color with the adjusted brightness.
  func adjustingBrightness(percentage: CGFloat) -> Self?
}

public extension GradientColorType {

  var cgColors: [CGColor] {
    colors.map(\.cgColor)
  }

  var locationNSNumbers: [NSNumber] {
    locations.map { $0 as NSNumber }
  }

  var isOpaque: Bool {
    // if any color is not opaque, then the whole is not opaque
    colors.contains(where: { $0.opacity < 1 }) ? false : true
  }

  func opacity(_ adjustOpacity: (_ currentOpacity: CGFloat) -> CGFloat) -> Self {
    withComponents(colors: colors.map { $0.opacity(adjustOpacity($0.opacity)) }, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }

  func blending(with fraction: CGFloat, of color: Color, colorSpace: ColorSpace) -> Self? {
    var mappedColors: [Color] = []
    for selfColor in colors {
      if let blendedColor = selfColor.blending(with: fraction, of: color, colorSpace: colorSpace) {
        mappedColors.append(blendedColor)
      } else {
        ChouTi.assertFailure("Failed to blend color", metadata: [
          "selfColor": "\(self)",
          "color": "\(color)",
          "fraction": "\(fraction)",
        ])
        return nil
      }
    }
    return withComponents(colors: mappedColors, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }

  func blending(with fraction: CGFloat, of color: Color) -> Self? {
    blending(with: fraction, of: color, colorSpace: .sRGB)
  }

  func adjustingBrightness(percentage: CGFloat) -> Self? {
    ChouTi.assert(percentage >= -1 && percentage <= 1, "Brightness percentage must be in the range of `-1` to `1`", metadata: [
      "percentage": "\(percentage)",
    ])
    let percentage = percentage.clamped(to: -1 ... 1)

    var mappedColors: [Color] = []
    for color in colors {
      if let adjustedColor = color.adjustingBrightness(percentage: percentage) {
        mappedColors.append(adjustedColor)
      } else {
        ChouTi.assertFailure("Failed to adjust brightness", metadata: [
          "color": "\(color)",
          "percentage": "\(percentage)",
        ])
        return nil
      }
    }

    return withComponents(colors: mappedColors, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }

  /// Returns a new gradient color by lightening the color by the given percentage.
  ///
  /// - Parameters:
  ///   - percentage: The percentage of lightness. `0` means no change, `1` means 100% brightness. Defaults to `0.1`.
  /// - Returns: A new gradient color by lightening the color by the given percentage.
  func lighter(by percentage: CGFloat = 0.1) -> Self? {
    ChouTi.assert(percentage >= 0 && percentage <= 1, "percentage must be in the range of `0` to `1`", metadata: [
      "percentage": "\(percentage)",
    ])
    return adjustingBrightness(percentage: percentage.clamped(to: 0 ... 1))
  }

  /// Returns a new gradient color by darkening the color by the given percentage.
  ///
  /// - Parameters:
  ///   - percentage: The percentage of darkness. `0` means no change, `1` means 0% brightness. Defaults to `0.1`.
  /// - Returns: A new gradient color by darkening the color by the given percentage.
  func darker(by percentage: CGFloat = 0.1) -> Self? {
    ChouTi.assert(percentage >= 0 && percentage <= 1, "percentage must be in the range of `0` to `1`", metadata: [
      "percentage": "\(percentage)",
    ])
    return adjustingBrightness(percentage: -percentage.clamped(to: 0 ... 1))
  }
}

public extension GradientColorType where Self == LinearGradientColor {

  /// Create a new linear gradient color.
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient.
  ///   - locations: The locations of the gradient.
  ///   - startPoint: The start point of the gradient.
  ///   - endPoint: The end point of the gradient.
  /// - Returns: A new linear gradient color.
  static func linearGradient(colors: [Color], locations: [CGFloat]? = nil, startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> LinearGradientColor {
    LinearGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }

  var unifiedColor: UnifiedColor {
    .gradient(.linearGradient(self))
  }
}

public extension GradientColorType where Self == RadialGradientColor {

  /// Create a new radial gradient color.
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient.
  ///   - locations: The locations of the gradient.
  ///   - centerPoint: The center point of the gradient.
  ///   - endPoint: The end point of the gradient.
  /// - Returns: A new radial gradient color.
  static func radialGradient(colors: [Color], locations: [CGFloat]? = nil, centerPoint: UnitPoint, endPoint: UnitPoint) -> RadialGradientColor {
    RadialGradientColor(colors: colors, locations: locations, centerPoint: centerPoint, endPoint: endPoint)
  }

  var unifiedColor: UnifiedColor {
    .gradient(.radialGradient(self))
  }
}

public extension GradientColorType where Self == AngularGradientColor {

  /// Create a new angular gradient color.
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient.
  ///   - locations: The locations of the gradient.
  ///   - centerPoint: The center point of the gradient.
  ///   - aimingPoint: The aiming point of the gradient.
  /// - Returns: A new angular gradient color.
  static func angularGradient(colors: [Color], locations: [CGFloat]? = nil, centerPoint: UnitPoint, aimingPoint: UnitPoint) -> AngularGradientColor {
    AngularGradientColor(colors: colors, locations: locations, centerPoint: centerPoint, aimingPoint: aimingPoint)
  }

  var unifiedColor: UnifiedColor {
    .gradient(.angularGradient(self))
  }
}

public extension GradientColorType where Self == GradientColor {

  var unifiedColor: UnifiedColor {
    .gradient(self)
  }
}

public extension GradientColorType {

  var themedUnifiedColor: ThemedUnifiedColor {
    ThemedUnifiedColor(unifiedColor)
  }
}
