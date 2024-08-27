//
//  CGSize+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 5/29/21.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiTest

import ChouTi
import ChouTiUI

class CGSize_ExtensionsTests: XCTestCase {

  func testInit() {
    expect(CGSize(100, 200)) == CGSize(width: 100, height: 200)
    expect(CGSize(100)) == CGSize(width: 100, height: 100)
    expect(CGSize(100.2)) == CGSize(width: 100.2, height: 100.2)

    expect(CGSize(width: 100, aspectRatio: 2)) == CGSize(width: 100, height: 50)
    expect(CGSize(height: 200, aspectRatio: 0.5)) == CGSize(width: 100, height: 200)
  }

  func testOperators() {
    expect(-CGSize(100, 200)) == CGSize(width: -100, height: -200)

    let size1 = CGSize(12.9, 23.3)
    let size2 = CGSize(2.5, 3.8)
    expect(size1 + size2) == CGSize(15.4, 27.1)
    expect(size1 - size2) == CGSize(10.4, 19.5)
    expect(size1 * size2) == CGSize(32.25, 88.53999999999999)
    expect(size1 / size2) == CGSize(5.16, 6.131578947368421)

    var size = size1
    size += size2
    expect(size) == CGSize(15.4, 27.1)
    size = size1
    size -= size2
    expect(size) == CGSize(10.4, 19.5)
    size = size1
    size *= size2
    expect(size) == CGSize(32.25, 88.53999999999999)
    size = size1
    size /= size2
    expect(size) == CGSize(5.16, 6.131578947368421)

    expect(size1 * 2) == CGSize(25.8, 46.6)
    expect(size1 / 2) == CGSize(6.45, 11.65)
    size = size1
    size *= 2
    expect(size) == CGSize(25.8, 46.6)
    size = size1
    size /= 2
    expect(size) == CGSize(6.45, 11.65)
  }

  func testAdding() {
    let size = CGSize(12.9, 23.3)
    expect(size.adding(width: 12.1, height: 26.7)) == CGSize(25, 50)
    expect(size.adding(width: 12.1)) == CGSize(25, 23.3)
    expect(size.adding(height: 26.7)) == CGSize(12.9, 50)
    expect(size.adding()) == CGSize(12.9, 23.3)
  }

  func testSubtracting() {
    let size = CGSize(15, 20)
    expect(size.subtracting(width: 10, height: 5.5)) == CGSize(5, 14.5)
    expect(size.subtracting(width: 10)) == CGSize(5, 20)
    expect(size.subtracting(height: 5.5)) == CGSize(15, 14.5)
    expect(size.subtracting()) == CGSize(15, 20)
  }

  func testMultiply() {
    let size = CGSize(12.9, 23.3)
    expect(size.multiply(by: 2)) == CGSize(25.8, 46.6)
    expect(size.multiply(by: 0)) == CGSize.zero
    expect(size.multiply(by: -1)) == CGSize(-12.9, -23.3)
    expect(size.multiply(by: 0.5)) == CGSize(6.45, 11.65)
    expect(size.multiply(by: 1)) == CGSize(12.9, 23.3)
  }

  func testInset() {
    let size = CGSize(12.9, 23.3)
    expect(size.inset(2)) == CGSize(8.9, 19.3)
    expect(size.inset(3, 6)) == CGSize(6.9, 11.3)
    expect(size.inset(horizontal: 3, vertical: 6)) == CGSize(6.9, 11.3)
    expect(size.inset(0)) == CGSize(12.9, 23.3)
    expect(size.inset(-2)) == CGSize(16.9, 27.3)
  }

  func testWithWidth() {
    let size = CGSize(12.9, 23.3)
    expect(size.width(10)) == CGSize(10, 23.3)
  }

  func testWithHeight() {
    let size = CGSize(12.9, 23.3)
    expect(size.height(10)) == CGSize(12.9, 10)
  }

  func testIsPositive() {
    let size = CGSize(12.9, 23.3)
    expect(size.isPositive) == true

    let size2 = CGSize(-12.9, 23.3)
    expect(size2.isPositive) == false
  }

  func testIsNonNegative() {
    let size1 = CGSize(12.9, 23.3)
    expect(size1.isNonNegative) == true

    let size2 = CGSize(-12.9, 23.3)
    expect(size2.isNonNegative) == false

    let size3 = CGSize(-12.9, -23.3)
    expect(size3.isNonNegative) == false
  }

  func testArea() {
    let size1 = CGSize(12, 23)
    expect(size1.area) == 276
  }

  func testAspectRatio() {
    let size1 = CGSize(12, 23)
    expect(size1.aspectRatio) == 0.5217391304347826
  }

  func testShape() {
    expect(CGSize(12, 23).isPortrait) == true
    expect(CGSize(32, 23).isPortrait) == false
    expect(CGSize(32, 32).isPortrait) == true

    expect(CGSize(12, 23).isLandScape) == false
    expect(CGSize(32, 23).isLandScape) == true
    expect(CGSize(32, 32).isLandScape) == false

    expect(CGSize(12, 23).isSquare) == false
    expect(CGSize(32, 23).isSquare) == false
    expect(CGSize(32, 32).isSquare) == true
  }

  func testRoundUpWithScaleFactor() {
    var size2 = CGSize(12.4, 23.7)
    size2.roundUp(scaleFactor: 2)
    expect(size2) == CGSize(12.5, 24)
    size2.roundUp(scaleFactor: 2)
    expect(size2) == CGSize(12.5, 24)
    size2.roundUp(scaleFactor: 1)
    expect(size2) == CGSize(13, 24)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Scale factor must be positive."
      expect(metadata) == ["scaleFactor": "0.0"]
    }

    size2.roundUp(scaleFactor: 0)

    Assert.resetTestAssertionFailureHandler()
  }

  func testRoundedUpWithScaleFactor() {
    let size = CGSize(12.9, 23.3)
    expect(size.roundedUp()) == CGSize(13, 24)
    expect(size.roundedUp(scaleFactor: 2)) == CGSize(13, 23.5)
    expect(size.roundedUp(scaleFactor: 3)) == CGSize(13, 23.333333333333332)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Scale factor must be positive."
      expect(metadata) == ["scaleFactor": "0.0"]
    }

    expect(CGSize(12, 13).roundedUp(scaleFactor: 0)) == CGSize.zero

    Assert.resetTestAssertionFailureHandler()
  }

  func testRounded() {
    let size = CGSize(12.9, 23.3)
    expect(size.rounded(scaleFactor: 2)) == CGSize(13, 23.5)
    expect(size.rounded(scaleFactor: 3)) == CGSize(13, 23.333333333333332)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Scale factor must be positive."
      expect(metadata) == ["scaleFactor": "0.0"]
    }

    expect(CGSize(12, 13).rounded(scaleFactor: 0)) == CGSize.zero

    Assert.resetTestAssertionFailureHandler()
  }

  func testRoundUp() {
    var size3 = CGSize(12.4, 23.7)
    size3.roundUp()
    expect(size3) == CGSize(13, 24)
  }

  func testApproximatelyEqual() {
    let pixelSize = 1 / CGFloat(3)
    let absoluteTolerance = pixelSize + 1e-12

    var size1 = CGSize(23.333333333333332, 0.5217391304347826)
    var size2 = CGSize(23.333333333333331, 0.5217391304347826)
    expect(size1) == size2
    expect(size1 == size2) == true
    expect(size1.equalTo(size2)) == true

    size1 = CGSize(23.333333333333332, 0.5217391304347826)
    size2 = CGSize(23.333333333333330, 0.5217391304347826)
    expect(size1) != size2
    expect(size1 == size2) == false
    expect(size1.equalTo(size2)) == false
    expect(size1.isApproximatelyEqual(to: size2, absoluteTolerance: absoluteTolerance)) == true

    size1 = CGSize(187.33333333333331, 135.66666666666666)
    size2 = CGSize(187.66666666666666, 135.66666666666666)
    expect(size1) != size2
    expect(size1 == size2) == false
    expect(size1.equalTo(size2)) == false
    expect(size1.isApproximatelyEqual(to: size2, absoluteTolerance: absoluteTolerance)) == true
  }

  func testOrientation() {
    expect(CGSize(12, 23).orientation) == .portrait
    expect(CGSize(23, 12).orientation) == .landscape
    expect(CGSize(0, 0).orientation) == .portrait
    expect(CGSize(12, 12).orientation) == .portrait
    expect(CGSize(0, 12).orientation) == .portrait
    expect(CGSize(12, 0).orientation) == .portrait
    expect(CGSize(-10, 12).orientation) == .portrait
    expect(CGSize(12, -10).orientation) == .portrait
  }

  func testHashable() {
    let size1 = CGSize(12, 23)
    let size2 = CGSize(12, 23)
    expect(size1.hashValue) == size2.hashValue
  }
}
