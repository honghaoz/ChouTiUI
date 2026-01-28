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

  func test_perceivedBrightness() throws {
    // rgb
    do {
      expect(Color.red.perceivedBrightness()).to(beApproximatelyEqual(to: 0.299, within: 0.01))
      expect(Color.green.perceivedBrightness()).to(beApproximatelyEqual(to: 0.587, within: 0.01))
      expect(Color.blue.perceivedBrightness()).to(beApproximatelyEqual(to: 0.114, within: 0.01))
    }

    // monochrome color
    do {
      expect(Color.white.perceivedBrightness()).to(beApproximatelyEqual(to: 1, within: 0.01))
      expect(Color.black.perceivedBrightness()).to(beApproximatelyEqual(to: 0, within: 0.01))
      try expect(CGColor(gray: 1, alpha: 1).asColor().unwrap().perceivedBrightness()).to(beApproximatelyEqual(to: 1, within: 1e-6))
      try expect(CGColor(gray: 0, alpha: 1).asColor().unwrap().perceivedBrightness()) == 0
    }

    // cmyk
    // https://www.w3schools.com/colors/colors_cmyk.asp
    do {
      let cmykWhite = try CGColor(colorSpace: CGColorSpaceCreateDeviceCMYK(), components: [0, 0, 0, 0, 1]).unwrap()
      try expect(cmykWhite.asColor().unwrap().perceivedBrightness()).to(beApproximatelyEqual(to: 0.99878945094347, within: 1e-7))

      let cmykBlack = try CGColor(colorSpace: CGColorSpaceCreateDeviceCMYK(), components: [0, 0, 0, 1, 1]).unwrap()
      try expect(cmykBlack.asColor().unwrap().perceivedBrightness()) == 0.10031022909283638

      // light green, cmyk(57%, 0%, 59%, 21%)
      let cmykLightGreen = try CGColor(colorSpace: CGColorSpaceCreateDeviceCMYK(), components: [0.57, 0, 0.59, 0.21, 1]).unwrap()
      try expect(cmykLightGreen.asColor().unwrap().perceivedBrightness()).to(beApproximatelyEqual(to: 0.5049150318205357, within: 1e-7))

      // dark green, cmyk(89%, 0%, 51%, 47%)
      let cmykDarkGreen = try CGColor(colorSpace: CGColorSpaceCreateDeviceCMYK(), components: [0.89, 0, 0.51, 0.47, 1]).unwrap()
      try expect(cmykDarkGreen.asColor().unwrap().perceivedBrightness()) == 0.2632510296702385
    }
  }

  func test_perceivedBrightness_invalidColor() {
    // invalid rgb color
    do {
      let invalidColor = Color(red: .nan, green: .nan, blue: .nan, alpha: 1)

      ChouTi.Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "color components contains NaN"
        expect(metadata["color"]) == "\(invalidColor)"
      }

      expect(invalidColor.perceivedBrightness()) == 0

      ChouTi.Assert.resetTestAssertionFailureHandler()
    }

    // patterned color
    do {
      ChouTi.Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "unsupported color space model"
        #if canImport(AppKit)
        expect(metadata["color"]?.hasPrefix("Pattern color: "), metadata["color"]) == true
        #else
        expect(metadata["color"]?.hasPrefix("<UIDynamicPatternColor"), metadata["color"]) == true
        #endif
        // "<CGColorSpace 0x6000014264c0> (kCGColorSpacePattern)"
        expect(metadata["colorSpace"]?.hasPrefix("<CGColorSpace ")) == true
        expect(metadata["colorSpace"]?.hasSuffix(" (kCGColorSpacePattern)")) == true
        expect(metadata["colorSpaceModel"]) == "CGColorSpaceModel(rawValue: 6)"
      }

      let patternedColor = Color(patternImage: Image.imageWithColor(.red))
      expect(patternedColor.perceivedBrightness()) == 0

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

private extension CGColor {

  func asColor() -> Color? {
    return Color(cgColor: self)
  }
}
