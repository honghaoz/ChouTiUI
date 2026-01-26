//
//  CALayer+FullSizeTrackingLayerTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/25/26.
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

class CALayer_FullSizeTrackingLayerTests: XCTestCase {

  func test_oneSublayer() {
    let window = TestWindow()

    let layer1 = CALayer()
    layer1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    window.layer.addSublayer(layer1)

    var onBoundsChangeCallCount = 0
    var onAddSizeChangeAnimationCallCount = 0
    var onBoundsChangeContext: CALayer.BoundsChangeContext?
    var onAddSizeChangeAnimationContext: CALayer.BoundsChangeContext?
    var onAddSizeChangeAnimationAnimation: CABasicAnimation?

    let layer2 = CALayer()
    layer1.addFullSizeTrackingLayer(
      layer2,
      onBoundsChange: { context in
        onBoundsChangeCallCount += 1
        onBoundsChangeContext = context
      },
      onAddSizeChangeAnimation: { context, animation in
        onAddSizeChangeAnimationCallCount += 1
        onAddSizeChangeAnimationContext = context
        onAddSizeChangeAnimationAnimation = animation
      }
    )

    // when add size change animation
    layer1.animateFrame(to: CGRect(x: 0, y: 0, width: 150, height: 200), timing: .easeInEaseOut(duration: 1.5))

    // then layers should have correct size change animation
    try expect(
      layer1.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))
    try expect((layer1.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5

    try expect(
      layer2.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))
    try expect((layer2.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5

    expect(onBoundsChangeCallCount) == 1
    expect(onBoundsChangeContext?.hostLayer) == layer1
    expect(onBoundsChangeContext?.trackingLayer) == layer2
    expect(onBoundsChangeContext?.oldBounds) == CGRect(x: 0, y: 0, width: 100, height: 100)
    expect(onBoundsChangeContext?.newBounds) == CGRect(x: 0, y: 0, width: 150, height: 200)

    expect(onAddSizeChangeAnimationCallCount) == 1
    expect(onAddSizeChangeAnimationContext?.hostLayer) == layer1
    expect(onAddSizeChangeAnimationContext?.trackingLayer) == layer2
    expect(onAddSizeChangeAnimationContext?.oldBounds) == CGRect(x: 0, y: 0, width: 100, height: 100)
    expect(onAddSizeChangeAnimationContext?.newBounds) == CGRect(x: 0, y: 0, width: 150, height: 200)
    expect(onAddSizeChangeAnimationAnimation?.duration) == 1.5
    expect(onAddSizeChangeAnimationAnimation?.keyPath) == "bounds.size"
    expect(onAddSizeChangeAnimationAnimation?.fromValue as? CGSize) == CGSize(-50, -100)
    expect(onAddSizeChangeAnimationAnimation?.toValue as? CGSize) == .zero
    expect(onAddSizeChangeAnimationAnimation?.isAdditive) == true
    expect(onAddSizeChangeAnimationAnimation?.timingFunction) == CAMediaTimingFunction(name: .easeInEaseOut)

    // when add another size change animation
    layer1.animateFrame(to: CGRect(x: 0, y: 0, width: 200, height: 300), timing: .easeInEaseOut(duration: 1.5))

    // then layers should have correct size change animation
    try expect(
      layer1.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "bounds.size-1", "position", "position-1"]
    ))
    try expect((layer1.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "bounds.size-1") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "position-1") as? CABasicAnimation).unwrap().duration) == 1.5

    try expect(
      layer2.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "bounds.size-1", "position", "position-1"]
    ))
    try expect((layer2.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "bounds.size-1") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "position-1") as? CABasicAnimation).unwrap().duration) == 1.5

    expect(onBoundsChangeCallCount) == 2
    expect(onBoundsChangeContext?.hostLayer) == layer1
    expect(onBoundsChangeContext?.trackingLayer) == layer2
    expect(onBoundsChangeContext?.oldBounds) == CGRect(x: 0, y: 0, width: 150, height: 200)
    expect(onBoundsChangeContext?.newBounds) == CGRect(x: 0, y: 0, width: 200, height: 300)

    expect(onAddSizeChangeAnimationCallCount) == 2
    expect(onAddSizeChangeAnimationContext?.hostLayer) == layer1
    expect(onAddSizeChangeAnimationContext?.trackingLayer) == layer2
    expect(onAddSizeChangeAnimationContext?.oldBounds) == CGRect(x: 0, y: 0, width: 150, height: 200)
    expect(onAddSizeChangeAnimationContext?.newBounds) == CGRect(x: 0, y: 0, width: 200, height: 300)
    expect(onAddSizeChangeAnimationAnimation?.duration) == 1.5
    expect(onAddSizeChangeAnimationAnimation?.keyPath) == "bounds.size"
    expect(onAddSizeChangeAnimationAnimation?.fromValue as? CGSize) == CGSize(-50, -100)
    expect(onAddSizeChangeAnimationAnimation?.toValue as? CGSize) == .zero
    expect(onAddSizeChangeAnimationAnimation?.isAdditive) == true
    expect(onAddSizeChangeAnimationAnimation?.timingFunction) == CAMediaTimingFunction(name: .easeInEaseOut)
  }

  /// Test the case when a sublayer has another sublayer that tracks the bounds of the sublayer.
  /// All layers should have correct size change animation.
  func test_nestedSublayer() {
    let window = TestWindow()

    let layer1 = CALayer()
    layer1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    window.layer.addSublayer(layer1)

    let layer2 = CALayer()
    layer1.addFullSizeTrackingLayer(layer2)

    let layer3 = CALayer()
    layer2.addFullSizeTrackingLayer(layer3)

    // when add size change animation
    layer1.animateFrame(to: CGRect(x: 0, y: 0, width: 150, height: 200), timing: .easeInEaseOut(duration: 1.5))

    // then layers should have correct size change animation
    try expect(
      layer1.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))
    try expect((layer1.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5

    try expect(
      layer2.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))
    try expect((layer2.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5

    try expect(
      layer3.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))
    try expect((layer3.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer3.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5

    // when add another size change animation
    layer1.animateFrame(to: CGRect(x: 0, y: 0, width: 200, height: 300), timing: .easeInEaseOut(duration: 1.5))

    // then layers should have correct size change animation
    try expect(
      layer1.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "bounds.size-1", "position", "position-1"]
    ))
    try expect((layer1.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "bounds.size-1") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer1.animation(forKey: "position-1") as? CABasicAnimation).unwrap().duration) == 1.5

    try expect(
      layer2.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "bounds.size-1", "position", "position-1"]
    ))
    try expect((layer2.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "bounds.size-1") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer2.animation(forKey: "position-1") as? CABasicAnimation).unwrap().duration) == 1.5

    try expect(
      layer3.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "bounds.size-1", "position", "position-1"]
    ))
    try expect((layer3.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer3.animation(forKey: "bounds.size-1") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer3.animation(forKey: "position") as? CABasicAnimation).unwrap().duration) == 1.5
    try expect((layer3.animation(forKey: "position-1") as? CABasicAnimation).unwrap().duration) == 1.5
  }
}
