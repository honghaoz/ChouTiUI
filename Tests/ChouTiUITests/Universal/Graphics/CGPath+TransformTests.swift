//
//  CGPath+TransformTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/17/21.
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

import ChouTiTest

import ChouTi

class CGPath_TransformTests: XCTestCase {

  // MARK: - Resizing

  func test_resizing_fill() {
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let newSize = CGSize(width: 200, height: 150)

    // resize
    let resizedPath = path.resizing(to: newSize, mode: .fill)

    let newBounds = resizedPath.boundingBox
    expect(
      newBounds.isApproximatelyEqual(to: CGRect(x: 0, y: 0, width: 200, height: 150), absoluteTolerance: 1e-6)
    ) == true

    expect(resizedPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 0, y: 0)),
      .addLineToPoint(CGPoint(x: 200, y: 0)),
      .addLineToPoint(CGPoint(x: 200, y: 150)),
      .addLineToPoint(CGPoint(x: 0, y: 150)),
      .closeSubpath,
    ]
  }

  func test_resizing_aspectFit() {
    // +---------------+
    // |               |
    // |               |
    // |+-------------+|
    // ||             ||
    // |+-------------+|
    // |               |
    // |               |
    // +---------------+
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let newSize = CGSize(width: 200, height: 300)

    // resize
    let resizedPath = path.resizing(to: newSize, mode: .aspectFit)

    let newBounds = resizedPath.boundingBox
    expect(
      newBounds.isApproximatelyEqual(to: CGRect(x: 0, y: 100, width: 200, height: 100), absoluteTolerance: 1e-6), "\(newBounds)"
    ) == true

    expect(resizedPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 0, y: 100)),
      .addLineToPoint(CGPoint(x: 200, y: 100)),
      .addLineToPoint(CGPoint(x: 200, y: 200)),
      .addLineToPoint(CGPoint(x: 0, y: 200)),
      .closeSubpath,
    ]
  }

  func test_resizing_aspectFill() {
    // +-----+------+------+
    // |     |      |      |
    // |     |      |      |
    // |     |      |      |
    // |     |      |      |
    // +-----+------+------+
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let newSize = CGSize(width: 200, height: 300)

    // resize
    let resizedPath = path.resizing(to: newSize, mode: .aspectFill)

    let newBounds = resizedPath.boundingBox
    expect(
      newBounds.isApproximatelyEqual(to: CGRect(x: -200, y: 0, width: 600, height: 300), absoluteTolerance: 1e-6), "\(newBounds)"
    ) == true

    expect(resizedPath.pathElements()) == [
      .moveToPoint(CGPoint(x: -200, y: 0)),
      .addLineToPoint(CGPoint(x: 400, y: 0)),
      .addLineToPoint(CGPoint(x: 400, y: 300)),
      .addLineToPoint(CGPoint(x: -200, y: 300)),
      .closeSubpath,
    ]
  }

  func test_resizing_curve() {
    // test a curve with control point that is out of the path
    let path = CGMutablePath()
    path.move(to: CGPoint.zero)
    path.addCurve(to: CGPoint(x: 100, y: 100), control1: CGPoint(x: -50, y: 100), control2: CGPoint(x: 100, y: 200))
    path.closeSubpath()

    expect(path.boundingBox) == CGRect(x: -50, y: 0, width: 150, height: 200)
    expect(path.boundingBoxOfPath) == CGRect(-10.204081632653061, 0.0, 110.20408163265306, 141.4213562373095)

    let newSize = CGSize(width: 200, height: 200)
    let resizedPath = path.resizing(to: newSize, mode: .aspectFit)

    let newBoundingBox = resizedPath.boundingBox
    expect(
      newBoundingBox.isApproximatelyEqual(to: CGRect(-34.205980919079416, 0.0, 212.13203435596424, 282.84271247461896), absoluteTolerance: 1e-6), "\(newBoundingBox)"
    ) == true

    let newBoundingBoxOfPath = resizedPath.boundingBoxOfPath
    expect(
      newBoundingBoxOfPath.isApproximatelyEqual(to: CGRect(22.073946563115182, 0.0, 155.85210687376963, 199.99999999999997), absoluteTolerance: 1e-6), "\(newBoundingBoxOfPath)"
    ) == true
  }

  // MARK: - Resized

  func test_resized_fill() {
    // +------------------------+
    // |                        |
    // | +-------------+        |
    // | |             |        |
    // | +-------------+        |
    // |                        |
    // |                        |
    // |                        |
    // +------------------------+

    // +---------------+
    // |               |
    // |  +----+       |
    // |  |    |       |
    // |  |    |       |
    // |  +----+       |
    // |               |
    // |               |
    // |               |
    // |               |
    // |               |
    // |               |
    // +---------------+
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let oldSize = CGSize(width: 200, height: 200)
    let newSize = CGSize(width: 50, height: 100)

    // x:
    // old: |--10--|--100--|--90--|
    // new: |--2.5--|--25--|--22.5--|

    // y:
    // old: |--20--|--50--|--130--|
    // new: |--10--|--25--|--65--|

    let resizedPath = path.resized(from: oldSize, to: newSize, mode: .fill)

    let newBounds = resizedPath.boundingBox
    expect(
      newBounds.isApproximatelyEqual(to: CGRect(2.5, 10.0, 25.0, 25.0), absoluteTolerance: 1e-6), "\(newBounds)"
    ) == true

    expect(resizedPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 2.5, y: 10.0)),
      .addLineToPoint(CGPoint(x: 27.5, y: 10.0)),
      .addLineToPoint(CGPoint(x: 27.5, y: 35.0)),
      .addLineToPoint(CGPoint(x: 2.5, y: 35.0)),
      .closeSubpath,
    ]
  }

  func test_resized_aspectFit() {
    // +------------------------+
    // |                        |
    // | +-------------+        |
    // | |             |        |
    // | +-------------+        |
    // |                        |
    // |                        |
    // |                        |
    // +------------------------+

    // +---------------+
    // |               |
    // |  +----+       |
    // |  +----+       |
    // |               |
    // |               |
    // |               |
    // |               |
    // |               |
    // |               |
    // |               |
    // |               |
    // +---------------+

    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let oldSize = CGSize(width: 200, height: 200)
    let newSize = CGSize(width: 50, height: 100)

    let resizedPath = path.resized(from: oldSize, to: newSize, mode: .aspectFit)

    let newBounds = resizedPath.boundingBox
    expect(
      newBounds.isApproximatelyEqual(to: CGRect(2.5, 30.0, 25.0, 12.5), absoluteTolerance: 1e-6), "\(newBounds)"
    ) == true

    expect(resizedPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 2.5, y: 30.0)),
      .addLineToPoint(CGPoint(x: 27.5, y: 30.0)),
      .addLineToPoint(CGPoint(x: 27.5, y: 42.5)),
      .addLineToPoint(CGPoint(x: 2.5, y: 42.5)),
      .closeSubpath,
    ]
  }

  func test_resized_invalid() {
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let oldSize = CGSize(width: 200, height: 200)
    let newSize = CGSize(.nan, .nan)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Failed to resize the path"
      expect(metadata) == ["path": "\(path)", "from": "\(oldSize)", "to": "\(newSize)"]
    }

    expect(path.resized(from: oldSize, to: newSize, mode: .aspectFit)) == path
    expect(path.resized(from: oldSize, to: newSize, mode: .aspectFill)) == path
    expect(path.resized(from: oldSize, to: newSize, mode: .fill)) == path

    Assert.resetTestAssertionFailureHandler()
  }

  // MARK: - Transform

  func test_transform_identity() {
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let transformedPath = path.transform(CGAffineTransform.identity)
    expect(transformedPath) == path
  }

  func test_transform_scale() {
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(ellipseIn: rect, transform: nil)

    var scale = CGAffineTransform.scale(2, 2)
    let transformedPath = path.transform(scale)
    expect(transformedPath) == CGPath(ellipseIn: rect, transform: &scale)
    print(transformedPath.boundingBoxOfPath)
    expect(transformedPath) == CGPath(ellipseIn: CGRect(x: 20, y: 40, width: 200, height: 100), transform: nil)
  }

  // MARK: - Translate

  func test_translate_point() {
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let translatedPath = path.translate(CGPoint(x: 10, y: 20))

    let newBounds = translatedPath.boundingBox
    expect(
      newBounds.isApproximatelyEqual(to: CGRect(20.0, 40.0, 100.0, 50.0), absoluteTolerance: 1e-6), "\(newBounds)"
    ) == true

    expect(translatedPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 20.0, y: 40.0)),
      .addLineToPoint(CGPoint(x: 120.0, y: 40.0)),
      .addLineToPoint(CGPoint(x: 120.0, y: 90.0)),
      .addLineToPoint(CGPoint(x: 20.0, y: 90.0)),
      .closeSubpath,
    ]
  }

  func test_translate_dx_dy() {
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let translatedPath = path.translate(dx: 10, dy: 20)

    let newBounds = translatedPath.boundingBox
    expect(
      newBounds.isApproximatelyEqual(to: CGRect(20.0, 40.0, 100.0, 50.0), absoluteTolerance: 1e-6), "\(newBounds)"
    ) == true

    expect(translatedPath.pathElements()) == [
      .moveToPoint(CGPoint(x: 20.0, y: 40.0)),
      .addLineToPoint(CGPoint(x: 120.0, y: 40.0)),
      .addLineToPoint(CGPoint(x: 120.0, y: 90.0)),
      .addLineToPoint(CGPoint(x: 20.0, y: 90.0)),
      .closeSubpath,
    ]
  }

  func test_translate_invalid() {
    let rect = CGRect(x: 10, y: 20, width: 100, height: 50)
    let path = CGPath(rect: rect, transform: nil)

    let dx: CGFloat = .nan
    let dy: CGFloat = .nan

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Failed to transform the path"
      expect(metadata) == ["path": "\(path)", "transform": "\(CGAffineTransform.translation(dx, dy))"]
    }

    let translatedPath = path.translate(dx: dx, dy: dy)

    expect(translatedPath) == path

    Assert.resetTestAssertionFailureHandler()
  }
}
