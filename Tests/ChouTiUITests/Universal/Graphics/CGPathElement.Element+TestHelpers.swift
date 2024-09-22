//
//  CGPathElement.Element+TestHelpers.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/22/24.
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

/// Compare two arrays of path elements with a tolerance.
func expectPathElementsEqual(_ actual: [CGPathElement.Element], _ expected: [CGPathElement.Element], absoluteTolerance: CGFloat = 1e-13, file: StaticString = #file, line: UInt = #line) {
  expect(actual.count, "path elements count", file: file, line: line) == expected.count

  for (index, (actualElement, expectedElement)) in zip(actual, expected).enumerated() {
    switch (actualElement, expectedElement) {
    case (.moveToPoint(let actualPoint), .moveToPoint(let expectedPoint)):
      expect(
        actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance),
        "[\(index)] moveToPoint: \(actualPoint) to be approximately equal to \(expectedPoint)",
        file: file,
        line: line
      ) == true
    case (.addLineToPoint(let actualPoint), .addLineToPoint(let expectedPoint)):
      expect(
        actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance),
        "[\(index)] addLineToPoint: \(actualPoint) to be approximately equal to \(expectedPoint)",
        file: file,
        line: line
      ) == true
    case (.addQuadCurveToPoint(let actualControl, let actualPoint), .addQuadCurveToPoint(let expectedControl, let expectedPoint)):
      expect(
        actualControl.isApproximatelyEqual(to: expectedControl, absoluteTolerance: absoluteTolerance),
        "[\(index)] addQuadCurveToPoint: control: \(actualControl) to be approximately equal to \(expectedControl)",
        file: file,
        line: line
      ) == true
      expect(
        actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance),
        "[\(index)] addQuadCurveToPoint: point: \(actualPoint) to be approximately equal to \(expectedPoint)",
        file: file,
        line: line
      ) == true
    case (.addCurveToPoint(let actualControl1, let actualControl2, let actualPoint), .addCurveToPoint(let expectedControl1, let expectedControl2, let expectedPoint)):
      expect(
        actualControl1.isApproximatelyEqual(to: expectedControl1, absoluteTolerance: absoluteTolerance),
        "[\(index)] addCurveToPoint: control1: \(actualControl1) to be approximately equal to \(expectedControl1)",
        file: file,
        line: line
      ) == true
      expect(
        actualControl2.isApproximatelyEqual(to: expectedControl2, absoluteTolerance: absoluteTolerance),
        "[\(index)] addCurveToPoint: control2: \(actualControl2) to be approximately equal to \(expectedControl2)",
        file: file,
        line: line
      ) == true
      expect(
        actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance),
        "[\(index)] addCurveToPoint: point: \(actualPoint) to be approximately equal to \(expectedPoint)",
        file: file,
        line: line
      ) == true
    case (.closeSubpath, .closeSubpath):
      continue
    default:
      fail("mismatched element, index: \(index), \(actualElement) != \(expectedElement)", file: file, line: line)
    }
  }
}

/// Prints the path elements for debugging.
func printPathElements(_ elements: [CGPathElement.Element]) {
  print("[")
  for element in elements {
    switch element {
    case .moveToPoint(let point):
      print("  .moveToPoint(CGPoint(x: \(point.x), y: \(point.y))),")
    case .addLineToPoint(let point):
      print("  .addLineToPoint(CGPoint(x: \(point.x), y: \(point.y))),")
    case .addQuadCurveToPoint(let control, let point):
      print("  .addQuadCurveToPoint(CGPoint(x: \(control.x), y: \(control.y)), CGPoint(x: \(point.x), y: \(point.y))),")
    case .addCurveToPoint(let control1, let control2, let point):
      print("  .addCurveToPoint(CGPoint(x: \(control1.x), y: \(control1.y)), CGPoint(x: \(control2.x), y: \(control2.y)), CGPoint(x: \(point.x), y: \(point.y))),")
    case .closeSubpath:
      print("  .closeSubpath,")
    case .unknown:
      fail("unknown element")
    }
  }
  print("]")
}
