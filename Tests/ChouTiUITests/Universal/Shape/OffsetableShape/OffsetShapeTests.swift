//
//  OffsetShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 5/6/24.
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

class OffsetShapeTests: XCTestCase {

  func testRectangle_cornerRadius_0_outer() {
    let rectangle = Rectangle()
    let offsetRectangle = OffsetShape(shape: rectangle, offset: 10)

    let path = offsetRectangle.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = CGPath(rect: CGRect(x: -10, y: -10, width: 120, height: 120), transform: nil)
    expect(path.pathElements()) == expectedPath.pathElements()
  }

  func testRectangle_cornerRadius_0_inner() {
    let rectangle = Rectangle()
    let offsetRectangle = OffsetShape(shape: rectangle, offset: -10)

    let path = offsetRectangle.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = CGPath(rect: CGRect(x: 10, y: 10, width: 80, height: 80), transform: nil)
    expect(path.pathElements()) == expectedPath.pathElements()
  }

  func testRectangle_cornerRadius_2_outer() {
    let rectangle = Rectangle(cornerRadius: 10)
    let offsetRectangle = OffsetShape(shape: rectangle, offset: 2)

    let path = offsetRectangle.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = Rectangle(cornerRadius: 12).path(in: CGRect(x: -2, y: -2, width: 104, height: 104))
    expect(path.pathElements()) == expectedPath.pathElements()
  }

  func testRectangle_cornerRadius_2_inner() {
    let rectangle = Rectangle(cornerRadius: 10)
    let offsetRectangle = OffsetShape(shape: rectangle, offset: -2)

    let path = offsetRectangle.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = Rectangle(cornerRadius: 8).path(in: CGRect(x: 2, y: 2, width: 96, height: 96))
    expect(path.pathElements()) == expectedPath.pathElements()
  }

  func testSuperEllipse_cornerRadius_0_outer() {
    let superEllipse = SuperEllipse(cornerRadius: 0)
    let offsetSuperEllipse = OffsetShape(shape: superEllipse, offset: 10)

    let path = offsetSuperEllipse.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = SuperEllipse(cornerRadius: 0).path(in: CGRect(x: -10, y: -10, width: 120, height: 120))
    expect(path.pathElements()) == expectedPath.pathElements()
  }

  func testSuperEllipse_cornerRadius_10_outer() {
    let superEllipse = SuperEllipse(cornerRadius: 10)
    let offsetSuperEllipse = OffsetShape(shape: superEllipse, offset: 10)

    let path = offsetSuperEllipse.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = SuperEllipse(cornerRadius: 20).path(in: CGRect(x: -10, y: -10, width: 120, height: 120))
    expect(path.pathElements()) == expectedPath.pathElements()
  }

  func testSuperEllipse_cornerRadius_10_inner() {
    let superEllipse = SuperEllipse(cornerRadius: 10)
    let offsetSuperEllipse = OffsetShape(shape: superEllipse, offset: -10)

    let path = offsetSuperEllipse.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
    let expectedPath = SuperEllipse(cornerRadius: 0).path(in: CGRect(x: 10, y: 10, width: 80, height: 80))
    expect(path.pathElements()) == expectedPath.pathElements()
  }

  // MARK: - OffsetableShape

  func test_offsetShapeIsOffsetableShape() {
    let offsetShape = Rectangle(cornerRadius: 10).offset(by: 2)
    let path = offsetShape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100), offset: 2)
    let expectedPath = Rectangle(cornerRadius: 14).path(in: CGRect(x: -4, y: -4, width: 108, height: 108))
    expect(path.pathElements()) == expectedPath.pathElements()
  }
}
