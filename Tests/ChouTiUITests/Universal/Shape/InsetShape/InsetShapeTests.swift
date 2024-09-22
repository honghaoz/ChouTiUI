//
//  InsetShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/3/21.
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

import CoreGraphics

import ChouTiTest

import ChouTiUI

class InsetShapeTests: XCTestCase {

  func test_init() {
    // init with shape, no insets
    do {
      let shape = Rectangle()
      let insetShape = InsetShape(shape: shape)
      expect(insetShape.shape) == shape
      expect(insetShape.insets) == LayoutEdgeInsets.zero
    }

    // init with shape, with insets
    do {
      let shape = Rectangle()
      let insetShape = InsetShape(shape: shape, insets: LayoutEdgeInsets(10, 20, 30, 40))
      expect(insetShape.shape) == shape
      expect(insetShape.insets) == LayoutEdgeInsets(10, 20, 30, 40)
    }
  }

  func test_path() {
    // zero insets
    do {
      let shape = Rectangle()
      let insetShape = InsetShape(shape: shape)
      let path = insetShape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
      expect(path) == shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    // non-zero insets
    do {
      let shape = Rectangle()
      let insetShape = InsetShape(shape: shape, insets: LayoutEdgeInsets(10, 20, 30, 40))
      let path = insetShape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
      expect(path) == shape.path(in: CGRect(x: 20, y: 10, width: 40, height: 60))
    }
  }

  func test_offsetable() {
    let shape = Rectangle()
    let insetShape = InsetShape(shape: shape, insets: LayoutEdgeInsets(10, 20, 30, 40))
    let path = insetShape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100), offset: 10)
    expect(path) == shape.path(in: CGRect(x: 10, y: 0, width: 60, height: 80))
  }
}
