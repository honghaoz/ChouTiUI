//
//  ShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/21/24.
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

class ShapeTests: XCTestCase {

  func test_optionalShape_isEqual() {
    // compare nil with nil
    do {
      let shape1: (any Shape)? = nil
      let shape2: (any Shape)? = nil
      expect(shape1.isEqual(to: shape2)) == true
    }

    // compare nil with non-nil
    do {
      let shape1: (any Shape)? = nil
      let shape2: (any Shape)? = Rectangle(cornerRadius: 10)
      expect(shape1.isEqual(to: shape2)) == false
    }

    // compare non-nil with nil
    do {
      let shape1: (any Shape)? = Rectangle(cornerRadius: 10)
      let shape2: (any Shape)? = nil
      expect(shape1.isEqual(to: shape2)) == false
    }

    // compare non-nil with non-nil
    do {
      let rect10_1: (any Shape)? = Rectangle(cornerRadius: 10)
      let rect10_2: (any Shape)? = Rectangle(cornerRadius: 10)
      let rect12: (any Shape)? = Rectangle(cornerRadius: 12)
      let circle10: (any Shape)? = Circle()
      expect(rect10_1.isEqual(to: rect10_1)) == true
      expect(rect10_1.isEqual(to: rect10_2)) == true
      expect(rect10_1.isEqual(to: rect12)) == false
      expect(rect10_1.isEqual(to: circle10)) == false
    }
  }
}
