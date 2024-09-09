//
//  LinearGradientColor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/3/21.
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

/// Linear gradient color.
public struct LinearGradientColor: GradientColorType, Equatable, Hashable {

  public static let clear = LinearGradientColor([.clear, .clear])

  public let colors: [Color]
  public let locations: [CGFloat]?
  public let startPoint: UnitPoint
  public let endPoint: UnitPoint

  #if canImport(QuartzCore)
  public var gradientLayerType: CAGradientLayerType { .axial }
  #endif

  /// Create a top-to-bottom linear gradient color.
  ///
  /// Example:
  /// ```swift
  /// // creates a gradient from top to bottom with two colors
  /// LinearGradientColor([Color.red, Color.yellow])
  ///
  /// // creates a gradient from top to bottom with three colors and specified locations
  /// LinearGradientColor([Color.red, Color.yellow, Color.blue], [0, 0.75, 1])
  /// ```
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient. The count should be at least 2.
  ///   - locations: The locations of the gradient. Defaults to `nil`.
  /// - Returns: A new linear gradient color.
  public init(_ colors: [Color], _ locations: [CGFloat]? = nil) {
    self.init(colors: colors, locations: locations, startPoint: .top, endPoint: .bottom)
  }

  /// Create a top-to-bottom linear gradient color.
  ///
  /// Example:
  /// ```
  /// LinearGradientColor(
  ///   Color.white,
  ///   Color.white(0.8)
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient. The count should be at least 2.
  /// - Returns: A new linear gradient color.
  public init(_ colors: Color...) {
    self.init(colors: colors, locations: nil, startPoint: .top, endPoint: .bottom)
  }

  /// Create a linear gradient color.
  ///
  /// Example:
  /// ```swift
  /// // creates a gradient from top to bottom with two colors
  /// LinearGradientColor([Color.red, Color.yellow], [0, 1], .top, .bottom)
  /// ```
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient. The count should be at least 2.
  ///   - locations: The locations of the gradient.
  ///   - startPoint: The start point of the gradient.
  ///   - endPoint: The end point of the gradient.
  /// - Returns: A new linear gradient color.
  public init(_ colors: [Color], _ locations: [CGFloat]?, _ startPoint: UnitPoint, _ endPoint: UnitPoint) {
    self.init(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }

  /// Create a linear gradient color.
  ///
  /// Example:
  /// ```swift
  /// LinearGradientColor(
  ///   colors: [
  ///     Color(h: 0, s: 0, b: 0.96, a: 1),
  ///     Color(h: 0, s: 0, b: 0.83, a: 1),
  ///     Color(h: 0, s: 0, b: 0.7, a: 1),
  ///   ],
  ///   locations: [
  ///     0,
  ///     0.75,
  ///     1.0,
  ///   ],
  ///   startPoint: .topLeft,
  ///   endPoint: .bottomRight
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - colors: The colors of the gradient. The count should be at least 2.
  ///   - locations: The locations of the gradient. The count should be the same as the count of `colors`. Defaults to `nil`.
  ///   - startPoint: The start point of the gradient. Defaults to `.top`.
  ///   - endPoint: The end point of the gradient. Defaults to `.bottom`.
  /// - Returns: A new linear gradient color.
  public init(colors: [Color], locations: [CGFloat]? = nil, startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) {
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

  /// Get the CGGradient of the linear gradient color.
  public var cgGradient: CGGradient? {
    CGGradient(colorsSpace: nil, colors: colors.map(\.cgColor) as CFArray, locations: locations)
  }

  /// Fill the current clipping region of `context` with the linear gradient color.
  ///
  /// Needs to provide explicit start and end points.
  ///
  /// - Parameters:
  ///   - context: The context to draw the gradient in.
  ///   - startPoint: The start point for the location 0 of the gradient.
  ///   - endPoint: The end point for the location 1 of the gradient.
  ///   - options: The options to control whether the gradient is drawn before the start point or after the end point. Defaults to `.drawsBeforeStartLocation` and `.drawsAfterEndLocation`.
  public func draw(in context: CGContext,
                   start startPoint: CGPoint,
                   end endPoint: CGPoint,
                   options: CGGradientDrawingOptions = [.drawsBeforeStartLocation, .drawsAfterEndLocation])
  {
    guard let cgGradient else {
      ChouTi.assertFailure("failed to get CGGradient", metadata: [
        "gradient": "\(self)",
      ])
      return
    }
    context.drawLinearGradient(cgGradient, start: startPoint, end: endPoint, options: options)
  }

  public func withComponents(colors: [Color], locations: [CGFloat]?, startPoint: UnitPoint, endPoint: UnitPoint) -> Self {
    LinearGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
  }

  // MARK: - Convenient

  /// Silver chrome.
  public static let silverChrome = LinearGradientColor(
    colors: [
      Color(h: 0, s: 0, b: 0.9, a: 1),
      Color(h: 0, s: 0, b: 0.75, a: 1),
      Color(h: 0, s: 0, b: 0.5, a: 1),
    ],
    locations: [
      0,
      0.5,
      1.0,
    ],
    startPoint: .top,
    endPoint: .bottom
  )

  /// A linear gradient color that creates a concave effect.
  ///
  /// This gradient simulates a recessed, dented, pressed, sunken, or curved-in appearance.
  public static let concaveGray = LinearGradientColor(
    colors: [
      Color(h: 0, s: 0, b: 0.8, a: 1),
      Color(h: 0, s: 0, b: 0.85, a: 1),
      Color(h: 0, s: 0, b: 0.9, a: 1),
    ],
    locations: [
      0,
      0.75,
      1.0,
    ],
    startPoint: .top,
    endPoint: .bottom
  )

  /// A linear gradient color that creates a convex effect.
  ///
  /// This gradient simulates a raised, elevated, or bulging appearance.
  public static let convexGray = LinearGradientColor(
    colors: [
      Color(h: 0, s: 0, b: 0.9, a: 1),
      Color(h: 0, s: 0, b: 0.8, a: 1),
      Color(h: 0, s: 0, b: 0.7, a: 1),
    ],
    locations: [
      0,
      0.5,
      1.0,
    ],
    startPoint: .top,
    endPoint: .bottom
  )

  /// https://stackoverflow.com/questions/9882791/how-to-make-recessed-button-in-css
  /// https://www.wordhippo.com/what-is/the-opposite-of/recessed.html
}
