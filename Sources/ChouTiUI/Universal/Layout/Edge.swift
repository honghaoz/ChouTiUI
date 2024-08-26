//
//  Edge.swift
//
//  Created by Honghao Zhang on 3/18/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit
#endif

/// A type indicates one edge of a rectangle.
public enum Edge: Sendable {

  case top
  case left
  case bottom
  case right

  /// Flips the edge vertically.
  ///
  /// This is useful for `NSWindow` coordinates (bottom-left zero origin).
  public func flipped() -> Edge {
    switch self {
    case .top:
      return .bottom
    case .left:
      return .right
    case .bottom:
      return .top
    case .right:
      return .left
    }
  }

  #if os(macOS)
  /// Converts the edge to `NSRectEdge`.
  ///
  /// Used in `NSPopover`.
  public var rectEdge: NSRectEdge {
    switch self {
    case .top:
      return .minY
    case .left:
      return .minX
    case .bottom:
      return .maxY
    case .right:
      return .maxX
    }
  }
  #endif
}
