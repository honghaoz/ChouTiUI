//
//  LayoutPoint.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/2/22.
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
import Foundation

/// A type represents a point using LayoutDimension.
public struct LayoutPoint: Equatable, Sendable {

  /// The zero point.
  public static let zero: LayoutPoint = LayoutPoint(.absolute(0), .absolute(0))

  /// The x coordinate.
  public let x: LayoutDimension

  /// The y coordinate.
  public let y: LayoutDimension

  /// Initializes a point with the given x and y coordinates.
  ///
  /// - Parameters:
  ///   - x: The x coordinate.
  ///   - y: The y coordinate.
  public init(_ x: LayoutDimension, _ y: LayoutDimension) {
    self.x = x
    self.y = y
  }

  /// Initializes a point with the given x and y coordinates.
  ///
  /// - Parameters:
  ///   - x: The x coordinate.
  ///   - y: The y coordinate.
  public init(x: LayoutDimension, y: LayoutDimension) {
    self.x = x
    self.y = y
  }

  /// Initializes an absolute point with the given x and y coordinates.
  ///
  /// - Parameters:
  ///   - x: The absolute x coordinate.
  ///   - y: The absolute y coordinate.
  public init(x: CGFloat, y: CGFloat) {
    self.x = .absolute(x)
    self.y = .absolute(y)
  }

  /// Returns a Boolean value indicating whether the point is zero.
  public func isZero() -> Bool {
    x.isZero() && y.isZero()
  }

  /// Returns the point from the given container size.
  ///
  /// - Parameters:
  ///   - size: The container size.
  /// - Returns: The point.
  public func cgPoint(from size: CGSize) -> CGPoint {
    CGPoint(x: x.length(from: size.width), y: y.length(from: size.height))
  }
}
