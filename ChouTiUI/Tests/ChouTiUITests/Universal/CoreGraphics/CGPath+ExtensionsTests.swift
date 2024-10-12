//
//  CGPath+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/12/24.
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

import ChouTi
import ChouTiUI

class CGPath_ExtensionsTests: XCTestCase {

  // MARK: - Factory

  func test_rect() {
    // no transform
    do {
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let path = CGPath.path(rect: rect)
      expect(path.pathElements()) == [
        .moveToPoint(CGPoint(0, 0)),
        .addLineToPoint(CGPoint(100, 0)),
        .addLineToPoint(CGPoint(100, 100)),
        .addLineToPoint(CGPoint(0, 100)),
        .closeSubpath,
      ]
    }

    // with transform
    do {
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let transform = CGAffineTransform.translation(x: 10, y: 20)
      let path = CGPath.path(rect: rect, transform: transform)
      expect(path.pathElements()) == [
        .moveToPoint(CGPoint(10, 20)),
        .addLineToPoint(CGPoint(110, 20)),
        .addLineToPoint(CGPoint(110, 120)),
        .addLineToPoint(CGPoint(10, 120)),
        .closeSubpath,
      ]
    }
  }

  func test_ellipse() {
    // no transform
    do {
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let path = CGPath.path(ellipseIn: rect)
      expect(path.pathElements()) == [
        .moveToPoint(CGPoint(100, 50)),
        .addCurveToPoint(CGPoint(100.0, 77.61423749), CGPoint(77.61423749, 100), CGPoint(50, 100)),
        .addCurveToPoint(CGPoint(22.385762510000003, 100.0), CGPoint(0.0, 77.61423749), CGPoint(0.0, 50.0)),
        .addCurveToPoint(CGPoint(0.0, 22.385762510000003), CGPoint(22.385762510000003, 0.0), CGPoint(50.0, 0.0)),
        .addCurveToPoint(CGPoint(77.61423749, 0.0), CGPoint(100.0, 22.385762510000003), CGPoint(100.0, 50.0)),
        .closeSubpath,
      ]
    }

    // with transform
    do {
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let transform = CGAffineTransform.translation(x: 10, y: 20)
      let path = CGPath.path(ellipseIn: rect, transform: transform)
      expect(path.pathElements()) == [
        .moveToPoint(CGPoint(110, 70)),
        .addCurveToPoint(CGPoint(110.0, 97.61423749), CGPoint(87.61423749, 120.0), CGPoint(60.0, 120.0)),
        .addCurveToPoint(CGPoint(32.385762510000006, 120.0), CGPoint(10.0, 97.61423749), CGPoint(10.0, 70.0)),
        .addCurveToPoint(CGPoint(10.0, 42.385762510000006), CGPoint(32.385762510000006, 20.0), CGPoint(60.0, 20.0)),
        .addCurveToPoint(CGPoint(87.61423749, 20.0), CGPoint(110.0, 42.385762510000006), CGPoint(110.0, 70.0)),
        .closeSubpath,
      ]
    }
  }

  func test_roundedRect() {
    // no transform
    do {
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let path = CGPath.path(roundedRect: rect, cornerWidth: 10, cornerHeight: 20)
      expect(path.pathElements()) == [
        .moveToPoint(CGPoint(100.0, 50)),
        .addLineToPoint(CGPoint(100.0, 90)),
        .addCurveToPoint(CGPoint(100.0, 95.522847498), CGPoint(95.522847498, 100), CGPoint(90.0, 100)),
        .addLineToPoint(CGPoint(10.0, 100.00000000000001)),
        .addCurveToPoint(CGPoint(4.477152502, 100.00000000000001), CGPoint(3.381768755302334e-16, 95.52284749800002), CGPoint(0.0, 90.00000000000001)),
        .addLineToPoint(CGPoint(4.440892098500626e-15, 9.999999999999998)),
        .addCurveToPoint(CGPoint(5.117245849561093e-15, 4.477152501999999), CGPoint(4.477152502000007, -6.763537510604668e-16), CGPoint(10.000000000000007, 0.0)),
        .addLineToPoint(CGPoint(90.0, 0.0)),
        .addCurveToPoint(CGPoint(95.522847498, 3.381768755302334e-16), CGPoint(100.0, 4.477152502), CGPoint(100.0, 10.0)),
        .closeSubpath,
      ]
    }

    // with transform
    do {
      let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
      let transform = CGAffineTransform.translation(x: 10, y: 20)
      let path = CGPath.path(roundedRect: rect, cornerWidth: 10, cornerHeight: 20, transform: transform)
      expect(path.pathElements()) == [
        .moveToPoint(CGPoint(110, 70)),
        .addLineToPoint(CGPoint(110, 110)),
        .addCurveToPoint(CGPoint(110, 115.522847498), CGPoint(105.522847498, 120), CGPoint(100, 120)),
        .addLineToPoint(CGPoint(20, 120.00000000000001)),
        .addCurveToPoint(CGPoint(14.477152502, 120.00000000000001), CGPoint(10.0, 115.52284749800002), CGPoint(10.0, 110.00000000000001)),
        .addLineToPoint(CGPoint(10.000000000000004, 30.0)),
        .addCurveToPoint(CGPoint(10.000000000000005, 24.477152502), CGPoint(14.477152502000006, 20.0), CGPoint(20.000000000000007, 20.0)),
        .addLineToPoint(CGPoint(100, 20)),
        .addCurveToPoint(CGPoint(105.522847498, 20), CGPoint(110.0, 24.477152502), CGPoint(110.0, 30.0)),
        .closeSubpath,
      ]
    }
  }

  // MARK: - Subpaths

  func test_subpaths_empty() {
    // empty path
    do {
      let path = CGMutablePath()
      expect(path.subpaths()) == []
    }
  }

  func test_subpaths_single() {
    // move to point
    do {
      let path = CGMutablePath()
      path.move(to: CGPoint(0, 0))
      let subpaths = path.subpaths()
      expect(subpaths.count) == 1
      expect(subpaths) == [path]
    }

    // add line to point
    do {
      let path = CGMutablePath()
      path.addLine(to: CGPoint(100, 0))
      let subpaths = path.subpaths()
      expect(subpaths.count) == 0
    }

    // add quad curve to point
    do {
      let path = CGMutablePath()
      path.addQuadCurve(to: CGPoint(100, 0), control: CGPoint(50, 0))
      let subpaths = path.subpaths()
      expect(subpaths.count) == 0
    }

    // add curve to point
    do {
      let path = CGMutablePath()
      path.addCurve(to: CGPoint(100, 0), control1: CGPoint(50, 0), control2: CGPoint(75, 0))
      let subpaths = path.subpaths()
      expect(subpaths.count) == 0
    }

    // close subpath
    do {
      let path = CGMutablePath()
      path.closeSubpath()
      let subpaths = path.subpaths()
      expect(subpaths.count) == 0
    }

    // move to point, add line
    do {
      let path = CGMutablePath()
      path.move(to: CGPoint(0, 0))
      path.addLine(to: CGPoint(100, 0))

      let subpaths = path.subpaths()
      expect(subpaths.count) == 1
      expect(subpaths) == [path]
    }

    // move to point, add line, add quad curve
    do {
      let path = CGMutablePath()
      path.move(to: CGPoint(0, 0))
      path.addLine(to: CGPoint(100, 0))
      path.addQuadCurve(to: CGPoint(100, 100), control: CGPoint(50, 0))

      let subpaths = path.subpaths()
      expect(subpaths.count) == 1
      expect(subpaths) == [path]
    }

    // move to point, add line, add quad curve, add curve, close subpath
    do {
      let path = CGMutablePath()
      path.move(to: CGPoint(0, 0))
      path.addLine(to: CGPoint(100, 0))
      path.addQuadCurve(to: CGPoint(100, 100), control: CGPoint(50, 0))
      path.addCurve(to: CGPoint(100, 100), control1: CGPoint(50, 0), control2: CGPoint(75, 0))
      path.closeSubpath()

      let subpaths = path.subpaths()
      expect(subpaths.count) == 1
      expect(subpaths) == [path]
    }
  }

  func test_subpaths_two() throws {
    // move to point, add line, add quad curve, move to point, add line
    do {
      let path = CGMutablePath()
      path.move(to: CGPoint(0, 0))
      path.addLine(to: CGPoint(100, 0))
      path.addQuadCurve(to: CGPoint(100, 100), control: CGPoint(50, 0))

      path.move(to: CGPoint(0, 0))
      path.addLine(to: CGPoint(100, 0))

      let subpaths = path.subpaths()
      expect(subpaths.count) == 2
      let firstSubpath = try subpaths[safe: 0].unwrap()
      expect(firstSubpath.pathElements()) == [
        .moveToPoint(CGPoint(0, 0)),
        .addLineToPoint(CGPoint(100, 0)),
        .addQuadCurveToPoint(CGPoint(50, 0), CGPoint(100, 100)),
      ]
      let secondSubpath = try subpaths[safe: 1].unwrap()
      expect(secondSubpath.pathElements()) == [
        .moveToPoint(CGPoint(0, 0)),
        .addLineToPoint(CGPoint(100, 0)),
      ]
    }

    // move to point, add line, add quad curve, close subpath, move to point, add line, close subpath
    do {
      let path = CGMutablePath()
      path.move(to: CGPoint(0, 0))
      path.addLine(to: CGPoint(100, 0))
      path.addQuadCurve(to: CGPoint(100, 100), control: CGPoint(50, 0))
      path.closeSubpath()

      path.move(to: CGPoint(0, 0))
      path.addLine(to: CGPoint(100, 0))
      path.closeSubpath()

      let subpaths = path.subpaths()
      expect(subpaths.count) == 2
      let firstSubpath = try subpaths[safe: 0].unwrap()
      expect(firstSubpath.pathElements()) == [
        .moveToPoint(CGPoint(0, 0)),
        .addLineToPoint(CGPoint(100, 0)),
        .addQuadCurveToPoint(CGPoint(50, 0), CGPoint(100, 100)),
        .closeSubpath,
      ]
      let secondSubpath = try subpaths[safe: 1].unwrap()
      expect(secondSubpath.pathElements()) == [
        .moveToPoint(CGPoint(0, 0)),
        .addLineToPoint(CGPoint(100, 0)),
        .closeSubpath,
      ]
    }
  }

  // MARK: - Miscellaneous

  func test_asBezierPath() {
    let path = CGPath.path(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
    let bezierPath = path.asBezierPath()

    #if canImport(AppKit)
    expect(bezierPath.cgPath.pathElements()) == [
      .moveToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(100, 0)),
      .addLineToPoint(CGPoint(100, 100)),
      .addLineToPoint(CGPoint(0, 100)),
      .closeSubpath,
      .moveToPoint(CGPoint(0, 0)),
    ]
    #endif

    #if canImport(UIKit)
    expect(bezierPath.cgPath.pathElements()) == [
      .moveToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(100, 0)),
      .addLineToPoint(CGPoint(100, 100)),
      .addLineToPoint(CGPoint(0, 100)),
      .closeSubpath,
    ]
    #endif

    let memoryAddressString = memoryAddressString(bezierPath)
    #if canImport(AppKit)
    expect(String(describing: bezierPath)) ==
      """
      Path <\(memoryAddressString)>
        Bounds: {{0, 0}, {100, 100}}
        Control point bounds: {{0, 0}, {100, 100}}
          0.000000 0.000000 moveto
          100.000000 0.000000 lineto
          100.000000 100.000000 lineto
          0.000000 100.000000 lineto
          closepath
          0.000000 0.000000 moveto
      """
    #endif

    #if canImport(UIKit)
    expect(String(describing: bezierPath)) ==
      """
      <UIBezierPath: \(memoryAddressString); <MoveTo {0, 0}>,
       <LineTo {100, 0}>,
       <LineTo {100, 100}>,
       <LineTo {0, 100}>,
       <Close>
      """
    #endif
  }

  func test_reversing() {
    let path = CGPath.path(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
    let reversedPath = path.reversing()

    #if canImport(AppKit)
    expect(reversedPath.pathElements()) == [
      .moveToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(0, 100)),
      .addLineToPoint(CGPoint(100, 100)),
      .addLineToPoint(CGPoint(100, 0)),
      .closeSubpath,
      .moveToPoint(CGPoint(0, 0)),
    ]
    #endif

    #if canImport(UIKit)
    expect(reversedPath.pathElements()) == [
      .moveToPoint(CGPoint(0, 100)),
      .addLineToPoint(CGPoint(100, 100)),
      .addLineToPoint(CGPoint(100, 0)),
      .addLineToPoint(CGPoint(0, 0)),
      .closeSubpath,
    ]
    #endif
  }
}
