//
//  LinearGradientColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/3/21.
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

class LinearGradientColorTests: XCTestCase {

  func test_clear() {
    let gradient = LinearGradientColor.clear
    expect(gradient.colors) == [Color.clear, Color.clear]
    expect(gradient.locations) == nil
    expect(gradient.startPoint) == UnitPoint.top
    expect(gradient.endPoint) == UnitPoint.bottom
  }

  #if canImport(QuartzCore)
  func test_gradientLayerType() {
    let gradient = LinearGradientColor([Color.red, Color.blue])
    expect(gradient.gradientLayerType) == CAGradientLayerType.axial
  }
  #endif

  func test_init() {
    // only colors
    do {
      let gradient = LinearGradientColor([Color.red, Color.blue])
      expect(gradient.colors) == [Color.red, Color.blue]
      expect(gradient.locations) == nil
      expect(gradient.startPoint) == UnitPoint.top
      expect(gradient.endPoint) == UnitPoint.bottom
    }

    // colors and locations
    do {
      let gradient = LinearGradientColor([Color.red, Color.blue], [0, 1])
      expect(gradient.colors) == [Color.red, Color.blue]
      expect(gradient.locations) == [0, 1]
      expect(gradient.startPoint) == UnitPoint.top
      expect(gradient.endPoint) == UnitPoint.bottom
    }

    // colors varargs
    do {
      let gradient = LinearGradientColor(Color.red, Color.blue, Color.green)
      expect(gradient.colors) == [Color.red, Color.blue, Color.green]
      expect(gradient.locations) == nil
      expect(gradient.startPoint) == UnitPoint.top
      expect(gradient.endPoint) == UnitPoint.bottom
    }

    // unnamed params
    do {
      let gradient = LinearGradientColor([Color.red, Color.blue], [0, 1], .left, .right)
      expect(gradient.colors) == [Color.red, Color.blue]
      expect(gradient.locations) == [0, 1]
      expect(gradient.startPoint) == UnitPoint.left
      expect(gradient.endPoint) == UnitPoint.right
    }

    // named params
    do {
      let gradient = LinearGradientColor(
        colors: [Color.red, Color.blue],
        locations: [0, 1],
        startPoint: .left,
        endPoint: .right
      )
      expect(gradient.colors) == [Color.red, Color.blue]
      expect(gradient.locations) == [0, 1]
      expect(gradient.startPoint) == UnitPoint.left
      expect(gradient.endPoint) == UnitPoint.right
    }
  }

  func test_init_invalid() {
    // empty colors
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "gradient color should have at least 2 colors."
        expect(metadata["colors"]) == "[]"
      }
      _ = LinearGradientColor([])
      Assert.resetTestAssertionFailureHandler()
    }

    // one color
    do {
      let color = Color.red
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "gradient color should have at least 2 colors."
        expect(metadata["colors"]) == "[\(color)]"
      }
      _ = LinearGradientColor([color])
      Assert.resetTestAssertionFailureHandler()
    }

    // locations count not equal to colors count
    do {
      let colors = [Color.red, Color.blue]
      let locations: [CGFloat] = [0, 1, 2]

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "locations should have the same count as colors"
        expect(metadata["colors"]) == "\(colors)"
        expect(metadata["locations"]) == "\(locations)"
      }
      _ = LinearGradientColor(colors: colors, locations: locations)
      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_cgGradient() {
    let gradient = LinearGradientColor([Color.red, Color.blue], [0, 1], .left, .right)
    expect(gradient.cgGradient) != nil
  }

  func test_draw() {
    let size = CGSize(width: 100, height: 100)

    guard let context = CGContext(
      data: nil,
      width: Int(size.width),
      height: Int(size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: .sRGB(),
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else {
      fail("failed to create CGContext")
      return
    }

    // valid gradient
    do {
      let gradient = LinearGradientColor([Color.red, Color.blue], [0, 1], .left, .right)
      gradient.draw(in: context, start: .zero, end: CGPoint(size.width, size.height))

      guard let cgImage = context.makeImage() else {
        fail("failed to create CGImage")
        return
      }

      #if canImport(AppKit)
      let image = NSImage(cgImage: cgImage, size: size)
      #else
      let image = UIImage(cgImage: cgImage)
      #endif

      // TODO: check the color in the image when `Image.colorAt` is added
      expect(image.size) == size
    }

    // invalid gradient
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "gradient color should have at least 2 colors."
        expect(metadata["colors"]) == "[]"
      }

      let gradient = LinearGradientColor([], nil, .left, .right)

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "failed to get CGGradient"
        expect(metadata["gradient"]) == "\(gradient)"
      }

      gradient.draw(in: context, start: .zero, end: CGPoint(size.width, size.height))

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_withComponents() {
    let gradient = LinearGradientColor([Color.red, Color.blue], [0, 1], .left, .right)
    let newGradient = gradient.withComponents(colors: [Color.blue, Color.red, Color.green], locations: [0, 0.2, 1], startPoint: .right, endPoint: .left)
    expect(newGradient.colors) == [Color.blue, Color.red, Color.green]
    expect(newGradient.locations) == [0, 0.2, 1]
    expect(newGradient.startPoint) == UnitPoint.right
    expect(newGradient.endPoint) == UnitPoint.left
  }

  func test_static() {
    do {
      let gradient = LinearGradientColor.silverChrome
      expect(gradient.colors) == [
        Color(h: 0, s: 0, b: 0.9, a: 1),
        Color(h: 0, s: 0, b: 0.75, a: 1),
        Color(h: 0, s: 0, b: 0.5, a: 1),
      ]
      expect(gradient.locations) == [0, 0.5, 1.0]
      expect(gradient.startPoint) == UnitPoint.top
      expect(gradient.endPoint) == UnitPoint.bottom
    }

    do {
      let gradient = LinearGradientColor.concaveGray
      expect(gradient.colors) == [
        Color(h: 0, s: 0, b: 0.8, a: 1),
        Color(h: 0, s: 0, b: 0.85, a: 1),
        Color(h: 0, s: 0, b: 0.9, a: 1),
      ]
      expect(gradient.locations) == [0, 0.75, 1.0]
    }

    do {
      let gradient = LinearGradientColor.convexGray
      expect(gradient.colors) == [
        Color(h: 0, s: 0, b: 0.9, a: 1),
        Color(h: 0, s: 0, b: 0.8, a: 1),
        Color(h: 0, s: 0, b: 0.7, a: 1),
      ]
      expect(gradient.locations) == [0, 0.5, 1.0]
    }
  }
}
