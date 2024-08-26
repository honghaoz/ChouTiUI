//
//  LayoutPointTests.swift
//
//  Created by Honghao Zhang on 8/2/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiUI
import ChouTiTest

class LayoutPointTests: XCTestCase {

  func testInitialization() {
    let point = LayoutPoint(x: .absolute(10), y: .relative(0.5))
    expect(point.x) == .absolute(10)
    expect(point.y) == .relative(0.5)

    let point2 = LayoutPoint(.relative(0.2), .absolute(5))
    expect(point2.x) == .relative(0.2)
    expect(point2.y) == .absolute(5)
  }

  func testPointInFrame() {
    let point = LayoutPoint(x: .relative(0.25), y: .mixed(0.5, 10))
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    let resultPoint = point.cgPoint(from: frame.size)
    expect(resultPoint.x) == 25
    expect(resultPoint.y) == 60
  }

  func testIsZero() {
    let zeroPoint = LayoutPoint(x: .absolute(0), y: .absolute(0))
    expect(zeroPoint.isZero()) == true

    let nonZeroPoint = LayoutPoint(x: .relative(0), y: .absolute(5))
    expect(nonZeroPoint.isZero()) == false
  }

  func testEquality() {
    let point1 = LayoutPoint(x: .absolute(10), y: .relative(0.5))
    let point2 = LayoutPoint(x: .absolute(10), y: .relative(0.5))
    let point3 = LayoutPoint(x: .absolute(20), y: .relative(0.5))

    expect(point1) == point2
    expect(point1) != point3
  }
}
