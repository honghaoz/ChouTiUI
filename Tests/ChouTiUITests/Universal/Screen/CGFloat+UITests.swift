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
    #else
    if let mainScreen = Screen.mainScreen() {
      if mainScreen.is3x {
        expect(mainScreen.halfPoint) == mainScreen.pixelSize * 2
      } else if mainScreen.is2x {
        expect(mainScreen.halfPoint) == mainScreen.pixelSize
      } else {
        expect(mainScreen.halfPoint) == mainScreen.pixelSize
      }
    }
    #endif
  }
}
