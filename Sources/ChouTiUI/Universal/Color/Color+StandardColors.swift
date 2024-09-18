//
//  Color+StandardColors.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/7/23.
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

  /// Create a grayscale color.
  ///
  /// - Parameters:
  ///   - white: The grayscale value. In the range of 0 to 1. 0 is black, 1 is white.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1.
  @inlinable
  @inline(__always)
  convenience init(white: CGFloat) {
    self.init(white: white, alpha: 1)
  }

  /// Create a grayscale color using white value.
  ///
  /// - Parameters:
  ///   - white: The grayscale value. In the range of 0 to 1. 0 is black, 1 is white. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  @inlinable
  @inline(__always)
  static func white(_ white: CGFloat = 1, alpha: CGFloat = 1) -> Color {
    Color(white: white, alpha: alpha)
  }

  /// Create a grayscale color using black value.
  ///
  /// - Parameters:
  ///   - black: The grayscale value. In the range of 0 to 1. 0 is white, 1 is black. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  @inlinable
  @inline(__always)
  static func black(_ black: CGFloat = 1, alpha: CGFloat = 1) -> Color {
    Color(white: 1 - black, alpha: alpha)
  }

  // MARK: - White/Black in RGB.

  /// White color in sRGB space.
  static let whiteRGB = Color.rgb(r: 1.0, g: 1.0, b: 1.0, colorSpace: .sRGB)

  /// Gray color in sRGB space.
  static let grayRGB = Color.rgb(r: 0.5, g: 0.5, b: 0.5, colorSpace: .sRGB)

  /// Black color in sRGB space.
  static let blackRGB = Color.rgb(r: 0, g: 0, b: 0, colorSpace: .sRGB)

  /// Create a grayscale color using RGB components.
  ///
  /// - Parameters:
  ///   - white: The grayscale value. In the range of 0 to 1. 0 is black, 1 is white. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  ///   - colorSpace: The color space of the color. Defaults to `.sRGB`.
  @inlinable
  @inline(__always)
  static func whiteRGB(_ white: CGFloat = 1, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> Color {
    Color(red: white, green: white, blue: white, alpha: alpha, colorSpace: colorSpace)
  }

  /// Create a grayscale color using RGB components.
  ///
  /// - Parameters:
  ///   - black: The grayscale value. In the range of 0 to 1. 0 is white, 1 is black. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  ///   - colorSpace: The color space of the color. Defaults to `.sRGB`.
  @inlinable
  @inline(__always)
  static func blackRGB(_ black: CGFloat = 1, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> Color {
    let white = 1 - black
    return Color(red: white, green: white, blue: white, alpha: alpha, colorSpace: colorSpace)
  }

  // MARK: - RGB

  /// Create a red color.
  ///
  /// - Parameters:
  ///   - value: The red value. In the range of 0 to 1. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  ///   - colorSpace: The color space of the color. Defaults to `.sRGB`.
  @inlinable
  @inline(__always)
  static func red(_ value: CGFloat = 1, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> Color {
    Color(red: 1, green: 1 - value, blue: 1 - value, alpha: alpha, colorSpace: colorSpace)
  }

  /// Create a green color.
  ///
  /// - Parameters:
  ///   - value: The green value. In the range of 0 to 1. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  ///   - colorSpace: The color space of the color. Defaults to `.sRGB`.
  @inlinable
  @inline(__always)
  static func green(_ value: CGFloat = 1, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> Color {
    Color(red: 1 - value, green: 1, blue: 1 - value, alpha: alpha, colorSpace: colorSpace)
  }

  /// Create a blue color.
  ///
  /// - Parameters:
  ///   - value: The blue value. In the range of 0 to 1. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  ///   - colorSpace: The color space of the color. Defaults to `.sRGB`.
  @inlinable
  @inline(__always)
  static func blue(_ value: CGFloat = 1, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> Color {
    Color(red: 1 - value, green: 1 - value, blue: 1, alpha: alpha, colorSpace: colorSpace)
  }

  // MARK: - White Blue

  /// The slightly blue tinted white used in UI.
  static let whiteBlue: Color = .whiteBlue(1)

  /// Create a slightly blue tinted white color.
  ///
  /// - Parameters:
  ///   - value: The white value. In the range of 0 to 1. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  @inlinable
  @inline(__always)
  static func whiteBlue(_ white: CGFloat = 1, alpha: CGFloat = 1) -> Color {
    Color.hsba(205 / 360, 2 / 100, white, alpha)
    // on Mac,
    // radio black (key, blue background) - RGB: 1, 25, 49
    // radio black (non-key, white background) - RGB: 53, 53, 53
  }

  /// The slightly blue tinted black used in UI.
  static let blackBlue: Color = .blackBlue(1)

  /// Create a slightly blue tinted black color.
  ///
  /// - Parameters:
  ///   - black: The black value. In the range of 0 to 1. Defaults to 1.
  ///   - alpha: The alpha component of the color. In the range of 0 to 1. Defaults to 1.
  @inlinable
  @inline(__always)
  static func blackBlue(_ black: CGFloat = 1, alpha: CGFloat = 1) -> Color {
    whiteBlue(1 - black, alpha: alpha)
  }
}
