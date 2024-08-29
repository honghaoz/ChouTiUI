//
//  NSView+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 8/28/24.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)
import AppKit

import ChouTiTest
import ChouTiUI
import ChouTi

class NSView_ExtensionsTests: XCTestCase {

  func testIgnoreHitTest() {
    let view = NSTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    // verify hit test
    expect(view.ignoreHitTest) == false
    let point = CGPoint(x: 5, y: 5)
    let hitView = view.hitTest(point)
    expect(hitView) === view

    // verify ignore hit test
    view.ignoreHitTest = true
    expect(view.ignoreHitTest) == true
    let hitView2 = view.hitTest(point)
    expect(hitView2) == nil
  }
}

#endif
