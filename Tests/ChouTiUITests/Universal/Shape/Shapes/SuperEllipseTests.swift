//
//  SuperEllipseTests.swift
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

class SuperEllipseTests: XCTestCase {

  func test_cornerRadius() {
    // default parameters
    do {
      let cornerRadius = SuperEllipse.CornerRadius()
      expect(cornerRadius.topLeft) == 0
      expect(cornerRadius.topRight) == 0
      expect(cornerRadius.bottomRight) == 0
      expect(cornerRadius.bottomLeft) == 0
    }

    // init with corner radius
    do {
      let cornerRadius = SuperEllipse.CornerRadius(3)
      expect(cornerRadius.topLeft) == 3
      expect(cornerRadius.topRight) == 3
      expect(cornerRadius.bottomRight) == 3
      expect(cornerRadius.bottomLeft) == 3
    }

    // init with corner radius
    do {
      let cornerRadius = SuperEllipse.CornerRadius(cornerRadius: 3, roundingCorners: .topLeft)
      expect(cornerRadius.topLeft) == 3
      expect(cornerRadius.topRight) == 0
      expect(cornerRadius.bottomRight) == 0
      expect(cornerRadius.bottomLeft) == 0

      let cornerRadius2 = SuperEllipse.CornerRadius(cornerRadius: 3, roundingCorners: .topRight)
      expect(cornerRadius2.topLeft) == 0
      expect(cornerRadius2.topRight) == 3
      expect(cornerRadius2.bottomRight) == 0
      expect(cornerRadius2.bottomLeft) == 0
    }

    // negative corner radius
    do {
      // init with individual corner radius
      do {
        let cornerRadius = SuperEllipse.CornerRadius(topLeft: -1, topRight: -1, bottomRight: -1, bottomLeft: -1)
        expect(cornerRadius.topLeft) == 0
        expect(cornerRadius.topRight) == 0
        expect(cornerRadius.bottomRight) == 0
        expect(cornerRadius.bottomLeft) == 0
      }

      // init with corner radius
      do {
        let cornerRadius = SuperEllipse.CornerRadius(cornerRadius: -1)
        expect(cornerRadius.topLeft) == 0
        expect(cornerRadius.topRight) == 0
        expect(cornerRadius.bottomRight) == 0
        expect(cornerRadius.bottomLeft) == 0
      }

      // init with rounding corners
      do {
        let cornerRadius = SuperEllipse.CornerRadius(cornerRadius: -2, roundingCorners: .all)
        expect(cornerRadius.topLeft) == 0
        expect(cornerRadius.topRight) == 0
        expect(cornerRadius.bottomRight) == 0
        expect(cornerRadius.bottomLeft) == 0
      }
    }
  }

  func test_init() {
    // init with corner radius
    do {
      let shape = SuperEllipse(cornerRadius: SuperEllipse.CornerRadius(3))
      expect(shape.cornerRadius.topLeft) == 3
      expect(shape.cornerRadius.topRight) == 3
      expect(shape.cornerRadius.bottomRight) == 3
      expect(shape.cornerRadius.bottomLeft) == 3
    }

    // init with rounding corners
    do {
      let shape = SuperEllipse(cornerRadius: 3, roundingCorners: .topLeft)
      expect(shape.cornerRadius.topLeft) == 3
      expect(shape.cornerRadius.topRight) == 0
      expect(shape.cornerRadius.bottomRight) == 0
      expect(shape.cornerRadius.bottomLeft) == 0
    }

    // init with static
    do {
      let shape: SuperEllipse = .superEllipse(cornerRadius: SuperEllipse.CornerRadius(3))
      expect(shape.cornerRadius.topLeft) == 3
      expect(shape.cornerRadius.topRight) == 3
      expect(shape.cornerRadius.bottomRight) == 3
      expect(shape.cornerRadius.bottomLeft) == 3
    }
    do {
      let shape: SuperEllipse = .superEllipse(cornerRadius: 3)
      expect(shape.cornerRadius.topLeft) == 3
      expect(shape.cornerRadius.topRight) == 3
      expect(shape.cornerRadius.bottomRight) == 3
      expect(shape.cornerRadius.bottomLeft) == 3
    }
    do {
      let shape: SuperEllipse = .superEllipse(3, .topLeft)
      expect(shape.cornerRadius.topLeft) == 3
      expect(shape.cornerRadius.topRight) == 0
      expect(shape.cornerRadius.bottomRight) == 0
      expect(shape.cornerRadius.bottomLeft) == 0
    }
  }

  func test_isEqual() {
    let shape = SuperEllipse(cornerRadius: 3)
    let shared: some Shape = .superEllipse(cornerRadius: 3)

    expect(shape.isEqual(to: SuperEllipse(cornerRadius: 3))) == true
    expect(shape.isEqual(to: shared)) == true
    expect(shape.isEqual(to: Rectangle())) == false
  }
}
