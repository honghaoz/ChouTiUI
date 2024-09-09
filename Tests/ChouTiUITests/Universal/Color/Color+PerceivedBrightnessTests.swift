//
//  Color+PerceivedBrightnessTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/7/23.
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
import ChouTiUI

class Color_PerceivedBrightnessTests: XCTestCase {

  func test_perceivedBrightness() {
    let white = Color.white
    let black = Color.black
    let red = Color.red
    let green = Color.green
    let blue = Color.blue

    expect(white.perceivedBrightness()).to(beApproximatelyEqual(to: 1, within: 0.01))
    expect(black.perceivedBrightness()).to(beApproximatelyEqual(to: 0, within: 0.01))
    expect(red.perceivedBrightness()).to(beApproximatelyEqual(to: 0.299, within: 0.01))
    expect(green.perceivedBrightness()).to(beApproximatelyEqual(to: 0.587, within: 0.01))
    expect(blue.perceivedBrightness()).to(beApproximatelyEqual(to: 0.114, within: 0.01))
  }

  func test_perceivedBrightness_invalidColor() {
    // invalid rgb color
    do {
      let invalidColor = Color(red: .nan, green: .nan, blue: .nan, alpha: 1)
      expect(invalidColor.perceivedBrightness().isNaN) == true
    }

    // not rgb color
    do {
      ChouTi.Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "pattern color space is not supported"
        #if canImport(AppKit)
        expect(metadata["color"]?.hasPrefix("Pattern color: "), metadata["color"]) == true
        #else
        expect(metadata["color"]?.hasPrefix("<UIDynamicPatternColor"), metadata["color"]) == true
        #endif
      }

      let invalidColor = Color(patternImage: Image.imageWithColor(.red))
      expect(invalidColor.perceivedBrightness()) == 0

      ChouTi.Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_isLight() {
    let white = Color.white
    let black = Color.black
    let darkGray = Color.darkGray
    let lightGray = Color.lightGray

    expect(white.isLight()) == true
    expect(black.isLight()) == false
    expect(darkGray.isLight()) == false
    expect(lightGray.isLight()) == true
  }

  func test_isDark() {
    let white = Color.white
    let black = Color.black
    let darkGray = Color.darkGray
    let lightGray = Color.lightGray

    expect(white.isDark()) == false
    expect(black.isDark()) == true
    expect(darkGray.isDark()) == true
    expect(lightGray.isDark()) == false
  }
}
