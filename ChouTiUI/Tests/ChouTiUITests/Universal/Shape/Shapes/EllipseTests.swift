//
//  EllipseTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/2/24.
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

class EllipseTests: XCTestCase {

  func test_static() {
    let shape: Ellipse = .ellipse
    expect(shape) == Ellipse()
  }

  func test_isEqual() {
    let shape = Ellipse()
    let shared: some Shape = .ellipse

    expect(shape.isEqual(to: Ellipse())) == true
    expect(shape.isEqual(to: shared)) == true
    expect(shape.isEqual(to: Rectangle())) == false
  }

  func test_path() {
    // valid rect
    do {
      let shape = Ellipse()
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let path = shape.path(in: rect)
      expect(path) == CGPath(ellipseIn: rect, transform: nil)
    }

    // zero rect
    do {
      let shape = Ellipse()
      let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
      let path = shape.path(in: rect)
      expect(path) == CGPath(ellipseIn: rect, transform: nil)
    }

    // negative rect
    do {
      let shape = Ellipse()
      let rect = CGRect(x: 0, y: 0, width: -100, height: -100)
      let path = shape.path(in: rect)
      expect(path) == CGPath(ellipseIn: rect, transform: nil)
    }

    // null rect
    do {
      let shape = Ellipse()
      let rect = CGRect.null
      let path = shape.path(in: rect)
      expect(path) == CGPath(ellipseIn: rect, transform: nil)
    }
  }

  func test_path_offset() {
    let shape = Ellipse()
    let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    let path = shape.path(in: rect, offset: 10)
    expect(path) == CGPath(ellipseIn: rect.inset(by: 10), transform: nil)
  }
}
