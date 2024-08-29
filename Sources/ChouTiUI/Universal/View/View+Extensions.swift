//
//  View+Extensions.swift
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTi

// MARK: - Layout

public extension View {

  /// Make this view same size as its superview.
  ///
  /// - Note: This method uses `autoresizingMask` to make the view same size as its superview.
  func makeFullSizeInSuperView() {
    guard let superview else {
      ChouTi.assertFailure("missing superview")
      return
    }

    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    frame = superview.bounds
  }

  /// Make view full width in super view and pin it at the top.
  ///
  /// For example, like a window title bar.
  ///
  /// - Note: This method uses `autoresizingMask` to make the view full width in super view and pin it at the top.
  func makeFullWidthAndPinToTopInSuperView(fixedHeight: CGFloat) {
    guard let superview else {
      ChouTi.assertFailure("missing superview")
      return
    }

    frame = superview.bounds.height(fixedHeight)
    autoresizingMask = [
      .flexibleWidth,
      .flexibleBottomMargin,
    ]
  }
}
