//
//  NSScreen+Extensions.swift
//
//  Created by Honghao Zhang on 11/7/21.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit

public extension NSScreen {

  /// The screen scale factor.
  ///
  /// This is equivalent to `backingScaleFactor`.
  @inlinable
  @inline(__always)
  var scale: CGFloat {
    backingScaleFactor
  }
}

#endif
