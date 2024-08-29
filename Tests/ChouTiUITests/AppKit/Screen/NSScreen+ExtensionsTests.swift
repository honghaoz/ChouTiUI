//
//  NSScreen+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 8/28/24.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit
import ChouTiTest
import ChouTiUI

class NSScreen_ExtensionsTests: XCTestCase {

  func testScale() {
    if let screen = NSScreen.main {
      expect(screen.scale) == screen.backingScaleFactor
    }
  }
}

#endif
