//
//  CombinedShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/21/24.
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

class CombinedShapeTests: XCTestCase {

  func test_init() {
    let mainShape = Rectangle()
    let subShape = Rectangle()
    let combinedShape = CombinedShape(mainShape: mainShape, subShape: subShape, mode: .add)
    expect(combinedShape.mainShape) == mainShape
    expect(combinedShape.subShape) == subShape
    expect(combinedShape.mode) == CombinedShape.Mode.add
  }

  func test_adding() {
    let mainShape = Rectangle()
    let subShape = Rectangle().offset(by: 10)
    let combinedShape = mainShape.adding(subShape)
    expect(combinedShape.mainShape) == mainShape
    expect(combinedShape.subShape) == subShape
    expect(combinedShape.mode) == CombinedShape.Mode.add

    let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
    let path = combinedShape.path(in: rect)

    let expectedPath = CGMutablePath()
    expectedPath.addRect(rect)
    expectedPath.addPath(CGPath(rect: rect.inset(by: -10), transform: nil))

    expect(path) == expectedPath
  }

  func test_differencing() {
    let mainShape = Rectangle()
    let subShape = Rectangle().offset(by: -5)
    let combinedShape = mainShape.differencing(subShape)

    let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
    let path = combinedShape.path(in: rect)

    let expectedPath = CGMutablePath()
    expectedPath.addRect(rect)
    expectedPath.addPath(CGPath(rect: rect.inset(by: 5), transform: nil).reversing())

    expect(path) == expectedPath

    expect(path.contains(CGPoint(x: 0, y: 0))) == true
    expect(path.contains(CGPoint(x: 0, y: 5))) == true
    expect(path.contains(CGPoint(x: 5, y: 5))) == true
    expect(path.contains(CGPoint(x: 6, y: 6))) == false
    expect(path.contains(CGPoint(x: 7, y: 7))) == false
    expect(path.contains(CGPoint(x: 100, y: 50))) == false

    expect(path.asBezierPath().contains(CGPoint(x: 0, y: 0))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 0, y: 5))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 5, y: 5))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 6, y: 6))) == false
    expect(path.asBezierPath().contains(CGPoint(x: 7, y: 7))) == false
    expect(path.asBezierPath().contains(CGPoint(x: 100, y: 50))) == false
  }

  func test_differencing2() {
    let mainShape = Rectangle()
    let subShape = Ellipse()
    let combinedShape = mainShape.differencing(subShape)

    let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
    let path = combinedShape.path(in: rect)

    let expectedPath = CGMutablePath()
    expectedPath.addRect(rect)
    expectedPath.addPath(CGPath(ellipseIn: rect, transform: nil).reversing())

    expect(path) == expectedPath

    // ⚠️ CGPath contains may break

    // expect(path.contains(CGPoint(x: 0, y: 0))) == true
    // expect(path.contains(CGPoint(x: 1, y: 1))) == true
    // expect(path.contains(CGPoint(x: 2, y: 1))) == true
    // expect(path.contains(CGPoint(x: 3, y: 1))) == true
    // expect(path.contains(CGPoint(x: 4, y: 1))) == true
    // expect(path.contains(CGPoint(x: 5, y: 1))) == true
    // expect(path.contains(CGPoint(x: 10, y: 1))) == true
    // expect(path.contains(CGPoint(x: 20, y: 1))) == true
    // expect(path.contains(CGPoint(x: 50, y: 1))) == true

    // expect(path.contains(CGPoint(x: 100, y: 1))) == false
    // expect(path.contains(CGPoint(x: 100, y: 50))) == false

    expect(path.asBezierPath().contains(CGPoint(x: 0, y: 0))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 1, y: 1))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 2, y: 1))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 3, y: 1))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 4, y: 1))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 5, y: 1))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 10, y: 1))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 20, y: 1))) == true
    expect(path.asBezierPath().contains(CGPoint(x: 50, y: 1))) == true

    expect(path.asBezierPath().contains(CGPoint(x: 100, y: 1))) == false
    expect(path.asBezierPath().contains(CGPoint(x: 100, y: 50))) == false
  }
}
