//
//  LayoutRect.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import CoreGraphics
import Foundation

/// A type represents a rectangle using LayoutDimension.
public struct LayoutRect: Equatable, Sendable {

  /// The zero rectangle, with zero origin and zero size.
  public static let zero: LayoutRect = LayoutRect(.zero, .zero)

  /// The origin of the rectangle.
  public let origin: LayoutPoint

  /// The size of the rectangle.
  public let size: LayoutSize

  /// Initializes a rectangle with the given origin and size.
  ///
  /// - Parameters:
  ///   - origin: The origin of the rectangle.
  ///   - size: The size of the rectangle.
  public init(_ origin: LayoutPoint, _ size: LayoutSize) {
    self.origin = origin
    self.size = size
  }

  /// Initializes a rectangle with the given origin and size.
  ///
  /// - Parameters:
  ///   - origin: The origin of the rectangle.
  ///   - size: The size of the rectangle.
  public init(origin: LayoutPoint, size: LayoutSize) {
    self.origin = origin
    self.size = size
  }

  /// Returns a Boolean value indicating whether the rectangle has zero origin and zero size.
  public func isZero() -> Bool {
    origin.isZero() && size.isZero()
  }

  /// Returns a CGRect with the given container size.
  ///
  /// - Parameters:
  ///   - size: The size of the container.
  public func cgRect(from size: CGSize) -> CGRect {
    CGRect(origin: origin.cgPoint(from: size), size: self.size.cgSize(from: size))
  }
}
