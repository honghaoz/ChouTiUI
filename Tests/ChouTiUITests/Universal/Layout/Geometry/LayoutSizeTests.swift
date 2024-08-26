//
//  LayoutSizeTests.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiUI
import ChouTiTest

class LayoutSizeTests: XCTestCase {

  func testZero() {
    let size = LayoutSize.zero
    expect(size.width) == .absolute(0)
    expect(size.height) == .absolute(0)
  }

  func testInitialization() {
    let size = LayoutSize(.absolute(10), .absolute(20))
    expect(size.width) == .absolute(10)
    expect(size.height) == .absolute(20)

    let size2 = LayoutSize(width: .absolute(10), height: .absolute(20))
    expect(size2.width) == .absolute(10)
    expect(size2.height) == .absolute(20)
  }

  func testIsZero() {
    let size = LayoutSize.zero
    expect(size.isZero()) == true

    let size2 = LayoutSize(.absolute(10), .absolute(20))
    expect(size2.isZero()) == false

    let size3 = LayoutSize(width: .absolute(10), height: .absolute(0))
    expect(size3.isZero()) == false

    let size4 = LayoutSize(width: .absolute(0), height: .absolute(20))
    expect(size4.isZero()) == false
  }

  func testCGSizeFromContainerSize() {
    let size = LayoutSize(.relative(0.1), .relative(0.2))
    let containerSize = CGSize(width: 100, height: 200)
    let cgSize = size.cgSize(from: containerSize)
    expect(cgSize.width) == 10
    expect(cgSize.height) == 40
  }
}
