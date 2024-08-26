//
//  Margin.swift
//
//  Created by Honghao Zhang on 12/20/21.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import CoreGraphics

/// A type that represents the margin of a layout.
public struct Margin: CustomStringConvertible, Hashable, Sendable {

  /// The zero margin.
  public static let zero = Margin()

  /// The half margin.
  public static let half = Margin(.half, .half, .half, .half)

  /// The 100% margin.
  public static let one = Margin(.one, .one, .one, .one)

  /// The top margin.
  public let top: LayoutDimension

  /// The left margin.
  public let left: LayoutDimension

  /// The bottom margin.
  public let bottom: LayoutDimension

  /// The right margin.
  public let right: LayoutDimension

  /// Initializes a margin with the given top, left, bottom, and right margins.
  ///
  /// - Parameters:
  ///   - top: The top margin.
  ///   - left: The left margin.
  ///   - bottom: The bottom margin.
  ///   - right: The right margin.
  public init(top: LayoutDimension = .zero, left: LayoutDimension = .zero, bottom: LayoutDimension = .zero, right: LayoutDimension = .zero) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  /// Initializes a margin with the given top, left, bottom, and right margins.
  ///
  /// - Parameters:
  ///   - top: The top margin.
  ///   - left: The left margin.
  ///   - bottom: The bottom margin.
  ///   - right: The right margin.
  public init(_ top: LayoutDimension, _ left: LayoutDimension, _ bottom: LayoutDimension, _ right: LayoutDimension) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  /// Initializes a margin with the given absolute top, left, bottom, and right margins.
  ///
  /// - Parameters:
  ///   - top: The absolute top margin.
  ///   - left: The absolute left margin.
  ///   - bottom: The absolute bottom margin.
  ///   - right: The absolute right margin.
  public init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
    self.top = .absolute(top)
    self.left = .absolute(left)
    self.bottom = .absolute(bottom)
    self.right = .absolute(right)
  }

  /// Initializes a margin with the given absolute size for all sides.
  ///
  /// - Parameters:
  ///   - size: The absolute size for all sides.
  public init(_ size: CGFloat) {
    self.top = .absolute(size)
    self.left = .absolute(size)
    self.bottom = .absolute(size)
    self.right = .absolute(size)
  }

  /// Initializes a margin with the given horizontal and vertical margins.
  ///
  /// - Parameters:
  ///   - horizontal: The horizontal margin.
  ///   - vertical: The vertical margin.
  public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
    self.init(top: .absolute(vertical), left: .absolute(horizontal), bottom: .absolute(vertical), right: .absolute(horizontal))
  }

  /// Returns the description of the margin.
  public var description: String {
    "(\(top), \(left), \(bottom), \(right))"
  }
}
