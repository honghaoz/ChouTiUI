//
//  CGFloat+UITests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/29/24.
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

import CoreGraphics

import ChouTiTest

import ChouTiUI

class CGFloatUITests: XCTestCase {

  func test_pixel() {
    expect(CGFloat.pixel) == 1 / Screen.mainScreenScale
  }

  func test_pixelTolerance() {
    expect(CGFloat.pixelTolerance) == CGFloat.pixel + 1e-12
  }

  func test_point() {
    expect(CGFloat.point) == 1
  }

  func test_halfPoint() {
    #if os(visionOS)
    expect(CGFloat.halfPoint) == 1 / Sizing.visionOS.scaleFactor
    #else
    if let mainScreen = Screen.mainScreen() {
      if mainScreen.is3x {
        expect(CGFloat.halfPoint) == mainScreen.pixelSize * 2
      } else if mainScreen.is2x {
        expect(CGFloat.halfPoint) == mainScreen.pixelSize
      } else {
        expect(CGFloat.halfPoint) == mainScreen.pixelSize
      }
    }
    #endif
  }
}
