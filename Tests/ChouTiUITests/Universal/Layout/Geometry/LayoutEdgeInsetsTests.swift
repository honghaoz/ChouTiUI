//
//  LayoutEdgeInsetsTests.swift
//
//  Created by Honghao Zhang on 6/12/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import CoreGraphics
import ChouTiTest
import ChouTiUI

class LayoutEdgeInsetsTests: XCTestCase {

  func testInitializeFromLayoutDimension() {
    let edgeInsets = LayoutEdgeInsets(top: .relative(0.2), left: .absolute(10), bottom: .mixed(0.5, 20), right: .absolute(20))
    expect(edgeInsets.top) == LayoutDimension.relative(0.2)
    expect(edgeInsets.left) == LayoutDimension.absolute(10)
    expect(edgeInsets.bottom) == LayoutDimension.mixed(0.5, 20)
    expect(edgeInsets.right) == LayoutDimension.absolute(20)
  }

  func testInitializeFromLayoutDimension2() {
    let edgeInsets = LayoutEdgeInsets(.relative(0.2), .absolute(10), .mixed(0.5, 20), .absolute(20))
    expect(edgeInsets.top) == LayoutDimension.relative(0.2)
    expect(edgeInsets.left) == LayoutDimension.absolute(10)
    expect(edgeInsets.bottom) == LayoutDimension.mixed(0.5, 20)
    expect(edgeInsets.right) == LayoutDimension.absolute(20)
  }

  func testInitializeWithSingleAmount() {
    let amount: CGFloat = 15
    let edgeInsets = LayoutEdgeInsets(amount)

    expect(edgeInsets.top) == LayoutDimension.absolute(amount)
    expect(edgeInsets.left) == LayoutDimension.absolute(amount)
    expect(edgeInsets.bottom) == LayoutDimension.absolute(amount)
    expect(edgeInsets.right) == LayoutDimension.absolute(amount)

    // Additional test to ensure all sides are equal
    expect(edgeInsets.top) == edgeInsets.left
    expect(edgeInsets.left) == edgeInsets.bottom
    expect(edgeInsets.bottom) == edgeInsets.right
  }

  func testInitializeFromEdgeInsets() {
    let edgeInsets = LayoutEdgeInsets(edgeInsets: EdgeInsets(top: 1, left: 2, bottom: 4, right: 5))
    expect(edgeInsets.top) == LayoutDimension.absolute(1)
    expect(edgeInsets.left) == LayoutDimension.absolute(2)
    expect(edgeInsets.bottom) == LayoutDimension.absolute(4)
    expect(edgeInsets.right) == LayoutDimension.absolute(5)
  }

  func testIsZeroFalse() {
    let edgeInsets = LayoutEdgeInsets(.relative(0), .absolute(10), .mixed(0.5, 20), .absolute(20))
    expect(edgeInsets.isZero()) == false
  }

  func testIsZeroTrue() {
    let edgeInsets = LayoutEdgeInsets(.relative(0), .absolute(0), .mixed(0, 0), .absolute(0))
    expect(edgeInsets.isZero()) == true
  }

  func testEdgeInsetsFromSize() {
    let layoutEdgeInsets = LayoutEdgeInsets(.relative(0.2), .absolute(10), .mixed(0.5, 20), .absolute(20))
    let edgeInsets = layoutEdgeInsets.edgeInsets(from: CGSize(width: 100, height: 100))
    expect(edgeInsets.top) == 20
    expect(edgeInsets.left) == 10
    expect(edgeInsets.bottom) == 70
    expect(edgeInsets.right) == 20
  }
}
