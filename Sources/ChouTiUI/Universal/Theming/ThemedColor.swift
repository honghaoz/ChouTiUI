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

import ChouTi
import Foundation

/// A type that represents a color that changes based on the theme.
public struct ThemedColor: Hashable {

  /// The foreground color.
  public static let foreground = ThemedColor(lightColor: .black, darkColor: .white)

  /// The secondary foreground color.
  public static let foregroundSecondary = ThemedColor(lightColor: .hex("#6A7278"), darkColor: .hex("#919FA6"))

  /// The tertiary foreground color.
  public static let foregroundTertiary = ThemedColor(lightColor: .hex("#B4BDC2"), darkColor: .hex("#545D61"))

  /// The background color.
  public static let background = ThemedColor(lightColor: .white, darkColor: .black)

  /// The secondary background color.
  public static let backgroundSecondary = ThemedColor(lightColor: .hex("#F5F8FA"), darkColor: .hex("#1E2124"))

  /// The tertiary background color.
  public static let backgroundTertiary = ThemedColor(lightColor: .hex("#E3E9ED"), darkColor: .hex("#30363A"))

  #if DEBUG
  public static let debugRed = ThemedColor(lightColor: .red.opacity(0.3), darkColor: .red.opacity(0.3))
  public static let debugBlue = ThemedColor(lightColor: .blue.opacity(0.3), darkColor: .blue.opacity(0.3))
  public static let debugYellow = ThemedColor(lightColor: .yellow.opacity(0.3), darkColor: .yellow.opacity(0.3))
  #endif

  /// The color for light theme.
  public let lightColor: Color

  /// The color for dark theme.
  public let darkColor: Color

  /// Creates a new themed color.
  ///
  /// - Parameters:
  ///   - lightColor: The color for light theme.
  ///   - darkColor: The color for dark theme.
  public init(lightColor: Color, darkColor: Color) {
    self.lightColor = lightColor
    self.darkColor = darkColor
  }

  /// Creates a new themed color with the same color for both light and dark theme.
  ///
  /// - Parameters:
  ///   - color: The color for both light and dark theme.
  public init(_ color: Color) {
    self.lightColor = color
    self.darkColor = color
  }

  /// Returns the color for the given theme.
  ///
  /// - Parameters:
  ///   - theme: The theme.
  /// - Returns: The color for the given theme.
  public func color(for theme: Theme) -> Color {
    switch theme {
    case .light:
      return lightColor
    case .dark:
      return darkColor
    }
  }

  // MARK: - Modifying Colors

  /// Returns a new themed color by lightening the color by the given percentage.
  ///
  /// Under the hood, the color is converted to HSBA color space and the brightness is adjusted.
  ///
  /// - Parameters:
  ///   - percentage: The percentage of lightness. `0` means no change, `1` means 100% brightness.
  /// - Returns: A new themed color by lightening the color by the given percentage.
  public func lighter(by percentage: CGFloat = 0.1) -> ThemedColor? {
    guard let lightColor = lightColor.lighter(by: percentage),
          let darkColor = darkColor.lighter(by: percentage)
    else {
      ChouTi.assertFailure("Failed to get lighter color", metadata: [
        "lightColor": "\(lightColor)",
        "darkColor": "\(darkColor)",
        "percentage": "\(percentage)",
      ])
      return nil
    }

    return ThemedColor(lightColor: lightColor, darkColor: darkColor)
  }

  /// Returns a new themed color by darkening the color by the given percentage.
  ///
  /// Under the hood, the color is converted to HSBA color space and the brightness is adjusted.
  ///
  /// - Parameters:
  ///   - percentage: The percentage of darkness. `0` means no change, `1` means 0% brightness.
  /// - Returns: A new themed color by darkening the color by the given percentage.
  public func darker(by percentage: CGFloat = 0.1) -> ThemedColor? {
    guard let lightColor = lightColor.darker(by: percentage),
          let darkColor = darkColor.darker(by: percentage)
    else {
      ChouTi.assertFailure("Failed to get darker color", metadata: [
        "lightColor": "\(lightColor)",
        "darkColor": "\(darkColor)",
        "percentage": "\(percentage)",
      ])
      return nil
    }

    return ThemedColor(lightColor: lightColor, darkColor: darkColor)
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
