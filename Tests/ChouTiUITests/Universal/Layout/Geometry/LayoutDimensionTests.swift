//
//  LayoutDimensionTests.swift
//
//  Created by Honghao Zhang on 11/2/21.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiUI
import ChouTiTest

class LayoutDimensionTests: XCTestCase {

  func testLength() {
    expect(LayoutDimension.absolute(3).length(from: 100)) == 3
    expect(LayoutDimension.relative(0.25).length(from: 100)) == 25
    expect(LayoutDimension.relative(2).length(from: 100)) == 200
    expect(LayoutDimension.mixed(0.25, 3).length(from: 100)) == 28
  }

  func testIsZero() {
    expect(LayoutDimension.absolute(3).isZero()) == false
    expect(LayoutDimension.absolute(0).isZero()) == true

    expect(LayoutDimension.relative(0.25).isZero()) == false
    expect(LayoutDimension.relative(0).isZero()) == true

    expect(LayoutDimension.mixed(0.25, 3).isZero()) == false
    expect(LayoutDimension.mixed(0.25, 0).isZero()) == false
    expect(LayoutDimension.mixed(0, 3).isZero()) == false
    expect(LayoutDimension.mixed(0, 0).isZero()) == true
  }

  func testPlusOperator() {
    expect(LayoutDimension.absolute(3) + LayoutDimension.absolute(6)) == .absolute(9)
    expect(LayoutDimension.absolute(3) + LayoutDimension.relative(0.6)) == .mixed(0.6, 3)
    expect(LayoutDimension.absolute(3) + LayoutDimension.mixed(0.6, 9)) == .mixed(0.6, 12)

    expect(LayoutDimension.relative(3) + LayoutDimension.absolute(6)) == .mixed(3, 6)
    expect(LayoutDimension.relative(0.5) + LayoutDimension.relative(0.6)) == .relative(1.1)
    expect(LayoutDimension.relative(3) + LayoutDimension.mixed(0.6, 9)) == .mixed(3.6, 9)

    expect(LayoutDimension.mixed(3, 5) + LayoutDimension.absolute(6)) == .mixed(3, 11)
    expect(LayoutDimension.mixed(0.5, 4) + LayoutDimension.relative(0.6)) == .mixed(1.1, 4)
    expect(LayoutDimension.mixed(0, 2) + LayoutDimension.mixed(0.6, 9)) == .mixed(0.6, 11)
  }
}
