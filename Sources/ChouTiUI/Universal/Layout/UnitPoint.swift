//
//  UnitPoint.swift
//
//  Created by Honghao Zhang on 8/25/21.
//  Copyright © 2024 ChouTi. All rights reserved.
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
