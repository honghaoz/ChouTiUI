//
//  GradientColorTypeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/8/24.
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

#if canImport(QuartzCore)
import QuartzCore
#endif

import ChouTiTest

import ChouTi
import ChouTiUI

class GradientColorTypeTests: XCTestCase {

  func test_cgColors() {
    let gradientColor = GradientColor.linearGradient(LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight))
    let cgColors = gradientColor.cgColors
    expect(cgColors) == [Color.red.cgColor, Color.green.cgColor, Color.blue.cgColor]
  }

  func test_locationNSNumbers() {
    let gradientColor = GradientColor.linearGradient(LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight))
    let locationNumbers = gradientColor.locationNSNumbers
    expect(locationNumbers) == [0.25, 0.5, 0.75]
  }

  func test_isOpaque() {
    let gradientColor = LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)
    expect(gradientColor.isOpaque) == true
  }

  func test_opacity() {
    let gradientColor = LinearGradientColor(colors: [.red.opacity(0.2), .green.opacity(0.5), .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)
    let newGradientColor = gradientColor.opacity { $0 * 0.5 }
    expect(newGradientColor.colors) == [Color.red.opacity(0.1), Color.green.opacity(0.25), Color.blue.opacity(0.5)]
    expect(newGradientColor.locations) == [0.25, 0.5, 0.75]
    expect(newGradientColor.startPoint) == .topLeft
    expect(newGradientColor.endPoint) == .bottomRight
  }

  func test_blending() throws {
    // default color space
    do {
      let gradientColor = LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)
      let newGradientColor = try gradientColor.blending(with: 0.5, of: .white).unwrap()
      try expect(newGradientColor.colors) == [Color.red.blending(with: 0.5, of: .white).unwrap(), Color.green.blending(with: 0.5, of: .white).unwrap(), Color.blue.blending(with: 0.5, of: .white).unwrap()]
      expect(newGradientColor.locations) == [0.25, 0.5, 0.75]
      expect(newGradientColor.startPoint) == .topLeft
      expect(newGradientColor.endPoint) == .bottomRight
    }

    // .displayP3 color space
    do {
      let gradientColor = LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)
      let newGradientColor = try gradientColor.blending(with: 0.5, of: .white, colorSpace: .displayP3).unwrap()
      try expect(newGradientColor.colors) == [Color.red.blending(with: 0.5, of: .white, colorSpace: .displayP3).unwrap(), Color.green.blending(with: 0.5, of: .white, colorSpace: .displayP3).unwrap(), Color.blue.blending(with: 0.5, of: .white, colorSpace: .displayP3).unwrap()]
      expect(newGradientColor.locations) == [0.25, 0.5, 0.75]
      expect(newGradientColor.startPoint) == .topLeft
      expect(newGradientColor.endPoint) == .bottomRight
    }

    // invalid blending
    do {
      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      let otherColor = Color(patternImage: .imageWithColor(.red))

      var assertIndex = 0
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        if assertIndex == 0 {
          expect(message) == "Failed to get rgba components"
          expect(metadata["color"]) == "\(otherColor)"
        } else if assertIndex == 1 {
          expect(message) == "Failed to get rgba components"
          expect(metadata["color"]) == "\(otherColor)"
        } else if assertIndex == 2 {
          expect(message) == "Failed to blend color"
          expect(metadata["selfColor"]) == "\(gradientColor)"
          expect(metadata["color"]) == "\(otherColor)"
          expect(metadata["fraction"]) == "0.5"
        } else {
          fail("Unexpected assertion failure")
        }
        assertIndex += 1
      }

      expect(gradientColor.blending(with: 0.5, of: otherColor)) == nil

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_adjustingBrightness() throws {
    // valid case
    do {
      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      let newGradientColor = try gradientColor.adjustingBrightness(percentage: 0.5).unwrap()
      expect(newGradientColor.colors) == [Color.red.adjustingBrightness(percentage: 0.5), Color.green.adjustingBrightness(percentage: 0.5)]
      expect(newGradientColor.locations) == [0, 1]
      expect(newGradientColor.startPoint) == .topLeft
      expect(newGradientColor.endPoint) == .bottomRight
    }

    // invalid percentage > 1
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "Brightness percentage must be in the range of `-1` to `1`"
        expect(metadata["percentage"]) == "2.0"
      }

      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.adjustingBrightness(percentage: 2)) == gradientColor.adjustingBrightness(percentage: 1)

      Assert.resetTestAssertionFailureHandler()
    }

    // invalid percentage < -1
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "Brightness percentage must be in the range of `-1` to `1`"
        expect(metadata["percentage"]) == "-2.0"
      }

      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.adjustingBrightness(percentage: -2)) == gradientColor.adjustingBrightness(percentage: -1)

      Assert.resetTestAssertionFailureHandler()
    }

    // invalid colors
    do {
      let invalidColor = Color(patternImage: .imageWithColor(.red))
      let gradientColor = LinearGradientColor(colors: [invalidColor, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)

      var assertIndex = 0
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        if assertIndex == 0 {
          expect(message) == "Failed to get hsba components"
          expect(metadata["color"]) == "\(invalidColor)"
        } else if assertIndex == 1 {
          expect(message) == "Failed to get hsba components"
          expect(metadata["color"]) == "\(invalidColor)"
        } else if assertIndex == 2 {
          expect(message) == "Failed to adjust brightness"
          expect(metadata["color"]) == "\(invalidColor)"
          expect(metadata["percentage"]) == "0.5"
        } else {
          fail("Unexpected assertion failure")
        }
        assertIndex += 1
      }

      expect(gradientColor.adjustingBrightness(percentage: 0.5)) == nil

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_lighter() throws {
    // valid case
    do {
      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      let newGradientColor = try gradientColor.lighter().unwrap()
      expect(newGradientColor.colors) == [Color.red.lighter(), Color.green.lighter()]
      expect(newGradientColor.locations) == [0, 1]
      expect(newGradientColor.startPoint) == .topLeft
      expect(newGradientColor.endPoint) == .bottomRight
    }

    // invalid percentage > 1
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "2.0"
      }

      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.lighter(by: 2)) == gradientColor.lighter(by: 1)

      Assert.resetTestAssertionFailureHandler()
    }

    // invalid percentage < -1
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "-2.0"
      }

      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.lighter(by: -2)) == gradientColor

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_darker() throws {
    // valid case
    do {
      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      let newGradientColor = try gradientColor.darker().unwrap()
      expect(newGradientColor.colors) == [Color.red.darker(), Color.green.darker()]
      expect(newGradientColor.locations) == [0, 1]
      expect(newGradientColor.startPoint) == .topLeft
      expect(newGradientColor.endPoint) == .bottomRight
    }

    // invalid percentage > 1
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "2.0"
      }

      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.darker(by: 2)) == gradientColor.darker(by: 1)

      Assert.resetTestAssertionFailureHandler()
    }

    // invalid percentage < -1
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "percentage must be in the range of `0` to `1`"
        expect(metadata["percentage"]) == "-2.0"
      }

      let gradientColor = LinearGradientColor(colors: [.red, .green], locations: [0, 1], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.darker(by: -2)) == gradientColor

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_convenient_initializers() {
    // linearGradient
    do {
      let gradientColor: GradientColorType = .linearGradient(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.colors) == [Color.red, Color.green, Color.blue]
      expect(gradientColor.locations) == [0.25, 0.5, 0.75]
      expect(gradientColor.startPoint) == .topLeft
      expect(gradientColor.endPoint) == .bottomRight
    }

    // angularGradient
    do {
      let gradientColor: GradientColorType = .angularGradient(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], centerPoint: .topLeft, aimingPoint: .bottomRight)
      expect(gradientColor.colors) == [Color.red, Color.green, Color.blue]
      expect(gradientColor.locations) == [0.25, 0.5, 0.75]
      expect(gradientColor.startPoint) == .topLeft
      expect(gradientColor.endPoint) == .bottomRight
    }

    // radialGradient
    do {
      let gradientColor: GradientColorType = .radialGradient(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], centerPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.colors) == [Color.red, Color.green, Color.blue]
      expect(gradientColor.locations) == [0.25, 0.5, 0.75]
      expect(gradientColor.startPoint) == .topLeft
      expect(gradientColor.endPoint) == .bottomRight
    }
  }

  func test_unifiedColor_themedUnifiedColor() {
    // linearGradient
    do {
      let gradientColor: GradientColorType = .linearGradient(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.unifiedColor) == .gradient(.linearGradient(LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)))
      expect(gradientColor.themedUnifiedColor) == ThemedUnifiedColor(gradientColor.unifiedColor)
    }

    // radialGradient
    do {
      let gradientColor: GradientColorType = .radialGradient(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], centerPoint: .topLeft, endPoint: .bottomRight)
      expect(gradientColor.unifiedColor) == .gradient(.radialGradient(RadialGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], centerPoint: .topLeft, endPoint: .bottomRight)))
      expect(gradientColor.themedUnifiedColor) == ThemedUnifiedColor(gradientColor.unifiedColor)
    }

    // angularGradient
    do {
      let gradientColor: GradientColorType = .angularGradient(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], centerPoint: .topLeft, aimingPoint: .bottomRight)
      expect(gradientColor.unifiedColor) == .gradient(.angularGradient(AngularGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], centerPoint: .topLeft, aimingPoint: .bottomRight)))
      expect(gradientColor.themedUnifiedColor) == ThemedUnifiedColor(gradientColor.unifiedColor)
    }

    // GradientColor
    do {
      let gradientColor: GradientColorType = GradientColor.linearGradient(LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight))
      expect(gradientColor.unifiedColor) == .gradient(.linearGradient(LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)))
      expect(gradientColor.themedUnifiedColor) == ThemedUnifiedColor(gradientColor.unifiedColor)
    }
  }
}
