//
//  UnitPoint.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/25/21.
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

/// A point in the unit space.
public struct UnitPoint: Equatable, Hashable, Sendable {

  /// The x coordinate.
  public let x: Double

  /// The y coordinate.
  public let y: Double

  /// Initialize a unit point with the given x and y coordinates.
  ///
  /// - Parameters:
  ///   - x: The x coordinate.
  ///   - y: The y coordinate.
  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }

  /// Initialize a unit point with the given x and y coordinates.
  ///
  /// - Parameters:
  ///   - x: The x coordinate.
  ///   - y: The y coordinate.
  public init(_ x: Double, _ y: Double) {
    self.x = x
    self.y = y
  }

  /// Convert point in bounds to unit point.
  ///
  /// - Parameters:
  ///   - point: The point in bounds.
  ///   - bounds: The bounds.
  public init(point: CGPoint, in bounds: CGRect) {
    self.x = point.x / bounds.width
    self.y = point.y / bounds.height
  }

  /// The center point.
  public static let center = UnitPoint(x: 0.5, y: 0.5)

  /// The left point.
  public static let left = UnitPoint(x: 0, y: 0.5)

  /// The right point.
  public static let right = UnitPoint(x: 1, y: 0.5)

  /// The top point.
  public static let top = UnitPoint(x: 0.5, y: 0)

  /// The bottom point.
  public static let bottom = UnitPoint(x: 0.5, y: 1)

  /// The top left point.
  public static let topLeft = UnitPoint(x: 0, y: 0)

  /// The top right point.
  public static let topRight = UnitPoint(x: 1, y: 0)

  /// The bottom left point.
  public static let bottomLeft = UnitPoint(x: 0, y: 1)

  /// The bottom right point.
  public static let bottomRight = UnitPoint(x: 1, y: 1)

  /// Convert the unit point to a CGPoint.
  public var cgPoint: CGPoint {
    CGPoint(x: x, y: y)
  }

  /// Get CGPoint in the frame.
  ///
  /// - Parameters:
  ///   - frame: The frame.
  public func point(in frame: CGRect) -> CGPoint {
    CGPoint(x: frame.origin.x + frame.width * x, y: frame.origin.y + frame.height * y)
  }
}
