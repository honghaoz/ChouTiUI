//
//  Color+HexTests.swift
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

class Color_HexTests: XCTestCase {

  func testRGBHex() throws {
    var color = Color.hex("#FF0000")
    expect(color.hexString(includeAlpha: false, colorSpace: .sRGB)) == "#FF0000"

    color = Color.hex("#123456")
    let (r, g, b, a) = try color.rgba().unwrap().unwrap()
    expect(r) == 0x12 / 255
    expect(g) == 0x34 / 255
    expect(b) == 0x56 / 255
    expect(a) == 1

    color = Color(red: 0x12 / 255, green: 0x34 / 255, blue: 0x56 / 255, alpha: 0x78 / 255)
    expect(color.hexString(includeAlpha: false)) == "#123456"
    expect(color.hex(includeAlpha: false)) == 0x123456
  }

  func testRGBAHex() throws {
    var color = Color.hex("#FF000088")
    let hexString = color.hexString(includeAlpha: true, colorSpace: .sRGB)
    expect(hexString) == "#FF000088"
    expect(color.hex(includeAlpha: true, colorSpace: .sRGB)) == 0xFF000088

    color = Color.hex("#12345678")
    let (r, g, b, a) = try color.rgba().unwrap().unwrap()
    expect(r) == 0x12 / 255
    expect(g) == 0x34 / 255
    expect(b) == 0x56 / 255
    expect(a) == 0x78 / 255

    color = Color(red: 0x12 / 255, green: 0x34 / 255, blue: 0x56 / 255, alpha: 0x78 / 255)
    expect(color.hexString()) == "#12345678"
    expect(color.hex()) == 0x12345678
    expect(color.hexString(includeAlpha: true)) == "#12345678"
    expect(color.hex(includeAlpha: true)) == 0x12345678
  }

  func testDisplayP3ColorSpace() {
    let color = Color.hex("#FF0000", colorSpace: .displayP3)
    expect(color.hexString(includeAlpha: false, colorSpace: .displayP3)) == "#FF0000"
    expect(color.hex(includeAlpha: false, colorSpace: .displayP3)) == 0xFF0000

    expect(
      Color.hex("#FF0000", colorSpace: .sRGB).hexString(includeAlpha: false, colorSpace: .displayP3)
    ) == "#E93323"

    expect(Color.rgba(1, 0, 0, 1, colorSpace: .sRGB).hexString(includeAlpha: false, colorSpace: .displayP3)) == "#E93323"
    expect(Color.rgba(1, 0, 0, 1, colorSpace: .sRGB).hex(includeAlpha: false, colorSpace: .displayP3)) == 0xE93323
    expect(Color.rgba(1, 0, 0, 1, colorSpace: .displayP3).hexString(includeAlpha: false, colorSpace: .displayP3)) == "#FF0000"
    expect(Color.rgba(1, 0, 0, 1, colorSpace: .displayP3).hex(includeAlpha: false, colorSpace: .displayP3)) == 0xFF0000
  }

  func testFallbackColor() {
    do {
      let color = Color.hex("ZZZZZZ")
      expect(color) == .clear

      let hexString = color.hexString(includeAlpha: false, colorSpace: .sRGB)
      expect(hexString) == "#000000"
      expect(color.hex(includeAlpha: false, colorSpace: .sRGB)) == 0x000000
    }
    do {
      let color = Color.hex("ZZZZZZ", fallbackColor: .black)
      expect(color) == .black

      let hexString = color.hexString(includeAlpha: false, colorSpace: .sRGB)
      expect(hexString) == "#000000"
      expect(color.hex(includeAlpha: false, colorSpace: .sRGB)) == 0x000000
    }
  }

  func test_invalidHexString() {
    do {
      let color = Color(hex: "ZZZZZZ")
      expect(color) == nil
    }

    do {
      let color = Color(hex: "#FFFF")
      expect(color) == nil
    }

    do {
      let color = Color(hex: "#1Z3456")
      expect(color) == nil
    }

    do {
      let color = Color(hex: "#1234567")
      expect(color) == nil
    }

    do {
      let color = Color(hex: "")
      expect(color) == nil
    }

    do {
      let color = Color(hex: "😀😃😄😁😆🥹")
      expect(color) == nil
    }
  }

  func testMaxIntensityColor() {
    let color = Color(hex: "#FFFFFF")
    expect(color) != nil
    expect(color?.hexString(includeAlpha: false, colorSpace: .sRGB)) == "#FFFFFF"
    expect(color?.hex(includeAlpha: false, colorSpace: .sRGB)) == 0xFFFFFF
  }

  func testMinIntensityColor() {
    let color = Color(hex: "#000000")
    expect(color) != nil
    expect(color?.hexString(includeAlpha: false, colorSpace: .sRGB)) == "#000000"
    expect(color?.hex(includeAlpha: false, colorSpace: .sRGB)) == 0x000000
  }

  func test_patternColor_hex() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Failed to get rgba components"
      #if canImport(AppKit)
      expect(metadata["color"]?.hasPrefix("Pattern color: "), metadata["color"]) == true
      #else
      expect(metadata["color"]?.hasPrefix("<UIDynamicPatternColor"), metadata["color"]) == true
      #endif
    }

    let color = Color(patternImage: Image.imageWithColor(.red))

    expect(color.hexString(includeAlpha: false, colorSpace: .sRGB)) == nil
    expect(color.hex(includeAlpha: false, colorSpace: .sRGB)) == nil

    Assert.resetTestAssertionFailureHandler()
  }

  func test_invalidHexString_displayP3() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Bad rgba values, you might want to use .displayP3 color space."
      expect(metadata["r"]) == "1.0930908918380737"
      expect(metadata["g"]) == "-0.22684034705162048"
      expect(metadata["b"]) == "-0.15007957816123962"
      expect(metadata["a"]) == "1.0"
    }

    let color = Color(red: 1, green: 0, blue: 0, alpha: 1, colorSpace: .displayP3)
    expect(color.hexString(includeAlpha: false, colorSpace: .sRGB)) == nil
    expect(color.hex(includeAlpha: false, colorSpace: .sRGB)) == nil

    Assert.resetTestAssertionFailureHandler()
  }
}
