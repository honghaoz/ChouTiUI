//
//  AngularGradientColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/21/21.
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

class AngularGradientColorTests: XCTestCase {

  func test_clear() {
    let gradient = AngularGradientColor.clear
    expect(gradient.colors) == [Color.clear, Color.clear]
    expect(gradient.locations) == nil
    expect(gradient.startPoint) == UnitPoint.center
    expect(gradient.endPoint) == UnitPoint.top
  }

  #if canImport(QuartzCore)
  func test_gradientLayerType() {
    let gradient = AngularGradientColor(colors: [Color.red, Color.blue], startPoint: .top, endPoint: .bottom)
    expect(gradient.gradientLayerType) == CAGradientLayerType.conic
  }
  #endif

  func test_init() {
    // default
    do {
      let gradient = AngularGradientColor(
        colors: [Color.red, Color.blue],
        startPoint: .top,
        endPoint: .bottom
      )
      expect(gradient.colors) == [Color.red, Color.blue]
      expect(gradient.locations) == nil
      expect(gradient.startPoint) == UnitPoint.top
      expect(gradient.endPoint) == UnitPoint.bottom
    }

    // colors and locations
    do {
      let gradient = AngularGradientColor(
        colors: [Color.red, Color.blue, Color.green],
        locations: [0, 0.5, 1],
        startPoint: .left,
        endPoint: .right
      )
      expect(gradient.colors) == [Color.red, Color.blue, Color.green]
      expect(gradient.locations) == [0, 0.5, 1]
      expect(gradient.startPoint) == UnitPoint.left
      expect(gradient.endPoint) == UnitPoint.right
    }

    // center point, aiming point
    do {
      let gradient = AngularGradientColor(
        colors: [Color.red, Color.blue],
        centerPoint: .center,
        aimingPoint: .bottom
      )
      expect(gradient.colors) == [Color.red, Color.blue]
      expect(gradient.locations) == nil
      expect(gradient.startPoint) == UnitPoint.center
      expect(gradient.endPoint) == UnitPoint.bottom
      expect(gradient.centerPoint) == UnitPoint.center
      expect(gradient.aimingPoint) == UnitPoint.bottom
    }
  }

  func test_init_invalid() {
    // empty colors
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "gradient color should have at least 2 colors."
        expect(metadata["colors"]) == "[]"
      }
      _ = AngularGradientColor(colors: [], startPoint: .left, endPoint: .right)
      Assert.resetTestAssertionFailureHandler()
    }

    // one color
    do {
      let colors = [Color.red]
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "gradient color should have at least 2 colors."
        expect(metadata["colors"]) == "\(colors)"
      }
      _ = AngularGradientColor(colors: colors, startPoint: .left, endPoint: .right)
      Assert.resetTestAssertionFailureHandler()
    }

    // locations count mismatch
    do {
      let colors = [Color.red, Color.blue]
      let locations: [CGFloat] = [0, 0.2, 1]
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "locations should have the same count as colors"
        expect(metadata["colors"]) == "\(colors)"
        expect(metadata["locations"]) == "\(locations)"
      }
      _ = AngularGradientColor(colors: colors, locations: locations, startPoint: .left, endPoint: .right)
      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_withComponents() {
    let gradient = AngularGradientColor(
      colors: [Color.red, Color.blue],
      startPoint: .top,
      endPoint: .bottom
    )
    let newGradient = gradient.withComponents(colors: [Color.blue, Color.red], locations: [0, 1], startPoint: .bottom, endPoint: .top)
    expect(newGradient.colors) == [Color.blue, Color.red]
    expect(newGradient.locations) == [0, 1]
    expect(newGradient.startPoint) == UnitPoint.bottom
    expect(newGradient.endPoint) == UnitPoint.top
  }
}
