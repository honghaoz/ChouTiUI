//
//  NSRectCorner.swift
//
//  Created by Honghao Zhang on 3/27/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit

/// The corners of a rectangle.
///
/// This is the AppKit version of `UIRectCorner`.
public struct NSRectCorner: OptionSet, Hashable {

  /// The top left corner.
  public static let topLeft = NSRectCorner(rawValue: 1 << 0) // 1

  /// The top right corner.
  public static let topRight = NSRectCorner(rawValue: 1 << 1) // 2

  /// The bottom left corner.
  public static let bottomLeft = NSRectCorner(rawValue: 1 << 2) // 4

  /// The bottom right corner.
  public static let bottomRight = NSRectCorner(rawValue: 1 << 3) // 8

  /// All corners.
  public static let allCorners: NSRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]

  public let rawValue: UInt8

  /// Creates a structure that represents the corners of a rectangle.
  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
}

#endif
