//
//  Color+Hex.swift
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

import ChouTi
import CoreGraphics
import CoreImage

public extension Color {

  private static let colorHexCharacterSet = CharacterSet(charactersIn: "0123456789abcdefABCDEF")

  /// Create a color from a hex string.
  ///
  /// - Parameters:
  ///   - hex: A hex string either in format of `#FF0000` (RGB) or `#FF000088` (RGBA)
  ///   - colorSpace: The color space for the color. Default to `.sRGB`.
  ///   - fallbackColor: The fallback color if hex string parsing is failed. Default to `.clear`.
  /// - Returns: A color.
  @inlinable
  @inline(__always)
  static func hex(_ hex: String, colorSpace: ColorSpace = .sRGB, fallbackColor: @autoclosure () -> Color = .clear) -> Color {
    Color(hex: hex, colorSpace: colorSpace) ?? fallbackColor()
  }

  /// Create a color from a hex string.
  ///
  /// - Parameters:
  ///   - hex: A hex string either in format of `#FF0000` (RGB) or `#FF000088` (RGBA)
  ///   - colorSpace: The color space for the color. Default to `.sRGB`.
  convenience init?(hex: String, colorSpace: ColorSpace = .sRGB) {
    /// https://stackoverflow.com/a/56874327/3164091
    /// https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor

    let hex = hex.removingCharacters(in: Color.colorHexCharacterSet.inverted)

    var hexValue: UInt64 = 0
    guard Scanner(string: hex).scanHexInt64(&hexValue) else {
      return nil
    }

    let r, g, b, a: UInt64
    switch hex.count {
    case 6:
      r = (hexValue & 0xFF0000) >> 16
      g = (hexValue & 0x00FF00) >> 8
      b = (hexValue & 0x0000FF)
      a = 255
    case 8:
      r = (hexValue & 0xFF000000) >> 24
      g = (hexValue & 0x00FF0000) >> 16
      b = (hexValue & 0x0000FF00) >> 8
      a = hexValue & 0x000000FF
    default:
      debugPrint("Bad hex string (\(hex)), hex string should be in format of #FF0000 (RGB) or #FF000088 (RGBA)")
      return nil
    }

    switch colorSpace {
    case .sRGB:
      self.init(
        red: CGFloat(r) / 255,
        green: CGFloat(g) / 255,
        blue: CGFloat(b) / 255,
        alpha: CGFloat(a) / 255
      )
    case .displayP3:
      self.init(
        displayP3Red: CGFloat(r) / 255,
        green: CGFloat(g) / 255,
        blue: CGFloat(b) / 255,
        alpha: CGFloat(a) / 255
      )
    }
  }

  /// Get hex value of the color.
  ///
  /// - Parameters:
  ///   - includeAlpha: If should include the alpha channel. If so, the hex value will be in `RGBA` format. Default to `true`.
  ///   - colorSpace: The color space used to get the `RGBA` components. Default to `.sRGB`.
  /// - Returns: A hex value or nil.
  func hex(includeAlpha: Bool = true, colorSpace: ColorSpace = .sRGB) -> UInt? {
    guard let rgba = rgba(colorSpace: colorSpace) else {
      return nil
    }

    let red = rgba.red
    let green = rgba.green
    let blue = rgba.blue
    let alpha = rgba.alpha

    guard red >= 0, red <= 1, green >= 0, green <= 1, blue >= 0, blue <= 1 else {
      ChouTi.assertFailure("Bad rgba values, you might want to use .displayP3 color space.", metadata: [
        "r": "\(red)",
        "g": "\(green)",
        "b": "\(blue)",
        "a": "\(alpha)",
      ])
      return nil
    }

    let r = UInt(red * 255)
    let g = UInt(green * 255)
    let b = UInt(blue * 255)
    let a = UInt(alpha * 255)

    if includeAlpha {
      return (r << 24) | (g << 16) | (b << 8) | a
    } else {
      return (r << 16) | (g << 8) | b
    }
  }

  /// Get hex string of the color.
  ///
  /// - Parameters:
  ///   - includeAlpha: If should include the alpha channel. If so, the hex string will be in `RGBA` format. Default to `true`.
  ///   - colorSpace: The color space used to get the `RGBA` components. Default to `.sRGB`.
  /// - Returns: A hex string or nil.
  func hexString(includeAlpha: Bool = true, colorSpace: ColorSpace = .sRGB) -> String? {
    guard let rgba = rgba(colorSpace: colorSpace) else {
      return nil
    }

    let r = rgba.red
    let g = rgba.green
    let b = rgba.blue
    let a = rgba.alpha

    guard r >= 0, r <= 1, g >= 0, g <= 1, b >= 0, b <= 1 else {
      ChouTi.assertFailure("Bad rgba values, you might want to use .displayP3 color space.", metadata: [
        "r": "\(r)",
        "g": "\(g)",
        "b": "\(b)",
        "a": "\(a)",
      ])
      return nil
    }

    if includeAlpha {
      return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    } else {
      return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
  }
}
