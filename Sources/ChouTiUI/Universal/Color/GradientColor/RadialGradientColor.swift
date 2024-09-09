//
//  RadialGradientColor.swift
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

/// Radial gradient color.
public struct RadialGradientColor: GradientColorType, Equatable, Hashable {

  public static let clearGradientColor = RadialGradientColor(colors: [.clear, .clear], centerPoint: .center, endPoint: .top)

  public var centerPoint: UnitPoint { startPoint }

  public let colors: [Color]
  public let locations: [CGFloat]?
  public let startPoint: UnitPoint
  public let endPoint: UnitPoint

  #if canImport(QuartzCore)
  public var gradientLayerType: CAGradientLayerType { .radial }
  #endif

  /// Create a radial gradient color.
  ///
  /// - Parameters:
  ///   - colors: The colors from the center to the end. The count should be at least 2.
  ///   - locations: The color locations from the center to the end. The count should be the same as `colors`.
  ///   - startPoint: The center point.
  ///   - endPoint: The end position represented in a `UnitPoint`.
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

  /// Create a radial gradient color.
  ///
  /// Examples:
  /// ```swift
  /// RadialGradientColor(
  ///   colors: [Color.white, Color.black],
  ///   locations: [0, 1],
  ///   centerPoint: .center,
  ///   endPoint: .bottom
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - colors: The colors from the center to the end. The count should be at least 2.
  ///   - locations: The color locations from the center to the end. The count should be the same as `colors`.
  ///   - centerPoint: The center point.
  ///   - endPoint: The end position represented in a `UnitPoint`. The endPoint.x is the x-axis of the end point. The endPoint.y is the y-axis of the end point.
  public init(colors: [Color], locations: [CGFloat]? = nil, centerPoint: UnitPoint, endPoint: UnitPoint) {
    self.init(colors: colors, locations: locations, startPoint: centerPoint, endPoint: endPoint)
  }

  public func withComponents(colors: [Color], locations: [CGFloat]?, startPoint: UnitPoint, endPoint: UnitPoint) -> Self {
    RadialGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }
}

// MARK: - Convenience Initializers

public extension RadialGradientColor {

  /**
   Make a center radial circle gradient color based on aspect ratio.

   Example:
   ```swift
   RadialGradientColor.centerRadial(
     colors: [.clear, Color.black(alpha: 0.5), Color.black(alpha: 0.6)],
     locations: [0, 0.7, 1],
     radius: 0.5,
     aspectRatio: size.aspectRatio
   )
   ```

   - Parameters:
     - colors: The colors from center to edge. The count should be at least 2.
     - locations: The locations from center to edge. The count should be the same as `colors`.
     - radius: The radius in the narrow axis. For example, if `aspectRatio` < 1, 0.5 radius means the radial circle ends at the edge of x-axis.
     - aspectRatio: The aspect ratio of the frame.
   - Returns: A center radial gradient color.
   */
  static func centerRadial(colors: [Color],
                           locations: [CGFloat]? = nil,
                           radius: CGFloat,
                           aspectRatio: CGFloat) -> RadialGradientColor
  {
    if aspectRatio <= 1 {
      // portrait
      return RadialGradientColor(
        colors: colors,
        locations: locations,
        centerPoint: .center,
        endPoint: UnitPoint(0.5 + radius, 0.5 + radius * aspectRatio)
      )
    } else {
      // landscape
      return RadialGradientColor(
        colors: colors,
        locations: locations,
        centerPoint: .center,
        endPoint: UnitPoint(0.5 + radius / aspectRatio, 0.5 + radius)
      )
    }
  }

  /// The circle diameter.
  enum CircleDiameter: Equatable, Hashable {
    /// Use the frame rectangle's width as the circle's diameter. The circle is small.
    case width
    /// Use the frame rectangle's length as the circle's diameter. The circle is large.
    case length
    /// Use the frame rectangle's diagonal as the circle's diameter. The circle is even larger.
    case diagonal
  }

  /**
   Make a center radial circle gradient color based on aspect ratio.

   Example:
   ```swift
   RadialGradientColor.centerRadial(
     colors: [.red, .blue],
     locations: [0, 1],
     diameter: .diagonal,
     radiusScaleFactor: 1,
     aspectRatio: size.aspectRatio
   )
   ```

   - Parameters:
     - colors: The colors from center to edge. The count should be at least 2.
     - locations: The locations from center to edge. The count should be the same as `colors`.
     - diameter: The circle diameter.
     - radiusScaleFactor: The radius scale factor. By default this is 1.
     - aspectRatio: The aspect ratio of the frame.
   - Returns: A center radial gradient color.
   */
  static func centerRadial(colors: [Color],
                           locations: [CGFloat]? = nil,
                           diameter: CircleDiameter,
                           radiusScaleFactor: CGFloat = 1,
                           aspectRatio: CGFloat) -> RadialGradientColor
  {
    let adjustmentScaleFactor: CGFloat
    switch diameter {
    case .width:
      adjustmentScaleFactor = 1
    case .length:
      if aspectRatio <= 1 {
        // portrait
        adjustmentScaleFactor = 1 / aspectRatio
      } else {
        // landscape
        adjustmentScaleFactor = aspectRatio
      }
    case .diagonal:
      // make radius from center to corner
      let aspectRatioAngle = atan(aspectRatio)
      if aspectRatio <= 1 {
        // portrait
        adjustmentScaleFactor = 1 / sin(aspectRatioAngle)
      } else {
        // landscape
        adjustmentScaleFactor = 1 / cos(aspectRatioAngle)
      }
    }

    return RadialGradientColor.centerRadial(
      colors: colors,
      locations: locations,
      radius: 0.5 * radiusScaleFactor * adjustmentScaleFactor,
      aspectRatio: aspectRatio
    )
  }
}

/// Reference:
/// https://stackoverflow.com/a/57128786/3164091
/// https://ikyle.me/blog/2020/cagradientlayer-explained
