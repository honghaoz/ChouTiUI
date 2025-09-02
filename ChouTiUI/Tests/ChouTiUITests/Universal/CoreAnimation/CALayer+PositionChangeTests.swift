//
//  CALayer+PositionChangeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/1/25.
//  Copyright © 2020 Honghao Zhang.
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang (github.com/honghaoz)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import QuartzCore

import ChouTiTest

import ChouTi
@testable import ChouTiUI

class CALayer_PositionChangeTests: XCTestCase {

  private var layer: CALayer!

  override func setUp() {
    super.setUp()

    layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 50, height: 80)
  }

  func test_onPositionChange() {
    let layer: CALayer = layer

    // initial state
    expect(layer.position) == CGPoint(x: 25, y: 40)
    expect(layer.test.positionKVOObservation) == nil

    // add callback 1
    var callCount1 = 0
    var calledOldPosition1: CGPoint?
    var calledNewPosition1: CGPoint?
    weak var token1: CancellableToken?
    token1 = layer.onPositionChange(block: { layer, old, new in
      callCount1 += 1
      calledOldPosition1 = old
      calledNewPosition1 = new
    })

    expect(layer.test.positionKVOObservation) != nil

    layer.position = CGPoint(x: 75, y: 120)
    expect(callCount1) == 1
    expect(calledOldPosition1) == CGPoint(x: 25, y: 40)
    expect(calledNewPosition1) == CGPoint(x: 75, y: 120)

    // add callback 2
    var callCount2 = 0
    var calledOldPosition2: CGPoint?
    var calledNewPosition2: CGPoint?
    weak var token2: CancellableToken?
    token2 = layer.onPositionChange(block: { layer, old, new in
      callCount2 += 1
      calledOldPosition2 = old
      calledNewPosition2 = new
    })

    expect(layer.test.positionKVOObservation) != nil

    layer.position = CGPoint(x: 125, y: 180)
    expect(callCount1) == 2
    expect(calledOldPosition1) == CGPoint(x: 75, y: 120)
    expect(calledNewPosition1) == CGPoint(x: 125, y: 180)
    expect(callCount2) == 1
    expect(calledOldPosition2) == CGPoint(x: 75, y: 120)
    expect(calledNewPosition2) == CGPoint(x: 125, y: 180)

    // cancel callback 1
    token1?.cancel()
    expect(layer.test.positionKVOObservation) != nil // still observing because of callback 2

    layer.position = CGPoint(x: 175, y: 240)
    expect(callCount1) == 2
    expect(calledOldPosition1) == CGPoint(x: 75, y: 120)
    expect(calledNewPosition1) == CGPoint(x: 125, y: 180)
    expect(callCount2) == 2
    expect(calledOldPosition2) == CGPoint(x: 125, y: 180)
    expect(calledNewPosition2) == CGPoint(x: 175, y: 240)

    // cancel callback 2
    token2?.cancel()
    expect(layer.test.positionKVOObservation) == nil // not observing anymore

    layer.position = CGPoint(x: 225, y: 300)
    expect(callCount1) == 2
    expect(calledOldPosition1) == CGPoint(x: 75, y: 120)
    expect(calledNewPosition1) == CGPoint(x: 125, y: 180)
    expect(callCount2) == 2
    expect(calledOldPosition2) == CGPoint(x: 125, y: 180)
    expect(calledNewPosition2) == CGPoint(x: 175, y: 240)
  }

  func test_releaseSelf() {
    var layer: CALayer? = CALayer()
    weak var weakLayer: CALayer? = layer
    layer?.onPositionChange(block: { _, _, _ in })

    layer = nil
    expect(weakLayer) == nil
  }

  func test_onPositionChange_fromBackgroundThread() {
    let expectation = XCTestExpectation(description: "")
    let backgroundQueue = DispatchQueue.make(label: "background")

    backgroundQueue.async {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "Should be on main thread. Message: \"\""
        expect(metadata["queue"]) == "background"
        expect(metadata["thread"]) == Thread.current.description
      }
      self.layer.onPositionChange(block: { _, _, _ in })
      Assert.resetTestAssertionFailureHandler()

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }
}
