//
//  View+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2020 Honghao Zhang.
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang (github.com/honghaoz)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
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
