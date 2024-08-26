//
//  LayoutAlignment.swift
//
//  Created by Honghao Zhang on 8/15/21.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import Foundation

/// The alignment of a subcomponent relative to its parent.
public enum LayoutAlignment: Hashable, Sendable {

  case center
  case left
  case right
  case top
  case bottom
  case topLeft
  case topRight
  case bottomLeft
  case bottomRight

  /// Flips the alignment vertically.
  ///
  /// This is useful for `NSWindow` coordinates (bottom-left zero origin).
  public func verticallyFlipped() -> LayoutAlignment {
    switch self {
    case .center:
      return .center
    case .left:
      return .left
    case .right:
      return .right
    case .top:
      return .bottom
    case .bottom:
      return .top
    case .topLeft:
      return .bottomLeft
    case .topRight:
      return .bottomRight
    case .bottomLeft:
      return .topLeft
    case .bottomRight:
      return .topRight
    }
  }
}
