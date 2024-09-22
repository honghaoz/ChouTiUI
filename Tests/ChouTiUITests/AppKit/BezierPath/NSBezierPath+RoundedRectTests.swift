//
//  NSBezierPath+RoundedRectTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/15/24.
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

class NSBezierPath_RoundedRectTests: XCTestCase {

  #if canImport(AppKit)
  func test_invalidRect() {
    let rect = CGRect(x: 0, y: 0, width: 0, height: 0)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "bounding rect area should be positive"
      expect(metadata["rect"]) == "\(rect)"
    }

    let path = BezierPath(roundedRect: rect, cornerRadius: 10)
    expect(path.cgPath.pathElements()).to(beEmpty())

    Assert.resetTestAssertionFailureHandler()
  }
  #endif

  func test_horizontalRect_shape1() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 10)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 15.28665, y: 0.0)),
      .addLineToPoint(CGPoint(x: 144.71335, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 149.1150704238147, y: 0.0), CGPoint(x: 151.31593055936997, y: 0.0), CGPoint(x: 153.68506207169008, y: 0.7491138784701601)),
      .addLineToPoint(CGPoint(x: 153.68506207169008, y: 0.7491138784701598)),
      .addCurveToPoint(CGPoint(x: 156.27176173374255, y: 1.6905955604437), CGPoint(x: 158.30940443955632, y: 3.7282382662574682), CGPoint(x: 159.25088612152985, y: 6.314937928309926)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 8.684069440630022), CGPoint(x: 160.0, y: 10.88492957618529), CGPoint(x: 160.0, y: 15.286649847295823)),
      .addLineToPoint(CGPoint(x: 160.0, y: 84.71335)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 89.11507042381471), CGPoint(x: 160.0, y: 91.31593055936997), CGPoint(x: 159.25088612152985, y: 93.68506207169007)),
      .addLineToPoint(CGPoint(x: 159.25088612152985, y: 93.68506207169007)),
      .addCurveToPoint(CGPoint(x: 158.30940443955632, y: 96.27176173374252), CGPoint(x: 156.27176173374255, y: 98.3094044395563), CGPoint(x: 153.68506207169008, y: 99.25088612152985)),
      .addCurveToPoint(CGPoint(x: 151.31593055936997, y: 100.0), CGPoint(x: 149.1150704238147, y: 100.0), CGPoint(x: 144.71335015270418, y: 100.0)),
      .addLineToPoint(CGPoint(x: 15.28665, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 10.88492957618529, y: 100.0), CGPoint(x: 8.684069440630022, y: 100.0), CGPoint(x: 6.314937928309925, y: 99.25088612152985)),
      .addLineToPoint(CGPoint(x: 6.314937928309925, y: 99.25088612152985)),
      .addCurveToPoint(CGPoint(x: 3.7282382662574673, y: 98.3094044395563), CGPoint(x: 1.6905955604436997, y: 96.27176173374254), CGPoint(x: 0.7491138784701598, y: 93.68506207169008)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 91.31593055936997), CGPoint(x: 0.0, y: 89.11507042381471), CGPoint(x: 0.0, y: 84.71335015270418)),
      .addLineToPoint(CGPoint(x: 0.0, y: 15.28665)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 10.88492957618529), CGPoint(x: 0.0, y: 8.684069440630022), CGPoint(x: 0.7491138784701583, y: 6.314937928309925)),
      .addLineToPoint(CGPoint(x: 0.7491138784701588, y: 6.314937928309925)),
      .addCurveToPoint(CGPoint(x: 1.690595560443698, y: 3.728238266257468), CGPoint(x: 3.7282382662574687, y: 1.6905955604436977), CGPoint(x: 6.314937928309926, y: 0.7491138784701588)),
      .addCurveToPoint(CGPoint(x: 8.684069440630022, y: 0.0), CGPoint(x: 10.88492957618529, y: 0.0), CGPoint(x: 15.286649847295823, y: 0.0)),
      .addLineToPoint(CGPoint(x: 15.28665, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_2() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 16)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 24.45864, y: 0.0)),
      .addLineToPoint(CGPoint(x: 135.54136, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 142.58411267810354, y: 0.0), CGPoint(x: 146.10548889499196, y: 0.0), CGPoint(x: 149.89609931470414, y: 1.1985822055522561)),
      .addLineToPoint(CGPoint(x: 149.89609931470414, y: 1.1985822055522561)),
      .addCurveToPoint(CGPoint(x: 154.03481877398806, y: 2.70495289670992), CGPoint(x: 157.2950471032901, y: 5.96518122601195), CGPoint(x: 158.80141779444776, y: 10.103900685295882)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 13.894511105008037), CGPoint(x: 160.0, y: 17.415887321896466), CGPoint(x: 160.0, y: 24.45863975567332)),
      .addLineToPoint(CGPoint(x: 160.0, y: 75.54136)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 82.58411267810354), CGPoint(x: 160.0, y: 86.10548889499196), CGPoint(x: 158.80141779444776, y: 89.89609931470412)),
      .addLineToPoint(CGPoint(x: 158.80141779444776, y: 89.89609931470412)),
      .addCurveToPoint(CGPoint(x: 157.2950471032901, y: 94.03481877398805), CGPoint(x: 154.03481877398806, y: 97.29504710329007), CGPoint(x: 149.89609931470414, y: 98.80141779444774)),
      .addCurveToPoint(CGPoint(x: 146.10548889499196, y: 100.0), CGPoint(x: 142.58411267810354, y: 100.0), CGPoint(x: 135.54136024432668, y: 100.0)),
      .addLineToPoint(CGPoint(x: 24.45864, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 17.415887321896466, y: 100.0), CGPoint(x: 13.894511105008037, y: 100.0), CGPoint(x: 10.10390068529588, y: 98.80141779444774)),
      .addLineToPoint(CGPoint(x: 10.10390068529588, y: 98.80141779444774)),
      .addCurveToPoint(CGPoint(x: 5.965181226011948, y: 97.29504710329009), CGPoint(x: 2.7049528967099197, y: 94.03481877398805), CGPoint(x: 1.1985822055522561, y: 89.89609931470412)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 86.10548889499196), CGPoint(x: 0.0, y: 82.58411267810354), CGPoint(x: 0.0, y: 75.54136024432668)),
      .addLineToPoint(CGPoint(x: 0.0, y: 24.45864)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 17.415887321896466), CGPoint(x: 0.0, y: 13.894511105008037), CGPoint(x: 1.1985822055522544, y: 10.10390068529588)),
      .addLineToPoint(CGPoint(x: 1.1985822055522546, y: 10.10390068529588)),
      .addCurveToPoint(CGPoint(x: 2.704952896709917, y: 5.965181226011949), CGPoint(x: 5.965181226011951, y: 2.7049528967099166), CGPoint(x: 10.103900685295882, y: 1.1985822055522546)),
      .addCurveToPoint(CGPoint(x: 13.894511105008037, y: 0.0), CGPoint(x: 17.415887321896466, y: 0.0), CGPoint(x: 24.45863975567332, y: 0.0)),
      .addLineToPoint(CGPoint(x: 24.45864, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 0)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(160, 0)),
      .addLineToPoint(CGPoint(160, 100)),
      .addLineToPoint(CGPoint(0, 100)),
      .addLineToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(0, 0)),
    ]
    expect(path.cgPath.pathElements()) == expectedElements
  }

  func test_horizontalRect_shape1_leastPositiveCornerRadius() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: .leastNonzeroMagnitude)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 1e-323, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 0.0), CGPoint(x: 160.0, y: 0.0), CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 0.0), CGPoint(x: 160.0, y: 5e-324), CGPoint(x: 160.0, y: 5e-324)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 5e-324), CGPoint(x: 160.0, y: 5e-324), CGPoint(x: 160.0, y: 5e-324)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 100.0), CGPoint(x: 160.0, y: 100.0), CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 100.0), CGPoint(x: 160.0, y: 100.0), CGPoint(x: 160.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 100.0), CGPoint(x: 160.0, y: 100.0), CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 1e-323, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 5e-324, y: 100.0), CGPoint(x: 5e-324, y: 100.0), CGPoint(x: 5e-324, y: 100.0)),
      .addLineToPoint(CGPoint(x: 5e-324, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 5e-324, y: 100.0), CGPoint(x: 0.0, y: 100.0), CGPoint(x: 0.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 100.0), CGPoint(x: 0.0, y: 100.0), CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 1e-323)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 5e-324), CGPoint(x: 0.0, y: 5e-324), CGPoint(x: 0.0, y: 5e-324)),
      .addLineToPoint(CGPoint(x: 0.0, y: 5e-324)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 5e-324), CGPoint(x: 5e-324, y: 0.0), CGPoint(x: 5e-324, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 5e-324, y: 0.0), CGPoint(x: 5e-324, y: 0.0), CGPoint(x: 5e-324, y: 0.0)),
      .addLineToPoint(CGPoint(x: 1e-323, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_negativeCornerRadius() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: -10)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: -15.28665, y: 0.0)),
      .addLineToPoint(CGPoint(x: 175.28665, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 170.8849295761853, y: 0.0), CGPoint(x: 168.68406944063003, y: 0.0), CGPoint(x: 166.31493792830992, y: -0.7491138784701601)),
      .addLineToPoint(CGPoint(x: 166.31493792830992, y: -0.7491138784701601)),
      .addCurveToPoint(CGPoint(x: 163.72823826625745, y: -1.6905955604436995), CGPoint(x: 161.69059556044368, y: -3.7282382662574722), CGPoint(x: 160.74911387847015, y: -6.314937928309927)),
      .addCurveToPoint(CGPoint(x: 160.0, y: -8.684069440630022), CGPoint(x: 160.0, y: -10.88492957618529), CGPoint(x: 160.0, y: -15.286649847295823)),
      .addLineToPoint(CGPoint(x: 160.0, y: 115.28665)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 110.88492957618529), CGPoint(x: 160.0, y: 108.68406944063003), CGPoint(x: 160.74911387847015, y: 106.31493792830993)),
      .addLineToPoint(CGPoint(x: 160.74911387847015, y: 106.31493792830993)),
      .addCurveToPoint(CGPoint(x: 161.69059556044368, y: 103.72823826625748), CGPoint(x: 163.72823826625748, y: 101.6905955604437), CGPoint(x: 166.31493792830992, y: 100.74911387847015)),
      .addCurveToPoint(CGPoint(x: 168.68406944063003, y: 100.0), CGPoint(x: 170.8849295761853, y: 100.0), CGPoint(x: 175.28664984729582, y: 100.0)),
      .addLineToPoint(CGPoint(x: -15.28665, y: 100.0)),
      .addCurveToPoint(CGPoint(x: -10.88492957618529, y: 100.0), CGPoint(x: -8.684069440630022, y: 100.0), CGPoint(x: -6.314937928309925, y: 100.74911387847015)),
      .addLineToPoint(CGPoint(x: -6.314937928309925, y: 100.74911387847015)),
      .addCurveToPoint(CGPoint(x: -3.7282382662574705, y: 101.6905955604437), CGPoint(x: -1.690595560443699, y: 103.72823826625746), CGPoint(x: -0.7491138784701601, y: 106.31493792830992)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 108.68406944063003), CGPoint(x: 0.0, y: 110.88492957618529), CGPoint(x: 0.0, y: 115.28664984729582)),
      .addLineToPoint(CGPoint(x: 0.0, y: -15.28665)),
      .addCurveToPoint(CGPoint(x: 0.0, y: -10.88492957618529), CGPoint(x: 0.0, y: -8.684069440630022), CGPoint(x: -0.7491138784701583, y: -6.314937928309925)),
      .addLineToPoint(CGPoint(x: -0.7491138784701583, y: -6.314937928309925)),
      .addCurveToPoint(CGPoint(x: -1.6905955604436975, y: -3.728238266257468), CGPoint(x: -3.7282382662574696, y: -1.690595560443697), CGPoint(x: -6.314937928309927, y: -0.7491138784701583)),
      .addCurveToPoint(CGPoint(x: -8.684069440630022, y: 0.0), CGPoint(x: -10.88492957618529, y: 0.0), CGPoint(x: -15.286649847295823, y: 0.0)),
      .addLineToPoint(CGPoint(x: -15.28665, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape2a() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 42)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 64.20393, y: 0.0)),
      .addLineToPoint(CGPoint(x: 95.79607, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 106.51285961907355, y: 0.0), CGPoint(x: 117.51716029684988, y: 0.0), CGPoint(x: 129.3628178584504, y: 3.745569392350802)),
      .addLineToPoint(CGPoint(x: 129.3628178584504, y: 3.745569392350802)),
      .addCurveToPoint(CGPoint(x: 147.75710983002548, y: 10.440544150405918), CGPoint(x: 160.0, y: 27.925203343417653), CGPoint(x: 160.0, y: 47.499999999999986)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 52.5)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 72.07479665658234), CGPoint(x: 147.75710983002548, y: 89.55945584959409), CGPoint(x: 129.3628178584504, y: 96.2544306076492)),
      .addCurveToPoint(CGPoint(x: 117.51716029684988, y: 100.0), CGPoint(x: 106.51285961907355, y: 100.0), CGPoint(x: 84.50425826352087, y: 100.0)),
      .addLineToPoint(CGPoint(x: 64.20393, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 53.48714038092645, y: 100.0), CGPoint(x: 42.48283970315011, y: 100.0), CGPoint(x: 30.637182141549626, y: 96.2544306076492)),
      .addLineToPoint(CGPoint(x: 30.637182141549626, y: 96.2544306076492)),
      .addCurveToPoint(CGPoint(x: 12.242890169974531, y: 89.55945584959409), CGPoint(x: 4.6629367034256575e-15, y: 72.07479665658235), CGPoint(x: 2.220446049250313e-15, y: 52.50000000000001)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 2.220446049250313e-15, y: 47.50000000000001)),
      .addCurveToPoint(CGPoint(x: -2.220446049250313e-16, y: 27.925203343417664), CGPoint(x: 12.242890169974531, y: 10.440544150405907), CGPoint(x: 30.637182141549633, y: 3.745569392350797)),
      .addCurveToPoint(CGPoint(x: 42.48283970315011, y: 0.0), CGPoint(x: 53.48714038092645, y: 0.0), CGPoint(x: 75.49574173647913, y: 0.0)),
      .addLineToPoint(CGPoint(x: 64.20393, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape2a_2() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 48)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 73.37592, y: 0.0)),
      .addLineToPoint(CGPoint(x: 86.62408, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 106.51285961907355, y: 0.0), CGPoint(x: 117.51716029684988, y: 0.0), CGPoint(x: 129.3628178584504, y: 3.745569392350802)),
      .addLineToPoint(CGPoint(x: 129.3628178584504, y: 3.745569392350802)),
      .addCurveToPoint(CGPoint(x: 147.75710983002548, y: 10.440544150405918), CGPoint(x: 160.0, y: 27.925203343417653), CGPoint(x: 160.0, y: 47.499999999999986)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 52.5)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 72.07479665658234), CGPoint(x: 147.75710983002548, y: 89.55945584959409), CGPoint(x: 129.3628178584504, y: 96.2544306076492)),
      .addCurveToPoint(CGPoint(x: 117.51716029684988, y: 100.0), CGPoint(x: 106.51285961907355, y: 100.0), CGPoint(x: 84.50425826352087, y: 100.0)),
      .addLineToPoint(CGPoint(x: 73.37592, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 53.48714038092645, y: 100.0), CGPoint(x: 42.48283970315011, y: 100.0), CGPoint(x: 30.637182141549626, y: 96.2544306076492)),
      .addLineToPoint(CGPoint(x: 30.637182141549626, y: 96.2544306076492)),
      .addCurveToPoint(CGPoint(x: 12.242890169974531, y: 89.55945584959409), CGPoint(x: 4.6629367034256575e-15, y: 72.07479665658235), CGPoint(x: 2.220446049250313e-15, y: 52.50000000000001)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 2.220446049250313e-15, y: 47.50000000000001)),
      .addCurveToPoint(CGPoint(x: -2.220446049250313e-16, y: 27.925203343417664), CGPoint(x: 12.242890169974531, y: 10.440544150405907), CGPoint(x: 30.637182141549633, y: 3.745569392350797)),
      .addCurveToPoint(CGPoint(x: 42.48283970315011, y: 0.0), CGPoint(x: 53.48714038092645, y: 0.0), CGPoint(x: 75.49574173647913, y: 0.0)),
      .addLineToPoint(CGPoint(x: 73.37592, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape3b() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 64)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 80.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 110.0, y: 0.0), CGPoint(x: 110.0, y: 0.0), CGPoint(x: 110.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 109.99999999999999, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 137.61423749, y: -5.0726531329535e-15), CGPoint(x: 160.0, y: 22.385762509999996), CGPoint(x: 160.0, y: 49.99999999999999)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 77.61423749), CGPoint(x: 137.61423749, y: 100.0), CGPoint(x: 110.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 110.0, y: 100.0), CGPoint(x: 110.0, y: 100.0), CGPoint(x: 110.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 50.0, y: 100.0), CGPoint(x: 50.0, y: 100.0), CGPoint(x: 50.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 50.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 22.385762510000003, y: 100.0), CGPoint(x: 1.6908843776511668e-15, y: 77.61423749), CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 50.00000000000001)),
      .addCurveToPoint(CGPoint(x: -3.3817687553023337e-15, y: 22.38576251000001), CGPoint(x: 22.385762509999996, y: 3.3817687553023337e-15), CGPoint(x: 49.99999999999999, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape3b_2() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 60)
    let path = BezierPath(roundedRect: rect, cornerRadius: 80)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 80.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 130.0, y: 0.0), CGPoint(x: 130.0, y: 0.0), CGPoint(x: 130.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 130.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 146.56854249399998, y: -3.0435918797721003e-15), CGPoint(x: 160.0, y: 13.431457505999994), CGPoint(x: 160.0, y: 29.999999999999993)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 30.0), CGPoint(x: 160.0, y: 30.0), CGPoint(x: 160.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 30.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 30.0), CGPoint(x: 160.0, y: 30.0), CGPoint(x: 160.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 30.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 46.568542494), CGPoint(x: 146.56854249399998, y: 60.0), CGPoint(x: 130.0, y: 60.0)),
      .addCurveToPoint(CGPoint(x: 130.0, y: 60.0), CGPoint(x: 130.0, y: 60.0), CGPoint(x: 130.0, y: 60.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 60.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 60.0), CGPoint(x: 30.0, y: 60.0), CGPoint(x: 30.0, y: 60.0)),
      .addLineToPoint(CGPoint(x: 30.000000000000004, y: 60.0)),
      .addCurveToPoint(CGPoint(x: 13.431457506000005, y: 60.0), CGPoint(x: 1.0145306265907002e-15, y: 46.568542494), CGPoint(x: 0.0, y: 30.000000000000004)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.000000000000004)),
      .addCurveToPoint(CGPoint(x: -2.0290612531814004e-15, y: 13.431457506000005), CGPoint(x: 13.431457505999997, y: 2.0290612531814004e-15), CGPoint(x: 29.999999999999996, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_verticalRect_shape1() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, cornerRadius: 10)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 15.28665, y: 0.0)),
      .addLineToPoint(CGPoint(x: 44.71335, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 49.115070423814714, y: 0.0), CGPoint(x: 51.315930559369974, y: 0.0), CGPoint(x: 53.685062071690076, y: 0.7491138784701601)),
      .addLineToPoint(CGPoint(x: 53.685062071690076, y: 0.7491138784701598)),
      .addCurveToPoint(CGPoint(x: 56.27176173374254, y: 1.6905955604437), CGPoint(x: 58.309404439556296, y: 3.7282382662574682), CGPoint(x: 59.25088612152984, y: 6.314937928309926)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 8.684069440630022), CGPoint(x: 60.0, y: 10.88492957618529), CGPoint(x: 60.0, y: 15.286649847295823)),
      .addLineToPoint(CGPoint(x: 60.0, y: 144.71335)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 149.1150704238147), CGPoint(x: 60.0, y: 151.31593055936997), CGPoint(x: 59.250886121529845, y: 153.68506207169008)),
      .addLineToPoint(CGPoint(x: 59.25088612152984, y: 153.68506207169008)),
      .addCurveToPoint(CGPoint(x: 58.309404439556296, y: 156.27176173374255), CGPoint(x: 56.27176173374254, y: 158.30940443955632), CGPoint(x: 53.685062071690076, y: 159.25088612152985)),
      .addCurveToPoint(CGPoint(x: 51.315930559369974, y: 160.0), CGPoint(x: 49.115070423814714, y: 160.0), CGPoint(x: 44.71335015270418, y: 160.0)),
      .addLineToPoint(CGPoint(x: 15.28665, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 10.88492957618529, y: 160.0), CGPoint(x: 8.684069440630022, y: 160.0), CGPoint(x: 6.314937928309925, y: 159.25088612152985)),
      .addLineToPoint(CGPoint(x: 6.314937928309925, y: 159.25088612152985)),
      .addCurveToPoint(CGPoint(x: 3.7282382662574673, y: 158.30940443955632), CGPoint(x: 1.6905955604436997, y: 156.27176173374255), CGPoint(x: 0.7491138784701598, y: 153.68506207169008)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 151.31593055936997), CGPoint(x: 0.0, y: 149.1150704238147), CGPoint(x: 0.0, y: 144.71335015270418)),
      .addLineToPoint(CGPoint(x: 0.0, y: 15.28665)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 10.88492957618529), CGPoint(x: 0.0, y: 8.684069440630022), CGPoint(x: 0.7491138784701583, y: 6.314937928309925)),
      .addLineToPoint(CGPoint(x: 0.7491138784701588, y: 6.314937928309925)),
      .addCurveToPoint(CGPoint(x: 1.690595560443698, y: 3.728238266257468), CGPoint(x: 3.7282382662574687, y: 1.6905955604436977), CGPoint(x: 6.314937928309926, y: 0.7491138784701588)),
      .addCurveToPoint(CGPoint(x: 8.684069440630022, y: 0.0), CGPoint(x: 10.88492957618529, y: 0.0), CGPoint(x: 15.286649847295823, y: 0.0)),
      .addLineToPoint(CGPoint(x: 15.28665, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_verticalRect_shape2b() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, cornerRadius: 32)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)), // top center
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)), // top center
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)), // top center
      .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)), // top center, slightly right

      .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)), // top right, slightly left, down
      .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)), // top right, down

      .addLineToPoint(CGPoint(x: 60.0, y: 111.08272)), // bottom right, slight up
      .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)), // bottom right, up
      .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)), // bottom right, up

      .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)), // bottom center

      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),

      .addLineToPoint(CGPoint(x: 28.5, y: 160.0)), // bottom center, slightly left

      .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)), // bottom left
      .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)), // bottom left

      .addLineToPoint(CGPoint(x: 0.0, y: 48.91728)), // left, 1/3
      .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)), // top left
      .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
      .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)), // top left

      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_verticalRect_shape2b_2() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, cornerRadius: 24)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
      .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
      .addLineToPoint(CGPoint(x: 60.0, y: 123.31204)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
      .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
      .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
      .addLineToPoint(CGPoint(x: 0.0, y: 36.68796)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
      .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
      .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_verticalRect_shape3a() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, cornerRadius: 64)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 29.999999999999993, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 46.56854249399999, y: -3.0435918797721003e-15), CGPoint(x: 60.0, y: 13.431457505999994), CGPoint(x: 60.0, y: 29.999999999999993)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 30.0), CGPoint(x: 60.0, y: 30.0), CGPoint(x: 60.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 60.0, y: 80.0)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 130.0), CGPoint(x: 60.0, y: 130.0), CGPoint(x: 60.0, y: 130.0)),
      .addLineToPoint(CGPoint(x: 60.0, y: 130.0)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 146.56854249399998), CGPoint(x: 46.568542494, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 30.000000000000004, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 13.431457506000005, y: 160.0), CGPoint(x: 1.0145306265907002e-15, y: 146.56854249399998), CGPoint(x: 0.0, y: 130.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 130.0), CGPoint(x: 0.0, y: 130.0), CGPoint(x: 0.0, y: 130.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 80.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.000000000000004)),
      .addCurveToPoint(CGPoint(x: -2.0290612531814004e-15, y: 13.431457506000005), CGPoint(x: 13.431457505999997, y: 2.0290612531814004e-15), CGPoint(x: 29.999999999999996, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_verticalRect_shape3a_2() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 240)
    let path = BezierPath(roundedRect: rect, cornerRadius: 100)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 29.999999999999993, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 46.56854249399999, y: -3.0435918797721003e-15), CGPoint(x: 60.0, y: 13.431457505999994), CGPoint(x: 60.0, y: 29.999999999999993)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 30.0), CGPoint(x: 60.0, y: 30.0), CGPoint(x: 60.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 60.0, y: 120.0)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 210.0), CGPoint(x: 60.0, y: 210.0), CGPoint(x: 60.0, y: 210.0)),
      .addLineToPoint(CGPoint(x: 60.0, y: 210.0)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 226.56854249399998), CGPoint(x: 46.568542494, y: 240.0), CGPoint(x: 30.0, y: 240.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 240.0), CGPoint(x: 30.0, y: 240.0), CGPoint(x: 30.0, y: 240.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 240.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 240.0), CGPoint(x: 30.0, y: 240.0), CGPoint(x: 30.0, y: 240.0)),
      .addLineToPoint(CGPoint(x: 30.000000000000004, y: 240.0)),
      .addCurveToPoint(CGPoint(x: 13.431457506000005, y: 240.0), CGPoint(x: 1.0145306265907002e-15, y: 226.56854249399998), CGPoint(x: 0.0, y: 210.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 210.0), CGPoint(x: 0.0, y: 210.0), CGPoint(x: 0.0, y: 210.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 120.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.000000000000004)),
      .addCurveToPoint(CGPoint(x: -2.0290612531814004e-15, y: 13.431457506000005), CGPoint(x: 13.431457505999997, y: 2.0290612531814004e-15), CGPoint(x: 29.999999999999996, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  // MARK: - Oval Corner Radius

  // UIBezierPath supports oval corner radius. NSBezierPath does not.

  // func test_horizontalRect_shape1_ovalCornerRadius() {
  //   let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
  //   let cornerRadii = CGSize(width: 10, height: 15)
  //   let path = BezierPath(roundedRect: rect, byRoundingCorners: .all, cornerRadii: cornerRadii)
  //
  //   // printPathElements(path.cgPath.pathElements())
  //
  //   let expectedElements: [CGPathElement.Element] = [
  //     .moveToPoint(CGPoint(x: 15.28665, y: 0.0)),
  //     .addLineToPoint(CGPoint(x: 144.71335, y: 0.0)),
  //     .addCurveToPoint(CGPoint(x: 149.1150704238147, y: 0.0), CGPoint(x: 151.31593055936997, y: 0.0), CGPoint(x: 153.68506207169008, y: 0.7491138784701601)),
  //     .addLineToPoint(CGPoint(x: 153.68506207169008, y: 0.7491138784701598)),
  //     .addCurveToPoint(CGPoint(x: 156.27176173374255, y: 1.6905955604437), CGPoint(x: 158.30940443955632, y: 3.7282382662574682), CGPoint(x: 159.25088612152985, y: 6.314937928309926)),
  //     .addCurveToPoint(CGPoint(x: 160.0, y: 8.684069440630022), CGPoint(x: 160.0, y: 10.88492957618529), CGPoint(x: 160.0, y: 15.286649847295823)),
  //     .addLineToPoint(CGPoint(x: 160.0, y: 84.71335)),
  //     .addCurveToPoint(CGPoint(x: 160.0, y: 89.11507042381471), CGPoint(x: 160.0, y: 91.31593055936997), CGPoint(x: 159.25088612152985, y: 93.68506207169007)),
  //     .addLineToPoint(CGPoint(x: 159.25088612152985, y: 93.68506207169007)),
  //     .addCurveToPoint(CGPoint(x: 158.30940443955632, y: 96.27176173374252), CGPoint(x: 156.27176173374255, y: 98.3094044395563), CGPoint(x: 153.68506207169008, y: 99.25088612152985)),
  //     .addCurveToPoint(CGPoint(x: 151.31593055936997, y: 100.0), CGPoint(x: 149.1150704238147, y: 100.0), CGPoint(x: 144.71335015270418, y: 100.0)),
  //     .addLineToPoint(CGPoint(x: 15.28665, y: 100.0)),
  //     .addCurveToPoint(CGPoint(x: 10.88492957618529, y: 100.0), CGPoint(x: 8.684069440630022, y: 100.0), CGPoint(x: 6.314937928309925, y: 99.25088612152985)),
  //     .addLineToPoint(CGPoint(x: 6.314937928309925, y: 99.25088612152985)),
  //     .addCurveToPoint(CGPoint(x: 3.7282382662574673, y: 98.3094044395563), CGPoint(x: 1.6905955604436997, y: 96.27176173374254), CGPoint(x: 0.7491138784701598, y: 93.68506207169008)),
  //     .addCurveToPoint(CGPoint(x: 0.0, y: 91.31593055936997), CGPoint(x: 0.0, y: 89.11507042381471), CGPoint(x: 0.0, y: 84.71335015270418)),
  //     .addLineToPoint(CGPoint(x: 0.0, y: 15.28665)),
  //     .addCurveToPoint(CGPoint(x: 0.0, y: 10.88492957618529), CGPoint(x: 0.0, y: 8.684069440630022), CGPoint(x: 0.7491138784701583, y: 6.314937928309925)),
  //     .addLineToPoint(CGPoint(x: 0.7491138784701588, y: 6.314937928309925)),
  //     .addCurveToPoint(CGPoint(x: 1.690595560443698, y: 3.728238266257468), CGPoint(x: 3.7282382662574687, y: 1.6905955604436977), CGPoint(x: 6.314937928309926, y: 0.7491138784701588)),
  //     .addCurveToPoint(CGPoint(x: 8.684069440630022, y: 0.0), CGPoint(x: 10.88492957618529, y: 0.0), CGPoint(x: 15.286649847295823, y: 0.0)),
  //     .addLineToPoint(CGPoint(x: 15.28665, y: 0.0)),
  //   ]
  //   expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  // }

  #if canImport(AppKit)
  func test_horizontalRect_shape1_ovalCornerRadius() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let cornerRadii = CGSize(width: 10, height: 15)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "cornerRadii only supports equal width and height"
      expect(metadata["cornerRadii"]) == "\(cornerRadii)"
    }

    let path = BezierPath(roundedRect: rect, byRoundingCorners: .all, cornerRadii: cornerRadii)
    expect(path.cgPath.pathElements()).to(beEmpty())

    Assert.resetTestAssertionFailureHandler()
  }
  #endif

  // MARK: - Rounding Corners

  func test_horizontalRect_shape1_roundingCorners_none() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_topLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.5733, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.5733)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 21.76985915237058), CGPoint(x: 0.0, y: 17.368138881260045), CGPoint(x: 1.4982277569403166, y: 12.62987585661985)),
      .addLineToPoint(CGPoint(x: 1.4982277569403175, y: 12.62987585661985)),
      .addCurveToPoint(CGPoint(x: 3.381191120887396, y: 7.456476532514936), CGPoint(x: 7.456476532514937, y: 3.3811911208873955), CGPoint(x: 12.629875856619853, y: 1.4982277569403175)),
      .addCurveToPoint(CGPoint(x: 17.368138881260045, y: 0.0), CGPoint(x: 21.76985915237058, y: 0.0), CGPoint(x: 30.573299694591647, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 69.4267)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 78.23014084762943), CGPoint(x: 160.0, y: 82.63186111873995), CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addLineToPoint(CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 156.6188088791126, y: 92.54352346748507), CGPoint(x: 152.54352346748504, y: 96.61880887911259), CGPoint(x: 147.37012414338014, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 142.63186111873995, y: 100.0), CGPoint(x: 138.23014084762943, y: 100.0), CGPoint(x: 129.42670030540836, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 21.76985915237058, y: 100.0), CGPoint(x: 17.368138881260045, y: 100.0), CGPoint(x: 12.62987585661985, y: 98.50177224305969)),
      .addLineToPoint(CGPoint(x: 12.62987585661985, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 7.456476532514935, y: 96.61880887911259), CGPoint(x: 3.3811911208873995, y: 92.54352346748507), CGPoint(x: 1.4982277569403195, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 82.63186111873995), CGPoint(x: 0.0, y: 78.23014084762943), CGPoint(x: 0.0, y: 69.42670030540836)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_topLeft_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.5733, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.5733)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 21.76985915237058), CGPoint(x: 0.0, y: 17.368138881260045), CGPoint(x: 1.4982277569403166, y: 12.62987585661985)),
      .addLineToPoint(CGPoint(x: 1.4982277569403175, y: 12.62987585661985)),
      .addCurveToPoint(CGPoint(x: 3.381191120887396, y: 7.456476532514936), CGPoint(x: 7.456476532514937, y: 3.3811911208873955), CGPoint(x: 12.629875856619853, y: 1.4982277569403175)),
      .addCurveToPoint(CGPoint(x: 17.368138881260045, y: 0.0), CGPoint(x: 21.76985915237058, y: 0.0), CGPoint(x: 30.573299694591647, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_topLeft_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.5733, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 69.4267)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 78.23014084762943), CGPoint(x: 160.0, y: 82.63186111873995), CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addLineToPoint(CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 156.6188088791126, y: 92.54352346748507), CGPoint(x: 152.54352346748504, y: 96.61880887911259), CGPoint(x: 147.37012414338014, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 142.63186111873995, y: 100.0), CGPoint(x: 138.23014084762943, y: 100.0), CGPoint(x: 129.42670030540836, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.5733)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 21.76985915237058), CGPoint(x: 0.0, y: 17.368138881260045), CGPoint(x: 1.4982277569403166, y: 12.62987585661985)),
      .addLineToPoint(CGPoint(x: 1.4982277569403175, y: 12.62987585661985)),
      .addCurveToPoint(CGPoint(x: 3.381191120887396, y: 7.456476532514936), CGPoint(x: 7.456476532514937, y: 3.3811911208873955), CGPoint(x: 12.629875856619853, y: 1.4982277569403175)),
      .addCurveToPoint(CGPoint(x: 17.368138881260045, y: 0.0), CGPoint(x: 21.76985915237058, y: 0.0), CGPoint(x: 30.573299694591647, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_topLeft_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.5733, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 21.76985915237058, y: 100.0), CGPoint(x: 17.368138881260045, y: 100.0), CGPoint(x: 12.62987585661985, y: 98.50177224305969)),
      .addLineToPoint(CGPoint(x: 12.62987585661985, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 7.456476532514935, y: 96.61880887911259), CGPoint(x: 3.3811911208873995, y: 92.54352346748507), CGPoint(x: 1.4982277569403195, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 82.63186111873995), CGPoint(x: 0.0, y: 78.23014084762943), CGPoint(x: 0.0, y: 69.42670030540836)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.5733)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 21.76985915237058), CGPoint(x: 0.0, y: 17.368138881260045), CGPoint(x: 1.4982277569403166, y: 12.62987585661985)),
      .addLineToPoint(CGPoint(x: 1.4982277569403175, y: 12.62987585661985)),
      .addCurveToPoint(CGPoint(x: 3.381191120887396, y: 7.456476532514936), CGPoint(x: 7.456476532514937, y: 3.3811911208873955), CGPoint(x: 12.629875856619853, y: 1.4982277569403175)),
      .addCurveToPoint(CGPoint(x: 17.368138881260045, y: 0.0), CGPoint(x: 21.76985915237058, y: 0.0), CGPoint(x: 30.573299694591647, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_topRight_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
      .addLineToPoint(CGPoint(x: 160.0, y: 69.4267)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 78.23014084762943), CGPoint(x: 160.0, y: 82.63186111873995), CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addLineToPoint(CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 156.6188088791126, y: 92.54352346748507), CGPoint(x: 152.54352346748504, y: 96.61880887911259), CGPoint(x: 147.37012414338014, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 142.63186111873995, y: 100.0), CGPoint(x: 138.23014084762943, y: 100.0), CGPoint(x: 129.42670030540836, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_topRight_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 21.76985915237058, y: 100.0), CGPoint(x: 17.368138881260045, y: 100.0), CGPoint(x: 12.62987585661985, y: 98.50177224305969)),
      .addLineToPoint(CGPoint(x: 12.62987585661985, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 7.456476532514935, y: 96.61880887911259), CGPoint(x: 3.3811911208873995, y: 92.54352346748507), CGPoint(x: 1.4982277569403195, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 82.63186111873995), CGPoint(x: 0.0, y: 78.23014084762943), CGPoint(x: 0.0, y: 69.42670030540836)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_bottomRight_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 69.4267)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 78.23014084762943), CGPoint(x: 160.0, y: 82.63186111873995), CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addLineToPoint(CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 156.6188088791126, y: 92.54352346748507), CGPoint(x: 152.54352346748504, y: 96.61880887911259), CGPoint(x: 147.37012414338014, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 142.63186111873995, y: 100.0), CGPoint(x: 138.23014084762943, y: 100.0), CGPoint(x: 129.42670030540836, y: 100.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 21.76985915237058, y: 100.0), CGPoint(x: 17.368138881260045, y: 100.0), CGPoint(x: 12.62987585661985, y: 98.50177224305969)),
      .addLineToPoint(CGPoint(x: 12.62987585661985, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 7.456476532514935, y: 96.61880887911259), CGPoint(x: 3.3811911208873995, y: 92.54352346748507), CGPoint(x: 1.4982277569403195, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 82.63186111873995), CGPoint(x: 0.0, y: 78.23014084762943), CGPoint(x: 0.0, y: 69.42670030540836)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_no_topLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
      .addLineToPoint(CGPoint(x: 160.0, y: 69.4267)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 78.23014084762943), CGPoint(x: 160.0, y: 82.63186111873995), CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addLineToPoint(CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 156.6188088791126, y: 92.54352346748507), CGPoint(x: 152.54352346748504, y: 96.61880887911259), CGPoint(x: 147.37012414338014, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 142.63186111873995, y: 100.0), CGPoint(x: 138.23014084762943, y: 100.0), CGPoint(x: 129.42670030540836, y: 100.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 21.76985915237058, y: 100.0), CGPoint(x: 17.368138881260045, y: 100.0), CGPoint(x: 12.62987585661985, y: 98.50177224305969)),
      .addLineToPoint(CGPoint(x: 12.62987585661985, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 7.456476532514935, y: 96.61880887911259), CGPoint(x: 3.3811911208873995, y: 92.54352346748507), CGPoint(x: 1.4982277569403195, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 82.63186111873995), CGPoint(x: 0.0, y: 78.23014084762943), CGPoint(x: 0.0, y: 69.42670030540836)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_no_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomRight, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.5733, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 69.4267)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 78.23014084762943), CGPoint(x: 160.0, y: 82.63186111873995), CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addLineToPoint(CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 156.6188088791126, y: 92.54352346748507), CGPoint(x: 152.54352346748504, y: 96.61880887911259), CGPoint(x: 147.37012414338014, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 142.63186111873995, y: 100.0), CGPoint(x: 138.23014084762943, y: 100.0), CGPoint(x: 129.42670030540836, y: 100.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 21.76985915237058, y: 100.0), CGPoint(x: 17.368138881260045, y: 100.0), CGPoint(x: 12.62987585661985, y: 98.50177224305969)),
      .addLineToPoint(CGPoint(x: 12.62987585661985, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 7.456476532514935, y: 96.61880887911259), CGPoint(x: 3.3811911208873995, y: 92.54352346748507), CGPoint(x: 1.4982277569403195, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 82.63186111873995), CGPoint(x: 0.0, y: 78.23014084762943), CGPoint(x: 0.0, y: 69.42670030540836)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.5733)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 21.76985915237058), CGPoint(x: 0.0, y: 17.368138881260045), CGPoint(x: 1.4982277569403166, y: 12.62987585661985)),
      .addLineToPoint(CGPoint(x: 1.4982277569403175, y: 12.62987585661985)),
      .addCurveToPoint(CGPoint(x: 3.381191120887396, y: 7.456476532514936), CGPoint(x: 7.456476532514937, y: 3.3811911208873955), CGPoint(x: 12.629875856619853, y: 1.4982277569403175)),
      .addCurveToPoint(CGPoint(x: 17.368138881260045, y: 0.0), CGPoint(x: 21.76985915237058, y: 0.0), CGPoint(x: 30.573299694591647, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_no_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.5733, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 21.76985915237058, y: 100.0), CGPoint(x: 17.368138881260045, y: 100.0), CGPoint(x: 12.62987585661985, y: 98.50177224305969)),
      .addLineToPoint(CGPoint(x: 12.62987585661985, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 7.456476532514935, y: 96.61880887911259), CGPoint(x: 3.3811911208873995, y: 92.54352346748507), CGPoint(x: 1.4982277569403195, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 82.63186111873995), CGPoint(x: 0.0, y: 78.23014084762943), CGPoint(x: 0.0, y: 69.42670030540836)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.5733)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 21.76985915237058), CGPoint(x: 0.0, y: 17.368138881260045), CGPoint(x: 1.4982277569403166, y: 12.62987585661985)),
      .addLineToPoint(CGPoint(x: 1.4982277569403175, y: 12.62987585661985)),
      .addCurveToPoint(CGPoint(x: 3.381191120887396, y: 7.456476532514936), CGPoint(x: 7.456476532514937, y: 3.3811911208873955), CGPoint(x: 12.629875856619853, y: 1.4982277569403175)),
      .addCurveToPoint(CGPoint(x: 17.368138881260045, y: 0.0), CGPoint(x: 21.76985915237058, y: 0.0), CGPoint(x: 30.573299694591647, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_roundingCorners_no_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.5733, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
      .addLineToPoint(CGPoint(x: 160.0, y: 69.4267)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 78.23014084762943), CGPoint(x: 160.0, y: 82.63186111873995), CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addLineToPoint(CGPoint(x: 158.5017722430597, y: 87.37012414338015)),
      .addCurveToPoint(CGPoint(x: 156.6188088791126, y: 92.54352346748507), CGPoint(x: 152.54352346748504, y: 96.61880887911259), CGPoint(x: 147.37012414338014, y: 98.50177224305968)),
      .addCurveToPoint(CGPoint(x: 142.63186111873995, y: 100.0), CGPoint(x: 138.23014084762943, y: 100.0), CGPoint(x: 129.42670030540836, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 30.5733)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 21.76985915237058), CGPoint(x: 0.0, y: 17.368138881260045), CGPoint(x: 1.4982277569403166, y: 12.62987585661985)),
      .addLineToPoint(CGPoint(x: 1.4982277569403175, y: 12.62987585661985)),
      .addCurveToPoint(CGPoint(x: 3.381191120887396, y: 7.456476532514936), CGPoint(x: 7.456476532514937, y: 3.3811911208873955), CGPoint(x: 12.629875856619853, y: 1.4982277569403175)),
      .addCurveToPoint(CGPoint(x: 17.368138881260045, y: 0.0), CGPoint(x: 21.76985915237058, y: 0.0), CGPoint(x: 30.573299694591647, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.5733, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_none() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_topLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.bottomRight], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_topLeft_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_topLeft_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_topLeft_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_topRight_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_topRight_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomLeft], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_no_topLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomRight, .bottomLeft], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_no_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomRight, .bottomLeft], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_no_bottomRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1_zeroCornerRadius_roundingCorners_no_bottomLeft() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize.zero)

    // printPathElements(path.cgPath.pathElements())

    let expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape2a_roundingCorners_none() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let roundingCorners: RectCorner = []
    let cornerRadii = CGSize(width: 42, height: 42)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 2a only supports all rounding corners"
      expect(metadata["rect"]) == "\(rect)"
      expect(metadata["cornerRadius"]) == "\(cornerRadii.width)"
      expect(metadata["roundingCorners"]) == "\(roundingCorners)"
    }

    _ = BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)

    Assert.resetTestAssertionFailureHandler()
  }

  func test_horizontalRect_shape2a_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let roundingCorners: RectCorner = [.topRight]
    let cornerRadii = CGSize(width: 42, height: 42)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 2a only supports all rounding corners"
      expect(metadata["rect"]) == "\(rect)"
      expect(metadata["cornerRadius"]) == "\(cornerRadii.width)"
      expect(metadata["roundingCorners"]) == "\(roundingCorners)"
    }

    _ = BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)

    Assert.resetTestAssertionFailureHandler()
  }

  func test_horizontalRect_shape3b_roundingCorners_none() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let roundingCorners: RectCorner = []
    let cornerRadii = CGSize(width: 64, height: 64)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 3b only supports all rounding corners"
      expect(metadata["rect"]) == "\(rect)"
      expect(metadata["cornerRadius"]) == "\(cornerRadii.width)"
      expect(metadata["roundingCorners"]) == "\(roundingCorners)"
    }

    _ = BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)

    Assert.resetTestAssertionFailureHandler()
  }

  func test_horizontalRect_shape3b_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let roundingCorners: RectCorner = [.topRight]
    let cornerRadii = CGSize(width: 64, height: 64)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 3b only supports all rounding corners"
      expect(metadata["rect"]) == "\(rect)"
      expect(metadata["cornerRadius"]) == "\(cornerRadii.width)"
      expect(metadata["roundingCorners"]) == "\(roundingCorners)"
    }

    _ = BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)

    Assert.resetTestAssertionFailureHandler()
  }

  func test_verticalRect_shape2b_roundingCorners_none() {
    // let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    // let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 40, height: 40))

    // printPathElements(path.cgPath.pathElements())

    // RoundingCorners: []
    // [
    //   .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topRight]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.bottomRight]
    // [
    //   .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 98.8534)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    // ]

    // RoundingCorners: [.bottomLeft]
    // [
    //   .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topLeft]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 61.1466)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
    //   .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topLeft, .topRight]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 61.1466)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
    //   .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topLeft, .bottomRight]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 98.8534)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 61.1466)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
    //   .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topLeft, .bottomLeft]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 61.1466)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
    //   .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topRight, .bottomRight]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 98.8534)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topRight, .bottomLeft]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.bottomRight, .bottomLeft]
    // [
    //   .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 98.8534)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topRight, .bottomRight, .bottomLeft]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 98.8534)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topLeft, .bottomRight, .bottomLeft]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0), CGPoint(x: 60.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 98.8534)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 61.1466)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
    //   .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topLeft, .topRight, .bottomLeft]
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0), CGPoint(x: 60.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 61.1466)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
    //   .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]

    // RoundingCorners: [.topLeft, .topRight, .bottomRight
    // [
    //   .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
    //   .addLineToPoint(CGPoint(x: 60.0, y: 98.8534)),
    //   .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
    //   .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0), CGPoint(x: 0.0, y: 160.0)),
    //   .addLineToPoint(CGPoint(x: 0.0, y: 61.1466)),
    //   .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
    //   .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
    //   .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
    //   .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
    //   .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    // ]
  }

  func test_verticalRect_shape2b_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let roundingCorners: RectCorner = [.topRight]
    let cornerRadii = CGSize(width: 40, height: 40)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 2b only supports all rounding corners"
      expect(metadata["rect"]) == "\(rect)"
      expect(metadata["cornerRadius"]) == "\(cornerRadii.width)"
      expect(metadata["roundingCorners"]) == "\(roundingCorners)"
    }

    _ = BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)

    Assert.resetTestAssertionFailureHandler()
  }

  func test_verticalRect_shape3a_roundingCorners_none() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let roundingCorners: RectCorner = []
    let cornerRadii = CGSize(width: 64, height: 64)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 3a only supports all rounding corners"
      expect(metadata["rect"]) == "\(rect)"
      expect(metadata["cornerRadius"]) == "\(cornerRadii.width)"
      expect(metadata["roundingCorners"]) == "\(roundingCorners)"
    }

    _ = BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)

    Assert.resetTestAssertionFailureHandler()
  }

  func test_verticalRect_shape3a_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let roundingCorners: RectCorner = [.topRight]
    let cornerRadii = CGSize(width: 64, height: 64)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 3a only supports all rounding corners"
      expect(metadata["rect"]) == "\(rect)"
      expect(metadata["cornerRadius"]) == "\(cornerRadii.width)"
      expect(metadata["roundingCorners"]) == "\(roundingCorners)"
    }

    _ = BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)

    Assert.resetTestAssertionFailureHandler()
  }

  // MARK: - Code Generation

  #if canImport(UIKit)
  func test_generate_shape1() {
    NSBezierPathRoundedRectGenerator.generateShape1Code()
  }

  func test_generate_shape2a() {
    NSBezierPathRoundedRectGenerator.generateShape2aCode()
  }

  func test_generate_shape2b() {
    NSBezierPathRoundedRectGenerator.generateShape2bCode()
  }

  func test_generate_shape3a() {
    NSBezierPathRoundedRectGenerator.generateShape3aCode()
  }

  func test_generate_shape3b() {
    NSBezierPathRoundedRectGenerator.generateShape3bCode()
  }
  #endif
}

// MARK: - Code Generation

#if canImport(UIKit) && DEBUG

public enum NSBezierPathRoundedRectGenerator {

  /// Generate shape 1 code.
  public static func generateShape1Code() {
    print(
      """
      ==================== Shape 1 ====================
      let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
      // ChouTi.assert(cornerRadius <= limit, "caller should make sure radius is within shape 1 limit")
      let limitedRadius: CGFloat = min(cornerRadius, limit)

      """
    )

    let rect = CGRect(0, 0, 120, 90)
    let cornerRadius: CGFloat = 10
    let shape1 = BezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    let shape1PathElements = shape1.pathElements()
    ChouTi.assert(shape1PathElements.count == 22)

    for (i, e) in shape1PathElements.enumerated() {
      switch i {
      // top left
      case 0:
        print("// top left")
        print("if roundingCorners.contains(.topLeft) {")
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .topLeft)
        print("} else {")
        print("  move(to: rect.topLeft)")
        print("}\n")
      // top right
      case 1:
        print("// top right")
        print("if roundingCorners.contains(.topRight) {")
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .topRight)
      case 2 ... 4:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .topRight)
      case 5:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .topRight)
        print("} else {")
        print("  addLine(to: rect.topRight)")
        print("}\n")
      // bottom right
      case 6:
        print("// bottom right")
        print("if roundingCorners.contains(.bottomRight) {")
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .bottomRight)
      case 7 ... 9:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .bottomRight)
      case 10:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .bottomRight)
        print("} else {")
        print("  addLine(to: rect.bottomRight)")
        print("}\n")
      // bottom left
      case 11:
        print("// bottom left")
        print("if roundingCorners.contains(.bottomLeft) {")
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .bottomLeft)
      case 12 ... 14:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .bottomLeft)
      case 15:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .bottomLeft)
        print("} else {")
        print("  addLine(to: rect.bottomLeft)")
        print("}\n")
      // top left
      case 16:
        print("// top left")
        print("if roundingCorners.contains(.topLeft) {")
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .topLeft)
      case 17 ... 20:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .topLeft)
      case 21:
        print("  ", terminator: "")
        printCodeLine(rect, cornerRadius, e, .topLeft)
        print("} else {")
        print("  addLine(to: rect.topLeft)")
        print("}")
      default:
        ChouTi.assertFailure("unexpected")
      }
    }

    print("==================== End ====================")
  }

  public static func generateShape2aCode() {
    print(
      #"""
      ==================== Shape 2a ====================
      ChouTi.assert(roundingCorners == .all, "shape 2a only supports all rounding corners", metadata: [
        "rect": "\(rect)",
        "cornerRadius": "\(cornerRadius)",
        "roundingCorners": "\(roundingCorners)",
      ])

      let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
      let limitedRadius: CGFloat = min(cornerRadius, limit)

      """#
    )

    let rect = CGRect(0, 0, 120, 90)
    let cornerRadius: CGFloat = 36
    let limit = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius = min(cornerRadius, limit)

    let shape2a = BezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    let shape2aPathElements = shape2a.pathElements()
    ChouTi.assert(shape2aPathElements.count == 22)

    for (i, e) in shape2aPathElements.enumerated() {
      switch i {
      case 0:
        print("// top left")
        printCodeLine(rect, cornerRadius, e, .topLeft, "cornerRadius")
      case 1:
        print("\n// top right")
        printCodeLine(rect, cornerRadius, e, .topRight, "cornerRadius")
      case 2 ... 4:
        printCodeLine(rect, limitedRadius, e, .topRight)
      case 5:
        print("\n// right center")
        print("addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)")
      case 6:
        print("addLine(to: rect.rightCenter)")
      case 7:
        print("addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)")
      case 8:
        print("\n// bottom right")
        printCodeLine(rect, limitedRadius, e, .bottomRight)
      case 9 ... 10:
        printCodeLine(rect, limitedRadius, e, .bottomRight)
      case 11:
        print("\n// bottom left")
        printCodeLine(rect, cornerRadius, e, .bottomLeft, "cornerRadius")
      case 12 ... 14:
        printCodeLine(rect, limitedRadius, e, .bottomLeft)
      case 15:
        print("\n// left center")
        print("addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)")
      case 16:
        print("addLine(to: rect.leftCenter)")
      case 17:
        print("addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)")
      case 18:
        print("\n// top left")
        printCodeLine(rect, limitedRadius, e, .topLeft)
      case 19 ... 20:
        printCodeLine(rect, limitedRadius, e, .topLeft)
      case 21:
        printCodeLine(rect, cornerRadius, e, .topLeft, "cornerRadius")
      default:
        ChouTi.assertFailure("unexpected")
      }
    }

    print("==================== End ====================")
  }

  public static func generateShape2bCode() {
    print(
      #"""
      ==================== Shape 2b ====================
      ChouTi.assert(roundingCorners == .all, "shape 2b only supports all rounding corners", metadata: [
        "rect": "\(rect)",
        "cornerRadius": "\(cornerRadius)",
        "roundingCorners": "\(roundingCorners)",
      ])

      let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
      let limitedRadius: CGFloat = min(cornerRadius, limit)

      """#
    )

    let rect = CGRect(0, 0, 90, 120)

    let cornerRadius: CGFloat = 36
    let limit = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius = min(cornerRadius, limit)

    let shape2b = BezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    let shape2bPathElements = shape2b.pathElements()
    ChouTi.assert(shape2bPathElements.count == 22)

    for (i, e) in shape2bPathElements.enumerated() {
      switch i {
      case 0:
        print("move(to: rect.topCenter)")
        print("")
      case 1:
        print("// top center")
        print("addLine(to: rect.topCenter)")
      case 2:
        print("addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)")
        print("")
      case 3:
        print("// top right")
        printCodeLine(rect, limitedRadius, e, .topRight)
      case 4 ... 5:
        printCodeLine(rect, limitedRadius, e, .topRight)
      case 6:
        print("\n// bottom right")
        printCodeLine(rect, cornerRadius, e, .bottomRight, "cornerRadius")
      case 7 ... 9:
        printCodeLine(rect, limitedRadius, e, .bottomRight)
      case 10:
        print("\n// bottom center")
        print("addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)")
      case 11:
        print("addLine(to: rect.bottomCenter)")
      case 12:
        print("addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)")
      case 13:
        print("\n// bottom left")
        printCodeLine(rect, limitedRadius, e, .bottomLeft)
      case 14 ... 15:
        printCodeLine(rect, limitedRadius, e, .bottomLeft)
      case 16:
        print("\n// top left")
        printCodeLine(rect, cornerRadius, e, .topLeft, "cornerRadius")
      case 17 ... 19:
        printCodeLine(rect, limitedRadius, e, .topLeft)
      case 20:
        print("\n// top center")
        print("addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)")
      case 21:
        print("addLine(to: rect.topCenter)")
      default:
        ChouTi.assertFailure("unexpected")
      }
    }

    print("==================== End ====================")
  }

  public static func generateShape3aCode() {
    print(
      #"""
      ==================== Shape 3a ====================
      ChouTi.assert(roundingCorners == .all, "shape 3a only supports all rounding corners", metadata: [
        "rect": "\(rect)",
        "cornerRadius": "\(cornerRadius)",
        "roundingCorners": "\(roundingCorners)",
      ])

      let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
      let limitedRadius: CGFloat = min(cornerRadius, limit)

      """#
    )

    let rect = CGRect(0, 0, 90, 120)
    let cornerRadius: CGFloat = 44
    let limit = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius = min(cornerRadius, limit)

    let shape3a = BezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    let shape3aPathElements = shape3a.pathElements()
    ChouTi.assert(shape3aPathElements.count == 22)

    for (i, e) in shape3aPathElements.enumerated() {
      switch i {
      case 0:
        print("move(to: rect.topCenter)")
      case 1:
        print("\n// top center")
        print("addLine(to: rect.topCenter)")
      case 2:
        print("addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)")
      case 3:
        print("addLine(to: rect.topCenter)")
      case 4:
        print("\n// top right")
        printCodeLine(rect, limitedRadius, e, .topRight)
      case 5:
        printCodeLine(rect, limitedRadius, e, .topRight)
      case 6:
        print("\n// right center")
        print("addLine(to: rect.rightCenter)")
      case 7:
        print("\n// bottom right")
        printCodeLine(rect, limitedRadius, e, .bottomRight)
      case 8:
        printCodeLine(rect, limitedRadius, e, .bottomRight)
      case 9:
        print("\n// bottom center")
        if case .addCurveToPoint(let c1, let c2, let point) = e {
          let (c1x, c1y) = reverseBottomRight(rect, limitedRadius, point: c1)
          let (c2x, c2y) = reverseBottomRight(rect, limitedRadius, point: c2)
          print("addCurve(to: rect.bottomCenter, controlPoint1: bottomRight(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), limitedRadius), controlPoint2: bottomRight(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), limitedRadius))")
        } else {
          ChouTi.assertFailure("unexpected element: \(e)")
        }
      case 10:
        print("addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)")
      case 11:
        print("addLine(to: rect.bottomCenter)")
      case 12:
        print("addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)")
      case 13:
        print("addLine(to: rect.bottomCenter)")
      case 14:
        print("\n// bottom left")
        printCodeLine(rect, limitedRadius, e, .bottomLeft)
      case 15:
        printCodeLine(rect, limitedRadius, e, .bottomLeft)
      case 16:
        print("\n// left center")
        print("addLine(to: rect.leftCenter)")
      case 17:
        print("\n// top left")
        printCodeLine(rect, limitedRadius, e, .topLeft)
      case 18:
        printCodeLine(rect, limitedRadius, e, .topLeft)
      case 19:
        print("\n// top center")
        if case .addCurveToPoint(let c1, let c2, let point) = e {
          let (c1x, c1y) = reverseTopLeft(rect, limitedRadius, point: c1)
          let (c2x, c2y) = reverseTopLeft(rect, limitedRadius, point: c2)
          print("addCurve(to: rect.topCenter, controlPoint1: topLeft(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), limitedRadius), controlPoint2: topLeft(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), limitedRadius))")
        } else {
          ChouTi.assertFailure("unexpected element: \(e)")
        }
      case 20:
        print("addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)")
      case 21:
        print("addLine(to: rect.topCenter)\n")
      default:
        ChouTi.assertFailure("unexpected")
      }
    }

    print("==================== End ====================")
  }

  public static func generateShape3bCode() {
    print(
      #"""
      ==================== Shape 3b ====================
      ChouTi.assert(roundingCorners == .all, "shape 3b only supports all rounding corners", metadata: [
        "rect": "\(rect)",
        "cornerRadius": "\(cornerRadius)",
        "roundingCorners": "\(roundingCorners)",
      ])

      let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
      let limitedRadius: CGFloat = min(cornerRadius, limit)

      """#
    )

    let rect = CGRect(0, 0, 120, 90)
    let cornerRadius: CGFloat = 44
    let limit = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius = min(cornerRadius, limit)

    let shape3b = BezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
    let shape3bPathElements = shape3b.pathElements()
    ChouTi.assert(shape3bPathElements.count == 22)

    for (i, e) in shape3bPathElements.enumerated() {
      switch i {
      case 0:
        print("move(to: rect.topCenter)")
      case 1:
        print("\n// top center")
        print("addLine(to: rect.topCenter)")
      case 2:
        print("\n// top right")
        printCodeLine(rect, limitedRadius, e, .topRight)
      case 3:
        printCodeLine(rect, limitedRadius, e, .topRight)
      case 4:
        print("\n// right center")
        if case .addCurveToPoint(let c1, let c2, let point) = e {
          let (c1x, c1y) = reverseTopRight(rect, limitedRadius, point: c1)
          let (c2x, c2y) = reverseTopRight(rect, limitedRadius, point: c2)
          print("addCurve(to: rect.rightCenter, controlPoint1: topRight(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), limitedRadius), controlPoint2: topRight(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), limitedRadius))")
        } else {
          ChouTi.assertFailure("unexpected element: \(e)")
        }
      case 5:
        print("addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)")
      case 6:
        print("addLine(to: rect.rightCenter)")
      case 7:
        print("addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)")
      case 8:
        print("addLine(to: rect.rightCenter)")
      case 9:
        print("\n// bottom right")
        printCodeLine(rect, limitedRadius, e, .bottomRight)
      case 10:
        printCodeLine(rect, limitedRadius, e, .bottomRight)
      case 11:
        print("\n// bottom center")
        print("addLine(to: rect.bottomCenter)")
      case 12:
        print("\n// bottom left")
        printCodeLine(rect, limitedRadius, e, .bottomLeft)
      case 13:
        printCodeLine(rect, limitedRadius, e, .bottomLeft)
      case 14:
        print("\n// left center")
        if case .addCurveToPoint(let c1, let c2, let point) = e {
          let (c1x, c1y) = reverseBottomLeft(rect, limitedRadius, point: c1)
          let (c2x, c2y) = reverseBottomLeft(rect, limitedRadius, point: c2)
          print("addCurve(to: rect.leftCenter, controlPoint1: bottomLeft(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), limitedRadius), controlPoint2: bottomLeft(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), limitedRadius))")
        } else {
          ChouTi.assertFailure("unexpected element: \(e)")
        }
      case 15:
        print("addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)")
      case 16:
        print("addLine(to: rect.leftCenter)")
      case 17:
        print("addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)")
      case 18:
        print("addLine(to: rect.leftCenter)")
      case 19:
        print("\n// top left")
        printCodeLine(rect, limitedRadius, e, .topLeft)
      case 20:
        printCodeLine(rect, limitedRadius, e, .topLeft)
      case 21:
        print("addLine(to: rect.topCenter)")
      default:
        ChouTi.assertFailure("unexpected")
      }
    }

    print("==================== End ====================")
  }
}

// MARK: - Code Generation Helper

/// Helper on passing the topLeft resulted point and get back x, y params
private func reverseTopLeft(_ rect: CGRect, _ radius: CGFloat, point: CGPoint) -> (x: CGFloat, y: CGFloat) {
  // CGPoint(x: rect.origin.x + x * radius, y: rect.origin.y + y * radius) == point
  let x = (point.x - rect.origin.x) / radius
  let y = (point.y - rect.origin.y) / radius
  return (x, y)
}

private func reverseTopRight(_ rect: CGRect, _ radius: CGFloat, point: CGPoint) -> (x: CGFloat, y: CGFloat) {
  // CGPoint(x: rect.origin.x + rect.width - x * radius, y: rect.origin.y + y * radius) == point
  let x = (point.x - rect.origin.x - rect.width) / -radius
  let y = (point.y - rect.origin.y) / radius
  return (x, y)
}

private func reverseBottomRight(_ rect: CGRect, _ radius: CGFloat, point: CGPoint) -> (x: CGFloat, y: CGFloat) {
  // CGPoint(x: rect.origin.x + rect.width - x * radius, y: rect.origin.y + rect.height - y * radius) == point
  let x = (point.x - rect.origin.x - rect.width) / -radius
  let y = (point.y - rect.origin.y - rect.height) / -radius
  return (x, y)
}

private func reverseBottomLeft(_ rect: CGRect, _ radius: CGFloat, point: CGPoint) -> (x: CGFloat, y: CGFloat) {
  // CGPoint(x: rect.origin.x + x * radius, y: rect.origin.y + rect.height - y * radius) == point
  let x = (point.x - rect.origin.x) / radius
  let y = (point.y - rect.origin.y - rect.height) / -radius
  return (x, y)
}

private enum FunctionType {

  case topLeft
  case topRight
  case bottomLeft
  case bottomRight

  var funcName: String {
    switch self {
    case .topLeft:
      return "topLeft"
    case .topRight:
      return "topRight"
    case .bottomLeft:
      return "bottomLeft"
    case .bottomRight:
      return "bottomRight"
    }
  }
}

private func printCodeLine(_ rect: CGRect, _ radius: CGFloat, _ element: CGPathElement.Element, _ functionType: FunctionType, _ radiusName: String = "limitedRadius") {
  switch element {
  case .moveToPoint(let point):
    switch functionType {
    case .topLeft:
      let (x, y) = reverseTopLeft(rect, radius, point: point)
      print("move(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    case .topRight:
      let (x, y) = reverseTopRight(rect, radius, point: point)
      print("move(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    case .bottomLeft:
      let (x, y) = reverseBottomLeft(rect, radius, point: point)
      print("move(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    case .bottomRight:
      let (x, y) = reverseBottomRight(rect, radius, point: point)
      print("move(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    }
  case .addLineToPoint(let point):
    switch functionType {
    case .topLeft:
      let (x, y) = reverseTopLeft(rect, radius, point: point)
      print("addLine(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    case .topRight:
      let (x, y) = reverseTopRight(rect, radius, point: point)
      print("addLine(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    case .bottomLeft:
      let (x, y) = reverseBottomLeft(rect, radius, point: point)
      print("addLine(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    case .bottomRight:
      let (x, y) = reverseBottomRight(rect, radius, point: point)
      print("addLine(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)))")
    }
  case .addQuadCurveToPoint:
    ChouTi.assertFailure("unexpected")
  case .addCurveToPoint(let c1, let c2, let point):
    switch functionType {
    case .topLeft:
      let (x, y) = reverseTopLeft(rect, radius, point: point)
      let (c1x, c1y) = reverseTopLeft(rect, radius, point: c1)
      let (c2x, c2y) = reverseTopLeft(rect, radius, point: c2)
      print("addCurve(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)), controlPoint1: \(functionType.funcName)(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), \(radiusName)), controlPoint2: \(functionType.funcName)(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), \(radiusName)))")
    case .topRight:
      let (x, y) = reverseTopRight(rect, radius, point: point)
      let (c1x, c1y) = reverseTopRight(rect, radius, point: c1)
      let (c2x, c2y) = reverseTopRight(rect, radius, point: c2)
      print("addCurve(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)), controlPoint1: \(functionType.funcName)(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), \(radiusName)), controlPoint2: \(functionType.funcName)(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), \(radiusName)))")
    case .bottomLeft:
      let (x, y) = reverseBottomLeft(rect, radius, point: point)
      let (c1x, c1y) = reverseBottomLeft(rect, radius, point: c1)
      let (c2x, c2y) = reverseBottomLeft(rect, radius, point: c2)
      print("addCurve(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)), controlPoint1: \(functionType.funcName)(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), \(radiusName)), controlPoint2: \(functionType.funcName)(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), \(radiusName)))")
    case .bottomRight:
      let (x, y) = reverseBottomRight(rect, radius, point: point)
      let (c1x, c1y) = reverseBottomRight(rect, radius, point: c1)
      let (c2x, c2y) = reverseBottomRight(rect, radius, point: c2)
      print("addCurve(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName)), controlPoint1: \(functionType.funcName)(rect, \(formattedNumber(c1x)), \(formattedNumber(c1y)), \(radiusName)), controlPoint2: \(functionType.funcName)(rect, \(formattedNumber(c2x)), \(formattedNumber(c2y)), \(radiusName)))")
    }
  case .closeSubpath:
    print("close()")
  case .unknown:
    ChouTi.assertFailure("unexpected")
  }
}

private func formattedNumber(_ n: CGFloat) -> String {
  if n == 0 {
    return "0"
  }
  // return String(format: "%.8f", n)
  return "\(n)"
}

#endif
