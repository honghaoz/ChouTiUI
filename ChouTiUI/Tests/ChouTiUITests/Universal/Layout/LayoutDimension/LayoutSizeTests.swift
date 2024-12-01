//
//  LayoutSizeTests.swift
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

class LayoutSizeTests: XCTestCase {

  func testZero() {
    let size = LayoutSize.zero
    expect(size.width) == .absolute(0)
    expect(size.height) == .absolute(0)
  }

  func testFull() {
    let size = LayoutSize.full
    expect(size.width) == .relative(1)
    expect(size.height) == .relative(1)
  }

  func testInitialization() {
    let size = LayoutSize(.absolute(10), .absolute(20))
    expect(size.width) == .absolute(10)
    expect(size.height) == .absolute(20)

    let size2 = LayoutSize(width: .absolute(10), height: .absolute(20))
    expect(size2.width) == .absolute(10)
    expect(size2.height) == .absolute(20)

    let size3 = LayoutSize(width: 10, height: 20)
    expect(size3.width) == .absolute(10)
    expect(size3.height) == .absolute(20)
  }

  func testIsZero() {
    let size = LayoutSize.zero
    expect(size.isZero()) == true

    let size2 = LayoutSize(.absolute(10), .absolute(20))
    expect(size2.isZero()) == false

    let size3 = LayoutSize(width: .absolute(10), height: .absolute(0))
    expect(size3.isZero()) == false

    let size4 = LayoutSize(width: .absolute(0), height: .absolute(20))
    expect(size4.isZero()) == false
  }

  func testCGSizeFromContainerSize() {
    let size = LayoutSize(.relative(0.1), .relative(0.2))
    let containerSize = CGSize(width: 100, height: 200)
    let cgSize = size.cgSize(from: containerSize)
    expect(cgSize.width) == 10
    expect(cgSize.height) == 40
  }
}
