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

  func test_horizontalRect_shape1_zeroCornerRadius() {
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

  func test_horizontalRect_shape1_negativeCornerRadius() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: -10)

    printPathElements(path.cgPath.pathElements())

    var expectedElements: [CGPathElement.Element] = [
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

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: -15.28665, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
  }

  func test_horizontalRect_shape1() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, cornerRadius: 10)

    // printPathElements(path.cgPath.pathElements())

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

    #if canImport(AppKit)
    expectedElements += [
      .closeSubpath,
      .moveToPoint(CGPoint(x: 30.0, y: 0.0)),
    ]
    #endif

    expectPathElementsEqual(path.cgPath.pathElements(), expectedElements)
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

  // MARK: - Rounding Corners

  func test_horizontalRect_shape1_roundingCorners_none() {
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

  func test_horizontalRect_shape1_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: 20, height: 20))

    printPathElements(path.cgPath.pathElements())

    var expectedElements: [CGPathElement.Element] = [
      .moveToPoint(CGPoint(x: 0.0, y: 0.0)),
      .addLineToPoint(CGPoint(x: 129.4267, y: 0.0)),
      .addCurveToPoint(CGPoint(x: 138.23014084762943, y: 0.0), CGPoint(x: 142.63186111873995, y: 0.0), CGPoint(x: 147.37012414338017, y: 1.4982277569403202)),
      .addLineToPoint(CGPoint(x: 147.37012414338017, y: 1.4982277569403195)),
      .addCurveToPoint(CGPoint(x: 152.54352346748507, y: 3.3811911208874), CGPoint(x: 156.6188088791126, y: 7.4564765325149365), CGPoint(x: 158.5017722430597, y: 12.629875856619853)),
      .addCurveToPoint(CGPoint(x: 160.0, y: 17.368138881260045), CGPoint(x: 160.0, y: 21.76985915237058), CGPoint(x: 160.0, y: 30.573299694591647)),
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

  func test_horizontalRect_shape3b_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 160, height: 100)
    let roundingCorners: RectCorner = [.topRight]
    let cornerRadii = CGSize(width: 64, height: 64)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 3b only supports all or none rounding corners"
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
    let path = BezierPath(roundedRect: rect, byRoundingCorners: [], cornerRadii: CGSize(width: 64, height: 64))

    // printPathElements(path.cgPath.pathElements())

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

  func test_verticalRect_shape3a_roundingCorners_topRight() {
    let rect = CGRect(x: 0, y: 0, width: 60, height: 160)
    let roundingCorners: RectCorner = [.topRight]
    let cornerRadii = CGSize(width: 64, height: 64)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "shape 3a only supports all or none rounding corners"
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

  func test_generate_shape2b() {
    NSBezierPathRoundedRectGenerator.generateShape2bCode()
  }
  #endif
}

// MARK: - Helper

/// Compare two arrays of path elements with a tolerance.
private func expectPathElementsEqual(_ actual: [CGPathElement.Element], _ expected: [CGPathElement.Element], absoluteTolerance: CGFloat = 1e-13, file: StaticString = #file, line: UInt = #line) {
  expect(actual.count, "path elements count", file: file, line: line) == expected.count

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
        print("}\n")
      default:
        ChouTi.assertFailure("unexpected")
      }
    }

    print("close()")

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

    print("\nclose()")

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
      print("move(to: \(functionType.funcName)(rect, \(formattedNumber(x)), \(formattedNumber(y)), \(radiusName))")
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
