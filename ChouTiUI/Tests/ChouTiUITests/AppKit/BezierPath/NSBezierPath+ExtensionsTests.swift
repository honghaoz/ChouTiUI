//
//  NSBezierPath+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/9/24.
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest

import ChouTi
@testable import ChouTiUI

class NSBezierPath_ExtensionsTests: XCTestCase {

  func test_init_arc() {
    let path = BezierPath(arcCenter: .zero, radius: 1, startAngle: 0, endAngle: .pi, clockwise: true)
    let memoryAddressString = memoryAddressString(path)

    #if canImport(AppKit)
    expect(String(describing: path)) ==
      """
      Path <\(memoryAddressString)>
        Bounds: {{-1, 0}, {2, 1}}
        Control point bounds: {{-1, 0}, {2, 1}}
          1.000000 0.000000 moveto
          1.000000 0.552285 0.552285 1.000000 0.000000 1.000000 curveto
          -0.552285 1.000000 -1.000000 0.552285 -1.000000 0.000000 curveto
      """
    #endif

    #if canImport(UIKit)
    expect(String(describing: path)) ==
      """
      <UIBezierPath: \(memoryAddressString); <MoveTo {1, 0}>,
       <CurveTo {0, 1} {1, 0.55228474979999997} {0.55228474979999997, 1}>,
       <CurveTo {-1, 0} {-0.55228474979999997, 1} {-1, 0.55228474979999997}>
      """
    #endif
  }

  func test_apply() {
    let path = BezierPath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: 1, y: 1))
    path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 1, y: 0.5), controlPoint2: CGPoint(x: 0.5, y: 1))
    path.apply(CGAffineTransform(translationX: 1, y: 2))
    expect(path.currentPoint) == CGPoint(x: 1, y: 2)

    let memoryAddressString = memoryAddressString(path)

    #if canImport(AppKit)
    expect(String(describing: path)) ==
      """
      Path <\(memoryAddressString)>
        Bounds: {{1, 2}, {1, 1}}
        Control point bounds: {{1, 2}, {1, 1}}
          1.000000 2.000000 moveto
          2.000000 3.000000 lineto
          2.000000 2.500000 1.500000 3.000000 1.000000 2.000000 curveto
      """
    #endif

    #if canImport(UIKit)
    expect(String(describing: path)) ==
      """
      <UIBezierPath: \(memoryAddressString); <MoveTo {1, 2}>,
       <LineTo {2, 3}>,
       <CurveTo {1, 2} {2, 2.5} {1.5, 3}>
      """
    #endif
  }

  func test_addArc() {
    let path = BezierPath()
    path.move(to: .zero)
    path.addArc(withCenter: CGPoint(x: 1, y: 1), radius: 1, startAngle: 0, endAngle: .pi, clockwise: true)
    expect(path.currentPoint.isApproximatelyEqual(to: CGPoint(x: 0, y: 1), absoluteTolerance: 1e-6)) == true

    let memoryAddressString = memoryAddressString(path)

    #if canImport(AppKit)
    expect(String(describing: path)) ==
      """
      Path <\(memoryAddressString)>
        Bounds: {{0, 0}, {2, 2}}
        Control point bounds: {{0, 0}, {2, 2}}
          0.000000 0.000000 moveto
          2.000000 1.000000 lineto
          2.000000 1.552285 1.552285 2.000000 1.000000 2.000000 curveto
          0.447715 2.000000 0.000000 1.552285 0.000000 1.000000 curveto
      """
    #endif

    #if canImport(UIKit)
    expect(String(describing: path)) ==
      """
      <UIBezierPath: \(memoryAddressString); <MoveTo {0, 0}>,
       <LineTo {2, 1}>,
       <CurveTo {1, 2} {2, 1.5522847498000001} {1.5522847498000001, 2}>,
       <CurveTo {0, 1} {0.44771525020000003, 2} {0, 1.5522847498000001}>
      """
    #endif
  }

  func test_useEvenOddRule() {
    let path = BezierPath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: 1, y: 1))
    path.addLine(to: CGPoint(x: 2, y: 2))
    path.close()

    path.usesEvenOddFillRule = true
    expect(path.usesEvenOddFillRule) == true
    #if canImport(AppKit)
    expect(path.windingRule) == .evenOdd
    #endif

    path.usesEvenOddFillRule = false
    expect(path.usesEvenOddFillRule) == false
    #if canImport(AppKit)
    expect(path.windingRule) == .nonZero
    #endif
  }
}
