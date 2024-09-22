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

  func test_path() {
    let shape = SuperEllipse(cornerRadius: 4)
    let rect = CGRect(x: 0, y: 0, width: 100, height: 44)
    let path = shape.path(in: rect)

    // printPathElements(path.pathElements())

    expect(path.pathElements()) == [
      .moveToPoint(CGPoint(x: 5.1278, y: 0.0)),
      .addLineToPoint(CGPoint(x: 94.8722, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 96.65524, y: 0.0), CGPoint(x: 97.3018, y: 0.18564), CGPoint(x: 97.95368, y: 0.53428)),
      .addCurveToPoint(CGPoint(x: 98.60552000000001, y: 0.88288), CGPoint(x: 99.114024, y: 1.39448), CGPoint(x: 99.46572, y: 2.04632)),
      .addCurveToPoint(CGPoint(x: 99.81432000000001, y: 2.69816), CGPoint(x: 100.0, y: 3.34476), CGPoint(x: 100.0, y: 5.127800000000001)),
      .addLineToPoint(CGPoint(x: 100.0, y: 38.8722)),
      .addCurveToPoint(CGPoint(x: 100.0, y: 40.65524), CGPoint(x: 99.81436, y: 41.3018), CGPoint(x: 99.46572, y: 41.95368)),
      .addCurveToPoint(CGPoint(x: 99.11712, y: 42.60552), CGPoint(x: 98.60552, y: 43.114024), CGPoint(x: 97.95368, y: 43.46572)),
      .addCurveToPoint(CGPoint(x: 97.30184, y: 43.814319999999995), CGPoint(x: 96.65524, y: 44.0), CGPoint(x: 94.8722, y: 44.0)),
      .addLineToPoint(CGPoint(x: 5.1278, y: 44.0)),
      .addCurveToPoint(CGPoint(x: 3.34476, y: 44.0), CGPoint(x: 2.6981999999999995, y: 43.81436), CGPoint(x: 2.0463199999999997, y: 43.46572)),
      .addCurveToPoint(CGPoint(x: 1.3944799999999997, y: 43.11712), CGPoint(x: 0.8859759999999997, y: 42.60552), CGPoint(x: 0.5342799999999996, y: 41.95368)),
      .addCurveToPoint(CGPoint(x: 0.18567999999999962, y: 41.30184), CGPoint(x: -3.3306690738754696e-16, y: 40.65524), CGPoint(x: -3.3306690738754696e-16, y: 38.8722)),
      .addLineToPoint(CGPoint(x: 0.0, y: 5.1278)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 3.34476), CGPoint(x: 0.18564, y: 2.6981999999999995), CGPoint(x: 0.53428, y: 2.0463199999999997)),
      .addCurveToPoint(CGPoint(x: 0.88288, y: 1.3944799999999997), CGPoint(x: 1.39448, y: 0.8859759999999997), CGPoint(x: 2.04632, y: 0.5342799999999996)),
      .addCurveToPoint(CGPoint(x: 2.69816, y: 0.18567999999999962), CGPoint(x: 3.34476, y: -3.3306690738754696e-16), CGPoint(x: 5.1278, y: 0.0)),
    ]
  }

  func test_path_bigCornerRadius() {
    let shape = SuperEllipse(cornerRadius: 44)
    let rect = CGRect(x: 0, y: 0, width: 100, height: 44)
    let path = shape.path(in: rect)

    // printPathElements(path.pathElements())

    expect(path.pathElements()) == [
      .moveToPoint(CGPoint(x: 22.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 78.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 85.64984593782908, y: 0.0), CGPoint(x: 88.42380748079098, y: 0.7964585202230976), CGPoint(x: 91.22059362689653, y: 2.292242287140684)),
      .addCurveToPoint(CGPoint(x: 94.0172081594446, y: 3.7878544405007997), CGPoint(x: 96.19886267015094, y: 5.982791840555404), CGPoint(x: 97.70775771285932, y: 8.779406373103475)),
      .addCurveToPoint(CGPoint(x: 99.20336986621943, y: 11.576020905651546), CGPoint(x: 100.0, y: 14.350154062170912), CGPoint(x: 100.0, y: 22.0)),
      .addLineToPoint(CGPoint(x: 100.0, y: 22.0)),
      .addCurveToPoint(CGPoint(x: 100.0, y: 29.649845937829088), CGPoint(x: 99.2035414797769, y: 32.423807480790984), CGPoint(x: 97.70775771285932, y: 35.22059362689652)),
      .addCurveToPoint(CGPoint(x: 96.2121455594992, y: 38.01720815944459), CGPoint(x: 94.01720815944459, y: 40.19886267015094), CGPoint(x: 91.22059362689653, y: 41.70775771285931)),
      .addCurveToPoint(CGPoint(x: 88.42397909434845, y: 43.203369866219425), CGPoint(x: 85.6498459378291, y: 43.99999999999999), CGPoint(x: 78.0, y: 43.99999999999999)),
      .addLineToPoint(CGPoint(x: 22.0, y: 44.0)),
      .addCurveToPoint(CGPoint(x: 14.350154062170912, y: 44.0), CGPoint(x: 11.576192519209016, y: 43.2035414797769), CGPoint(x: 8.779406373103475, y: 41.70775771285932)),
      .addCurveToPoint(CGPoint(x: 5.982791840555404, y: 40.212145559499206), CGPoint(x: 3.801137329849058, y: 38.0172081594446), CGPoint(x: 2.2922422871406836, y: 35.22059362689653)),
      .addCurveToPoint(CGPoint(x: 0.7966301337805679, y: 32.42397909434846), CGPoint(x: -4.440892098500626e-16, y: 29.64984593782909), CGPoint(x: -4.440892098500626e-16, y: 22.000000000000007)),
      .addLineToPoint(CGPoint(x: 0.0, y: 22.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 14.350154062170912), CGPoint(x: 0.7964585202230976, y: 11.576192519209016), CGPoint(x: 2.292242287140684, y: 8.779406373103475)),
      .addCurveToPoint(CGPoint(x: 3.7878544405007997, y: 5.982791840555404), CGPoint(x: 5.982791840555404, y: 3.801137329849058), CGPoint(x: 8.779406373103475, y: 2.2922422871406836)),
      .addCurveToPoint(CGPoint(x: 11.576020905651546, y: 0.7966301337805679), CGPoint(x: 14.350154062170912, y: -4.440892098500626e-16), CGPoint(x: 22.0, y: 0.0)),
    ]
  }

  func test_path_offset() {
    // positive corner radius
    do {
      let shape = SuperEllipse(cornerRadius: 16)
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)

      // offset is positive
      do {
        let path = shape.path(in: rect, offset: 10)
        expect(path) == SuperEllipse(cornerRadius: 16 + 10).path(in: rect.expanded(by: 10))
      }

      // offset is negative
      do {
        // not enough negative offset
        do {
          let path = shape.path(in: rect, offset: -10)
          expect(path) == SuperEllipse(cornerRadius: 16 - 10).path(in: rect.inset(by: 10))
        }

        // enough negative offset
        do {
          let path = shape.path(in: rect, offset: -18)
          expect(path) == SuperEllipse(cornerRadius: 0).path(in: rect.inset(by: 18))
        }
      }

      // offset is 0
      do {
        let path = shape.path(in: rect, offset: 0)
        expect(path) == SuperEllipse(cornerRadius: 16).path(in: rect)
      }
    }

    // zero corner radius
    do {
      let shape = SuperEllipse(cornerRadius: 0)
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)

      // offset is positive
      do {
        let path = shape.path(in: rect, offset: 10)
        expect(path) == SuperEllipse(cornerRadius: 0).path(in: rect.inset(by: -10))
      }
    }
  }
}
