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

  func test_horizontalRect_shape1_cornerRadius0() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 0)

    #if canImport(AppKit)
    expect(path.cgPath.pathElements()) == [
      .moveToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(160, 0)),
      .addLineToPoint(CGPoint(160, 100)),
      .addLineToPoint(CGPoint(0, 100)),
      .closeSubpath,
    ]
    #endif

    #if canImport(UIKit)
    expect(path.cgPath.pathElements()) == [
      .moveToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(160, 0)),
      .addLineToPoint(CGPoint(160, 100)),
      .addLineToPoint(CGPoint(0, 100)),
      .addLineToPoint(CGPoint(0, 0)),
      .addLineToPoint(CGPoint(0, 0)),
    ]
    #endif
  }

  func test_horizontalRect_shape1() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 10)

    var expectedElements: [CGPathElement.Element] = [
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

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: 15.28665, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape2a() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 42)

    // printPathElements(path.cgPath.pathElements())

    #if canImport(AppKit)
    expect(path.cgPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 65.6108415865105, y: 0.0)),
      .addLineToPoint(CGPoint(x: 95.79607714, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 106.51285527384051, y: 0.0), CGPoint(x: 117.51716221534318, y: 0.0), CGPoint(x: 127.44078196657406, y: 3.2747947108850535)),
      .addLineToPoint(CGPoint(x: 129.36281382230794, y: 3.7455682813085978)),
      .addCurveToPoint(CGPoint(x: 147.75710761920257, y: 10.440543398908444), CGPoint(x: 159.9999833187763, y: 27.92520810464384), CGPoint(x: 159.9999833187763, y: 47.500009534464134)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 52.49999798844067)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 72.07479385785307), CGPoint(x: 147.75710761920257, y: 89.55945954483691), CGPoint(x: 129.36281382230794, y: 96.25443139160859)),
      .addCurveToPoint(CGPoint(x: 117.51716221534318, y: 100.0), CGPoint(x: 106.51285527384051, y: 100.0), CGPoint(x: 84.50426068872142, y: 100.0)),
      .addLineToPoint(CGPoint(x: 64.20392286, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 53.48714080116568, y: 100.0), CGPoint(x: 42.48283778465682, y: 100.0), CGPoint(x: 32.55921607092903, y: 96.7252062703634)),
      .addLineToPoint(CGPoint(x: 30.637184215195163, y: 96.25443139160859)),
      .addCurveToPoint(CGPoint(x: 12.242889437052071, y: 89.55945954483691), CGPoint(x: -2.2895797242878936e-06, y: 72.07479385785307), CGPoint(x: -3.270828177554134e-07, y: 52.49999439052968)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: -3.270828177554134e-07, y: 47.49999808656551)),
      .addCurveToPoint(CGPoint(x: 1.3083312710216536e-06, y: 27.925198292159305), CGPoint(x: 12.242893362045884, y: 10.440541436411538), CGPoint(x: 30.63718617769207, y: 3.7455679542257796)),
      .addCurveToPoint(CGPoint(x: 42.48283778465682, y: 0.0), CGPoint(x: 53.48714080116568, y: 0.0), CGPoint(x: 75.49573931127858, y: 0.0)),
      .addLineToPoint(CGPoint(x: 64.20392286, y: 0.0)),
      .addLineToPoint(CGPoint(x: 65.6108415865105, y: 0.0)),
      .closeSubpath,
      .moveToPoint(CGPoint(x: 65.6108415865105, y: 0.0)),
    ]
    #endif

    #if canImport(UIKit)
    expectPathElementsEqual(path.cgPath.pathElements(), [
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
    ])
    #endif
  }

  func test_horizontalRect_shape3b() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 64)

    // printPathElements(path.cgPath.pathElements())

    #if canImport(AppKit)
    expect(path.cgPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 80.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 109.99999607500618, y: 0.0), CGPoint(x: 109.99999607500618, y: 0.0), CGPoint(x: 109.99999607500618, y: 0.0)),
      .addLineToPoint(CGPoint(x: 109.99999607500618, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 137.6142308448347, y: 3.270828177554134e-07), CGPoint(x: 160.0, y: 22.385763267674573), CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0), CGPoint(x: 160.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 77.61423869482233), CGPoint(x: 137.6142308448347, y: 100.0), CGPoint(x: 109.99999607500618, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 109.99999607500618, y: 100.0), CGPoint(x: 109.99999607500618, y: 100.0), CGPoint(x: 109.99999607500618, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 109.99999607500618, y: 100.0), CGPoint(x: 109.99999607500618, y: 100.0), CGPoint(x: 109.99999607500618, y: 100.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 50.0, y: 100.0), CGPoint(x: 50.0, y: 100.0), CGPoint(x: 50.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 49.99999607500618, y: 100.0)),
      .addCurveToPoint(CGPoint(x: 22.385759342680764, y: 100.0), CGPoint(x: -1.3083312710216536e-06, y: 77.61423084483471), CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0), CGPoint(x: 0.0, y: 50.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 50.0)),
      .addCurveToPoint(CGPoint(x: 2.2895797242878936e-06, y: 22.385761305177667), CGPoint(x: 22.38576523017148, y: -3.270828177554134e-07), CGPoint(x: 50.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0), CGPoint(x: 50.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 80.0, y: 0.0)),
      .closeSubpath,
      .moveToPoint(CGPoint(x: 80.0, y: 0.0)),
    ]
    #endif

    #if canImport(UIKit)
    expectPathElementsEqual(path.cgPath.pathElements(), [
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
    ])
    #endif
  }

  func test_verticalRect_shape1() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, cornerRadius: 10)

    // printPathElements(path.cgPath.pathElements())

    var expectedElements: [CGPathElement.Element] = [
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

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: 15.28665, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_verticalRect_shape2b() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, cornerRadius: 32)

    // printPathElements(path.cgPath.pathElements())

    var expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 31.499999999999996, y: -8.881784197001252e-16)),
      .addCurveToPoint(CGPoint(x: 43.2448779939494, y: -2.9976021664879227e-15), CGPoint(x: 53.73567350975645, y: 7.345734101984717), CGPoint(x: 57.75265836458952, y: 18.38230928492978)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 25.48970382189007), CGPoint(x: 60.0, y: 32.09228422855587), CGPoint(x: 60.0, y: 45.29744504188747)),
      .addLineToPoint(CGPoint(x: 60.0, y: 111.08272)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 127.90771577144413), CGPoint(x: 60.0, y: 134.5102961781099), CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
      .addLineToPoint(CGPoint(x: 57.75265836458952, y: 141.6176907150702)),
      .addCurveToPoint(CGPoint(x: 53.73567350975645, y: 152.65426589801527), CGPoint(x: 43.2448779939494, y: 160.0), CGPoint(x: 31.5, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 28.5, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 16.7551220060506, y: 160.0), CGPoint(x: 6.2643264902435485, y: 152.65426589801527), CGPoint(x: 2.2473416354104794, y: 141.6176907150702)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 134.5102961781099), CGPoint(x: 0.0, y: 127.90771577144413), CGPoint(x: 0.0, y: 114.70255495811253)),
      .addLineToPoint(CGPoint(x: 0.0, y: 48.91728)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 32.09228422855587), CGPoint(x: 0.0, y: 25.48970382189007), CGPoint(x: 2.247341635410475, y: 18.38230928492978)),
      .addLineToPoint(CGPoint(x: 2.2473416354104763, y: 18.38230928492978)),
      .addCurveToPoint(CGPoint(x: 6.264326490243543, y: 7.34573410198472), CGPoint(x: 16.75512200605059, y: 1.2212453270876722e-15), CGPoint(x: 28.499999999999996, y: -8.881784197001252e-16)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements, absoluteTolerance: 1.5)
  }

  func test_verticalRect_shape3a() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, cornerRadius: 64)

    // printPathElements(path.cgPath.pathElements())

    #if canImport(AppKit)
    expect(path.cgPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 46.568544394391544, y: 1.9624969065324802e-07), CGPoint(x: 60.0, y: 13.431457960604744), CGPoint(x: 60.0, y: 30.0)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 30.000002354996287), CGPoint(x: 60.0, y: 30.000002354996287), CGPoint(x: 60.0, y: 30.00000470999257)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 30.0), CGPoint(x: 60.0, y: 30.0), CGPoint(x: 60.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 60.0, y: 80.0)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 130.0000023549963), CGPoint(x: 60.0, y: 130.0000023549963), CGPoint(x: 60.0, y: 130.0000023549963)),
      .addLineToPoint(CGPoint(x: 60.0, y: 130.0000023549963)),
      .addCurveToPoint(CGPoint(x: 60.0, y: 146.56854439439155), CGPoint(x: 46.568544394391544, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0), CGPoint(x: 30.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 160.0)),
      .addCurveToPoint(CGPoint(x: 13.431455605608457, y: 160.0), CGPoint(x: -7.849987626129921e-07, y: 146.56854439439155), CGPoint(x: 0.0, y: 130.0000023549963)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 130.0000023549963), CGPoint(x: 0.0, y: 129.9999976450037), CGPoint(x: 0.0, y: 129.9999976450037)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 130.0000023549963), CGPoint(x: 0.0, y: 130.0000023549963), CGPoint(x: 0.0, y: 130.0000023549963)),
      .addLineToPoint(CGPoint(x: 0.0, y: 80.0)),
      .addCurveToPoint(CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0), CGPoint(x: 0.0, y: 30.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 29.999997645003706)),
      .addCurveToPoint(CGPoint(x: 1.3737478345727363e-06, y: 13.4314567831066), CGPoint(x: 13.431457960604744, y: -1.9624969065324802e-07), CGPoint(x: 30.0, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0), CGPoint(x: 30.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 30.0, y: 0.0)),
      .closeSubpath,
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]
    #endif

    #if canImport(UIKit)
    expectPathElementsEqual(path.cgPath.pathElements(), [
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
    ])
    #endif
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
  //   var expectedElements: [CGPathElement.Element] = [
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
  //
  //   #if canImport(AppKit)
  //   expectedElements += [
  //     .closeSubpath,
  //     .moveToPoint(CGPoint(x: 15.28665, y: 0.0)),
  //   ]
  //   #endif
  //
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

  // MARK: - Oval Corner Radius

  func test_horizontalRect_shape1_noRoundingCorners() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [], cornerRadii: CGSize(width: 20, height: 20))

    // printPathElements(path.cgPath.pathElements())

    var expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    #endif

    #if canImport(UIKit)
    expectedElements += [
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  // func test_horizontalRect_shape2a_byRoundingCorners() {
  //   let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
  //   let path = BezierPath(roundedRect: rect, byRoundingCorners: [], cornerRadii: CGSize(width: 42, height: 42))
  //
  //   // printPathElements(path.cgPath.pathElements())
  //
  //   var expectedElements: [CGPathElement.Element] = [
  //     .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
  //     .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
  //     .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
  //     .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
  //     .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
  //   ]
  //
  //   #if canImport(AppKit)
  //   expectedElements += [
  //     .closeSubpath,
  //     .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
  //   ]
  //   #endif
  //
  //   #if canImport(UIKit)
  //   expectedElements += [
  //     .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
  //   ]
  //   #endif
  //
  //   expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  // }

  func test_horizontalRect_shape3b_noRoundingCorners() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [], cornerRadii: CGSize(width: 64, height: 64))

    // printPathElements(path.cgPath.pathElements())

    var expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 160.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 100.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    #endif

    #if canImport(UIKit)
    expectedElements += [
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_verticalRect_shape3a_noRoundingCorners() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [], cornerRadii: CGSize(width: 64, height: 64))

    printPathElements(path.cgPath.pathElements())

    var expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 60.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 60.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 160.0)),
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    #endif

    #if canImport(UIKit)
    expectedElements += [
      .addLineToPoint(CGPoint(x: 0.0, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }
}

// MARK: - Helper

/// Compare two arrays of path elements with a tolerance.
private func expectPathElementsEqual(_ actual: [CGPathElement.Element], _ expected: [CGPathElement.Element], absoluteTolerance: CGFloat = 1e-13, file: StaticString = #file, line: UInt = #line) {
  expect(actual.count, file: file, line: line) == expected.count

  for (index, (actualElement, expectedElement)) in zip(actual, expected).enumerated() {
    switch (actualElement, expectedElement) {
    case (.moveToPoint(let actualPoint), .moveToPoint(let expectedPoint)):
      expect(actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance), file: file, line: line) == true
    case (.addLineToPoint(let actualPoint), .addLineToPoint(let expectedPoint)):
      expect(actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance), file: file, line: line) == true
    case (.addQuadCurveToPoint(let actualControl, let actualPoint), .addQuadCurveToPoint(let expectedControl, let expectedPoint)):
      expect(actualControl.isApproximatelyEqual(to: expectedControl, absoluteTolerance: absoluteTolerance), file: file, line: line) == true
      expect(actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance), file: file, line: line) == true
    case (.addCurveToPoint(let actualControl1, let actualControl2, let actualPoint), .addCurveToPoint(let expectedControl1, let expectedControl2, let expectedPoint)):
      expect(actualControl1.isApproximatelyEqual(to: expectedControl1, absoluteTolerance: absoluteTolerance), file: file, line: line) == true
      expect(actualControl2.isApproximatelyEqual(to: expectedControl2, absoluteTolerance: absoluteTolerance), file: file, line: line) == true
      expect(actualPoint.isApproximatelyEqual(to: expectedPoint, absoluteTolerance: absoluteTolerance), file: file, line: line) == true
    case (.closeSubpath, .closeSubpath):
      continue
    default:
      fail("mismatched element, index: \(index), \(actualElement) != \(expectedElement)", file: file, line: line)
    }
  }
}

/// A helper function to print the path elements for debugging.
private func printPathElements(_ elements: [CGPathElement.Element]) {
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
