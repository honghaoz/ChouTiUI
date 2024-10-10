//
//  Color+HSBA.swift
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

  /// Makes an opaque `Color` with the specified hue, saturation, brightness in the sRGB color space.
  ///
  /// - Parameters:
  ///   - h: The hue value of the color. Defaults to `0`.
  ///   - s: The saturation value of the color. Defaults to `0`.
  ///   - b: The brightness value of the color. Defaults to `0`.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func hsb(h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0) -> Color {
    Color(hue: h, saturation: s, brightness: b, alpha: 1)
  }

  /// Makes an opaque `Color` with the specified hue, saturation, brightness in the sRGB color space.
  ///
  /// - Parameters:
  ///   - h: The hue value of the color.
  ///   - s: The saturation value of the color.
  ///   - b: The brightness value of the color.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func hsb(_ h: CGFloat, _ s: CGFloat, _ b: CGFloat) -> Color {
    Color(hue: h, saturation: s, brightness: b, alpha: 1)
  }

  /// Makes a `Color` with the specified hue, saturation, brightness, alpha values in the sRGB color space.
  ///
  /// - Parameters:
  ///   - h: The hue value of the color.
  ///   - s: The saturation value of the color.
  ///   - b: The brightness value of the color.
  ///   - a: The opacity value of the color. In the range of `0` to `1`. Defaults to `1`.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func hsba(_ h: CGFloat, _ s: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> Color {
    Color(hue: h, saturation: s, brightness: b, alpha: a)
  }

  /// Makes a `Color` with the specified hue, saturation, brightness, alpha values in the sRGB color space.
  ///
  /// - Parameters:
  ///   - h: The hue value of the color. Defaults to `0`.
  ///   - s: The saturation value of the color. Defaults to `0`.
  ///   - b: The brightness value of the color. Defaults to `0`.
  ///   - a: The opacity value of the color. In the range of `0` to `1`. Defaults to `1`.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func hsba(h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1) -> Color {
    Color(hue: h, saturation: s, brightness: b, alpha: a)
  }

  // MARK: - Init

  /// Create a new color with the specified hue, saturation, brightness and alpha values.
  ///
  /// - Parameters:
  ///   - h: The hue value of the color.
  ///   - s: The saturation value of the color.
  ///   - b: The brightness value of the color.
  ///   - a: The opacity value of the color. In the range of `0` to `1`. Defaults to `1`.
  convenience init(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat = 1) {
    self.init(hue: h, saturation: s, brightness: b, alpha: a)
  }

  #if canImport(AppKit)
  /// Create a new color with the specified hue, saturation, brightness and alpha values.
  ///
  /// - Parameters:
  ///   - colorSpace: The color space for the HSBA components.
  ///   - h: The hue value of the color.
  ///   - s: The saturation value of the color.
  ///   - b: The brightness value of the color.
  ///   - a: The opacity value of the color. In the range of `0` to `1`. Defaults to `1`.
  convenience init(colorSpace: NSColorSpace, h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat = 1) {
    self.init(colorSpace: colorSpace, hue: h, saturation: s, brightness: b, alpha: a)
  }
  #endif

  // MARK: - Get HSBA

  /// Get hue, saturation, brightness and alpha components from the color.
  ///
  /// The HSBA is based on sRGB color space. So for the color from displayP3 color space, the HSBA may contains value larger than 1.
  ///
  /// - Returns: The `HSBA` model.
  func hsba() -> HSBA? {
    #if canImport(AppKit)
    let color: NSColor
    if self.isRGB, self.colorSpace == NSColorSpace.sRGB || self.colorSpace == NSColorSpace.extendedSRGB {
      color = self
    } else if let convertedColor = usingColorSpace(.extendedSRGB) {
      color = convertedColor
    } else {
      ChouTi.assertFailure("Failed to get hsba components", metadata: [
        "color": "\(self)",
      ])
      return nil
    }

    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    if hue == 1 {
      // for .red color:
      // iOS returns 0, mac return 1
      // make mac returns same value
      //
      // 360° -> 0° maps to 1.0 -> 0.0
      hue = 0
    }
    return HSBA(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    #else
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    let isConverted = getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    if isConverted {
      return HSBA(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    } else {
      ChouTi.assertFailure("Failed to get hsba components", metadata: [
        "color": "\(self)",
      ])
      return nil
    }
    #endif
  }

  /// Get the hue component from the color.
  ///
  /// - Returns: The hue component or `nil` if the color doesn't support RGBA.
  @inlinable
  @inline(__always)
  func hue() -> CGFloat? {
    hsba()?.hue
  }

  /// Get the saturation component from the color.
  ///
  /// - Returns: The saturation component or `nil` if the color doesn't support RGBA.
  @inlinable
  @inline(__always)
  func saturation() -> CGFloat? {
    hsba()?.saturation
  }

  /// Get the brightness component from the color.
  ///
  /// - Returns: The brightness component or `nil` if the color doesn't support RGBA.
  @inlinable
  @inline(__always)
  func brightness() -> CGFloat? {
    hsba()?.brightness
  }

  // MARK: - Modify HSBA

  /// Get a new color by modifying the hue value.
  ///
  /// - Parameter value: The new hue value.
  /// - Returns: A new color or `nil` if the color doesn't support RGBA.
  func hue(_ value: CGFloat) -> Color? {
    guard let hsba = hsba() else {
      ChouTi.assertFailure("Failed to get hsba components", metadata: [
        "color": "\(self)",
      ])
      return nil
    }
    return Color(hue: value, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
  }

  /// Get a new color by modifying the saturation value.
  ///
  /// - Warning: ⚠️ Graphite color with saturation less than 1 would result into red color.
  ///
  /// - Parameter value: The new saturation value.
  /// - Returns: A new color or `nil` if the color doesn't support RGBA.
  func saturation(_ value: CGFloat) -> Color? {
    guard let hsba = hsba() else {
      ChouTi.assertFailure("Failed to get hsba components", metadata: [
        "color": "\(self)",
      ])
      return nil
    }
    return Color(hue: hsba.hue, saturation: value, brightness: hsba.brightness, alpha: hsba.alpha)
  }

  /// Get a new color by modifying the brightness value.
  ///
  /// - Parameter value: The new brightness value.
  /// - Returns: A new color or `nil` if the color doesn't support RGBA.
  func brightness(_ value: CGFloat) -> Color? {
    guard let hsba = hsba() else {
      ChouTi.assertFailure("Failed to get hsba components", metadata: [
        "color": "\(self)",
      ])
      return nil
    }
    return Color(hue: hsba.hue, saturation: hsba.saturation, brightness: value, alpha: hsba.alpha)
  }

  /// Make a lighter color.
  ///
  /// - Parameter percentage: The lighter percentage. `0` means no change. `1` means 100% brightness. Default value is `0.1`.
  /// - Returns: A new color.
  @inlinable
  @inline(__always)
  func lighter(by percentage: CGFloat = 0.1) -> Color? {
    ChouTi.assert(percentage >= 0 && percentage <= 1, "percentage must be in the range of `0` to `1`", metadata: [
      "percentage": "\(percentage)",
    ])
    let percentage = percentage.clamped(to: 0 ... 1)
    return adjustingBrightness(percentage: percentage)
  }

  /// Make a darker color.
  ///
  /// - Parameter percentage: The darker percentage. `0` means no change. `1` means 0% brightness. Default value is `0.1`.
  /// - Returns: A new color.
  @inlinable
  @inline(__always)
  func darker(by percentage: CGFloat = 0.1) -> Color? {
    ChouTi.assert(percentage >= 0 && percentage <= 1, "percentage must be in the range of `0` to `1`", metadata: [
      "percentage": "\(percentage)",
    ])
    let percentage = percentage.clamped(to: 0 ... 1)
    return adjustingBrightness(percentage: -1.0 * percentage)
  }

  /// Make a new color with its brightness adjusted.
  ///
  /// - Parameter percentage: The brightness adjustment percentage, in the range of `-1` to `1`.
  ///                         `0` means no change, `-1` means 0% brightness, `1` means 100% brightness.
  /// - Returns: A new color.
  func adjustingBrightness(percentage: CGFloat) -> Color? {
    guard let brightness = hsba()?.brightness else {
      ChouTi.assertFailure("Failed to get hsba components", metadata: [
        "color": "\(self)",
      ])
      return nil
    }

    ChouTi.assert(percentage >= -1 && percentage <= 1, "brightness percentage must be in the range of `-1` to `1`", metadata: [
      "percentage": "\(percentage)",
    ])
    let percentage = percentage.clamped(to: -1 ... 1)

    let newBrightness: CGFloat = {
      if percentage > 0 {
        // bring it `percentage` percent closer to 1
        let diff = (1 - brightness) * percentage
        return brightness + diff
      } else {
        // bring it `percentage` percent closer to 0
        return (1 + percentage) * brightness
      }
    }()

    return self.brightness(newBrightness)
  }
}
