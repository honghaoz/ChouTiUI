//
//  EdgeInsets+ExtensionsTests.swift
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

import ChouTiTest

import ChouTiUI

class EdgeInsets_ExtensionsTests: XCTestCase {

  func test_init() {
    // init with top, left, bottom, right
    do {
      let edgeInsets = EdgeInsets(10, 20, 30, 40)
      expect(edgeInsets.top) == 10
      expect(edgeInsets.left) == 20
      expect(edgeInsets.bottom) == 30
      expect(edgeInsets.right) == 40
    }

    // init with horizontal and vertical
    do {
      let edgeInsets = EdgeInsets(horizontal: 10, vertical: 20)
      expect(edgeInsets.top) == 20
      expect(edgeInsets.left) == 10
      expect(edgeInsets.bottom) == 20
      expect(edgeInsets.right) == 10
    }
  }

  func test_horizontal() {
    expect(EdgeInsets(10, 20, 30, 40).horizontal) == 60
    expect(EdgeInsets.zero.horizontal) == 0
  }

  func test_vertical() {
    expect(EdgeInsets(10, 20, 30, 40).vertical) == 40
    expect(EdgeInsets.zero.vertical) == 0
  }

  func test_with() {
    // with all
    do {
      let edgeInsets = EdgeInsets(10, 20, 30, 40)
      let edgeInsets2 = edgeInsets.with(top: 100, left: 200, bottom: 300, right: 400)
      expect(edgeInsets2.top) == 100
      expect(edgeInsets2.left) == 200
      expect(edgeInsets2.bottom) == 300
      expect(edgeInsets2.right) == 400
    }

    // with some
    do {
      let edgeInsets = EdgeInsets(10, 20, 30, 40)
      let edgeInsets2 = edgeInsets.with(top: 100, left: 200)
      expect(edgeInsets2.top) == 100
      expect(edgeInsets2.left) == 200
      expect(edgeInsets2.bottom) == 30
      expect(edgeInsets2.right) == 40
    }

    // with none
    do {
      let edgeInsets = EdgeInsets(10, 20, 30, 40)
      let edgeInsets2 = edgeInsets.with()
      expect(edgeInsets2.top) == 10
      expect(edgeInsets2.left) == 20
      expect(edgeInsets2.bottom) == 30
      expect(edgeInsets2.right) == 40
    }
  }

  func test_hashable() {
    let edgeInsets1 = EdgeInsets(10, 20, 30, 40)
    let edgeInsets2 = EdgeInsets(10, 20, 30, 40)
    expect(edgeInsets1.hashValue) == edgeInsets2.hashValue

    let edgeInsets3 = EdgeInsets(10, 20, 30, 41)
    expect(edgeInsets1.hashValue) != edgeInsets3.hashValue
  }

  func test_equal() {
    let edgeInsets1 = EdgeInsets(10, 20, 30, 40)
    let edgeInsets2 = EdgeInsets(10, 20, 30, 40)
    expect(edgeInsets1) == edgeInsets2
  }
}
