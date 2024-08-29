//
//  CGFloat+UITests.swift
//
//  Created by Honghao Zhang on 8/29/24.
//  Copyright © 2024 ChouTi. All rights reserved.
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

class CGFloatUITests: XCTestCase {

  func test_pixel() {
    expect(CGFloat.pixel) == 1 / Screen.mainScreenScale
  }

  func test_pixelTolerance() {
    expect(CGFloat.pixelTolerance) == CGFloat.pixel + 1e-12
  }

  func test_point() {
    expect(CGFloat.point) == 1
  }

  func test_halfPoint() {
    #if os(visionOS)
    expect(CGFloat.halfPoint) == 1 / Sizing.visionOS.scaleFactor
    #elseif os(iOS)
    expect(CGFloat.halfPoint) == 0.6666666666666666
    #elseif os(macOS)
    expect(CGFloat.halfPoint) == 0.5
    #endif
  }
}