//
//  ThemedColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 5/18/22.
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

class ThemedColorTests: XCTestCase {

  func test_foreground() {
    let color = ThemedColor.foreground
    expect(color.lightColor) == .black
    expect(color.darkColor) == .white
  }

  func test_foregroundSecondary() {
    let color = ThemedColor.foregroundSecondary
    expect(color.lightColor) == .hex("#6A7278")
    expect(color.darkColor) == .hex("#919FA6")
  }

  func test_foregroundTertiary() {
    let color = ThemedColor.foregroundTertiary
    expect(color.lightColor) == .hex("#B4BDC2")
    expect(color.darkColor) == .hex("#545D61")
  }

  func test_background() {
    let color = ThemedColor.background
    expect(color.lightColor) == .white
    expect(color.darkColor) == .black
  }

  func test_backgroundSecondary() {
    let color = ThemedColor.backgroundSecondary
    expect(color.lightColor) == .hex("#F5F8FA")
    expect(color.darkColor) == .hex("#1E2124")
  }

  func test_backgroundTertiary() {
    let color = ThemedColor.backgroundTertiary
    expect(color.lightColor) == .hex("#E3E9ED")
    expect(color.darkColor) == .hex("#30363A")
  }

  #if DEBUG
  func test_debugRed() {
    let color = ThemedColor.debugRed
    expect(color.lightColor) == .red.opacity(0.3)
    expect(color.darkColor) == .red.opacity(0.3)
  }

  func test_debugBlue() {
    let color = ThemedColor.debugBlue
    expect(color.lightColor) == .blue.opacity(0.3)
    expect(color.darkColor) == .blue.opacity(0.3)
  }

  func test_debugYellow() {
    let color = ThemedColor.debugYellow
    expect(color.lightColor) == .yellow.opacity(0.3)
    expect(color.darkColor) == .yellow.opacity(0.3)
  }
  #endif

  func test_init() {
    do {
      let color = ThemedColor(lightColor: .red, darkColor: .blue)
      expect(color.lightColor) == .red
      expect(color.darkColor) == .blue

      expect(color.color(for: .light)) == .red
      expect(color.color(for: .dark)) == .blue
    }
    do {
      let color = ThemedColor(.red)
      expect(color.lightColor) == .red
      expect(color.darkColor) == .red

      expect(color.color(for: .light)) == .red
      expect(color.color(for: .dark)) == .red
    }
  }

  func test_lighter() {
    // default percentage is 0.1
    do {
      let color = ThemedColor(lightColor: .red, darkColor: .blue)
      let lighterColor = color.lighter()
      expect(lighterColor?.lightColor) == .red.lighter()
      expect(lighterColor?.darkColor) == .blue.lighter()
    }

    // custom percentage
    do {
      let color = ThemedColor(lightColor: .red, darkColor: .blue)
      let lighterColor = color.lighter(by: 0.5)
      expect(lighterColor?.lightColor) == .red.lighter(by: 0.5)
      expect(lighterColor?.darkColor) == .blue.lighter(by: 0.5)
    }

    // non HSBA color
    do {
      let patternColor = Color(patternImage: Image())

      var assertIndex = 0
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        if assertIndex == 0 {
          expect(message) == "Failed to get hsba components"
          expect(metadata["color"]) == "\(patternColor)"
        } else if assertIndex == 1 {
          expect(message) == "Failed to get hsba components"
          expect(metadata["color"]) == "\(patternColor)"
        } else if assertIndex == 2 {
          expect(message) == "Failed to get lighter color"
          expect(metadata["lightColor"]) == "\(patternColor)"
          expect(metadata["darkColor"]) == "\(patternColor)"
          expect(metadata["percentage"]) == "0.1"
        } else {
          fail("Unexpected assert failure")
        }

        assertIndex += 1
      }

      let color = ThemedColor(lightColor: patternColor, darkColor: patternColor)
      let lighterColor = color.lighter()
      expect(lighterColor?.lightColor) == nil
      expect(lighterColor?.darkColor) == nil

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_darker() {
    // default percentage is 0.1
    do {
      let color = ThemedColor(lightColor: .red, darkColor: .blue)
      let darkerColor = color.darker()
      expect(darkerColor?.lightColor) == .red.darker()
      expect(darkerColor?.darkColor) == .blue.darker()
    }

    // custom percentage
    do {
      let color = ThemedColor(lightColor: .red, darkColor: .blue)
      let darkerColor = color.darker(by: 0.5)
      expect(darkerColor?.lightColor) == .red.darker(by: 0.5)
      expect(darkerColor?.darkColor) == .blue.darker(by: 0.5)
    }

    // non HSBA color
    do {
      let patternColor = Color(patternImage: Image())

      var assertIndex = 0
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        if assertIndex == 0 {
          expect(message) == "Failed to get hsba components"
          expect(metadata["color"]) == "\(patternColor)"
        } else if assertIndex == 1 {
          expect(message) == "Failed to get hsba components"
          expect(metadata["color"]) == "\(patternColor)"
        } else if assertIndex == 2 {
          expect(message) == "Failed to get darker color"
          expect(metadata["lightColor"]) == "\(patternColor)"
          expect(metadata["darkColor"]) == "\(patternColor)"
          expect(metadata["percentage"]) == "0.1"
        } else {
          fail("Unexpected assert failure")
        }

        assertIndex += 1
      }

      let color = ThemedColor(lightColor: patternColor, darkColor: patternColor)
      let darkerColor = color.darker()
      expect(darkerColor?.lightColor) == nil
      expect(darkerColor?.darkColor) == nil

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_colorToThemeColor() {
    let color = Color.red
    let themedColor = color.themedColor
    expect(themedColor.lightColor) == color
    expect(themedColor.darkColor) == color
  }
}
