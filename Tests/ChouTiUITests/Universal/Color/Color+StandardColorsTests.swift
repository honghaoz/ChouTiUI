//
//  Color+StandardColorsTests.swift
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

import ChouTiTest

import ChouTiUI

class Color_StandardColorsTests: XCTestCase {

  func testWhiteBlack() throws {
    var color = Color.white(0.7, alpha: 0.8)
    expect(try color.red().unwrap()).to(beApproximatelyEqual(to: 0.7, within: 1e-4))
    expect(try color.green().unwrap()).to(beApproximatelyEqual(to: 0.7, within: 1e-4))
    expect(try color.blue().unwrap()).to(beApproximatelyEqual(to: 0.7, within: 1e-4))
    expect(color.alpha()).to(beApproximatelyEqual(to: 0.8, within: 1e-4))

    color = Color(white: 0.7)
    expect(try color.red().unwrap()).to(beApproximatelyEqual(to: 0.7, within: 1e-4))
    expect(try color.green().unwrap()).to(beApproximatelyEqual(to: 0.7, within: 1e-4))
    expect(try color.blue().unwrap()).to(beApproximatelyEqual(to: 0.7, within: 1e-4))
    expect(color.alpha()) == 1

    color = Color.white()
    expect(try color.red().unwrap()).to(beApproximatelyEqual(to: 1.0, within: 1e-4))
    expect(try color.green().unwrap()).to(beApproximatelyEqual(to: 1.0, within: 1e-4))
    expect(try color.blue().unwrap()).to(beApproximatelyEqual(to: 1.0, within: 1e-4))
    expect(color.alpha()) == 1.0

    color = Color.black(0.7, alpha: 0.8)
    expect(try color.red().unwrap()).to(beApproximatelyEqual(to: 0.3, within: 1e-4))
    expect(try color.green().unwrap()).to(beApproximatelyEqual(to: 0.3, within: 1e-4))
    expect(try color.blue().unwrap()).to(beApproximatelyEqual(to: 0.3, within: 1e-4))
    expect(color.alpha()) == 0.8

    color = Color.black()
    expect(color.red()) == 0
    expect(color.green()) == 0
    expect(color.blue()) == 0
    expect(color.alpha()) == 1
  }

  func testWhiteRGB() throws {
    let color = Color.whiteRGB
    let rgbaSRGB = try color.rgba().unwrap()
    expect(rgbaSRGB.red) == 1
    expect(rgbaSRGB.green) == 1
    expect(rgbaSRGB.blue) == 1
    expect(rgbaSRGB.alpha) == 1

    let rgbaDisplayP3 = try color.rgba(colorSpace: .displayP3).unwrap()
    expect(rgbaDisplayP3.red) == 0.9999999403953552
    expect(rgbaDisplayP3.green) == 1
    expect(rgbaDisplayP3.blue) == 1
    expect(rgbaDisplayP3.alpha) == 1
  }

  func testGrayRGB() throws {
    let color = Color.grayRGB
    let rgbaSRGB = try color.rgba().unwrap()
    expect(rgbaSRGB.red) == 0.5
    expect(rgbaSRGB.green) == 0.5
    expect(rgbaSRGB.blue) == 0.5
    expect(rgbaSRGB.alpha) == 1

    let rgbaDisplayP3 = try color.rgba(colorSpace: .displayP3).unwrap()
    expect(rgbaDisplayP3.red) == 0.5
    expect(rgbaDisplayP3.green) == 0.5
    expect(rgbaDisplayP3.blue) == 0.5
    expect(rgbaDisplayP3.alpha) == 1
  }

  func testBlackRGB() throws {
    let color = Color.blackRGB
    let rgbaSRGB = try color.rgba().unwrap()
    expect(rgbaSRGB.red) == 0
    expect(rgbaSRGB.green) == 0
    expect(rgbaSRGB.blue) == 0
    expect(rgbaSRGB.alpha) == 1

    let rgbaDisplayP3 = try color.rgba(colorSpace: .displayP3).unwrap()
    expect(rgbaDisplayP3.red) == 0
    expect(rgbaDisplayP3.green) == 0
    expect(rgbaDisplayP3.blue) == 0
    expect(rgbaDisplayP3.alpha) == 1
  }

  func testWhiteRGBInitializer_default() throws {
    let color = Color.whiteRGB()

    let rgbaSRGB = try color.rgba().unwrap()
    expect(rgbaSRGB.red) == 1
    expect(rgbaSRGB.green) == 1
    expect(rgbaSRGB.blue) == 1
    expect(rgbaSRGB.alpha) == 1

    let rgbaDisplayP3 = try color.rgba(colorSpace: .displayP3).unwrap()
    expect(rgbaDisplayP3.red) == 0.9999999403953552
    expect(rgbaDisplayP3.green) == 1
    expect(rgbaDisplayP3.blue) == 1
    expect(rgbaDisplayP3.alpha) == 1
  }

  func testWhiteRGBInitializer_displayP3() throws {
    let color = Color.whiteRGB(colorSpace: .displayP3)

    let rgbaSRGB = try color.rgba().unwrap()
    expect(rgbaSRGB.red).to(beApproximatelyEqual(to: 0.9999999403953552, within: 1e-6))
    expect(rgbaSRGB.green).to(beApproximatelyEqual(to: 1.0000001192092896, within: 1e-6))
    expect(rgbaSRGB.blue).to(beApproximatelyEqual(to: 1.0000001192092896, within: 1e-6))
    expect(rgbaSRGB.alpha) == 1.0

    let rgbaDisplayP3 = try color.rgba(colorSpace: .displayP3).unwrap()
    expect(rgbaDisplayP3.red).to(beApproximatelyEqual(to: 1, within: 1e-7))
    expect(rgbaDisplayP3.green) == 1
    expect(rgbaDisplayP3.blue) == 1
    expect(rgbaDisplayP3.alpha) == 1
  }

  func testBlackRGBInitializer_default() throws {
    let color = Color.blackRGB()

    let rgbaSRGB = try color.rgba().unwrap()
    expect(rgbaSRGB.red) == 0
    expect(rgbaSRGB.green) == 0
    expect(rgbaSRGB.blue) == 0
    expect(rgbaSRGB.alpha) == 1

    let rgbaDisplayP3 = try color.rgba(colorSpace: .displayP3).unwrap()
    expect(rgbaDisplayP3.red) == 0
    expect(rgbaDisplayP3.green) == 0
    expect(rgbaDisplayP3.blue) == 0
    expect(rgbaDisplayP3.alpha) == 1
  }

  func testBlackRGBInitializer_displayP3() throws {
    let color = Color.blackRGB(colorSpace: .displayP3)

    let rgbaSRGB = try color.rgba().unwrap()
    expect(rgbaSRGB.red) == 0
    expect(rgbaSRGB.green) == 0
    expect(rgbaSRGB.blue) == 0
    expect(rgbaSRGB.alpha) == 1

    let rgbaDisplayP3 = try color.rgba(colorSpace: .displayP3).unwrap()
    expect(rgbaDisplayP3.red) == 0
    expect(rgbaDisplayP3.green) == 0
    expect(rgbaDisplayP3.blue) == 0
    expect(rgbaDisplayP3.alpha) == 1
  }

  func testWhiteRGBInitializer_alpha() throws {
    expect(Color.whiteRGB(alpha: 0.789).opacity) == 0.789
  }

  func testBlackRGBInitializer_alpha() throws {
    expect(Color.blackRGB(alpha: 0.789).opacity) == 0.789
  }

  func testRed() throws {
    let color = Color.red(0.3, alpha: 0.8)
    let rgba = try color.rgba().unwrap()
    let hsba = try color.hsba().unwrap()
    expect(rgba.red) == 1
    expect(rgba.green) == 0.7
    expect(rgba.blue) == 0.7

    expect(rgba.alpha) == 0.8

    expect(hsba.hue) == 0
    expect(hsba.saturation).to(beApproximatelyEqual(to: 0.3, within: 1e-6))
    expect(hsba.brightness) == 1
  }

  func testGreen() throws {
    let color = Color.green(0.3, alpha: 0.8)
    let rgba = try color.rgba().unwrap()
    let hsba = try color.hsba().unwrap()
    expect(rgba.red) == 0.7
    expect(rgba.green) == 1
    expect(rgba.blue) == 0.7

    expect(rgba.alpha) == 0.8

    expect(hsba.hue) == 0.3333333333333333
    expect(hsba.saturation).to(beApproximatelyEqual(to: 0.3, within: 1e-6))
    expect(hsba.brightness) == 1
  }

  func testBlue() throws {
    let color = Color.blue(0.3, alpha: 0.8)
    let rgba = try color.rgba().unwrap()
    let hsba = try color.hsba().unwrap()
    expect(rgba.red) == 0.7
    expect(rgba.green) == 0.7
    expect(rgba.blue) == 1

    expect(rgba.alpha) == 0.8

    expect(hsba.hue) == 0.6666666666666666
    expect(hsba.saturation).to(beApproximatelyEqual(to: 0.3, within: 1e-6))
    expect(hsba.brightness) == 1
  }

  func testWhiteBlue() throws {
    var color = Color.whiteBlue
    do {
      let rgba = try color.rgba().unwrap()

      expect(rgba.red) == 0.98
      expect(rgba.green) == 0.9916666666666667
      expect(rgba.blue) == 1

      expect(rgba.alpha) == 1
    }

    do {
      color = .whiteBlue(0.7, alpha: 0.2)
      let rgba = try color.rgba().unwrap()

      expect(rgba.red) == 0.6859999999999999
      expect(rgba.green) == 0.6941666666666666
      expect(rgba.blue) == 0.7

      expect(rgba.alpha) == 0.2
    }
  }

  func testBlackBlue() throws {
    var color = Color.blackBlue
    do {
      let rgba = try color.rgba().unwrap()

      expect(rgba.red) == 0
      expect(rgba.green) == 0
      expect(rgba.blue) == 0

      expect(rgba.alpha) == 1
    }

    do {
      color = .blackBlue(0.7, alpha: 0.2)
      let rgba = try color.rgba().unwrap()

      expect(rgba.red).to(beApproximatelyEqual(to: 0.29400000000000004, within: 1e-6))
      expect(rgba.green).to(beApproximatelyEqual(to: 0.29750000000000004, within: 1e-6))
      expect(rgba.blue).to(beApproximatelyEqual(to: 0.3, within: 1e-6))

      expect(rgba.alpha) == 0.2
    }
  }
}
