//
//  UnifiedColor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/18/21.
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
import Foundation

/// A color type that represents either a solid color or a gradient color.
public enum UnifiedColor: Hashable {

  /// A solid color.
  case color(Color)

  /// A gradient color.
  case gradient(GradientColor)

  /// Get the solid color if it's a solid color, otherwise nil.
  public var solidColor: Color? {
    switch self {
    case .color(let color):
      return color
    case .gradient:
      return nil
    }
  }

  /// Get the gradient color if it's a gradient color, otherwise nil.
  public var gradientColor: GradientColorType? {
    switch self {
    case .color:
      return nil
    case .gradient(let gradient):
      return gradient.gradientColor
    }
  }

  /// Check if it's a solid color.
  public var isSolidColor: Bool {
    switch self {
    case .color:
      return true
    case .gradient:
      return false
    }
  }

  /// Check if it's a gradient color.
  @inlinable
  @inline(__always)
  public var isGradientColor: Bool {
    !isSolidColor
  }

  /// Check if it's an opaque color.
  public var isOpaque: Bool {
    switch self {
    case .color(let color):
      return color.isOpaque
    case .gradient(let gradient):
      return gradient.gradientColor.isOpaque
    }
  }

  /// Create a new color with adjusted opacity.
  ///
  /// - Parameter adjustOpacity: A closure that takes the current opacity and returns the new opacity.
  public func opacity(_ adjustOpacity: (_ currentOpacity: CGFloat) -> CGFloat) -> UnifiedColor {
    switch self {
    case .color(let color):
      return .color(color.opacity(adjustOpacity))
    case .gradient(let gradientColor):
      return .gradient(gradientColor.opacity(adjustOpacity))
    }
  }
}

public extension UnifiedColor {

  /// Create a new linear gradient color.
  ///
  /// - Parameter gradient: The linear gradient color.
  @inlinable
  @inline(__always)
  static func linearGradient(_ gradient: LinearGradientColor) -> UnifiedColor {
    .gradient(.linearGradient(gradient))
  }

  /// Create a new radial gradient color.
  ///
  /// - Parameter gradient: The radial gradient color.
  @inlinable
  @inline(__always)
  static func radialGradient(_ gradient: RadialGradientColor) -> UnifiedColor {
    .gradient(.radialGradient(gradient))
  }

  /// Create a new angular gradient color.
  ///
  /// - Parameter gradient: The angular gradient color.
  @inlinable
  @inline(__always)
  static func angularGradient(_ gradient: AngularGradientColor) -> UnifiedColor {
    .gradient(.angularGradient(gradient))
  }
}

public extension Color {

  /// Create a new unified color with the current color.
  @inlinable
  @inline(__always)
  var unifiedColor: UnifiedColor {
    .color(self)
  }
}

// MARK: - Deprecated

// --------------------------------------------------
// The following methods can create ambiguous usages.
// --------------------------------------------------

// public extension ThemedColor {
//
//   static let clear: UnifiedColor = .color(.clear)
//
//   static func rgba(_ r: CGFloat = 0, _ g: CGFloat = 0, _ b: CGFloat = 0, _ a: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> UnifiedColor {
//     .color(.rgba(r, g, b, a, colorSpace: colorSpace))
//   }
//
//   static func rgb(_ r: CGFloat = 0, _ g: CGFloat = 0, _ b: CGFloat = 0, colorSpace: ColorSpace = .sRGB) -> UnifiedColor {
//     .color(.rgba(r, g, b, 1, colorSpace: colorSpace))
//   }
//
//   static func hsba(_ h: CGFloat = 0, _ s: CGFloat = 0, _ b: CGFloat = 0, _ a: CGFloat = 1) -> UnifiedColor {
//     .color(.hsba(h, s, b, a))
//   }
//
//   static func hsb(_ h: CGFloat = 0, _ s: CGFloat = 0, _ b: CGFloat = 0) -> UnifiedColor {
//     .color(.hsb(h, s, b))
//   }
//
//   static func hex(_ hex: String, colorSpace: ColorSpace = .sRGB, fallbackColor: Color = .clear) -> UnifiedColor {
//     .color(.hex(hex, colorSpace: colorSpace, fallbackColor: fallbackColor))
//   }
//
//   static func white(_ white: CGFloat = 1, alpha: CGFloat = 1) -> UnifiedColor {
//     .color(Color(white: white, alpha: alpha))
//   }
//
//   static func black(_ black: CGFloat = 1, alpha: CGFloat = 1) -> UnifiedColor {
//     .color(Color(white: 1 - black, alpha: alpha))
//   }
// }
