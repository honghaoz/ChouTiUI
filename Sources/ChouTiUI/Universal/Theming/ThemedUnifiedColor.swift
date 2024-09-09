//
//  ThemedUnifiedColor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/25/22.
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

/// A type that represents a unified color that changes based on the theme.
public struct ThemedUnifiedColor: Hashable {

  /// The unified color for light theme.
  public let lightColor: UnifiedColor

  /// The unified color for dark theme.
  public let darkColor: UnifiedColor

  /// Creates a new themed unified color.
  ///
  /// - Parameters:
  ///   - lightColor: The unified color for light theme.
  ///   - darkColor: The unified color for dark theme.
  public init(lightColor: UnifiedColor, darkColor: UnifiedColor) {
    self.lightColor = lightColor
    self.darkColor = darkColor
  }

  /// Creates a new themed unified color with solid colors.
  ///
  /// - Parameters:
  ///   - lightColor: The solid color for light theme.
  ///   - darkColor: The solid color for dark theme.
  public init(lightColor: Color, darkColor: Color) {
    self.lightColor = .color(lightColor)
    self.darkColor = .color(darkColor)
  }

  /// Creates a new themed unified color with linear gradient colors.
  ///
  /// - Parameters:
  ///   - lightColor: The linear gradient color for light theme.
  ///   - darkColor: The linear gradient color for dark theme.
  public init(lightColor: LinearGradientColor, darkColor: LinearGradientColor) {
    self.lightColor = .linearGradient(lightColor)
    self.darkColor = .linearGradient(darkColor)
  }

  /// Creates a new themed unified color with radial gradient colors.
  ///
  /// - Parameters:
  ///   - lightColor: The radial gradient color for light theme.
  ///   - darkColor: The radial gradient color for dark theme.
  public init(lightColor: RadialGradientColor, darkColor: RadialGradientColor) {
    self.lightColor = .radialGradient(lightColor)
    self.darkColor = .radialGradient(darkColor)
  }

  /// Creates a new themed unified color with angular gradient colors.
  ///
  /// - Parameters:
  ///   - lightColor: The angular gradient color for light theme.
  ///   - darkColor: The angular gradient color for dark theme.
  public init(lightColor: AngularGradientColor, darkColor: AngularGradientColor) {
    self.lightColor = .angularGradient(lightColor)
    self.darkColor = .angularGradient(darkColor)
  }

  /// Creates a new themed unified color with the same color for both light and dark theme.
  ///
  /// - Parameter color: The unified color for both light and dark theme.
  public init(_ color: UnifiedColor) {
    self.lightColor = color
    self.darkColor = color
  }

  /// Creates a new themed unified color with solid color for both light and dark theme.
  ///
  /// - Parameter color: The solid color for both light and dark theme.
  public init(_ color: Color) {
    self.lightColor = .color(color)
    self.darkColor = .color(color)
  }

  /// Creates a new themed unified color with the same color for both light and dark theme.
  ///
  /// - Parameter themedColor: The themed color.
  public init(_ themedColor: ThemedColor) {
    self.lightColor = .color(themedColor.lightColor)
    self.darkColor = .color(themedColor.darkColor)
  }

  /// Returns the unified color for the given theme.
  ///
  /// - Parameter theme: The theme.
  /// - Returns: The unified color for the given theme.
  public func color(for theme: Theme) -> UnifiedColor {
    switch theme {
    case .light:
      return lightColor
    case .dark:
      return darkColor
    }
  }
}

// MARK: - Color + ThemedUnifiedColor

public extension Color {

  /// Returns the themed unified color with the current color.
  @inlinable
  @inline(__always)
  var themedUnifiedColor: ThemedUnifiedColor { ThemedUnifiedColor(self) }
}

public extension UnifiedColor {

  /// Returns the themed unified color with the current color.
  @inlinable
  @inline(__always)
  var themedUnifiedColor: ThemedUnifiedColor { ThemedUnifiedColor(self) }
}

public extension ThemedColor {

  /// Returns the themed unified color with the current color.
  @inlinable
  @inline(__always)
  var themedUnifiedColor: ThemedUnifiedColor { ThemedUnifiedColor(self) }
}
