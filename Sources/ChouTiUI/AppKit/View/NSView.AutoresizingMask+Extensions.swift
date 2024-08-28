//
//  NSView.AutoresizingMask+Extensions.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit

/// For UIKit compatibility.
public extension NSView.AutoresizingMask {

  /// Resizing performed by expanding or shrinking a view’s width.
  static let flexibleWidth: Self = .width

  /// Resizing performed by expanding or shrinking a view's height.
  static let flexibleHeight: Self = .height

  /// Resizing performed by expanding or shrinking a view in the direction of the left margin.
  static let flexibleLeftMargin: Self = .minXMargin

  /// Resizing performed by expanding or shrinking a view in the direction of the right margin.
  static let flexibleRightMargin: Self = .maxXMargin

  /// Resizing performed by expanding or shrinking a view in the direction of the top margin.
  static let flexibleTopMargin: Self = .minYMargin

  /// Resizing performed by expanding or shrinking a view in the direction of the bottom margin.
  static let flexibleBottomMargin: Self = .maxYMargin
}

#endif
