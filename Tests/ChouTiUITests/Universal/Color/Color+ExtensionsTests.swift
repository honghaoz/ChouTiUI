//
//  Color+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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

class Color_ExtensionsTests: XCTestCase {

  func test_fromCGColor() throws {
    let cgColor = try CGColor.rgba(red: 1, green: 0, blue: 0, alpha: 1, colorSpace: .displayP3()).unwrap()
    let color = Color.from(cgColor: cgColor)

    expect(color.red(colorSpace: .displayP3)) == 1
  }

  func test_opacityAdjustment() {
    let color = Color(white: 1)

    expect(color.opacity(0.5).alpha()) == 0.5
    expect(color.opacity(0).alpha()) == 0

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "alpha must be within 0...1"
      expect(metadata["alpha"]) == "1.2"
    }
    expect(color.opacity(1.2).alpha()) == 1
    Assert.resetTestAssertionFailureHandler()

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "alpha must be within 0...1"
      expect(metadata["alpha"]) == "1.2"
    }
    expect(color.opacity { $0 + 0.2 }.alpha()) == 1
    Assert.resetTestAssertionFailureHandler()

    expect(color.opacity { $0 - 0.2 }.alpha()) == 0.8

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "alpha must be within 0...1"
      expect(metadata["alpha"]) == "-0.19999999999999996"
    }
    expect(color.opacity { $0 - 1.2 }.alpha()) == 0
    Assert.resetTestAssertionFailureHandler()
  }

  func test_isOpaque() {
    let color = Color(white: 0.7, alpha: 0.9)
    expect(color.isOpaque) == false

    let opaqueColor = Color(white: 0.7, alpha: 1)
    expect(opaqueColor.isOpaque) == true

    let patternColor = Color(patternImage: Image.imageWithColor(.red))
    expect(patternColor.isOpaque) == false
  }

  func test_isPatterned() {
    expect(Color.red.isPatterned) == false
    expect(Color(white: 0.7, alpha: 0.9).isPatterned) == false
    expect(Color(patternImage: .imageWithColor(.red)).isPatterned) == true
  }

  func test_randomColor() throws {
    let color1 = Color.random()
    let color2 = Color.random()
    try expect(color1.rgba().unwrap()) != color2.rgba().unwrap()
    expect(color1.opacity) == 1
    expect(color2.opacity) == 1

    let containsTransparentColor = [0 ..< 10]
      .map { _ in
        Color.random(includingAlpha: true)
      }
      .contains(where: { $0.alpha() < 1 })
    expect(containsTransparentColor).to(beTrue())
  }

  func test_randomLightColor() throws {
    for _ in 1 ... 100 {
      let lightColor = Color.randomLightColor()
      let perceivedBrightness = try lightColor.brightness().unwrap()
      expect(perceivedBrightness) >= 0.7
    }
  }

  func test_randomDarkColor() throws {
    for _ in 1 ... 100 {
      let darkColor = Color.randomDarkColor()
      let perceivedBrightness = try darkColor.brightness().unwrap()
      expect(perceivedBrightness) <= 0.4
    }
  }

  func test_blending() throws {
    // valid blending
    do {
      let blendedColor = try Color.black.blending(with: 0.5, of: Color.white).unwrap()
      let rgba = try blendedColor.rgba().unwrap()
      expect(rgba.red).to(beApproximatelyEqual(to: 0.5, within: 0.01))
      expect(rgba.green).to(beApproximatelyEqual(to: 0.5, within: 0.01))
      expect(rgba.blue).to(beApproximatelyEqual(to: 0.5, within: 0.01))
      expect(rgba.alpha).to(beApproximatelyEqual(to: 1.0, within: 0.01))
    }

    // valid blending
    do {
      let blendedColor = try Color.red.blending(with: 0.25, of: Color.white).unwrap()
      let rgba = try blendedColor.rgba().unwrap()
      expect(rgba.red).to(beApproximatelyEqual(to: 1.0, within: 0.01))
      expect(rgba.green).to(beApproximatelyEqual(to: 0.25, within: 0.01))
      expect(rgba.blue).to(beApproximatelyEqual(to: 0.25, within: 0.01))
      expect(rgba.alpha).to(beApproximatelyEqual(to: 1.0, within: 0.01))
    }

    // invalid blending fraction
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "fraction must be within 0...1"
        expect(metadata["fraction"]) == "1.1"
      }

      let selfColor = Color.red
      let otherColor = Color.blue
      expect(selfColor.blending(with: 1.1, of: otherColor)) == selfColor.blending(with: 1, of: otherColor)

      Assert.resetTestAssertionFailureHandler()
    }

    // invalid blending color
    do {
      let selfColor = Color(patternImage: .imageWithColor(.red))
      let otherColor = Color.red

      var assertIndex = 0
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        if assertIndex == 0 {
          expect(message) == "Failed to get rgba components"
          expect(metadata["color"]) == "\(selfColor)"
        } else if assertIndex == 1 {
          expect(message) == "Failed to get rgba components"
          expect(metadata["selfColor"]) == "\(selfColor)"
          expect(metadata["color"]) == "\(otherColor)"
        } else {
          fail("Unexpected assertion failure")
        }
        assertIndex += 1
      }

      expect(selfColor.blending(with: 0.1, of: otherColor)) == nil

      Assert.resetTestAssertionFailureHandler()
    }
  }
}
