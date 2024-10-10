//
//  LayoutRectTests.swift
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

class LayoutRectTests: XCTestCase {

  func testZero() {
    let rect = LayoutRect.zero
    expect(rect.origin) == LayoutPoint.zero
    expect(rect.size) == LayoutSize.zero
  }

  func testInitialization() {
    let rect = LayoutRect(LayoutPoint(.absolute(10), .absolute(20)), LayoutSize(.absolute(30), .absolute(40)))
    expect(rect.origin) == LayoutPoint(.absolute(10), .absolute(20))
    expect(rect.size) == LayoutSize(.absolute(30), .absolute(40))

    let rect2 = LayoutRect(origin: LayoutPoint(.absolute(10), .absolute(20)), size: LayoutSize(.absolute(30), .absolute(40)))
    expect(rect2.origin) == LayoutPoint(.absolute(10), .absolute(20))
    expect(rect2.size) == LayoutSize(.absolute(30), .absolute(40))
  }

  func testIsZero() {
    let rect = LayoutRect.zero
    expect(rect.isZero()) == true

    let rect2 = LayoutRect(LayoutPoint(.absolute(10), .absolute(20)), LayoutSize(.absolute(30), .absolute(40)))
    expect(rect2.isZero()) == false

    let rect3 = LayoutRect(origin: LayoutPoint(.absolute(0), .absolute(0)), size: LayoutSize(.absolute(30), .absolute(40)))
    expect(rect3.isZero()) == false

    let rect4 = LayoutRect(origin: LayoutPoint(.absolute(10), .absolute(20)), size: .zero)
    expect(rect4.isZero()) == false
  }

  func testCGRectFromContainerSize() {
    let rect = LayoutRect(LayoutPoint(.relative(0.2), .relative(0.3)), LayoutSize(.relative(0.4), .relative(0.5)))
    let cgRect = rect.cgRect(from: CGSize(width: 100, height: 100))
    expect(cgRect) == CGRect(x: 20, y: 30, width: 40, height: 50)
  }
}
