//
//  NSRectCornerTests.swift
//
//  Created by Honghao Zhang on 3/27/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import ChouTiUI
import ChouTiTest

class NSRectCornerTests: XCTestCase {

  func testInit() {
    expect(NSRectCorner.topLeft.rawValue) == 1
    expect(NSRectCorner.topRight.rawValue) == 2
    expect(NSRectCorner.bottomLeft.rawValue) == 4
    expect(NSRectCorner.bottomRight.rawValue) == 8
    expect(NSRectCorner.allCorners.rawValue) == 15
  }
}

#endif
