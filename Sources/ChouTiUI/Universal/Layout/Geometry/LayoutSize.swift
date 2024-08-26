//
//  LayoutSize.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import CoreGraphics
import Foundation

/// A type represents a size using LayoutDimension.
public struct LayoutSize: Equatable, Sendable {

  /// The zero size.
  public static let zero: LayoutSize = LayoutSize(.absolute(0), .absolute(0))

  /// The width.
  public let width: LayoutDimension

  /// The height.
  public let height: LayoutDimension

  /// Initializes a size with the given width and height.
  ///
  /// - Parameters:
  ///   - width: The width.
  ///   - height: The height.
  public init(_ width: LayoutDimension, _ height: LayoutDimension) {
    self.width = width
    self.height = height
  }

  /// Initializes a size with the given width and height.
  ///
  /// - Parameters:
  ///   - width: The width.
  ///   - height: The height.
  public init(width: LayoutDimension, height: LayoutDimension) {
    self.width = width
    self.height = height
  }

  /// Returns a Boolean value indicating whether the size has zero width and height.
  public func isZero() -> Bool {
    width.isZero() && height.isZero()
  }

  /// Returns a CGSize with the given container size.
  ///
  /// - Parameters:
  ///   - size: The size of the container.
  public func cgSize(from size: CGSize) -> CGSize {
    CGSize(width: width.length(from: size.width), height: height.length(from: size.height))
  }
}
