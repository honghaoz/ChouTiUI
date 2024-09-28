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
    expect(shape.style) == .continuous
  }

  func test_isEqual() {
    let shape = Capsule()
    let shared: some Shape = .capsule

    expect(shape.isEqual(to: Capsule())) == true
    expect(shape.isEqual(to: shared)) == true
    expect(shape.isEqual(to: Capsule(style: .circular))) == false
    expect(shape.isEqual(to: Circle())) == false
  }

  func test_path() {
    // continuous
    do {
      // square
      do {
        let shape = Capsule(style: .continuous)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let path = shape.path(in: rect)
        expect(path) == CGPath(ellipseIn: rect, transform: nil)
      }

      // wide
      do {
        let shape = Capsule(style: .continuous)
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        let path = shape.path(in: rect)

        let expectedElements: [CGPathElement.Element] = [
          .moveToPoint(CGPoint(x: 76.43325, y: 0.0)),
          .addLineToPoint(CGPoint(x: 123.56675000000001, y: 0.0)),
          .addCurveToPoint(CGPoint(x: 146.51285961907354, y: 0.0), CGPoint(x: 157.51716029684988, y: 0.0), CGPoint(x: 169.3628178584504, y: 3.7455693923507973)),
          .addLineToPoint(CGPoint(x: 169.3628178584504, y: 3.745569392350797)),
          .addCurveToPoint(CGPoint(x: 187.75710983002548, y: 10.440544150405914), CGPoint(x: 200.0, y: 27.925203343417653), CGPoint(x: 200.0, y: 47.49999999999999)),
          .addCurveToPoint(CGPoint(x: 200.0, y: 50.0), CGPoint(x: 200.0, y: 50.0), CGPoint(x: 200.0, y: 50.0)),
          .addLineToPoint(CGPoint(x: 200.0, y: 50.0)),
          .addCurveToPoint(CGPoint(x: 200.0, y: 50.0), CGPoint(x: 200.0, y: 50.0), CGPoint(x: 200.0, y: 50.0)),
          .addLineToPoint(CGPoint(x: 200.0, y: 52.5)),
          .addCurveToPoint(CGPoint(x: 200.0, y: 72.07479665658235), CGPoint(x: 187.75710983002548, y: 89.5594558495941), CGPoint(x: 169.3628178584504, y: 96.25443060764921)),
          .addCurveToPoint(CGPoint(x: 157.51716029684988, y: 100.0), CGPoint(x: 146.51285961907354, y: 100.0), CGPoint(x: 124.50425826352087, y: 100.0)),
          .addLineToPoint(CGPoint(x: 76.43325, y: 100.0)),
          .addCurveToPoint(CGPoint(x: 53.487140380926455, y: 100.0), CGPoint(x: 42.48283970315011, y: 100.0), CGPoint(x: 30.637182141549623, y: 96.25443060764921)),
          .addLineToPoint(CGPoint(x: 30.637182141549626, y: 96.25443060764921)),
          .addCurveToPoint(CGPoint(x: 12.242890169974526, y: 89.5594558495941), CGPoint(x: -9.86864910777917e-16, y: 72.07479665658235), CGPoint(x: -3.3306690738754696e-15, y: 52.50000000000001)),
          .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
          .addLineToPoint(CGPoint(x: 0.0, y: 50.0)),
          .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
          .addLineToPoint(CGPoint(x: -3.3306690738754696e-15, y: 47.50000000000001)),
          .addCurveToPoint(CGPoint(x: -5.674473236973023e-15, y: 27.925203343417664), CGPoint(x: 12.242890169974531, y: 10.440544150405904), CGPoint(x: 30.637182141549633, y: 3.7455693923507916)),
          .addCurveToPoint(CGPoint(x: 42.48283970315011, y: 0.0), CGPoint(x: 53.487140380926455, y: 0.0), CGPoint(x: 75.49574173647913, y: 0.0)),
          .addLineToPoint(CGPoint(x: 76.43325, y: 0.0)),
        ]

        expectPathElementsEqual(path.pathElements(), expectedElements, absoluteTolerance: 1e-13)
      }

      // tall
      do {
        let shape = Capsule(style: .continuous)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
        let path = shape.path(in: rect)

        let expectedElements: [CGPathElement.Element] = [
          .moveToPoint(CGPoint(x: 50.0, y: 0.0)),
          .addLineToPoint(CGPoint(x: 50.0, y: 0.0)),
          .addCurveToPoint(CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0)),
          .addLineToPoint(CGPoint(x: 52.49999999999999, y: 2.220446049250313e-15)),
          .addCurveToPoint(CGPoint(x: 72.07479665658234, y: -1.3322676295501878e-15), CGPoint(x: 89.55945584959409, y: 12.242890169974531), CGPoint(x: 96.2544306076492, y: 30.637182141549633)),
          .addCurveToPoint(CGPoint(x: 100.0, y: 42.48283970315011), CGPoint(x: 100.0, y: 53.48714038092645), CGPoint(x: 100.0, y: 75.49574173647913)),
          .addLineToPoint(CGPoint(x: 100.0, y: 123.56675)),
          .addCurveToPoint(CGPoint(x: 100.0, y: 146.51285961907357), CGPoint(x: 100.0, y: 157.51716029684988), CGPoint(x: 96.2544306076492, y: 169.36281785845037)),
          .addLineToPoint(CGPoint(x: 96.2544306076492, y: 169.36281785845037)),
          .addCurveToPoint(CGPoint(x: 89.55945584959409, y: 187.75710983002546), CGPoint(x: 72.07479665658234, y: 200.0), CGPoint(x: 52.5, y: 200.0)),
          .addCurveToPoint(CGPoint(x: 50.0, y: 200.0), CGPoint(x: 50.0, y: 200.0), CGPoint(x: 50.0, y: 200.0)),
          .addLineToPoint(CGPoint(x: 50.0, y: 200.0)),
          .addCurveToPoint(CGPoint(x: 50.0, y: 200.0), CGPoint(x: 50.0, y: 200.0), CGPoint(x: 50.0, y: 200.0)),
          .addLineToPoint(CGPoint(x: 47.5, y: 200.0)),
          .addCurveToPoint(CGPoint(x: 27.925203343417664, y: 200.0), CGPoint(x: 10.440544150405916, y: 187.75710983002548), CGPoint(x: 3.745569392350802, y: 169.3628178584504)),
          .addCurveToPoint(CGPoint(x: 0.0, y: 157.51716029684988), CGPoint(x: 0.0, y: 146.51285961907357), CGPoint(x: 0.0, y: 124.50425826352087)),
          .addLineToPoint(CGPoint(x: 0.0, y: 76.43325)),
          .addCurveToPoint(CGPoint(x: 0.0, y: 53.48714038092645), CGPoint(x: 0.0, y: 42.48283970315011), CGPoint(x: 3.745569392350795, y: 30.63718214154963)),
          .addLineToPoint(CGPoint(x: 3.745569392350797, y: 30.63718214154963)),
          .addCurveToPoint(CGPoint(x: 10.440544150405907, y: 12.242890169974535), CGPoint(x: 27.925203343417657, y: 5.773159728050814e-15), CGPoint(x: 47.49999999999999, y: 2.220446049250313e-15)),
          .addCurveToPoint(CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0)),
          .addLineToPoint(CGPoint(x: 50.0, y: 0.0)),
        ]

        expectPathElementsEqual(path.pathElements(), expectedElements, absoluteTolerance: 1e-13)
      }
    }

    // circular
    do {
      // square
      do {
        let shape = Capsule(style: .circular)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let path = shape.path(in: rect)
        expect(path) == CGPath(ellipseIn: rect, transform: nil)
      }

      // wide
      do {
        let shape = Capsule(style: .circular)
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        let path = shape.path(in: rect)

        var expectedElements: [CGPathElement.Element] = [
          .moveToPoint(CGPoint(x: 150.0, y: 0.0)),
          .addLineToPoint(CGPoint(x: 150.0, y: 0.0)),
          .addCurveToPoint(CGPoint(x: 177.61423749, y: -5.0726531329535e-15), CGPoint(x: 200.0, y: 22.385762509999996), CGPoint(x: 200.0, y: 49.99999999999999)),
          .addCurveToPoint(CGPoint(x: 200.0, y: 77.61423749), CGPoint(x: 177.61423749, y: 100.0), CGPoint(x: 150.0, y: 100.0)),
          .addLineToPoint(CGPoint(x: 50.0, y: 100.0)),
          .addLineToPoint(CGPoint(x: 50.0, y: 100.0)),
          .addCurveToPoint(CGPoint(x: 22.385762510000003, y: 100.0), CGPoint(x: 1.6908843776511668e-15, y: 77.61423749), CGPoint(x: 0.0, y: 50.0)),
          .addCurveToPoint(CGPoint(x: -1.6908843776511668e-15, y: 22.385762510000003), CGPoint(x: 22.385762510000003, y: 1.6908843776511668e-15), CGPoint(x: 50.0, y: 0.0)),
          .closeSubpath,
        ]

        #if canImport(AppKit)
        expectedElements += [
          .moveToPoint(CGPoint(x: 150.0, y: 0.0)),
        ]
        #endif

        expectPathElementsEqual(path.pathElements(), expectedElements, absoluteTolerance: 1e-8)
      }

      // tall
      do {
        let shape = Capsule(style: .circular)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
        let path = shape.path(in: rect)

        var expectedElements: [CGPathElement.Element] = [
          .moveToPoint(CGPoint(x: 0.0, y: 50.0)),
          .addLineToPoint(CGPoint(x: 0.0, y: 50.00000000000001)),
          .addCurveToPoint(CGPoint(x: -3.381768755490889e-15, y: 22.38576250846034), CGPoint(x: 22.385762508460324, y: 5.072653133236334e-15), CGPoint(x: 49.99999999999999, y: 0.0)),
          .addCurveToPoint(CGPoint(x: 77.61423749153965, y: -5.072653133236334e-15), CGPoint(x: 100.0, y: 22.385762508460317), CGPoint(x: 100.0, y: 49.999999999999986)),
          .addLineToPoint(CGPoint(x: 100.0, y: 150.0)),
          .addLineToPoint(CGPoint(x: 100.0, y: 150.0)),
          .addCurveToPoint(CGPoint(x: 100.0, y: 177.61423749153965), CGPoint(x: 77.61423749153967, y: 200.0), CGPoint(x: 50.0, y: 200.0)),
          .addCurveToPoint(CGPoint(x: 22.38576250846033, y: 200.0), CGPoint(x: 3.381768755490889e-15, y: 177.61423749153965), CGPoint(x: 0.0, y: 150.0)),
          .closeSubpath,
        ]

        #if canImport(AppKit)
        expectedElements += [
          .moveToPoint(CGPoint(x: 0.0, y: 50.0)),
        ]
        #endif

        expectPathElementsEqual(path.pathElements(), expectedElements, absoluteTolerance: 1e-8)
      }
    }
  }

  func test_path_offset() {
    // continuous
    do {
      // square
      do {
        let shape = Capsule(style: .continuous)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let path = shape.path(in: rect, offset: 10)
        expect(path) == CGPath(ellipseIn: rect.inset(by: -10), transform: nil)
      }

      // wide
      do {
        let shape = Capsule(style: .continuous)
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        let path = shape.path(in: rect, offset: 10)
        expect(path) == Capsule(style: .continuous).path(in: rect.inset(by: -10))
      }

      // tall
      do {
        let shape = Capsule(style: .continuous)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
        let path = shape.path(in: rect, offset: 10)
        expect(path) == Capsule(style: .continuous).path(in: rect.inset(by: -10))
      }
    }

    // circular
    do {
      // square
      do {
        let shape = Capsule(style: .circular)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let path = shape.path(in: rect, offset: 10)
        expect(path) == CGPath(ellipseIn: rect.inset(by: -10), transform: nil)
      }

      // wide
      do {
        let shape = Capsule(style: .circular)
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        let path = shape.path(in: rect, offset: 10)
        expect(path) == Capsule(style: .circular).path(in: rect.inset(by: -10))
      }

      // tall
      do {
        let shape = Capsule(style: .circular)
        let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
        let path = shape.path(in: rect, offset: 10)
        expect(path) == Capsule(style: .circular).path(in: rect.inset(by: -10))
      }
    }
  }
}
