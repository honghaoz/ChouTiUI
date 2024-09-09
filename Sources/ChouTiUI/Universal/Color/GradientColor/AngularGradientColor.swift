//
//  AngularGradientColor.swift
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

/// Angular gradient color.
public struct AngularGradientColor: GradientColorType, Equatable, Hashable {

  public static let clearGradientColor = AngularGradientColor(colors: [.clear, .clear], centerPoint: .center, aimingPoint: .top)

  public var centerPoint: UnitPoint { startPoint }
  public var aimingPoint: UnitPoint { endPoint }

  public let colors: [Color]
  public let locations: [CGFloat]?
  public let startPoint: UnitPoint
  public let endPoint: UnitPoint

  #if canImport(QuartzCore)
  public var gradientLayerType: CAGradientLayerType { .conic }
  #endif

  /// Create an angular gradient color.
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient. The count should be at least 2.
  ///   - locations: The locations of the gradient. The count should be the same as the count of `colors`. Defaults to `nil`.
  ///   - startPoint: The start point of the gradient.
  ///   - endPoint: The end point of the gradient.
  /// - Returns: A new angular gradient color.
  public init(colors: [Color], locations: [CGFloat]? = nil, startPoint: UnitPoint, endPoint: UnitPoint) {
    ChouTi.assert(colors.count >= 2, "gradient color should have at least 2 colors.", metadata: [
      "colors": "\(colors)",
    ])
    // swiftlint:disable:next force_unwrapping
    ChouTi.assert(locations == nil || locations!.count == colors.count, "locations should have the same count as colors", metadata: [
      "colors": "\(colors)",
      "locations": "\(locations!)", // swiftlint:disable:this force_unwrapping
    ])
    self.colors = colors
    self.locations = locations
    self.startPoint = startPoint
    self.endPoint = endPoint
  }

  /// Create an angular gradient color.
  ///
  /// Example:
  ///
  /// ```swift
  /// AngularGradientColor(colors: [UIColor.red, UIColor.yellow], centerPoint: .center, aimingPoint: .top)
  /// ```
  ///
  /// ```swift
  /// AngularGradientColor(
  ///   colors: [
  ///     Color(h: 0, s: 0, b: 0.96, a: 1),
  ///     Color(h: 0, s: 0, b: 0.83, a: 1),
  ///   ],
  ///   locations: [
  ///     0,
  ///     1.0,
  ///   ],
  ///   centerPoint: .center,
  ///   aimingPoint: .bottom
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient. The count should be at least 2.
  ///   - locations: The locations of the gradient. The count should be the same as the count of `colors`. Defaults to `nil`.
  ///   - centerPoint: The center point of the gradient.
  ///   - aimingPoint: The aiming point of the gradient.
  /// - Returns: A new angular gradient color.
  public init(colors: [Color], locations: [CGFloat]? = nil, centerPoint: UnitPoint, aimingPoint: UnitPoint) {
    self.init(colors: colors, locations: locations, startPoint: centerPoint, endPoint: aimingPoint)
  }

  public func withComponents(colors: [Color], locations: [CGFloat]?, startPoint: UnitPoint, endPoint: UnitPoint) -> Self {
    AngularGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }
}

/// https://ikyle.me/blog/2020/cagradientlayer-explained
