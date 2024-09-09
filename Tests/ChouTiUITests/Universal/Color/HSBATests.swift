//
//  HSBATests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/7/24.
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

import ChouTi
import ChouTiUI

class HSBATests: XCTestCase {

  func test_init() {
    do {
      let hsba = HSBA(hue: 0, saturation: 0, brightness: 0, alpha: 0)
      expect(hsba.hue) == 0
      expect(hsba.saturation) == 0
      expect(hsba.brightness) == 0
      expect(hsba.alpha) == 0
    }

    do {
      let hsba = HSBA(0, 0, 0, 0)
      expect(hsba.hue) == 0
      expect(hsba.saturation) == 0
      expect(hsba.brightness) == 0
      expect(hsba.alpha) == 0
    }
  }

  func test_init_with_invalid_hue() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "hue must be between 0 and 1"
      expect(metadata["hue"]) == "2.0"
    }

    let hsba = HSBA(hue: 2, saturation: 0, brightness: 0, alpha: 0)
    expect(hsba.hue) == 2.0
    expect(hsba.saturation) == 0
    expect(hsba.brightness) == 0
    expect(hsba.alpha) == 0

    Assert.resetTestAssertionFailureHandler()
  }

  func test_init_with_invalid_alpha() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "alpha must be between 0 and 1"
      expect(metadata["alpha"]) == "2.0"
    }

    let hsba = HSBA(hue: 0, saturation: 0, brightness: 0, alpha: 2)
    expect(hsba.hue) == 0
    expect(hsba.saturation) == 0
    expect(hsba.brightness) == 0
    expect(hsba.alpha) == 1

    Assert.resetTestAssertionFailureHandler()
  }

  func test_unwrap() {
    let hsba = HSBA(hue: 0, saturation: 0, brightness: 0, alpha: 0)
    let (h, s, b, a) = hsba.unwrap()
    expect(h) == 0
    expect(s) == 0
    expect(b) == 0
    expect(a) == 0
  }
}
