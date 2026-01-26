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

    // expect the tracking layer's frame to be the same as the host layer's frame
    expect(layer2.frame) == layer1.frame

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

  /// Test the order of block invocation when the bounds change.
  func test_blockInvocationOrder() {
    let window = TestWindow()

    let beginFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    let endFrame = CGRect(x: 0, y: 0, width: 150, height: 200)

    let layer1 = CALayer()
    layer1.frame = beginFrame
    window.layer.addSublayer(layer1)

    let layer2 = CALayer()

    enum BlockType: Equatable {
      case onBoundsChange
      case onAddSizeChangeAnimation
    }

    var blockInvocationOrder: [BlockType] = []
    layer1.addFullSizeTrackingLayer(
      layer2,
      onBoundsChange: { [weak layer2] context in
        expect(layer2?.frame) == beginFrame // layer2's frame should not be changed yet

        expect(context.oldBounds) == beginFrame
        expect(context.newBounds) == endFrame

        blockInvocationOrder.append(.onBoundsChange)
      },
      onAddSizeChangeAnimation: { context, animation in
        expect(context.oldBounds) == beginFrame
        expect(context.newBounds) == endFrame

        blockInvocationOrder.append(.onAddSizeChangeAnimation)
      }
    )

    // when add size change animations
    layer1.animateFrame(to: endFrame, timing: .easeInEaseOut(duration: 1.5))

    // then layers should have correct size change animation
    try expect(
      layer1.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))

    // verify onBoundsChange block is called before onAddSizeChangeAnimation block
    expect(blockInvocationOrder) == [.onBoundsChange, .onAddSizeChangeAnimation]
  }

  func test_removeFullSizeTrackingLayer() {
    let window = TestWindow()

    let layer1 = CALayer()
    layer1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    window.layer.addSublayer(layer1)

    let layer2 = CALayer()
    layer1.addFullSizeTrackingLayer(layer2)

    // when change the host layer's frame
    layer1.frame = CGRect(x: 0, y: 0, width: 150, height: 200)

    // then the tracking layer's frame should be the same as the host layer's frame
    expect(layer2.frame) == layer1.frame

    // when remove the tracking layer
    layer1.removeFullSizeTrackingLayer(layer2)

    // when change the host layer's frame again
    layer1.frame = CGRect(x: 0, y: 0, width: 200, height: 300)

    // then the tracking layer's frame should not be changed
    expect(layer2.frame) == CGRect(x: 0, y: 0, width: 150, height: 200)
  }

  /// Test the case when the host layer's size change animation is non-additive.
  func test_nonAdditiveAnimation() throws {
    let window = TestWindow()

    let layer1 = CALayer()
    layer1.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    window.layer.addSublayer(layer1)

    var onBoundsChangeCallCount = 0
    var onAddSizeChangeAnimationCallCount = 0
    var onAddSizeChangeAnimationAnimation: CABasicAnimation?

    let layer2 = CALayer()
    layer1.addFullSizeTrackingLayer(
      layer2,
      onBoundsChange: { _ in
        onBoundsChangeCallCount += 1
      },
      onAddSizeChangeAnimation: { _, animation in
        onAddSizeChangeAnimationCallCount += 1
        onAddSizeChangeAnimationAnimation = animation
      }
    )

    // expect the tracking layer's frame to be the same as the host layer's frame
    expect(layer2.frame) == layer1.frame

    // when add a non-additive size change animation to the host layer
    // NOTE: animation must be added BEFORE changing bounds, because the bounds change listener
    // looks for the animation on the host layer to synchronize to the tracking layer
    let oldBounds = layer1.bounds
    let newBounds = CGRect(x: 0, y: 0, width: 150, height: 200)

    let sizeAnimation = CABasicAnimation(keyPath: "bounds.size")
    sizeAnimation.duration = 1.5
    sizeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    sizeAnimation.isAdditive = false
    sizeAnimation.fromValue = oldBounds.size
    sizeAnimation.toValue = newBounds.size
    layer1.add(sizeAnimation, forKey: "bounds.size")

    let positionAnimation = CABasicAnimation(keyPath: "position")
    positionAnimation.duration = 1.5
    positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    positionAnimation.isAdditive = false
    positionAnimation.fromValue = oldBounds.center
    positionAnimation.toValue = newBounds.center
    layer1.add(positionAnimation, forKey: "position")

    // now change the bounds (this triggers the bounds change listener which will sync the animation)
    layer1.bounds = newBounds
    layer1.position = newBounds.center

    // then the host layer should have non-additive animations
    try expect(
      layer1.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))
    let hostSizeAnimation = try (layer1.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap()
    expect(hostSizeAnimation.isAdditive) == false
    expect(hostSizeAnimation.fromValue as? CGSize) == oldBounds.size
    expect(hostSizeAnimation.toValue as? CGSize) == newBounds.size
    expect(hostSizeAnimation.duration) == 1.5

    // then the tracking layer should also have non-additive animations
    try expect(
      layer2.animationKeys().unwrap().sorted()
    ).to(beEqual(
      to: ["bounds.size", "position"]
    ))
    let trackingSizeAnimation = try (layer2.animation(forKey: "bounds.size") as? CABasicAnimation).unwrap()
    expect(trackingSizeAnimation.isAdditive) == false
    // for non-additive animation, the fromValue should be the presentation bounds size (or old bounds if no presentation)
    // and the toValue should be the new bounds size
    expect(trackingSizeAnimation.fromValue as? CGSize) == oldBounds.size
    expect(trackingSizeAnimation.toValue as? CGSize) == newBounds.size
    expect(trackingSizeAnimation.duration) == 1.5
    expect(trackingSizeAnimation.timingFunction) == CAMediaTimingFunction(name: .easeInEaseOut)

    let trackingPositionAnimation = try (layer2.animation(forKey: "position") as? CABasicAnimation).unwrap()
    expect(trackingPositionAnimation.isAdditive) == false
    expect(trackingPositionAnimation.fromValue as? CGPoint) == oldBounds.center
    expect(trackingPositionAnimation.toValue as? CGPoint) == newBounds.center
    expect(trackingPositionAnimation.duration) == 1.5

    // verify callbacks
    expect(onBoundsChangeCallCount) == 1
    expect(onAddSizeChangeAnimationCallCount) == 1
    expect(onAddSizeChangeAnimationAnimation?.isAdditive) == false
    expect(onAddSizeChangeAnimationAnimation?.duration) == 1.5
    expect(onAddSizeChangeAnimationAnimation?.keyPath) == "bounds.size"
  }
}
