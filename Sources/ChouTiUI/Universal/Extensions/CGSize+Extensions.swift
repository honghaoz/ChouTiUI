//
//  CGSize+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/25/21.
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

import CoreGraphics

import ChouTi

public extension CGSize {

  /// Insets the size by the given edge insets.
  ///
  /// - Parameters:
  ///   - edgeInsets: The edge insets to be applied to the size.
  /// - Returns: A new size that is inset by the given edge insets.
  @inlinable
  @inline(__always)
  func inset(by edgeInsets: EdgeInsets) -> CGSize {
    CGSize(width - edgeInsets.horizontal, height - edgeInsets.vertical)
  }

  /// Expands the size by the given margins represented as an `EdgeInsets`.
  ///
  /// - Parameters:
  ///   - edgeInsets: The margins to be applied to the size.
  /// - Returns: A new size that is expanded by the given margins.
  @inlinable
  @inline(__always)
  func expanded(by edgeInsets: EdgeInsets) -> CGSize {
    CGSize(width + edgeInsets.horizontal, height + edgeInsets.vertical)
  }
}
