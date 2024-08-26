//
//  LayoutDimension.swift
//
//  Created by Honghao Zhang on 7/5/21.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import CoreGraphics

/// A type represents a length dimension.
public enum LayoutDimension: Comparable, Hashable, Sendable {

  /// The zero dimension.
  public static let zero: Self = .absolute(0)

  /// The 100% dimension.
  public static let one: Self = .relative(1)

  /// The half dimension.
  public static let half: Self = .relative(0.5)

  /// The double dimension.
  public static let double: Self = .relative(2)

  /// The absolute dimension.
  case absolute(_ dimension: CGFloat)

  /// The relative dimension.
  case relative(_ percentage: CGFloat)

  /// The mixed dimension.
  case mixed(_ percentage: CGFloat, _ absoluteDimension: CGFloat)

  /// Get the absolute length from the container size.
  ///
  /// - Parameter containerSize: The container size.
  /// - Returns: The absolute length.
  public func length(from containerSize: CGFloat) -> CGFloat {
    switch self {
    case .absolute(let dimension):
      return dimension
    case .relative(let percentage):
      return containerSize * percentage
    case .mixed(let percentage, let absoluteDimension):
      return containerSize * percentage + absoluteDimension
    }
  }

  /// Check if the dimension is zero.
  ///
  /// - Returns: A boolean value indicating if the dimension is zero.
  public func isZero() -> Bool {
    switch self {
    case .absolute(let dimension):
      return dimension == 0
    case .relative(let percentage):
      return percentage == 0
    case .mixed(let percentage, let dimension):
      return dimension == 0 && percentage == 0
    }
  }
}

// MARK: - Operator +

infix operator +: AdditionPrecedence

/// Support addition of two `LayoutDimension`.
///
/// - Parameters:
///   - lhs: A `LayoutDimension`.
///   - rhs: A `LayoutDimension`.
/// - Returns: A `LayoutDimension` that is the sum of the two dimensions.
public func + (lhs: LayoutDimension, rhs: LayoutDimension) -> LayoutDimension {
  switch (lhs, rhs) {
  case (.absolute(let dimension1), .absolute(let dimension2)):
    return .absolute(dimension1 + dimension2)
  case (.absolute(let dimension), .relative(let percentage)):
    return .mixed(percentage, dimension)
  case (.absolute(let dimension1), .mixed(let percentage, let dimension2)):
    return .mixed(percentage, dimension1 + dimension2)
  case (.relative(let percentage), .absolute(let dimension)):
    return .mixed(percentage, dimension)
  case (.relative(let percentage1), .relative(let percentage2)):
    return .relative(percentage1 + percentage2)
  case (.relative(let percentage1), .mixed(let percentage2, let dimension)):
    return .mixed(percentage1 + percentage2, dimension)
  case (.mixed(let percentage, let dimension1), .absolute(let dimension2)):
    return .mixed(percentage, dimension1 + dimension2)
  case (.mixed(let percentage1, let dimension), .relative(let percentage2)):
    return .mixed(percentage1 + percentage2, dimension)
  case (.mixed(let percentage1, let dimension1), .mixed(let percentage2, let dimension2)):
    return .mixed(percentage1 + percentage2, dimension1 + dimension2)
  }
}
