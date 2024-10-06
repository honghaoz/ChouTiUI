//
//  CGPathElement.ElementTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/28/22.
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

class CGPathElement_ElementTests: XCTestCase {

  func test_description() {
    expect(CGPathElement.Element.moveToPoint(.zero).description) == "moveToPoint: (0.0, 0.0)"
    expect(CGPathElement.Element.addLineToPoint(.zero).description) == "addLineToPoint: (0.0, 0.0)"
    expect(CGPathElement.Element.addQuadCurveToPoint(.zero, .zero).description) == "addQuadCurveToPoint, control: (0.0, 0.0), point: (0.0, 0.0)"
    expect(CGPathElement.Element.addCurveToPoint(.zero, .zero, .zero).description) == "addCurveToPoint, control1: (0.0, 0.0), control2: (0.0, 0.0), point: (0.0, 0.0)"
    expect(CGPathElement.Element.closeSubpath.description) == "closeSubpath"
    expect(CGPathElement.Element.unknown.description) == "unknown"
  }

  func test_element() {
    let path = CGMutablePath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: 1, y: 1))
    path.addQuadCurve(to: CGPoint(x: 0, y: 0), control: CGPoint(x: 1, y: 0.5))
    path.addCurve(to: CGPoint(x: 2, y: 1), control1: CGPoint(x: 1, y: 0.5), control2: CGPoint(x: 2, y: 0.5))
    path.closeSubpath()

    let elements = path.pathElements()
    expect(elements) == [
      .moveToPoint(CGPoint.zero),
      .addLineToPoint(CGPoint(1, 1)),
      .addQuadCurveToPoint(CGPoint(1, 0.5), CGPoint.zero),
      .addCurveToPoint(CGPoint(1, 0.5), CGPoint(2, 0.5), CGPoint(2, 1)),
      .closeSubpath,
    ]
  }

  func test_element_description() {
    let path = CGMutablePath()
    path.move(to: .zero)
    path.addLine(to: CGPoint(x: 1, y: 1))
    path.addQuadCurve(to: CGPoint(x: 0, y: 0), control: CGPoint(x: 1, y: 0.5))
    path.addCurve(to: CGPoint(x: 2, y: 1), control1: CGPoint(x: 1, y: 0.5), control2: CGPoint(x: 2, y: 0.5))
    path.closeSubpath()

    var elementDescriptions: [String] = []
    var elementTypes: [CGPathElementType] = []
    path.applyWithBlock { elementPointer in
      let element = elementPointer.pointee
      elementDescriptions.append(element.description)
      elementTypes.append(element.type)
    }

    expect(elementDescriptions) == [
      "moveToPoint: (0.0, 0.0)",
      "addLineToPoint: (1.0, 1.0)",
      "addQuadCurveToPoint, control: (1.0, 0.5), point: (0.0, 0.0)",
      "addCurveToPoint, control1: (1.0, 0.5), control2: (2.0, 0.5), point: (2.0, 1.0)",
      "closeSubpath",
    ]
    expect(elementTypes.map(\.description)) == [
      "moveToPoint",
      "addLineToPoint",
      "addQuadCurveToPoint",
      "addCurveToPoint",
      "closeSubpath",
    ]
  }
}
