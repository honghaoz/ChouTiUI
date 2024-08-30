//
//  NSView.AutoresizingMask+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2020 Honghao Zhang (github.com/honghaoz).
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang
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
