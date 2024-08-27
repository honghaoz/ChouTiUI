//
//  MarginTests.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiUI
import ChouTiTest

class MarginTests: XCTestCase {

  func testZero() {
    let margin = Margin.zero
    expect(margin.top) == .absolute(0)
    expect(margin.left) == .absolute(0)
    expect(margin.bottom) == .absolute(0)
    expect(margin.right) == .absolute(0)
  }

  func testHalf() {
    let margin = Margin.half
    expect(margin.top) == .relative(0.5)
    expect(margin.left) == .relative(0.5)
    expect(margin.bottom) == .relative(0.5)
    expect(margin.right) == .relative(0.5)
  }

  func testOne() {
    let margin = Margin.one
    expect(margin.top) == .relative(1)
    expect(margin.left) == .relative(1)
    expect(margin.bottom) == .relative(1)
    expect(margin.right) == .relative(1)
  }

  func testInitialization() {
    let margin = Margin(.absolute(10), .absolute(20), .absolute(30), .absolute(40))
    expect(margin.top) == .absolute(10)
    expect(margin.left) == .absolute(20)
    expect(margin.bottom) == .absolute(30)
    expect(margin.right) == .absolute(40)

    let margin2 = Margin(top: .relative(0.1), left: .relative(0.2), bottom: .relative(0.3), right: .relative(0.4))
    expect(margin2.top) == .relative(0.1)
    expect(margin2.left) == .relative(0.2)
    expect(margin2.bottom) == .relative(0.3)
    expect(margin2.right) == .relative(0.4)

    let margin3 = Margin(10, 20, 30, 40)
    expect(margin3.top) == .absolute(10)
    expect(margin3.left) == .absolute(20)
    expect(margin3.bottom) == .absolute(30)
    expect(margin3.right) == .absolute(40)

    let margin4 = Margin(10)
    expect(margin4.top) == .absolute(10)
    expect(margin4.left) == .absolute(10)
    expect(margin4.bottom) == .absolute(10)
    expect(margin4.right) == .absolute(10)

    let margin5 = Margin(horizontal: 10, vertical: 20)
    expect(margin5.top) == .absolute(20)
    expect(margin5.left) == .absolute(10)
    expect(margin5.bottom) == .absolute(20)
    expect(margin5.right) == .absolute(10)
  }

  func testDescription() {
    let margin = Margin(.absolute(10), .absolute(20), .absolute(30), .absolute(40))
    expect(margin.description) == "(absolute(10.0), absolute(20.0), absolute(30.0), absolute(40.0))"

    let margin2 = Margin(.relative(0.1), .relative(0.2), .relative(0.3), .relative(0.4))
    expect(margin2.description) == "(relative(0.1), relative(0.2), relative(0.3), relative(0.4))"
  }
}