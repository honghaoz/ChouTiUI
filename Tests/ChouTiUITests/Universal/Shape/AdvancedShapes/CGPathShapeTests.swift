//
//  CGPathShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 2/28/23.
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

class CGPathShapeTests: XCTestCase {

  func test_init() {
    // with canvas size
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .stretch)
      expect(shape.cgPath) == cgPath
      expect(shape.canvasSize) == CGSize(40, 60)
      expect(shape.contentMode) == .stretch
    }

    // without canvas size
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape = CGPathShape(cgPath: cgPath, contentMode: .aspectFit)
      expect(shape.cgPath.pathElements()) == CGPath(rect: CGRect(0, 0, 30, 40), transform: nil).pathElements()
      expect(shape.canvasSize) == CGSize(30, 40)
      expect(shape.contentMode) == .aspectFit
    }
  }

  func test_path() {
    // +-----------+
    // |           |
    // |           |
    // |  +-----+  |
    // |  |     |  |
    // |  |     |  |
    // |  +-----+  |
    // |           |
    // |           |
    // +-----------+

    // with canvasSize
    do {
      // stretch
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 80), contentMode: .stretch)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(10, 20, 30, 40)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(16.0, 20.0, 48.0, 40.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(10, 25, 30, 50)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(20, 40, 30, 40)
      }

      // aspectFill
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 80), contentMode: .aspectFill)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(10, 20, 30, 40)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(16.0, 8.0, 48.0, 64.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(6.25, 25.0, 37.5, 50.0)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(20, 40, 30, 40)
      }

      // aspectFit
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 80), contentMode: .aspectFit)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(10, 20, 30, 40)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(25.0, 20.0, 30.0, 40.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(10.0, 30.0, 30.0, 40.0)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(20, 40, 30, 40)
      }
    }

    // without canvas size
    do {
      // stretch
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, contentMode: .stretch)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(0, 0, 50, 80)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(0, 0, 80, 80)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(0, 0, 50, 100)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(10.0, 20.0, 50.0, 80.0)
      }

      // aspectFill
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, contentMode: .aspectFill)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(-5.0, 0.0, 60.0, 80.0)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(0.0, -13.333333333333329, 80.0, 106.66666666666666), absoluteTolerance: 1e-9)) == true
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(-12.5, 0.0, 75.0, 100.0)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(5.0, 20.0, 60.0, 80.0)
      }

      // aspectFit
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, contentMode: .aspectFit)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(0.0, 6.666666666666664, 50.0, 66.66666666666669), absoluteTolerance: 1e-9)) == true

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(10.0, 0.0, 60.0, 80.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(0.0, 16.666666666666664, 50.0, 66.66666666666669), absoluteTolerance: 1e-9)) == true

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(10.0, 26.666666666666664, 50.0, 66.66666666666669), absoluteTolerance: 1e-9)) == true
      }
    }
  }

  func test_equal() {
    // same cgPath, canvasSize, contentMode
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .stretch)
      let shape2 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .stretch)
      expect(shape1) == shape2
    }

    // different cgPath
    do {
      let cgPath1 = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let cgPath2 = CGPath(rect: CGRect(11, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath1, canvasSize: CGSize(40, 60), contentMode: .stretch)
      let shape2 = CGPathShape(cgPath: cgPath2, canvasSize: CGSize(40, 60), contentMode: .stretch)
      expect(shape1) != shape2
    }

    // different canvasSize
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .stretch)
      let shape2 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 70), contentMode: .stretch)
      expect(shape1) != shape2
    }

    // different contentMode
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .stretch)
      let shape2 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .aspectFit)
      expect(shape1) != shape2
    }
  }
}
