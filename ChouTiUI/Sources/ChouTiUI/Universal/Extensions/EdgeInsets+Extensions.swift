//
//  EdgeInsets+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/18/21.
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

public extension EdgeInsets {

  /// The inset amount on the horizontal axis.
  var horizontal: CGFloat { left + right }

  /// The inset amount on the vertical axis.
  var vertical: CGFloat { top + bottom }

  /// Creates an `EdgeInsets` with the specified top, left, bottom, and right insets.
  ///
  /// - Parameters:
  ///   - top: The top inset amount.
  ///   - left: The left inset amount.
  ///   - bottom: The bottom inset amount.
  ///   - right: The right inset amount.
  init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
    self.init(top: top, left: left, bottom: bottom, right: right)
  }

  /// Creates an `EdgeInsets` with the specified horizontal and vertical insets.
  ///
  /// - Parameters:
  ///   - horizontal: The inset amount on the horizontal axis.
  ///   - vertical: The inset amount on the vertical axis.
  init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
    self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }

  /// Returns a new `EdgeInsets` with the specified insets.
  ///
  /// - Parameters:
  ///   - top: The top inset amount.
  ///   - left: The left inset amount.
  ///   - bottom: The bottom inset amount.
  ///   - right: The right inset amount.
  func with(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> EdgeInsets {
    EdgeInsets(top ?? self.top, left ?? self.left, bottom ?? self.bottom, right ?? self.right)
  }
}

// MARK: - Hashable

extension EdgeInsets: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(top)
    hasher.combine(left)
    hasher.combine(bottom)
    hasher.combine(right)
  }
}
