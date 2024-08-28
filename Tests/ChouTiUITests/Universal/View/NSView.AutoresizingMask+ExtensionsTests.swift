//
//  NSView.AutoresizingMask+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit
import ChouTiTest
import ChouTiUI

class NSView_AutoresizingMask_ExtensionsTests: XCTestCase {

  func test() {
    expect(NSView.AutoresizingMask.flexibleWidth) == .width
    expect(NSView.AutoresizingMask.flexibleHeight) == .height
    expect(NSView.AutoresizingMask.flexibleLeftMargin) == .minXMargin
    expect(NSView.AutoresizingMask.flexibleRightMargin) == .maxXMargin
    expect(NSView.AutoresizingMask.flexibleTopMargin) == .minYMargin
    expect(NSView.AutoresizingMask.flexibleBottomMargin) == .maxYMargin
  }
}

#endif
