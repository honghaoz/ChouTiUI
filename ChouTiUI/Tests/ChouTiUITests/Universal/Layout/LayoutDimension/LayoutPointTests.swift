//
//  LayoutPointTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/2/22.
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

import ChouTiTest

import ChouTiUI

class LayoutPointTests: XCTestCase {

  func testInitialization() {
    let point = LayoutPoint(x: .absolute(10), y: .relative(0.5))
    expect(point.x) == .absolute(10)
    expect(point.y) == .relative(0.5)

    let point2 = LayoutPoint(.relative(0.2), .absolute(5))
    expect(point2.x) == .relative(0.2)
    expect(point2.y) == .absolute(5)

    let point3 = LayoutPoint(x: 10, y: 5)
    expect(point3.x) == .absolute(10)
    expect(point3.y) == .absolute(5)
  }

  func testPointInFrame() {
    let point = LayoutPoint(x: .relative(0.25), y: .mixed(0.5, 10))
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    let resultPoint = point.cgPoint(from: frame.size)
    expect(resultPoint.x) == 25
    expect(resultPoint.y) == 60
  }

  func testIsZero() {
    let zeroPoint = LayoutPoint(x: .absolute(0), y: .absolute(0))
    expect(zeroPoint.isZero()) == true

    let nonZeroPoint = LayoutPoint(x: .relative(0), y: .absolute(5))
    expect(nonZeroPoint.isZero()) == false
  }

  func testEquality() {
    let point1 = LayoutPoint(x: .absolute(10), y: .relative(0.5))
    let point2 = LayoutPoint(x: .absolute(10), y: .relative(0.5))
    let point3 = LayoutPoint(x: .absolute(20), y: .relative(0.5))

    expect(point1) == point2
    expect(point1) != point3
  }
}
