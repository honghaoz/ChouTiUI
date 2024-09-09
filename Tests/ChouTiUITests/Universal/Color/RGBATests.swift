//
//  RGBATests.swift
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

class RGBATests: XCTestCase {

  func test_init() {
    do {
      let rgba = RGBA(red: 1, green: 1, blue: 1, alpha: 1)
      expect(rgba.red) == 1
      expect(rgba.green) == 1
      expect(rgba.blue) == 1
      expect(rgba.alpha) == 1
    }

    do {
      let rgba = RGBA(1, 1, 1, 1)
      expect(rgba.red) == 1
      expect(rgba.green) == 1
      expect(rgba.blue) == 1
      expect(rgba.alpha) == 1
    }
  }

  func test_init_with_invalid_alpha() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "alpha must be between 0 and 1"
      expect(metadata["alpha"]) == "2.0"
    }

    let rgba = RGBA(red: 1, green: 1, blue: 1, alpha: 2)
    expect(rgba.red) == 1
    expect(rgba.green) == 1
    expect(rgba.blue) == 1
    expect(rgba.alpha) == 1

    Assert.resetTestAssertionFailureHandler()
  }

  func test_unwrap() {
    let rgba = RGBA(red: 1, green: 1, blue: 1, alpha: 1)
    let (r, g, b, a) = rgba.unwrap()
    expect(r) == 1
    expect(g) == 1
    expect(b) == 1
    expect(a) == 1
  }
}
