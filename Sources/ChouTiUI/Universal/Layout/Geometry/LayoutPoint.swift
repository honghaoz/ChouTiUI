//
//  LayoutPoint.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
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
