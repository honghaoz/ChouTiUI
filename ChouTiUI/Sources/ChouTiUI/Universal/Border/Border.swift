//
//  Border.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/15/21.
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

/// A type describes a layer's border info.
public struct Border: Hashable {

  /// The color of the border.
  public let color: UnifiedColor

  /// The width of the border.
  public let width: CGFloat

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The color of the border.
  ///   - width: The width of the border.
  public init(color: UnifiedColor, width: CGFloat) {
    self.color = color
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The color of the border.
  ///   - width: The width of the border.
  public init(_ color: UnifiedColor, _ width: CGFloat) {
    self.color = color
    self.width = width
  }

  // MARK: - Convenient init methods

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The solid color of the border.
  ///   - width: The width of the border.
  public init(color: Color, width: CGFloat) {
    self.color = .color(color)
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The solid color of the border.
  ///   - width: The width of the border.
  public init(_ color: Color, _ width: CGFloat) {
    self.color = .color(color)
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The linear gradient color of the border.
  ///   - width: The width of the border.
  public init(color: LinearGradientColor, width: CGFloat) {
    self.color = .linearGradient(color)
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The linear gradient color of the border.
  ///   - width: The width of the border.
  public init(_ linearGradient: LinearGradientColor, _ width: CGFloat) {
    self.color = .linearGradient(linearGradient)
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The radial gradient color of the border.
  ///   - width: The width of the border.
  public init(color: RadialGradientColor, width: CGFloat) {
    self.color = .radialGradient(color)
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The radial gradient color of the border.
  ///   - width: The width of the border.
  public init(_ radialGradient: RadialGradientColor, _ width: CGFloat) {
    self.color = .radialGradient(radialGradient)
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The angular gradient color of the border.
  ///   - width: The width of the border.
  public init(color: AngularGradientColor, width: CGFloat) {
    self.color = .angularGradient(color)
    self.width = width
  }

  /// Creates a border with the given color and width.
  /// - Parameters:
  ///   - color: The angular gradient color of the border.
  ///   - width: The width of the border.
  public init(_ angularGradient: AngularGradientColor, _ width: CGFloat) {
    self.color = .angularGradient(angularGradient)
    self.width = width
  }
}
