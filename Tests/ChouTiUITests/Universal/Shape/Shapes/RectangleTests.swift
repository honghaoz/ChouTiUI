//
//  RectangleTests.swift
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

class RectangleTests: XCTestCase {

  func test_init() {
    // default parameters
    do {
      let shape = Rectangle()
      expect(shape.cornerRadius) == 0
      expect(shape.roundingCorners) == .all
    }

    // init with corner radius
    do {
      let shape = Rectangle(cornerRadius: 3)
      expect(shape.cornerRadius) == 3
      expect(shape.roundingCorners) == .all
    }

    // init with rounding corners
    do {
      let shape = Rectangle(roundingCorners: .topLeft)
      expect(shape.cornerRadius) == 0
      expect(shape.roundingCorners) == .topLeft
    }

    // negative corner radius
    do {
      let shape = Rectangle(cornerRadius: -1)
      expect(shape.cornerRadius) == 0
      expect(shape.roundingCorners) == .all
    }
  }

  func test_static() {
    do {
      let shape: Rectangle = .rectangle
      expect(shape.cornerRadius) == 0
      expect(shape.roundingCorners) == .all
    }

    do {
      let shape: Rectangle = .rectangle(3, .topLeft)
      expect(shape.cornerRadius) == 3
      expect(shape.roundingCorners) == .topLeft
    }

    do {
      let shape: Rectangle = .rectangle(cornerRadius: 3, roundingCorners: .topLeft)
      expect(shape.cornerRadius) == 3
      expect(shape.roundingCorners) == .topLeft
    }
  }

  func test_isEqual() {
    let shape = Rectangle(cornerRadius: 3)
    let shared: some Shape = .rectangle(cornerRadius: 3)

    expect(shape.isEqual(to: Rectangle(cornerRadius: 3))) == true
    expect(shape.isEqual(to: shared)) == true
    expect(shape.isEqual(to: Rectangle())) == false

    expect(shape) == shared as? Rectangle
  }

  func test_path() {
    // all corners
    do {
      let shape = Rectangle(cornerRadius: 16)
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
      let path = shape.path(in: rect)

      expect(path) == BezierPath(roundedRect: rect, byRoundingCorners: .all, cornerRadii: CGSize(16, 16)).cgPath
    }

    // top left corner
    do {
      let shape = Rectangle(cornerRadius: 16, roundingCorners: .topLeft)
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
      let path = shape.path(in: rect)

      expect(path) == BezierPath(roundedRect: rect, byRoundingCorners: .topLeft, cornerRadii: CGSize(16, 16)).cgPath
    }

    // corner radius is not limited
    do {
      let cornerRadius: CGFloat = 48
      let shape = Rectangle(cornerRadius: cornerRadius)
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
      let path = shape.path(in: rect)

      expect(path) == BezierPath(roundedRect: rect, byRoundingCorners: .all, cornerRadii: CGSize(cornerRadius, cornerRadius)).cgPath
    }
  }

  func test_path_offset() {
    // positive corner radius
    do {
      let shape = Rectangle(cornerRadius: 16)
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)

      // offset is positive
      do {
        let path = shape.path(in: rect, offset: 10)
        expect(path) == BezierPath(roundedRect: rect.inset(by: -10), cornerRadius: 16 + 10).cgPath
      }

      // offset is negative
      do {
        // not enough negative offset
        do {
          let path = shape.path(in: rect, offset: -10)
          expect(path) == BezierPath(roundedRect: rect.inset(by: 10), cornerRadius: 16 - 10).cgPath
        }

        // enough negative offset
        do {
          let path = shape.path(in: rect, offset: -18)
          expect(path) == BezierPath(rect: rect.inset(by: 18)).cgPath
        }
      }

      // offset is 0
      do {
        let path = shape.path(in: rect, offset: 0)
        expect(path) == BezierPath(roundedRect: rect, cornerRadius: 16).cgPath
      }
    }

    // zero corner radius
    do {
      let shape = Rectangle(cornerRadius: 0)
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)

      // offset is positive
      do {
        let path = shape.path(in: rect, offset: 10)
        expect(path) == BezierPath(rect: rect.inset(by: -10)).cgPath
      }
    }
  }
}
