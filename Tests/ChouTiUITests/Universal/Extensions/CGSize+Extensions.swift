//
//  CGSize+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/22/24.
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

import ChouTiTest

import ChouTiUI

class CGSizeExtensionsTests: XCTestCase {

  func test_inset() {
    let size = CGSize(width: 100, height: 100)
    let edgeInsets = EdgeInsets(10, 20, 30, 40)
    let insetSize = size.inset(by: edgeInsets)
    expect(insetSize) == CGSize(width: 40, height: 60)
  }

  func test_expanded() {
    let size = CGSize(width: 100, height: 100)
    let edgeInsets = EdgeInsets(10, 20, 30, 40)
    let expandedSize = size.expanded(by: edgeInsets)
    expect(expandedSize) == CGSize(width: 160, height: 140)
  }

  func test_inset_with_zero() {
    let size = CGSize(width: 100, height: 100)
    let edgeInsets = EdgeInsets.zero
    let insetSize = size.inset(by: edgeInsets)
    expect(insetSize) == size
  }

  func test_expanded_with_zero() {
    let size = CGSize(width: 100, height: 100)
    let edgeInsets = EdgeInsets.zero
    let expandedSize = size.expanded(by: edgeInsets)
    expect(expandedSize) == size
  }

  func test_inset_with_negative_edge_insets() {
    let size = CGSize(width: 100, height: 100)
    let edgeInsets = EdgeInsets(-10, -20, -30, -40)
    let insetSize = size.inset(by: edgeInsets)
    expect(insetSize) == CGSize(width: 160, height: 140)
  }

  func test_expanded_with_negative_edge_insets() {
    let size = CGSize(width: 100, height: 100)
    let edgeInsets = EdgeInsets(-10, -20, -30, -40)
    let expandedSize = size.expanded(by: edgeInsets)
    expect(expandedSize) == CGSize(width: 40, height: 60)
  }
}
