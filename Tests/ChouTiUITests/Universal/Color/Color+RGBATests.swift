//
//  Color+RGBATests.swift
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

class Color_RGBATests: XCTestCase {

  // MARK: - Init

  func test_invalidAlpha() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Invalid alpha component"
      expect(metadata["alpha"]) == "-1.0"
    }

    let color = Color.rgba(r: 0, g: 0, b: 0, a: -1, colorSpace: .sRGB)
    expect(color.alpha()) == 0

    Assert.resetTestAssertionFailureHandler()
  }

  func testInit_rgb_sRGB_sRGB() throws {
    var color = Color.rgb(r: 0, g: 0, b: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 1, g: 0, b: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 0, g: 1, b: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 0, g: 0, b: 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 1, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 1, g: 1, b: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 1, g: 0, b: 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 1, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 0, g: 1, b: 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 1, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 0.2, g: 0.2, b: 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.2, 0.2, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 0.2, g: 0.3, b: 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.3, 0.2, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 0.5, g: 0.5, b: 0.5, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.5, 0.5, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 0.5, g: 0.7, b: 0.9, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.7, 0.9, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(r: 1, g: 1, b: 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 1, 1)
    expect(color.alpha()) == 1
  }

  func testInit_rgb2_sRGB_sRGB() throws {
    var color = Color.rgb(0, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(1, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0, 0, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 1, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(1, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(1, 0, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 1, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0, 1, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 1, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0.2, 0.2, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.2, 0.2, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0.2, 0.3, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.3, 0.2, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0.5, 0.5, 0.5, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.5, 0.5, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0.5, 0.7, 0.9, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.7, 0.9, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(1, 1, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 1, 1)
    expect(color.alpha()) == 1
  }

  func testInit_rgba_sRGB_sRGB() throws {
    var color = Color.rgba(r: 0, g: 0, b: 0, a: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(r: 1, g: 0, b: 0, a: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(r: 0, g: 1, b: 0, a: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(r: 0, g: 0, b: 1, a: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 1, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(r: 1, g: 1, b: 0, a: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(r: 1, g: 0, b: 1, a: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 1, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(r: 0, g: 1, b: 1, a: 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 1, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(r: 0.2, g: 0.2, b: 0.2, a: 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.2, 0.2, 0.2)
    expect(color.alpha()) == 0.2

    color = Color.rgba(r: 0.2, g: 0.3, b: 0.2, a: 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.3, 0.2, 0.2)
    expect(color.alpha()) == 0.2

    color = Color.rgba(r: 0.5, g: 0.5, b: 0.5, a: 0.5, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.5, 0.5, 0.5)
    expect(color.alpha()) == 0.5

    color = Color.rgba(r: 0.5, g: 0.7, b: 0.9, a: 0.9, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.7, 0.9, 0.9)
    expect(color.alpha()) == 0.9

    color = Color.rgba(r: 1, g: 1, b: 1, a: 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 1, 1)
    expect(color.alpha()) == 1
  }

  func testInit_rgba2_sRGB_sRGB() throws {
    var color = Color.rgba(0, 0, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(1, 0, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(0, 1, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(0, 0, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 1, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(1, 1, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(1, 0, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 0, 1, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(0, 1, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 1, 1, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(0.2, 0.2, 0.2, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.2, 0.2, 0.2)
    expect(color.alpha()) == 0.2

    color = Color.rgba(0.2, 0.3, 0.2, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.2, 0.3, 0.2, 0.2)
    expect(color.alpha()) == 0.2

    color = Color.rgba(0.5, 0.5, 0.5, 0.5, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.5, 0.5, 0.5)
    expect(color.alpha()) == 0.5

    color = Color.rgba(0.5, 0.7, 0.9, 0.9, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0.5, 0.7, 0.9, 0.9)
    expect(color.alpha()) == 0.9

    color = Color.rgba(1, 1, 1, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(1, 1, 1, 1)
    expect(color.alpha()) == 1
  }

  func testInit_rgb2_sRGB_displayP3() throws {
    var color = Color.rgb(0, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)) == RGBA(0, 0, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(1, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9174699187278748, green: 0.2003689408302307, blue: 0.13852068781852722, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.45842450857162476, green: 0.9852612614631653, blue: 0.29824867844581604, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0, 0, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.0002182410389650613, green: 0.0, blue: 0.9596025347709656, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(1, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9999926686286926, green: 1.0, blue: 0.33084142208099365, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(1, 0, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9174782633781433, green: 0.20031103491783142, blue: 0.9674867987632751, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0, 1, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.45844483375549316, green: 0.9852531552314758, blue: 0.9924567341804504, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0.2, 0.2, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.19999998807907104, green: 0.19999998807907104, blue: 0.19999998807907104, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0.2, 0.3, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.22157880663871765, green: 0.29729434847831726, blue: 0.20909452438354492, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0.5, 0.5, 0.5, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)) == RGBA(0.5, 0.5, 0.5, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(0.5, 0.7, 0.9, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.5425793528556824, green: 0.6945104598999023, blue: 0.8824123740196228, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(1, 1, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9999999403953552, green: 1.0, blue: 1.0, alpha: 1.0))) == true
    expect(color.alpha()) == 1
  }

  func testInit_rgba2_sRGB_displayP3() throws {
    var color = Color.rgba(0, 0, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)) == RGBA(0, 0, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(1, 0, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9174699187278748, green: 0.2003689408302307, blue: 0.13852068781852722, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0, 1, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.45842450857162476, green: 0.9852612614631653, blue: 0.29824867844581604, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0, 0, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.0002182410389650613, green: 0.0, blue: 0.9596025347709656, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(1, 1, 0, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9999926686286926, green: 1.0, blue: 0.33084142208099365, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(1, 0, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9174782633781433, green: 0.20031103491783142, blue: 0.9674867987632751, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0, 1, 1, 0, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.45844483375549316, green: 0.9852531552314758, blue: 0.9924567341804504, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0.2, 0.2, 0.2, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.19999998807907104, green: 0.19999998807907104, blue: 0.19999998807907104, alpha: 0.2))) == true
    expect(color.alpha()) == 0.2

    color = Color.rgba(0.2, 0.3, 0.2, 0.2, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.22157880663871765, green: 0.29729434847831726, blue: 0.20909452438354492, alpha: 0.2))) == true
    expect(color.alpha()) == 0.2

    color = Color.rgba(0.5, 0.5, 0.5, 0.5, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)) == RGBA(0.5, 0.5, 0.5, 0.5)
    expect(color.alpha()) == 0.5

    color = Color.rgba(0.5, 0.7, 0.9, 0.9, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.5425793528556824, green: 0.6945104598999023, blue: 0.8824123740196228, alpha: 0.9))) == true
    expect(color.alpha()) == 0.9

    color = Color.rgba(1, 1, 1, 1, colorSpace: .sRGB)
    expect(color.rgba(colorSpace: .displayP3)?.isApproximatelyEqual(to: RGBA(red: 0.9999999403953552, green: 1.0, blue: 1.0, alpha: 1.0))) == true
    expect(color.alpha()) == 1
  }

  func testInit_rgb2_displayP3_sRGB() throws {
    var color = Color.rgb(0, 0, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 0, 1)
    expect(color.alpha()) == 1

    color = Color.rgb(1, 0, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 1.0930908918380737, green: -0.22684034705162048, blue: -0.15007957816123962, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0, 1, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: -0.5116420984268188, green: 1.0182716846466064, blue: -0.31062406301498413, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0, 0, 1, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: -0.0003518527664709836, green: 0.00027732315356843174, blue: 1.0420056581497192, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(1, 1, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 1.0000120401382446, green: 0.9999905228614807, blue: -0.3462020754814148, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(1, 0, 1, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 1.0930802822113037, green: -0.2267804741859436, blue: 1.0337947607040405, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0, 1, 1, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: -0.5116706490516663, green: 1.0182808637619019, blue: 1.0085779428482056, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0.2, 0.2, 0.2, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.19999998807907104, green: 0.19999998807907104, blue: 0.19999998807907104, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0.2, 0.3, 0.2, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.1683105230331421, green: 0.30338749289512634, blue: 0.1895776093006134, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0.5, 0.5, 0.5, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(0.5, 0.5, 0.5, 1))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(0.5, 0.7, 0.9, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.4384061396121979, green: 0.7068762183189392, blue: 0.9189073443412781, alpha: 1.0))) == true
    expect(color.alpha()) == 1

    color = Color.rgb(1, 1, 1, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.9999999403953552, green: 1.0000001192092896, blue: 1.0000001192092896, alpha: 1.0))) == true
    expect(color.alpha()) == 1
  }

  func testInit_rgba2_displayP3_sRGB() throws {
    var color = Color.rgba(0, 0, 0, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)) == RGBA(0, 0, 0, 0)
    expect(color.alpha()) == 0

    color = Color.rgba(1, 0, 0, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 1.0930908918380737, green: -0.22684034705162048, blue: -0.15007957816123962, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0, 1, 0, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: -0.5116420984268188, green: 1.0182716846466064, blue: -0.31062406301498413, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0, 0, 1, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: -0.0003518527664709836, green: 0.00027732315356843174, blue: 1.0420056581497192, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(1, 1, 0, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 1.0000120401382446, green: 0.9999905228614807, blue: -0.3462020754814148, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(1, 0, 1, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 1.0930802822113037, green: -0.2267804741859436, blue: 1.0337947607040405, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0, 1, 1, 0, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: -0.5116706490516663, green: 1.0182808637619019, blue: 1.0085779428482056, alpha: 0.0))) == true
    expect(color.alpha()) == 0

    color = Color.rgba(0.2, 0.2, 0.2, 0.2, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.19999998807907104, green: 0.19999998807907104, blue: 0.19999998807907104, alpha: 0.2))) == true
    expect(color.alpha()) == 0.2
    expect(color.opacity) == 0.2

    color = Color.rgba(0.2, 0.3, 0.2, 0.2, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.1683105230331421, green: 0.30338749289512634, blue: 0.1895776093006134, alpha: 0.2))) == true
    expect(color.alpha()) == 0.2
    expect(color.opacity) == 0.2

    color = Color.rgba(0.5, 0.5, 0.5, 0.5, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(0.5, 0.5, 0.5, 0.5))) == true
    expect(color.alpha()) == 0.5
    expect(color.opacity) == 0.5

    color = Color.rgba(0.5, 0.7, 0.9, 0.9, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.4384061396121979, green: 0.7068762183189392, blue: 0.9189073443412781, alpha: 0.9))) == true
    expect(color.alpha()) == 0.9
    expect(color.opacity) == 0.9

    color = Color.rgba(1, 1, 1, 1, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.9999999403953552, green: 1.0000001192092896, blue: 1.0000001192092896, alpha: 1.0))) == true
    expect(color.alpha()) == 1
    expect(color.opacity) == 1
  }

  func testRedGreenBlue() {
    var color = Color.rgba(0.5, 0.7, 0.9, 0.9, colorSpace: .displayP3)
    expect(color.rgba(colorSpace: .sRGB)?.isApproximatelyEqual(to: RGBA(red: 0.4384061396121979, green: 0.7068762183189392, blue: 0.9189073443412781, alpha: 0.9))) == true
    expect(color.alpha()) == 0.9

    expect(color.red()) == 0.4384061396121979
    expect(color.green()) == 0.7068762183189392
    expect(color.blue()) == 0.9189073443412781

    expect(color.red(colorSpace: .sRGB)) == 0.4384061396121979
    expect(color.green(colorSpace: .sRGB)) == 0.7068762183189392
    expect(color.blue(colorSpace: .sRGB)) == 0.9189073443412781

    expect(color.red(colorSpace: .sRGB)) == 0.4384061396121979
    expect(color.green(colorSpace: .sRGB)) == 0.7068762183189392
    expect(color.blue(colorSpace: .sRGB)) == 0.9189073443412781

    // swiftlint:disable:next force_unwrapping
    expect(color.red(colorSpace: .displayP3)!).to(beApproximatelyEqual(to: 0.5, within: 1e-7))
    // swiftlint:disable:next force_unwrapping
    expect(color.green(colorSpace: .displayP3)!).to(beApproximatelyEqual(to: 0.7, within: 1e-6))
    // swiftlint:disable:next force_unwrapping
    expect(color.blue(colorSpace: .displayP3)!).to(beApproximatelyEqual(to: 0.9, within: 1e-7))

    color = Color.rgba(0.5, 0.7, 0.9, 0.9, colorSpace: .sRGB)
    expect(color.red(colorSpace: .sRGB)) == 0.5
    expect(color.green(colorSpace: .sRGB)) == 0.7
    expect(color.blue(colorSpace: .sRGB)) == 0.9

    expect(color.red(colorSpace: .displayP3)) == 0.5425793528556824
    expect(color.green(colorSpace: .displayP3)) == 0.6945104598999023
    expect(color.blue(colorSpace: .displayP3)) == 0.8824123740196228
  }

  // MARK: - Get RGBA

  func testStandardColor_defaultColorSpace_red() {
    let color = Color.red
    guard let rgba = color.rgba() else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 1
    expect(rgba.green) == 0
    expect(rgba.blue) == 0
    expect(rgba.alpha) == 1
  }

  func testStandardColor_sRGB_red() {
    let color = Color.red
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 1
    expect(rgba.green) == 0
    expect(rgba.blue) == 0
    expect(rgba.alpha) == 1
  }

  func testStandardColor_sRGB_green() {
    let color = Color.green
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0
    expect(rgba.green) == 1
    expect(rgba.blue) == 0
    expect(rgba.alpha) == 1
  }

  func testStandardColor_sRGB_black() {
    let color = Color.black
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0
    expect(rgba.green) == 0
    expect(rgba.blue) == 0
    expect(rgba.alpha) == 1
  }

  func testStandardColor_sRGB_white() {
    /// on Mac, `Color.white` creates a displayP3 white
    /// on iOS, `Color.white` creates a dynamic white? it returns both 1 for sRBG and displsyP3
    #if os(macOS)
    let color = Color.whiteRGB
    #else
    let color = Color.white
    #endif
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 1
    expect(rgba.green) == 1
    expect(rgba.blue) == 1
    expect(rgba.alpha) == 1
  }

  func testStandardColor_sRGB_gray() {
    let color = Color.gray
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0.5
    expect(rgba.green) == 0.5
    expect(rgba.blue) == 0.5
    expect(rgba.alpha) == 1
  }

  func testStandardColor_sRGB_clear() {
    let color = Color.clear
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0
    expect(rgba.green) == 0
    expect(rgba.blue) == 0
    expect(rgba.alpha) == 0
  }

  func testStandardColor_sRGB_brown() {
    let color = Color.brown
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0.6
    expect(rgba.green) == 0.4
    expect(rgba.blue) == 0.2
    expect(rgba.alpha) == 1
  }

  func testPatternImageColor_sRGB() {
    let color = Color(patternImage: Image.imageWithColor(.red))

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Failed to get rgba components"
      expect(metadata["color"]) == "\(color)"
    }

    expect(color.rgba(colorSpace: .sRGB)) == nil

    Assert.resetTestAssertionFailureHandler()
  }

  func testGrayScaleColor_sRGB() {
    let color = Color.white(0.5)
    guard let rgba = color.rgba(colorSpace: .sRGB) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0.5
    expect(rgba.green) == 0.5
    expect(rgba.blue) == 0.5
    expect(rgba.alpha) == 1
  }

  func testStandardColor_displayP3_red() {
    let color = Color.red
    guard let rgba = color.rgba(colorSpace: .displayP3) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red).to(beApproximatelyEqual(to: 0.9174699187278748, within: 1e-6))
    expect(rgba.green).to(beApproximatelyEqual(to: 0.2003689408302307, within: 1e-6))
    expect(rgba.blue).to(beApproximatelyEqual(to: 0.13852068781852722, within: 1e-6))
    expect(rgba.alpha) == 1
  }

  func testStandardColor_displayP3_green() {
    let color = Color.green
    guard let rgba = color.rgba(colorSpace: .displayP3) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red).to(beApproximatelyEqual(to: 0.45842450857162476, within: 1e-6))
    expect(rgba.green).to(beApproximatelyEqual(to: 0.9852612614631653, within: 1e-6))
    expect(rgba.blue).to(beApproximatelyEqual(to: 0.29824867844581604, within: 1e-6))
    expect(rgba.alpha) == 1
  }

  func testStandardColor_displayP3_black() {
    let color = Color.black
    guard let rgba = color.rgba(colorSpace: .displayP3) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0
    expect(rgba.green) == 0
    expect(rgba.blue) == 0
    expect(rgba.alpha) == 1
  }

  func testStandardColor_displayP3_white() {
    let color = Color.white
    guard let rgba = color.rgba(colorSpace: .displayP3) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 1
    expect(rgba.green) == 1
    expect(rgba.blue) == 1
    expect(rgba.alpha) == 1
  }

  func testStandardColor_displayP3_clear() {
    let color = Color.clear
    guard let rgba = color.rgba(colorSpace: .displayP3) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0
    expect(rgba.green) == 0
    expect(rgba.blue) == 0
    expect(rgba.alpha) == 0
  }

  func testStandardColor_displayP3_brown() {
    let color = Color.brown
    guard let rgba = color.rgba(colorSpace: .displayP3) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red).to(beApproximatelyEqual(to: 0.5708470940589905, within: 1e-6))
    expect(rgba.green).to(beApproximatelyEqual(to: 0.4086872935295105, within: 1e-6))
    expect(rgba.blue).to(beApproximatelyEqual(to: 0.23532789945602417, within: 1e-6))
    expect(rgba.alpha) == 1
  }

  func testPatternImageColor_displayP3() {
    let color = Color(patternImage: .imageWithColor(.red))

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Failed to convert color in displayP3"
      expect(metadata["color"]) == "\(color)"
    }

    expect(color.rgba(colorSpace: .displayP3)) == nil

    Assert.resetTestAssertionFailureHandler()
  }

  func testGrayScaleColor_displayP3() {
    let color = Color.white(0.5)
    guard let rgba = color.rgba(colorSpace: .displayP3) else {
      fail("Failed to get RGBA")
      return
    }
    expect(rgba.red) == 0.5
    expect(rgba.green) == 0.5
    expect(rgba.blue) == 0.5
    expect(rgba.alpha) == 1
  }

  func testColorAlpha() {
    let color_sRGB = Color.rgba(r: 0.5, g: 0.5, b: 0.5, a: 0.5, colorSpace: .sRGB)
    expect(color_sRGB.alpha()) == 0.5

    let color_displayP3 = Color.rgba(r: 0.5, g: 0.5, b: 0.5, a: 0.5, colorSpace: .displayP3)
    expect(color_displayP3.alpha()) == 0.5
  }

  // MARK: - Lerp

  func testLerpAtStart() {
    let startColor = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let endColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let lerpColor = startColor.lerp(to: endColor, t: 0.0)
    expect(lerpColor) == startColor
  }

  func testLerpAtEnd() {
    let startColor = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let endColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let lerpColor = startColor.lerp(to: endColor, t: 1.0)
    expect(lerpColor) == endColor
  }

  func testLerpAtMiddle() {
    let startColor = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let endColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let expectedColor = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    let lerpColor = startColor.lerp(to: endColor, t: 0.5)
    expect(lerpColor) == expectedColor
  }

  func testLerp_displayP3() throws {
    let startColor = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0, colorSpace: .displayP3)
    let endColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0, colorSpace: .displayP3)
    let lerpColor = startColor.lerp(to: endColor, t: 0.1, colorSpace: .displayP3)
    let expectedColor = Color(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0, colorSpace: .displayP3)

    let lerpColorRGBA = try lerpColor.rgba().unwrap()
    let expectedColorRGBA = try expectedColor.rgba().unwrap()

    expect(lerpColorRGBA.red).to(beApproximatelyEqual(to: expectedColorRGBA.red, within: 1e-6))
    expect(lerpColorRGBA.green).to(beApproximatelyEqual(to: expectedColorRGBA.green, within: 1e-6))
    expect(lerpColorRGBA.blue).to(beApproximatelyEqual(to: expectedColorRGBA.blue, within: 1e-6))
    expect(lerpColorRGBA.alpha).to(beApproximatelyEqual(to: expectedColorRGBA.alpha, within: 1e-6))
  }

  func testLerpWithOutOfBoundsProgress() {
    let startColor = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let endColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "t should be within 0...1"
      expect(metadata["t"]) == "-1.0"
    }

    let lerpColor1 = startColor.lerp(to: endColor, t: -1.0)
    expect(lerpColor1) == startColor

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "t should be within 0...1"
      expect(metadata["t"]) == "2.0"
    }

    let lerpColor2 = startColor.lerp(to: endColor, t: 2.0)
    expect(lerpColor2) == endColor

    Assert.resetTestAssertionFailureHandler()
  }

  func testLerpWithSameColors() {
    let startColor = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    let lerpColor = startColor.lerp(to: startColor, t: 0.5)
    expect(lerpColor) == startColor
  }

  func test_lerp_invalidColor() {
    let startColor = Color.red
    let endColor = Color(patternImage: .imageWithColor(.red))

    var assertIndex = 0
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      if assertIndex == 0 {
        expect(message) == "Failed to get rgba components"
        expect(metadata["color"]) == "\(endColor)"
      } else if assertIndex == 1 {
        expect(message) == "Failed to get rgba components"
        expect(metadata["from"]) == "\(startColor)"
        expect(metadata["to"]) == "\(endColor)"
      } else {
        fail("Unexpected assertion failure")
      }

      assertIndex += 1
    }

    let lerpColor = startColor.lerp(to: endColor, t: 0.5)
    expect(lerpColor) == startColor

    Assert.resetTestAssertionFailureHandler()
  }
}

private extension RGBA {

  func isApproximatelyEqual(to other: RGBA, tolerance: Double = 1e-6) -> Bool {
    return abs(red - other.red) < tolerance &&
      abs(green - other.green) < tolerance &&
      abs(blue - other.blue) < tolerance &&
      abs(alpha - other.alpha) < tolerance
  }
}
