//
//  ThemedColor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 5/18/22.
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

import ChouTi

/// A type that represents a color that changes based on the theme.
public extension ThemedColor {

  /// The foreground color.
  static let foreground = ThemedColor(light: .black, dark: .white)

  /// The secondary foreground color.
  static let foregroundSecondary = ThemedColor(light: .hex("#6A7278"), dark: .hex("#919FA6"))

  /// The tertiary foreground color.
  static let foregroundTertiary = ThemedColor(light: .hex("#B4BDC2"), dark: .hex("#545D61"))

  /// The background color.
  static let background = ThemedColor(light: .white, dark: .black)

  /// The secondary background color.
  static let backgroundSecondary = ThemedColor(light: .hex("#F5F8FA"), dark: .hex("#1E2124"))

  /// The tertiary background color.
  static let backgroundTertiary = ThemedColor(light: .hex("#E3E9ED"), dark: .hex("#30363A"))

  #if DEBUG
  static let debugRed = ThemedColor(light: .red.opacity(0.3), dark: .red.opacity(0.3))
  static let debugBlue = ThemedColor(light: .blue.opacity(0.3), dark: .blue.opacity(0.3))
  static let debugYellow = ThemedColor(light: .yellow.opacity(0.3), dark: .yellow.opacity(0.3))
  #endif

  // MARK: - Modifying Colors

  /// Returns a new themed color by lightening the color by the given percentage.
  ///
  /// Under the hood, the color is converted to HSBA color space and the brightness is adjusted.
  ///
  /// - Parameters:
  ///   - percentage: The percentage of lightness. `0` means no change, `1` means 100% brightness.
  /// - Returns: A new themed color by lightening the color by the given percentage.
  func lighter(by percentage: CGFloat = 0.1) -> ThemedColor? {
    guard let lightColor = light.lighter(by: percentage),
          let darkColor = dark.lighter(by: percentage)
    else {
      ChouTi.assertFailure("Failed to get lighter color", metadata: [
        "lightColor": "\(light)",
        "darkColor": "\(dark)",
        "percentage": "\(percentage)",
      ])
      return nil
    }

    return ThemedColor(light: lightColor, dark: darkColor)
  }

  /// Returns a new themed color by darkening the color by the given percentage.
  ///
  /// Under the hood, the color is converted to HSBA color space and the brightness is adjusted.
  ///
  /// - Parameters:
  ///   - percentage: The percentage of darkness. `0` means no change, `1` means 0% brightness.
  /// - Returns: A new themed color by darkening the color by the given percentage.
  func darker(by percentage: CGFloat = 0.1) -> ThemedColor? {
    guard let lightColor = light.darker(by: percentage),
          let darkColor = dark.darker(by: percentage)
    else {
      ChouTi.assertFailure("Failed to get darker color", metadata: [
        "lightColor": "\(light)",
        "darkColor": "\(dark)",
        "percentage": "\(percentage)",
      ])
      return nil
    }

    return ThemedColor(light: lightColor, dark: darkColor)
  }
}

// MARK: - Color + ThemedColor

public extension Color {

  /// Returns a new themed color with the same color for both light and dark theme.
  @inlinable
  @inline(__always)
  var themedColor: ThemedColor { ThemedColor(self) }
}

// MARK: - Deprecated

// ---------------------------------------------
// this conflicts with Color.clear in ColorNode
// ---------------------------------------------

//  public extension ThemedColor {
//
//    public static let clear = Color.clear.themedColor
//  }
