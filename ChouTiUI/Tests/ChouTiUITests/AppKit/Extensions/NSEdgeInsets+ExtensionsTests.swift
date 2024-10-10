//
//  NSEdgeInsets+ExtensionsTests.swift
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

import ChouTiTest

import ChouTiUI

class NSEdgeInsets_ExtensionsTests: XCTestCase {

  func test_zero() {
    let insets = NSEdgeInsets.zero
    expect(insets.top) == 0
    expect(insets.left) == 0
    expect(insets.bottom) == 0
    expect(insets.right) == 0
  }

  func test_equal() {
    let insets1 = NSEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
    let insets2 = NSEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
    expect(insets1) == insets2
  }
}

#endif
