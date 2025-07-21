//
//  CALayer+BoundsChangeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/9/24.
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

class CALayer_BoundsChangeTests: XCTestCase {

  private var layer: CALayer!

  override func setUp() {
    super.setUp()

    layer = CALayer()
    layer.bounds.size = CGSize(width: 50, height: 80)
  }

  func test_onBoundsChange() {
    let layer: CALayer = layer

    // initial state
    expect(layer.bounds) == CGRect(x: 0, y: 0, width: 50, height: 80)
    expect(layer.test.boundsKVOObservation) == nil

    // add callback 1
    var callCount1 = 0
    var calledOldBounds1: CGRect?
    var calledNewBounds1: CGRect?
    weak var token1: CancellableToken?
    token1 = layer.onBoundsChange(block: { layer, old, new in
      callCount1 += 1
      calledOldBounds1 = old
      calledNewBounds1 = new
    })

    expect(layer.test.boundsKVOObservation) != nil

    layer.bounds = CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(callCount1) == 1
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 50, height: 80)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)

    // add callback 2
    var callCount2 = 0
    var calledOldBounds2: CGRect?
    var calledNewBounds2: CGRect?
    weak var token2: CancellableToken?
    token2 = layer.onBoundsChange(block: { layer, old, new in
      callCount2 += 1
      calledOldBounds2 = old
      calledNewBounds2 = new
    })

    expect(layer.test.boundsKVOObservation) != nil

    layer.bounds = CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount1) == 2
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount2) == 1
    expect(calledOldBounds2) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds2) == CGRect(x: 0, y: 0, width: 250, height: 380)

    // cancel callback 1
    token1?.cancel()
    expect(layer.test.boundsKVOObservation) != nil // still observing because of callback 2

    layer.bounds = CGRect(x: 0, y: 0, width: 350, height: 480)
    expect(callCount1) == 2
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount2) == 2
    expect(calledOldBounds2) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(calledNewBounds2) == CGRect(x: 0, y: 0, width: 350, height: 480)

    // cancel callback 2
    token2?.cancel()
    expect(layer.test.boundsKVOObservation) == nil // not observing anymore

    layer.bounds = CGRect(x: 0, y: 0, width: 450, height: 580)
    expect(callCount1) == 2
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount2) == 2
    expect(calledOldBounds2) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(calledNewBounds2) == CGRect(x: 0, y: 0, width: 350, height: 480)
  }

  func test_onBoundsChange_frame() {
    let layer: CALayer = layer

    // initial state
    expect(layer.frame) == CGRect(x: -25, y: -40, width: 50, height: 80)
    expect(layer.test.boundsKVOObservation) == nil

    // add callback 1
    var callCount1 = 0
    var calledOldBounds1: CGRect?
    var calledNewBounds1: CGRect?
    weak var token1: CancellableToken?
    token1 = layer.onBoundsChange(block: { layer, old, new in
      callCount1 += 1
      calledOldBounds1 = old
      calledNewBounds1 = new
    })

    expect(layer.test.boundsKVOObservation) != nil

    layer.frame = CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(callCount1) == 1
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 50, height: 80)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)

    // add callback 2
    var callCount2 = 0
    var calledOldBounds2: CGRect?
    var calledNewBounds2: CGRect?
    weak var token2: CancellableToken?
    token2 = layer.onBoundsChange(block: { layer, old, new in
      callCount2 += 1
      calledOldBounds2 = old
      calledNewBounds2 = new
    })

    expect(layer.test.boundsKVOObservation) != nil

    layer.frame = CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount1) == 2
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount2) == 1
    expect(calledOldBounds2) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds2) == CGRect(x: 0, y: 0, width: 250, height: 380)

    // cancel callback 1
    token1?.cancel()
    expect(layer.test.boundsKVOObservation) != nil // still observing because of callback 2

    layer.frame = CGRect(x: 0, y: 0, width: 350, height: 480)
    expect(callCount1) == 2
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount2) == 2
    expect(calledOldBounds2) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(calledNewBounds2) == CGRect(x: 0, y: 0, width: 350, height: 480)

    // cancel callback 2
    token2?.cancel()
    expect(layer.test.boundsKVOObservation) == nil // not observing anymore

    layer.frame = CGRect(x: 0, y: 0, width: 450, height: 580)
    expect(callCount1) == 2
    expect(calledOldBounds1) == CGRect(x: 0, y: 0, width: 150, height: 280)
    expect(calledNewBounds1) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(callCount2) == 2
    expect(calledOldBounds2) == CGRect(x: 0, y: 0, width: 250, height: 380)
    expect(calledNewBounds2) == CGRect(x: 0, y: 0, width: 350, height: 480)
  }

  func test_releaseSelf() {
    var layer: CALayer? = CALayer()
    weak var weakLayer: CALayer? = layer
    layer?.onBoundsChange(block: { _, _, _ in })

    layer = nil
    expect(weakLayer) == nil
  }

  func test_onBoundsChange_fromBackgroundThread() {
    let expectation = XCTestExpectation(description: "")
    let backgroundQueue = DispatchQueue.make(label: "background")

    backgroundQueue.async {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "Should be on main thread. Message: \"\""
        expect(metadata["queue"]) == "background"
        expect(metadata["thread"]) == Thread.current.description
      }
      self.layer.onBoundsChange(block: { _, _, _ in })
      Assert.resetTestAssertionFailureHandler()

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }
}
