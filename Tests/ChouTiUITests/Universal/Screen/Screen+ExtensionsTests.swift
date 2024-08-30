//
//  Screen+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/28/24.
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
