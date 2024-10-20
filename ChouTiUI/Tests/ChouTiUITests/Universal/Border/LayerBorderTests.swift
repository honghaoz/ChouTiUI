//
//  LayerBorderTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 6/23/23.
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

import CoreGraphics
import QuartzCore

import ChouTiTest

import ChouTi
import ChouTiUI

class LayerBorderTests: XCTestCase {

  func test_none() {
    let layerBorder = LayerBorder.none
    expect(layerBorder.borderColor) == nil
    expect(layerBorder.borderWidth) == 0
  }

  func test_init() {
    // with color and width
    do {
      let layerBorder = LayerBorder(borderColor: Color.red.cgColor, borderWidth: 1)
      expect(layerBorder.borderColor) == Color.red.cgColor
      expect(layerBorder.borderWidth) == 1
    }

    // with border
    do {
      let layerBorder = LayerBorder(border: Border(Color.red, 1))
      expect(layerBorder.borderColor) == Color.red.cgColor
      expect(layerBorder.borderWidth) == 1
    }

    // with border with gradient color
    do {
      let linearGradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1])
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "LayerBorder only supports solid color"
        expect(metadata) == ["borderColor": "\(UnifiedColor.gradient(.linearGradient(linearGradientColor)))"]
      }

      let layerBorder = LayerBorder(border: Border(linearGradientColor, 1))
      expect(layerBorder.borderColor) == nil
      expect(layerBorder.borderWidth) == 1

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_changeBorderColor() {
    let layerBorder = LayerBorder(borderColor: Color.red.cgColor, borderWidth: 1)
    let layerBorder2 = layerBorder.borderColor(Color.green.cgColor)
    expect(layerBorder2.borderColor) == Color.green.cgColor
    expect(layerBorder2.borderWidth) == 1
  }

  func test_changeBorderWidth() {
    let layerBorder = LayerBorder(borderColor: Color.red.cgColor, borderWidth: 1)
    let layerBorder2 = layerBorder.borderWidth(2)
    expect(layerBorder2.borderColor) == Color.red.cgColor
    expect(layerBorder2.borderWidth) == 2
  }

  func test_description() throws {
    let layerBorder = LayerBorder(borderColor: Color.red.cgColor, borderWidth: 1)

    let regex = try NSRegularExpression(pattern: "LayerBorder\\(borderColor: \\<CGColor 0x[0-9a-f]+> \\[\\<CGColorSpace 0x[0-9a-f]+> \\(kCGColorSpaceICCBased; kCGColorSpaceModelRGB; sRGB IEC61966-2\\.1\\)] \\( 1 0 0 1 \\), borderWidth: 1.0\\)", options: [.dotMatchesLineSeparators])
    let range = NSRange(location: 0, length: layerBorder.description.utf16.count)
    let matches = regex.matches(in: layerBorder.description, options: [], range: range)

    expect(matches.count == 1) == true
  }

  func test_view_layerBorder() {
    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif

    view.layerBorder = LayerBorder(borderColor: Color.red.cgColor, borderWidth: 1)
    expect(view.layerBorder.borderColor) == Color.red.cgColor
    expect(view.layerBorder.borderWidth) == 1

    view.layerBorder = LayerBorder(border: Border(Color.green, 2))
    expect(view.layerBorder.borderColor) == Color.green.cgColor
    expect(view.layerBorder.borderWidth) == 2

    #if os(macOS)
    view.wantsLayer = false
    #endif

    var assertionCount = 0
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      if assertionCount == 0 {
        expect(message) == "NSView should set `wantsLayer == true`."
      } else if assertionCount == 1 {
        expect(message) == "view must have a layer"
        expect(metadata) == ["view": "\(view)"]
      }
      assertionCount += 1
    }

    view.layerBorder = LayerBorder(border: Border(Color.blue, 3))
    expect(view.layerBorder.borderColor) == nil
    expect(view.layerBorder.borderWidth) == 0

    Assert.resetTestAssertionFailureHandler()
  }

  func test_view_updateBorder() {
    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif

    view.updateBorder(with: LayerBorder(border: Border(Color.red, 1)))
    expect(view.layerBorder.borderColor) == Color.red.cgColor
    expect(view.layerBorder.borderWidth) == 1

    #if os(macOS)
    view.wantsLayer = false
    #endif

    var assertionCount = 0
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      if assertionCount == 0 {
        expect(message) == "NSView should set `wantsLayer == true`."
      } else if assertionCount == 1 {
        expect(message) == "view must have a layer"
        expect(metadata) == ["view": "\(view)"]
      }
      assertionCount += 1
    }

    view.updateBorder(with: LayerBorder(border: Border(Color.green, 2)))
    expect(view.layerBorder.borderColor) == nil
    expect(view.layerBorder.borderWidth) == 0
  }
}
