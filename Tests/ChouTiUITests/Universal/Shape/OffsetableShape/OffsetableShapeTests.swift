//
//  OffsetableShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/20/24.
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

class OffsetableShapeTests: XCTestCase {

  func test_offset_by() {
    let shape = Rectangle(cornerRadius: 10)
    let offsetShape = shape.offset(by: 2)
    expect(offsetShape) == OffsetShape(shape: shape, offset: 2)

    let path = offsetShape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = Rectangle(cornerRadius: 12).path(in: CGRect(x: -2, y: -2, width: 104, height: 104))
    expect(path.pathElements()) == expectedPath.pathElements()
  }
}
