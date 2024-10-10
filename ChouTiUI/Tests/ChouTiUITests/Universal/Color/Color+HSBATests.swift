//
//  Color+HSBATests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/11/21.
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

class Color_HSBATests: XCTestCase {

  func testInit() {
    var color = Color.hsba(h: 0.5, s: 0.5, b: 0.5, a: 0.5)
    expect(color.red()) == 0.25
    expect(color.green()) == 0.5
    expect(color.blue()) == 0.5
    expect(color.alpha()) == 0.5

    color = Color.hsba(0.5, 0.5, 0.5, 0.5)
    expect(color.red()) == 0.25
    expect(color.green()) == 0.5
    expect(color.blue()) == 0.5
    expect(color.alpha()) == 0.5

    color = Color.hsb(0.5, 0.5, 0.5)
    expect(color.red()) == 0.25
    expect(color.green()) == 0.5
    expect(color.blue()) == 0.5
    expect(color.alpha()) == 1

    // test default parameters
    color = Color.hsba(h: 0.5)
    expect(color.red()) == 0
    expect(color.green()) == 0
    expect(color.blue()) == 0
    expect(color.alpha()) == 1

    color = Color.hsba(s: 0.5)
    expect(color.red()) == 0
    expect(color.green()) == 0
    expect(color.blue()) == 0
    expect(color.alpha()) == 1

    // hsb Int
    color = Color.hsba(h: 120 / 360, s: 80 / 100, b: 50 / 100, a: 70 / 100)
    expect(color.red()) == 0.09999999999999998
    expect(color.green()) == 0.5
    expect(color.blue()) == 0.09999999999999998
    expect(color.alpha()) == 0.7

    color = Color.hsba(120 / 360, 80 / 100, 50 / 100, 70 / 100)
    expect(color.red()) == 0.09999999999999998
    expect(color.green()) == 0.5
    expect(color.blue()) == 0.09999999999999998
    expect(color.alpha()) == 0.7

    color = Color.hsb(120 / 360, 80 / 100, 70 / 100)
    expect(color.red()) == 0.13999999999999996
    expect(color.green()) == 0.7
    expect(color.blue()) == 0.13999999999999996
    expect(color.alpha()) == 1

    // test default parameters
    color = Color.hsba(h: 120 / 360)
    expect(color.red()) == 0
    expect(color.green()) == 0
    expect(color.blue()) == 0
    expect(color.alpha()) == 1

    color = Color.hsba(s: 80 / 100)
    expect(color.red()) == 0
    expect(color.green()) == 0
    expect(color.blue()) == 0
    expect(color.alpha()) == 1

    color = Color.hsb(s: 80 / 100)
    expect(color.red()) == 0
    expect(color.green()) == 0
    expect(color.blue()) == 0
    expect(color.alpha()) == 1

    color = Color(h: 0, s: 1, b: 0.5, a: 0.8)
    expect(color.red()) == 0.5
    expect(color.green()) == 0
    expect(color.blue()) == 0
    expect(color.alpha()) == 0.8
  }

  #if os(macOS)
  func testNSColor_initWith_colorSpace() throws {
    let color = Color(colorSpace: .displayP3, h: 1, s: 1, b: 1, a: 1)
    expect(try color.rgba().unwrap().red) == 1.0930908918380737
  }
  #endif

  func testsRGBColor_Red() throws {
    let color = Color.red
    expect(color.hue()) == 0
    expect(color.saturation()) == 1
    expect(color.brightness()) == 1
    expect(color.alpha()) == 1

    let (h, s, b, a) = try color.hsba().unwrap().unwrap()
    expect(h) == 0
    expect(s) == 1
    expect(b) == 1
    expect(a) == 1
  }

  func testsRGBColor_Green() throws {
    let color = Color.green
    expect(color.hue()) == 0.3333333333333333
    expect(color.saturation()) == 1
    expect(color.brightness()) == 1
    expect(color.alpha()) == 1

    let (h, s, b, a) = try color.hsba().unwrap().unwrap()
    expect(h) == 0.3333333333333333
    expect(s) == 1
    expect(b) == 1
    expect(a) == 1
  }

  func testsRGBColor_Blue() throws {
    let color = Color.blue
    expect(color.hue()) == 0.6666666666666666
    expect(color.saturation()) == 1
    expect(color.brightness()) == 1
    expect(color.alpha()) == 1

    let (h, s, b, a) = try color.hsba().unwrap().unwrap()
    expect(h) == 0.6666666666666666
    expect(s) == 1
    expect(b) == 1
    expect(a) == 1
  }

  func testsRGBColor_Purple() throws {
    let color = Color.purple
    expect(color.hue()) == 0.8333333333333334
    expect(color.saturation()) == 1
    expect(color.brightness()) == 0.5
    expect(color.alpha()) == 1

    let (h, s, b, a) = try color.hsba().unwrap().unwrap()
    expect(h) == 0.8333333333333334
    expect(s) == 1
    expect(b) == 0.5
    expect(a) == 1
  }

  func testGenericGamma22GrayColor() throws {
    let color = Color.clear
    expect(color.hue()) == 0
    expect(color.saturation()) == 0
    expect(color.brightness()) == 0
    expect(color.alpha()) == 0

    let (h, s, b, a) = try color.hsba().unwrap().unwrap()
    expect(h) == 0
    expect(s) == 0
    expect(b) == 0
    expect(a) == 0
  }

  func test_displayP3Color() throws {
    let color = Color.rgb(r: 1, g: 0, b: 0, colorSpace: .displayP3)
    let hsba = try color.hsba().unwrap().unwrap()
    expect(hsba.hue) == 0.9903074788255699
    expect(hsba.saturation) == 1.207521944190917
    expect(hsba.brightness) == 1.0930908918380737
    expect(hsba.alpha) == 1

    expect(color.hue()) == 0.9903074788255699
    expect(color.saturation()) == 1.207521944190917
    expect(color.brightness()) == 1.0930908918380737
    expect(color.alpha()) == 1
  }

  func test_setHue() throws {
    var color = Color.red
    color = try color.hue(0.5).unwrap()
    expect(color.hue()) == 0.5
    expect(color.saturation()) == 1
    expect(color.brightness()) == 1
    expect(color.alpha()) == 1

    color = try color.hue(1).unwrap()
    expect(color.hue()) == 0
  }

  func test_setSaturation() throws {
    var color = Color.red
    color = try color.saturation(0.5).unwrap()
    expect(color.hue()) == 0
    expect(color.saturation()) == 0.5
    expect(color.brightness()) == 1
    expect(color.alpha()) == 1

    color = try color.saturation(1).unwrap()
    expect(color.saturation()) == 1
  }

  func test_setBrightness() throws {
    var color = Color.red
    color = try color.brightness(0.5).unwrap()
    expect(color.hue()) == 0
    expect(color.saturation()) == 1
    expect(color.brightness()) == 0.5
    expect(color.alpha()) == 1

    color = try color.brightness(1).unwrap()
    expect(color.brightness()) == 1
  }

  func test_patternColor() throws {
    let color = Color(patternImage: .imageWithColor(.red))

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Failed to get hsba components"
      expect(metadata["color"]) == "\(color)"
    }

    expect(color.hsba()) == nil
    expect(color.hue()) == nil
    expect(color.saturation()) == nil
    expect(color.brightness()) == nil

    expect(color.hue(0.5)) == nil
    expect(color.saturation(0.5)) == nil
    expect(color.brightness(0.5)) == nil
    expect(color.darker()) == nil
    expect(color.lighter()) == nil

    Assert.resetTestAssertionFailureHandler()
  }

  // MARK: - Brightness adjustment

  func testLighter() throws {
    expect(try Color.red.lighter(by: 0)?.brightness().unwrap()) == 1
    expect(try Color.red.lighter(by: 0.5)?.brightness().unwrap()) == 1
    expect(try Color.red.lighter(by: 1)?.brightness().unwrap()) == 1

    expect(try Color.red.brightness(0.6)?.lighter(by: 0)?.brightness().unwrap()) == 0.6
    expect(try Color.red.brightness(0.6)?.lighter(by: 0.5)?.brightness().unwrap()) == 0.8
    expect(try Color.red.brightness(0.6)?.lighter(by: 1)?.brightness().unwrap()) == 1

    // invalid percentage
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "1.1"
      }

      _ = Color.red.lighter(by: 1.1)

      Assert.resetTestAssertionFailureHandler()

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "-0.1"
      }

      _ = Color.red.lighter(by: -0.1)

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func testDarker() {
    expect(try Color.red.darker(by: 0)?.brightness().unwrap()) == 1
    expect(try Color.red.darker(by: 0.5)?.brightness().unwrap()) == 0.5
    expect(try Color.red.darker(by: 1)?.brightness().unwrap()) == 0

    expect(try Color.red.brightness(0.6)?.darker(by: 0)?.brightness().unwrap()) == 0.6
    expect(try Color.red.brightness(0.6)?.darker(by: 0.5)?.brightness().unwrap()) == 0.3
    expect(try Color.red.brightness(0.6)?.darker(by: 1)?.brightness().unwrap()) == 0

    // invalid percentage
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "1.1"
      }

      _ = Color.red.darker(by: 1.1)

      Assert.resetTestAssertionFailureHandler()

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "-0.1"
      }

      _ = Color.red.darker(by: -0.1)

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func testAdjustingBrightness() {
    expect(try Color.red.brightness(0.6)?.adjustingBrightness(percentage: 1)?.brightness().unwrap()) == 1
    expect(try Color.red.brightness(0.6)?.adjustingBrightness(percentage: 0.5)?.brightness().unwrap()) == 0.8
    expect(try Color.red.brightness(0.6)?.adjustingBrightness(percentage: 0)?.brightness().unwrap()) == 0.6
    expect(try Color.red.brightness(0.6)?.adjustingBrightness(percentage: -0.5)?.brightness().unwrap()) == 0.3
    expect(try Color.red.brightness(0.6)?.adjustingBrightness(percentage: -1)?.brightness().unwrap()) == 0

    // invalid percentage
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "brightness percentage must be in the range of `-1` to `1`"
        expect(metadata["percentage"]) == "1.1"
      }

      _ = Color.red.brightness(0.6)?.adjustingBrightness(percentage: 1.1)

      Assert.resetTestAssertionFailureHandler()

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "brightness percentage must be in the range of `-1` to `1`"
        expect(metadata["percentage"]) == "-0.1"
      }

      _ = Color.red.brightness(0.6)?.adjustingBrightness(percentage: -0.1)

      Assert.resetTestAssertionFailureHandler()
    }
  }
}
