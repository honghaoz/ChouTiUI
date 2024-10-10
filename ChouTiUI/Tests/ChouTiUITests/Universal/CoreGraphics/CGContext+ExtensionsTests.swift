//
//  CGContext+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/6/24.
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

import CoreGraphics

import ChouTiTest

import ChouTiUI

final class CGContext_ExtensionsTests: XCTestCase {

  func testFlipCoordinatesVertically() throws {
    // matching height
    do {
      let context = try CGContext(
        data: nil,
        width: 200,
        height: 100,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
      ).unwrap()
      expect(context.ctm) == CGAffineTransform.identity
      context.flipCoordinatesVertically(height: 100)
      expect(context.ctm) == CGAffineTransform(a: 1.0, b: 0, c: 0, d: -1, tx: 0, ty: 100.0)
    }

    // smaller height
    do {
      let context = try CGContext(
        data: nil,
        width: 200,
        height: 100,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
      ).unwrap()
      expect(context.ctm) == CGAffineTransform.identity
      context.flipCoordinatesVertically(height: 30)
      expect(context.ctm) == CGAffineTransform(a: 1.0, b: 0.0, c: -0.0, d: -1.0, tx: 0.0, ty: 30.0)
    }
  }

  func testFlipCoordinatesVertically_usingLayer() {
    let expectation = self.expectation(description: "draw")

    class TestLayer: CALayer {

      var expectation: XCTestExpectation?

      override func draw(in context: CGContext) {
        let scale = contentsScale

        #if os(macOS)
        context.flipCoordinatesVertically(height: bounds.height)
        #endif

        expect(context.ctm) == CGAffineTransform(a: scale, b: 0, c: 0, d: -scale, tx: 0, ty: bounds.height * scale)
        context.flipCoordinatesVertically(height: bounds.height)
        expect(context.ctm) == CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: 0, ty: 0)

        super.draw(in: context)

        expectation?.fulfill()
      }
    }

    let layer = TestLayer()
    layer.contentsScale = 2.0
    layer.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
    layer.expectation = expectation

    // trigger draw
    layer.setNeedsDisplay()
    layer.displayIfNeeded()

    waitForExpectations(timeout: 1)
  }

  func testFlipCoordinatesVertically_usingView() {
    let expectation = self.expectation(description: "draw")

    class TestView: View {

      var expectation: XCTestExpectation?

      #if os(macOS)
      // isFlipped has no effect on the drawing context
      // override var isFlipped: Bool { true }

      override init(frame: CGRect) {
        super.init(frame: frame)

        wantsLayer = true
      }

      @available(*, unavailable)
      public required init?(coder: NSCoder) {
        // swiftlint:disable:next fatal_error
        fatalError("init(coder:) is unavailable")
      }
      #endif

      override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = CGContext.current else {
          fail("Failed to get current CGContext")
          return
        }

        #if os(macOS)
        context.flipCoordinatesVertically(height: bounds.height)
        #endif

        let scale = self.unsafeLayer.contentsScale
        expect(context.ctm) == CGAffineTransform(a: scale, b: 0, c: 0, d: -scale, tx: 0, ty: bounds.height * scale)
        context.flipCoordinatesVertically(height: bounds.height)
        expect(context.ctm) == CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: 0, ty: 0)

        expectation?.fulfill()
      }
    }

    let view = TestView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    view.expectation = expectation
    #if os(macOS)
    view.setNeedsDisplay(.zero)
    view.display()
    #else
    view.layer()?.setNeedsDisplay()
    view.layer()?.displayIfNeeded()
    #endif

    waitForExpectations(timeout: 1)
  }

  func testOnPushedGraphicsState() throws {
    let context = try CGContext(
      data: nil,
      width: 100,
      height: 100,
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ).unwrap()

    func drawLine(y: CGFloat, color: CGColor) {
      context.setStrokeColor(color)

      context.beginPath()
      context.move(to: CGPoint(x: 0, y: y))
      context.addLine(to: CGPoint(x: 100, y: y))
      context.strokePath()
    }

    func measureHorizontalLineWidth(in image: CGImage,
                                    lineColor: CGColor,
                                    file: StaticString = #filePath,
                                    line: UInt = #line) -> CGFloat
    {
      guard let data = image.dataProvider?.data,
            let pointer = CFDataGetBytePtr(data)
      else {
        fail("Failed to get image data", file: file, line: line)
        return 0
      }

      let bytesPerRow = image.bytesPerRow
      let bytesPerPixel = image.bitsPerPixel / 8
      let midX = image.width / 2

      expect(image.alphaInfo, file: file, line: line) == .premultipliedLast

      let components = lineColor.components ?? [0, 0, 0, 1]
      let expectedRed = UInt8(components[0] * 255)
      let expectedGreen = UInt8(components[1] * 255)
      let expectedBlue = UInt8(components[2] * 255)
      let expectedAlpha = UInt8(components[3] * 255)

      var startY: Int?
      var endY: Int?

      for y in 0 ..< image.height {
        let offset = y * bytesPerRow + midX * bytesPerPixel
        let red = pointer[offset]
        let green = pointer[offset + 1]
        let blue = pointer[offset + 2]
        let alpha = pointer[offset + 3]

        // Check if the pixel is the line color and not transparent (255 alpha)
        if red == expectedRed, green == expectedGreen, blue == expectedBlue, alpha == expectedAlpha {
          if startY == nil {
            startY = y
          }
          endY = y
        } else if startY != nil {
          // we've found the end of the line
          break
        }
      }

      guard let start = startY, let end = endY else {
        fail("Failed to find line in image", file: file, line: line)
        return 0
      }

      return CGFloat(end - start + 1)
    }

    // set line width to 10
    let lineWidth: CGFloat = 10
    context.setLineWidth(lineWidth)

    // verify line width is 10
    do {
      let lineColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
      drawLine(y: 20, color: lineColor)
      expect(try measureHorizontalLineWidth(in: context.makeImage().unwrap(), lineColor: lineColor)) == lineWidth
    }

    // set line width to 20 on a pushed graphics state
    try context.onPushedGraphicsState { context in
      let lineWidth: CGFloat = 20
      context.setLineWidth(lineWidth)

      // verify line width is 20
      let lineColor = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
      drawLine(y: 50, color: lineColor)
      expect(try measureHorizontalLineWidth(in: context.makeImage().unwrap(), lineColor: lineColor)) == lineWidth
    }

    // verify line width is still 10
    do {
      let lineColor = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
      drawLine(y: 80, color: lineColor)
      expect(try measureHorizontalLineWidth(in: context.makeImage().unwrap(), lineColor: lineColor)) == lineWidth
    }
  }
}
