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
public typealias ThemedUnifiedColor = Themed<UnifiedColor>

public extension ThemedUnifiedColor {

  /// Creates a new themed unified color with solid colors.
  ///
  /// - Parameters:
  ///   - light: The solid color for light theme.
  ///   - dark: The solid color for dark theme.
  init(light: Color, dark: Color) {
    self.init(light: .color(light), dark: .color(dark))
  }

  /// Creates a new themed unified color with solid color for both light and dark theme.
  ///
  /// - Parameter color: The solid color for both light and dark theme.
  init(_ color: Color) {
    self.init(.color(color))
  }

  /// Creates a new themed unified color with linear gradient colors.
  ///
  /// - Parameters:
  ///   - light: The linear gradient color for light theme.
  ///   - dark: The linear gradient color for dark theme.
  init(light: LinearGradientColor, dark: LinearGradientColor) {
    self.init(light: .linearGradient(light), dark: .linearGradient(dark))
  }

  /// Creates a new themed unified color with radial gradient colors.
  ///
  /// - Parameters:
  ///   - light: The radial gradient color for light theme.
  ///   - dark: The radial gradient color for dark theme.
  init(light: RadialGradientColor, dark: RadialGradientColor) {
    self.init(light: .radialGradient(light), dark: .radialGradient(dark))
  }

  /// Creates a new themed unified color with angular gradient colors.
  ///
  /// - Parameters:
  ///   - light: The angular gradient color for light theme.
  ///   - dark: The angular gradient color for dark theme.
  init(light: AngularGradientColor, dark: AngularGradientColor) {
    self.init(light: .angularGradient(light), dark: .angularGradient(dark))
  }

  /// Creates a new themed unified color with the same color for both light and dark theme.
  ///
  /// - Parameter themedColor: The themed color.
  init(_ themedColor: ThemedColor) {
    self.init(light: .color(themedColor.light), dark: .color(themedColor.dark))
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
