//
//  CapsuleTests.swift
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

class CapsuleTests: XCTestCase {

  func test_static() {
    let shape: Capsule = .capsule
    expect(shape) == Capsule()
  }

  func test_isEqual() {
    let shape = Capsule()
    let shared: some Shape = .capsule

    expect(shape.isEqual(to: Capsule())) == true
    expect(shape.isEqual(to: shared)) == true
    expect(shape.isEqual(to: Circle())) == false
  }

  func test_path() {
    // valid rect
    do {
      // square
      do {
        let shape = Capsule()
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let path = shape.path(in: rect)
        expect(path) == CGPath(ellipseIn: rect, transform: nil)
      }

      // wide
      do {
        let shape = Capsule()
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        let path = shape.path(in: rect)
        expect(path.pathElements()) == [
          .moveToPoint(CGPoint(x: 150.0, y: 0.0)),
          .addLineToPoint(CGPoint(x: 150.0, y: 100.0)),
          .addCurveToPoint(CGPoint(x: 122.38576250846033, y: 100.0), CGPoint(x: 100.0, y: 77.61423749153968), CGPoint(x: 100.0, y: 50.00000000000001)),
          .addCurveToPoint(CGPoint(x: 100.0, y: 22.38576250846034), CGPoint(x: 122.38576250846033, y: 5.072653133236334e-15), CGPoint(x: 150.0, y: 0.0)),
          .addLineToPoint(CGPoint(x: 50.0, y: 100.0)),
          .addLineToPoint(CGPoint(x: 50.0, y: 0.0)),
          .addCurveToPoint(CGPoint(x: 77.61423749153967, y: 1.6908843777454446e-15), CGPoint(x: 100.0, y: 22.38576250846033), CGPoint(x: 100.0, y: 50.0)),
          .addCurveToPoint(CGPoint(x: 100.0, y: 77.61423749153967), CGPoint(x: 77.61423749153967, y: 100.0), CGPoint(x: 50.0, y: 100.0)),
          .closeSubpath,
          .moveToPoint(CGPoint(x: 150.0, y: 0.0)),
        ]
      }

      // tall
      do {
        let shape = Capsule()
        let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
        let path = shape.path(in: rect)

        expect(path.pathElements()) == [
          .moveToPoint(CGPoint(x: 0.0, y: 50.0)),
          .addLineToPoint(CGPoint(x: 0.0, y: 50.00000000000001)),
          .addCurveToPoint(CGPoint(x: -3.381768755490889e-15, y: 22.38576250846034), CGPoint(x: 22.385762508460324, y: 5.072653133236334e-15), CGPoint(x: 49.99999999999999, y: 0.0)),
          .addCurveToPoint(CGPoint(x: 77.61423749153965, y: -5.072653133236334e-15), CGPoint(x: 100.0, y: 22.385762508460317), CGPoint(x: 100.0, y: 49.999999999999986)),
          .addLineToPoint(CGPoint(x: 100.0, y: 150.0)),
          .addLineToPoint(CGPoint(x: 100.0, y: 150.0)),
          .addCurveToPoint(CGPoint(x: 100.0, y: 177.61423749153965), CGPoint(x: 77.61423749153967, y: 200.0), CGPoint(x: 50.0, y: 200.0)),
          .addCurveToPoint(CGPoint(x: 22.38576250846033, y: 200.0), CGPoint(x: 3.381768755490889e-15, y: 177.61423749153965), CGPoint(x: 0.0, y: 150.0)),
          .closeSubpath,
          .moveToPoint(CGPoint(x: 0.0, y: 50.0)),
        ]
      }
    }
  }

  func test_path_offset() {
    // square
    do {
      let shape = Capsule()
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let path = shape.path(in: rect, offset: 10)
      expect(path) == CGPath(ellipseIn: rect.inset(by: -10), transform: nil)
    }

    // wide
    do {
      let shape = Capsule()
      let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
      let path = shape.path(in: rect, offset: 10)
      expect(path) == Capsule().path(in: rect.inset(by: -10))
    }

    // tall
    do {
      let shape = Capsule()
      let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
      let path = shape.path(in: rect, offset: 10)
      expect(path) == Capsule().path(in: rect.inset(by: -10))
    }
  }
}
