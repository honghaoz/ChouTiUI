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
    expect(color.light) == .black
    expect(color.dark) == .white
  }

  func test_foregroundSecondary() {
    let color = ThemedColor.foregroundSecondary
    expect(color.light) == .hex("#6A7278")
    expect(color.dark) == .hex("#919FA6")
  }

  func test_foregroundTertiary() {
    let color = ThemedColor.foregroundTertiary
    expect(color.light) == .hex("#B4BDC2")
    expect(color.dark) == .hex("#545D61")
  }

  func test_background() {
    let color = ThemedColor.background
    expect(color.light) == .white
    expect(color.dark) == .black
  }

  func test_backgroundSecondary() {
    let color = ThemedColor.backgroundSecondary
    expect(color.light) == .hex("#F5F8FA")
    expect(color.dark) == .hex("#1E2124")
  }

  func test_backgroundTertiary() {
    let color = ThemedColor.backgroundTertiary
    expect(color.light) == .hex("#E3E9ED")
    expect(color.dark) == .hex("#30363A")
  }

  #if DEBUG
  func test_debugRed() {
    let color = ThemedColor.debugRed
    expect(color.light) == .red.opacity(0.3)
    expect(color.dark) == .red.opacity(0.3)
  }

  func test_debugBlue() {
    let color = ThemedColor.debugBlue
    expect(color.light) == .blue.opacity(0.3)
    expect(color.dark) == .blue.opacity(0.3)
  }

  func test_debugYellow() {
    let color = ThemedColor.debugYellow
    expect(color.light) == .yellow.opacity(0.3)
    expect(color.dark) == .yellow.opacity(0.3)
  }
  #endif

  func test_init() {
    do {
      let color = ThemedColor(light: .red, dark: .blue)
      expect(color.light) == .red
      expect(color.dark) == .blue

      expect(color.resolve(for: .light)) == .red
      expect(color.resolve(for: .dark)) == .blue
    }
    do {
      let color = ThemedColor(.red)
      expect(color.light) == .red
      expect(color.dark) == .red

      expect(color.resolve(for: .light)) == .red
      expect(color.resolve(for: .dark)) == .red
    }
  }

  func test_lighter() {
    // default percentage is 0.1
    do {
      let color = ThemedColor(light: .red, dark: .blue)
      let lighterColor = color.lighter()
      expect(lighterColor?.light) == .red.lighter()
      expect(lighterColor?.dark) == .blue.lighter()
    }

    // custom percentage
    do {
      let color = ThemedColor(light: .red, dark: .blue)
      let lighterColor = color.lighter(by: 0.5)
      expect(lighterColor?.light) == .red.lighter(by: 0.5)
      expect(lighterColor?.dark) == .blue.lighter(by: 0.5)
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

      let color = ThemedColor(light: patternColor, dark: patternColor)
      let lighterColor = color.lighter()
      expect(lighterColor?.light) == nil
      expect(lighterColor?.dark) == nil

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_darker() {
    // default percentage is 0.1
    do {
      let color = ThemedColor(light: .red, dark: .blue)
      let darkerColor = color.darker()
      expect(darkerColor?.light) == .red.darker()
      expect(darkerColor?.dark) == .blue.darker()
    }

    // custom percentage
    do {
      let color = ThemedColor(light: .red, dark: .blue)
      let darkerColor = color.darker(by: 0.5)
      expect(darkerColor?.light) == .red.darker(by: 0.5)
      expect(darkerColor?.dark) == .blue.darker(by: 0.5)
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

      let color = ThemedColor(light: patternColor, dark: patternColor)
      let darkerColor = color.darker()
      expect(darkerColor?.light) == nil
      expect(darkerColor?.dark) == nil

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_colorToThemeColor() {
    let color = Color.red
    let themedColor = color.themedColor
    expect(themedColor.light) == color
    expect(themedColor.dark) == color
  }
}
