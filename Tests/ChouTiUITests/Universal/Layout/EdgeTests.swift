//
//  EdgeTests.swift
//
//  Created by Honghao Zhang on 3/18/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiUI
import ChouTiTest

#if os(macOS)
import AppKit
#endif

class EdgeTests: XCTestCase {

  func test_flipped() {
    expect(Edge.top.flipped()) == Edge.bottom
    expect(Edge.left.flipped()) == Edge.right
    expect(Edge.bottom.flipped()) == Edge.top
    expect(Edge.right.flipped()) == Edge.left
  }

  #if os(macOS)
  func test_rectEdge() {
    expect(Edge.top.rectEdge) == NSRectEdge.minY
    expect(Edge.left.rectEdge) == NSRectEdge.minX
    expect(Edge.bottom.rectEdge) == NSRectEdge.maxY
    expect(Edge.right.rectEdge) == NSRectEdge.maxX
  }
  #endif
}
