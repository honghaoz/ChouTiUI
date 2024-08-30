//
//  UnitPointTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/25/21.
//  Copyright © 2020 Honghao Zhang (github.com/honghaoz).
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang
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

import ChouTiUI
import ChouTiTest

class UnitPointTests: XCTestCase {

  func testInitialization() {
    let point1 = UnitPoint(x: 0.3, y: 0.7)
    expect(point1.x) == 0.3
    expect(point1.y) == 0.7

    let point2 = UnitPoint(0.4, 0.6)
    expect(point2.x) == 0.4
    expect(point2.y) == 0.6
  }

  func testInitializationWithPointInBounds() {
    let bounds = CGRect(x: 0, y: 0, width: 100, height: 200)
    let point = UnitPoint(point: CGPoint(x: 50, y: 100), in: bounds)
    expect(point.x) == 0.5
    expect(point.y) == 0.5
  }

  func testPredefinedPoints() {
    expect(UnitPoint.center) == UnitPoint(x: 0.5, y: 0.5)
    expect(UnitPoint.left) == UnitPoint(x: 0, y: 0.5)
    expect(UnitPoint.right) == UnitPoint(x: 1, y: 0.5)
    expect(UnitPoint.top) == UnitPoint(x: 0.5, y: 0)
    expect(UnitPoint.bottom) == UnitPoint(x: 0.5, y: 1)
    expect(UnitPoint.topLeft) == UnitPoint(x: 0, y: 0)
    expect(UnitPoint.topRight) == UnitPoint(x: 1, y: 0)
    expect(UnitPoint.bottomLeft) == UnitPoint(x: 0, y: 1)
    expect(UnitPoint.bottomRight) == UnitPoint(x: 1, y: 1)
  }

  func testCGPointConversion() {
    let unitPoint = UnitPoint(x: 0.3, y: 0.7)
    let cgPoint = unitPoint.cgPoint
    expect(cgPoint.x) == 0.3
    expect(cgPoint.y) == 0.7
  }

  func testPointInFrame() {
    let unitPoint = UnitPoint(x: 0.25, y: 0.75)
    let frame = CGRect(x: 100, y: 200, width: 400, height: 600)
    let point = unitPoint.point(in: frame)
    expect(point.x) == 200
    expect(point.y) == 650
  }

  func testEquality() {
    expect(UnitPoint(x: 0.3, y: 0.7)) == UnitPoint(0.3, 0.7)
    expect(UnitPoint(x: 0.3, y: 0.7)) != UnitPoint(x: 0.7, y: 0.3)
  }

  func testHashable() {
    let set = Set([UnitPoint(x: 0.3, y: 0.7), UnitPoint(0.3, 0.7), UnitPoint(x: 0.7, y: 0.3)])
    expect(set.count) == 2
  }
}
