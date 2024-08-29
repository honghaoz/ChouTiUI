//
//  Screen+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 8/28/24.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest
import ChouTiUI

class Screen_ExtensionsTests: XCTestCase {

  func testMainScreenScale() {
    #if os(macOS)
    expect(Screen.mainScreenScale) == NSScreen.main?.backingScaleFactor ?? 2
    #elseif os(visionOS)
    expect(Screen.mainScreenScale) == Sizing.visionOS.scaleFactor
    #else
    expect(Screen.mainScreenScale) == UIScreen.main.scale
    #endif
  }

  #if !os(visionOS)

  func testMainScreen() {
    #if os(macOS)
    expect(Screen.mainScreen()) == NSScreen.main
    #else
    expect(Screen.mainScreen()) == UIScreen.main
    #endif
  }

  func testPixelSize() {
    expect(Screen.mainScreen()?.pixelSize) == 1 / Screen.mainScreenScale
  }

  func testHalfPoint() {
    if let mainScreen = Screen.mainScreen() {
      if mainScreen.is3x {
        expect(mainScreen.halfPoint) == mainScreen.pixelSize * 2
      } else if mainScreen.is2x {
        expect(mainScreen.halfPoint) == mainScreen.pixelSize
      } else {
        expect(mainScreen.halfPoint) == mainScreen.pixelSize
      }
    }
  }

  func testIs3x() {
    expect(Screen.mainScreen()?.is3x) == (Screen.mainScreenScale == 3)
  }

  func testIs2x() {
    expect(Screen.mainScreen()?.is2x) == (Screen.mainScreenScale == 2)
  }

  @available(iOS 10.3, macOS 12.0, *)
  func testMinimumRefreshInterval() {
    if let mainScreen = Screen.mainScreen() {
      expect(mainScreen.minimumRefreshInterval).to(beApproximatelyEqual(to: 1 / Double(mainScreen.maximumFramesPerSecond), within: 1e-9))
    }
  }

  #endif
}
