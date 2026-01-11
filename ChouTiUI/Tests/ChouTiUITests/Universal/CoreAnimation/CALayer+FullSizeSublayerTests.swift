//
//  CALayer+FullSizeSublayerTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/12/25.
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
@_spi(Private) import ComposeUI

class CALayer_FullSizeSublayerTests: XCTestCase {

  func test_addFullSizeSublayerAt() throws {
    do {
      let layer = CALayer()
      let sublayer1 = CALayer()
      let sublayer2 = CALayer()
      layer.addFullSizeSublayer(sublayer1)
      layer.addFullSizeSublayer(sublayer2)

      expect(layer.sublayers) == [sublayer1, sublayer2]
    }

    do {
      let layer = CALayer()
      let sublayer1 = CALayer()
      let sublayer2 = CALayer()
      layer.addFullSizeSublayer(sublayer1, at: 0)
      layer.addFullSizeSublayer(sublayer2, at: 0)

      expect(layer.sublayers) == [sublayer2, sublayer1]
    }
  }

  func test_removeFullSizeSublayer() throws {
    let layer = CALayer()
    let sublayer1 = CALayer()
    let sublayer2 = CALayer()

    expect(layer.test.fullSizeSublayerBoundsToken) == nil

    layer.addFullSizeSublayer(sublayer1)
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer1): sublayer1]
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    layer.addFullSizeSublayer(sublayer2)
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer1): sublayer1, ObjectIdentifier(sublayer2): sublayer2]
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    layer.removeFullSizeSublayer(sublayer1)
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer2): sublayer2]
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    layer.addFullSizeSublayer(sublayer1)
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer2): sublayer2, ObjectIdentifier(sublayer1): sublayer1]
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    layer.removeFullSizeSublayer(sublayer2)
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer1): sublayer1]
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    layer.removeFullSizeSublayer(sublayer1)
    expect(layer.test.fullSizeSublayers) == [:]
    expect(layer.test.fullSizeSublayerBoundsToken) == nil
  }

  func test_moveFullSizeSublayerAutomatically() throws {
    let layer = CALayer()
    let sublayer1 = CALayer()
    let sublayer2 = CALayer()
    layer.addFullSizeSublayer(sublayer1)
    layer.addFullSizeSublayer(sublayer2)

    expect(layer.sublayers) == [sublayer1, sublayer2]
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer1): sublayer1, ObjectIdentifier(sublayer2): sublayer2]
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    sublayer2.removeFromSuperlayer() // remove the sublayer from the layer
    expect(layer.sublayers) == [sublayer1] // sublayers is updated
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer1): sublayer1, ObjectIdentifier(sublayer2): sublayer2] // fullSizeSublayers is not updated
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100) // trigger the bounds change
    expect(layer.sublayers) == [sublayer1]
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer1): sublayer1] // fullSizeSublayers is updated
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    sublayer1.removeFromSuperlayer()
    expect(layer.sublayers) == nil
    expect(layer.test.fullSizeSublayers) == [ObjectIdentifier(sublayer1): sublayer1] // fullSizeSublayers is not updated
    expect(layer.test.fullSizeSublayerBoundsToken) != nil

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 100) // trigger the bounds change
    expect(layer.sublayers) == nil
    expect(layer.test.fullSizeSublayers) == [:] // fullSizeSublayers is updated
    expect(layer.test.fullSizeSublayerBoundsToken) == nil // bounds listener is removed
  }

  func test_nonAdditiveAnimation_beforeBoundsChange() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    let sublayer = CALayer()
    layer.addFullSizeSublayer(sublayer)

    // non additive animation, animation added before the bounds change
    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size")
        animation.fromValue = CGSize(width: 100, height: 100)
        animation.toValue = CGSize(width: 200, height: 200)
        return animation
      }(),
      forKey: "bounds.size"
    )
    layer.bounds.size = CGSize(width: 200, height: 200)

    let waitExpectation = expectation(description: "wait")

    RunLoop.main.perform {
      let animationKeys = sublayer.animationKeys()
      expect(animationKeys) == ["position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }

  func test_boundsChange_nonAdditiveAnimation_afterBoundsChange() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    let sublayer = CALayer()
    layer.addFullSizeSublayer(sublayer)

    // non additive animation, animation added after the bounds change
    layer.bounds.size = CGSize(width: 200, height: 200)
    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size")
        animation.fromValue = CGSize(width: 100, height: 100)
        animation.toValue = CGSize(width: 200, height: 200)
        return animation
      }(),
      forKey: "bounds.size"
    )

    let waitExpectation = expectation(description: "wait")

    RunLoop.main.perform {
      let animationKeys = sublayer.animationKeys()
      expect(animationKeys) == ["position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }

  func test_boundsChange_additiveAnimation() throws {
    let window = TestWindow()

    let layer = CALayer()
    window.layer.addSublayer(layer)
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    let sublayer = CALayer()
    layer.addFullSizeSublayer(sublayer)

    // additive animation, animation added before the bounds change
    layer.animateFrame(to: CGRect(x: 0, y: 0, width: 150, height: 200), timing: .spring())

    // additive animation, animation added before the bounds change
    layer.animateFrame(to: CGRect(x: 0, y: 0, width: 150, height: 200), timing: .spring())

    let waitExpectation = expectation(description: "wait")

    RunLoop.main.perform {
      let animationKeys = sublayer.animationKeys()
      expect(animationKeys) == ["position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }

  func test_boundsChange_implicitAnimation() throws {
    let window = TestWindow()

    let layer = CALayer()
    window.layer.addSublayer(layer)
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    let sublayer = CALayer()
    layer.addFullSizeSublayer(sublayer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 300)

    expect(layer.animationKeys()) == ["bounds"]
    expect(sublayer.animationKeys()) == ["position", "bounds"]

    let waitExpectation = expectation(description: "wait")

    RunLoop.main.perform {
      self.wait(timeout: 0.05)
      let animationKeys = sublayer.animationKeys()
      expect(animationKeys) == ["bounds", "position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }

  func test_boundsChange_noImplicitAnimation() throws {
    let window = TestWindow()

    let layer = CALayer()
    window.layer.addSublayer(layer)
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    let sublayer = CALayer()
    layer.addFullSizeSublayer(sublayer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    CATransaction.disableAnimations {
      layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 300)
    }

    expect(layer.animationKeys()) == nil
    expect(sublayer.animationKeys()) == nil

    let waitExpectation = expectation(description: "wait")

    RunLoop.main.perform {
      let animationKeys = sublayer.animationKeys()
      expect(animationKeys) == nil
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }
}
