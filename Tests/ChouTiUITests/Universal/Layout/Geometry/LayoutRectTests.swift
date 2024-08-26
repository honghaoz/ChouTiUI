//
//  LayoutRectTests.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiUI
import ChouTiTest

class LayoutRectTests: XCTestCase {

  func testZero() {
    let rect = LayoutRect.zero
    expect(rect.origin) == LayoutPoint.zero
    expect(rect.size) == LayoutSize.zero
  }

  func testInitialization() {
    let rect = LayoutRect(LayoutPoint(.absolute(10), .absolute(20)), LayoutSize(.absolute(30), .absolute(40)))
    expect(rect.origin) == LayoutPoint(.absolute(10), .absolute(20))
    expect(rect.size) == LayoutSize(.absolute(30), .absolute(40))

    let rect2 = LayoutRect(origin: LayoutPoint(.absolute(10), .absolute(20)), size: LayoutSize(.absolute(30), .absolute(40)))
    expect(rect2.origin) == LayoutPoint(.absolute(10), .absolute(20))
    expect(rect2.size) == LayoutSize(.absolute(30), .absolute(40))
  }

  func testIsZero() {
    let rect = LayoutRect.zero
    expect(rect.isZero()) == true

    let rect2 = LayoutRect(LayoutPoint(.absolute(10), .absolute(20)), LayoutSize(.absolute(30), .absolute(40)))
    expect(rect2.isZero()) == false

    let rect3 = LayoutRect(origin: LayoutPoint(.absolute(0), .absolute(0)), size: LayoutSize(.absolute(30), .absolute(40)))
    expect(rect3.isZero()) == false

    let rect4 = LayoutRect(origin: LayoutPoint(.absolute(10), .absolute(20)), size: .zero)
    expect(rect4.isZero()) == false
  }

  func testCGRectFromContainerSize() {
    let rect = LayoutRect(LayoutPoint(.relative(0.2), .relative(0.3)), LayoutSize(.relative(0.4), .relative(0.5)))
    let cgRect = rect.cgRect(from: CGSize(width: 100, height: 100))
    expect(cgRect) == CGRect(x: 20, y: 30, width: 40, height: 50)
  }
}
