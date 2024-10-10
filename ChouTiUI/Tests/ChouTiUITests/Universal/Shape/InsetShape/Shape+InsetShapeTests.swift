//
//  Shape+InsetShapeTests.swift
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

import CoreGraphics

import ChouTiTest

import ChouTiUI

class Shape_InsetShapeTests: XCTestCase {

  func test_inset_byAmount() {
    // zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(by: 0)
      expect(insetShape) == InsetShape(shape: shape)
    }

    // non-zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(by: 10)
      expect(insetShape) == InsetShape(shape: shape, insets: LayoutEdgeInsets(10, 10, 10, 10))
    }
  }

  func test_inset_byTopLeftBottomRight() {
    // zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(top: 0, left: 0, bottom: 0, right: 0)
      expect(insetShape) == InsetShape(shape: shape)
      let insetShape2 = shape.inset(0, 0, 0, 0)
      expect(insetShape2) == InsetShape(shape: shape)
    }

    // non-zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(top: 10, left: 20, bottom: 30, right: 40)
      expect(insetShape) == InsetShape(shape: shape, insets: LayoutEdgeInsets(10, 20, 30, 40))
      let insetShape2 = shape.inset(10, 20, 30, 40)
      expect(insetShape2) == InsetShape(shape: shape, insets: LayoutEdgeInsets(10, 20, 30, 40))
    }
  }

  func test_inset_byHorizontalVertical() {
    // zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(horizontal: 0, vertical: 0)
      expect(insetShape) == InsetShape(shape: shape)
    }

    // non-zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(horizontal: 10, vertical: 20)
      expect(insetShape) == InsetShape(shape: shape, insets: LayoutEdgeInsets(20, 10, 20, 10))
    }
  }

  func test_inset_byInsets() {
    // zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(insets: LayoutEdgeInsets(0, 0, 0, 0))
      expect(insetShape) == InsetShape(shape: shape)
    }

    // non-zero amount
    do {
      let shape = Rectangle()
      let insetShape = shape.inset(insets: LayoutEdgeInsets(10, 20, 30, 40))
      expect(insetShape) == InsetShape(shape: shape, insets: LayoutEdgeInsets(10, 20, 30, 40))
    }
  }
}
