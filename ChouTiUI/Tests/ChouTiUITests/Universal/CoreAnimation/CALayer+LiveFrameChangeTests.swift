//
//  CALayer+LiveFrameChangeTests.swift
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
@_spi(Private) import ComposeUI

class CALayer_LiveFrameChangeTests: XCTestCase {

  private var window: TestWindow!
  private var layer: CALayer!

  override func setUp() {
    super.setUp()

    window = TestWindow()
    layer = CALayer()
    layer.delegate = CALayer.DisableImplicitAnimationDelegate.shared
    layer.frame = CGRect(x: 10, y: 20, width: 100, height: 200)
    window.layer.addSublayer(layer)

    wait(timeout: 0.05) // wait for layer setup
  }

  override func tearDown() {
    layer = nil
    window = nil
    super.tearDown()
  }

  // MARK: - Manual Tick Helpers

  /// Wait until the animation for the given key is committed, i.e. its begin time is resolved to an absolute time,
  /// so that manual ticks can compute frames relative to the begin time.
  ///
  /// - Parameter key: The animation key.
  /// - Returns: The committed animation.
  private func waitForCommittedAnimation(forKey key: String) throws -> CABasicAnimation {
    expect((self.layer.animation(forKey: key)?.beginTime ?? 0) > 0).toEventually(beTrue())
    return try (layer.animation(forKey: key) as? CABasicAnimation).unwrap()
  }

  /// The expected animation progress for a manual tick at the given time.
  ///
  /// This mirrors the lookahead-based progress calculation in the live frame tick, so that tests can verify the
  /// per-key-path frame wiring with exact values. The timing curve math itself is verified independently in
  /// `test_onLiveFrameChange_manualTicks_deterministicFrames` with hand-computed values.
  ///
  /// - Parameters:
  ///   - animation: The committed animation.
  ///   - tickTime: The manual tick time.
  ///   - lookahead: The average tick duration at the tick time. The first manual tick after a fresh session uses, the default 16ms.
  /// - Returns: The expected progress.
  private func expectedProgress(of animation: CABasicAnimation, tickTime: TimeInterval, lookahead: TimeInterval = 0.016) -> CGFloat {
    let timeProgress = ((tickTime - animation.beginTime + lookahead) / animation.duration).clamped(to: 0 ... 1)
    return CGFloat(animation.progress(for: Float(timeProgress)) ?? 1)
  }

  /// Assert that the frame equals the expected frame, within a small tolerance for each component.
  ///
  /// - Parameters:
  ///   - frame: The actual frame.
  ///   - expectedFrame: The expected frame.
  private func expectFrame(_ frame: CGRect?, toBe expectedFrame: CGRect, file: StaticString = #filePath, line: UInt = #line) throws {
    let frame = try frame.unwrap(file: file, line: line)
    expect(frame.origin.x, file: file, line: line).to(beApproximatelyEqual(to: expectedFrame.origin.x, within: 0.01))
    expect(frame.origin.y, file: file, line: line).to(beApproximatelyEqual(to: expectedFrame.origin.y, within: 0.01))
    expect(frame.width, file: file, line: line).to(beApproximatelyEqual(to: expectedFrame.width, within: 0.01))
    expect(frame.height, file: file, line: line).to(beApproximatelyEqual(to: expectedFrame.height, within: 0.01))
  }

  // MARK: - No Animation

  func test_onLiveFrameChange_noAnimations_positionChanged() throws {
    // old position is (60, 120)
    var capturedFrames: [(CALayer, CGRect)] = []

    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
    }

    layer.position = CGPoint(x: 150, y: 300)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames.count) == 1
    try expect(capturedFrames.first.unwrap().0) === layer
    try expect(capturedFrames.first.unwrap().1) == CGRect(x: 100, y: 200, width: 100, height: 200)
  }

  func test_onLiveFrameChange_noAnimations_providesConcreteLayerAPIWithoutCasting() throws {
    // given: a CAShapeLayer observed by onLiveFrameChange
    let shapeLayer = CAShapeLayer()
    shapeLayer.delegate = CALayer.DisableImplicitAnimationDelegate.shared
    shapeLayer.frame = CGRect(x: 10, y: 20, width: 100, height: 200)
    window.layer.addSublayer(shapeLayer)
    wait(timeout: 1e-6)

    let expectedPath = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: 20, height: 12), transform: nil)
    shapeLayer.path = expectedPath

    var capturedPath: CGPath?
    var capturedFrame: CGRect?
    shapeLayer.onLiveFrameChange { (layer: CAShapeLayer, frame) in
      // compile-time check: callback layer can use `CAShapeLayer` API without casting
      capturedPath = layer.path
      capturedFrame = frame
    }

    // when: the shape layer frame changes
    shapeLayer.position = CGPoint(x: 150, y: 300)
    wait(timeout: 1e-6)

    // then: callback should be able to read `CAShapeLayer` API directly and get expected values
    try expect(capturedPath.unwrap().boundingBoxOfPath) == expectedPath.boundingBoxOfPath
    try expect(capturedFrame.unwrap()) == CGRect(x: 100, y: 200, width: 100, height: 200)
  }

  func test_onLiveFrameChange_noAnimations_boundsSizeChanged() throws {
    var capturedFrames: [(CALayer, CGRect)] = []

    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
    }

    layer.bounds = CGRect(x: 0, y: 0, width: 110, height: 220)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames.count) == 1
    try expect(capturedFrames.first.unwrap().0) === layer
    try expect(capturedFrames.first.unwrap().1) == CGRect(x: 5, y: 10, width: 110, height: 220)

    // set same frame again
    layer.bounds = CGRect(x: 5, y: 10, width: 110, height: 220)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames.count) == 1 // should not be called again for the same frame
  }

  func test_onLiveFrameChange_noAnimations_frameChanged() throws {
    var capturedFrames: [(CALayer, CGRect)] = []

    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
    }

    layer.frame = CGRect(x: 11, y: 22, width: 110, height: 220)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames.count) == 1
    try expect(capturedFrames.first.unwrap().0) === layer
    try expect(capturedFrames.first.unwrap().1) == CGRect(x: 11, y: 22, width: 110, height: 220) // then bounds changed
  }

  func test_onLiveFrameChange_noAnimations_cancel() throws {
    // old position is (60, 120)

    var capturedFrames1: [(CALayer, CGRect)] = []
    var capturedFrames2: [(CALayer, CGRect)] = []

    let token1 = layer.onLiveFrameChange { layer, frame in
      capturedFrames1.append((layer, frame))
    }
    expect(layer.sublayers?.count) == 1 // should have a display layer

    let token2 = layer.onLiveFrameChange { layer, frame in
      capturedFrames2.append((layer, frame))
    }
    expect(layer.sublayers?.count) == 1 // should still have one display layer

    // set the same position should not trigger callback
    layer.position = CGPoint(x: 60, y: 120)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames1.count) == 0
    expect(capturedFrames2.count) == 0

    // change frame should trigger callback
    layer.position = CGPoint(x: 110, y: 210)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames1.count) == 1
    expect(capturedFrames2.count) == 1

    // cancel token1
    token1.cancel()
    expect(layer.sublayers?.count) == 1 // should still have one display layer

    // change frame again
    layer.position = CGPoint(x: 120, y: 220)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames1.count) == 1
    expect(capturedFrames2.count) == 2 // observation2 should still trigger callback

    // cancel token2
    token2.cancel()
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer

    // change frame should not trigger callback
    layer.position = CGPoint(x: 110, y: 210)
    wait(timeout: 1e-6) // wait until next runloop

    expect(capturedFrames1.count) == 1
    expect(capturedFrames2.count) == 2
  }

  func test_onLiveFrameChange_cancel_cleansUpBookkeeping() throws {
    // given: two live frame observers
    let token1 = layer.onLiveFrameChange { _, _ in }
    let token2 = layer.onLiveFrameChange { _, _ in }
    expect(layer.test.liveFrameChangeBlocksCount) == 2
    expect(layer.test.liveFrameLastNotifiedFramesCount) == 2

    // when: cancelling the first observer
    token1.cancel()

    // then: the first observer's bookkeeping is removed
    expect(layer.test.liveFrameChangeBlocksCount) == 1
    expect(layer.test.liveFrameLastNotifiedFramesCount) == 1

    // when: cancelling the second observer
    token2.cancel()

    // then: all bookkeeping is removed
    expect(layer.test.liveFrameChangeBlocksCount) == 0
    expect(layer.test.liveFrameLastNotifiedFramesCount) == 0
  }

  // MARK: - Explicit Animation

  func test_onLiveFrameChange_explicitAnimation_positionChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActions {
        expectation.fulfill()
      }
    }

    layer.position = CGPoint(x: 150, y: 300)

    let animation = CABasicAnimation(keyPath: "position")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.explicitAnimationDuration
    animation.fromValue = CGPoint(x: 60, y: 120)
    animation.toValue = CGPoint(x: 150, y: 300)
    layer.add(animation, forKey: "position")

    if isGitHubActions {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 100, y: 200, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_positionChanged_additive() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an additive position animation is added
    layer.animate(keyPath: "position", to: CGPoint(x: 150, y: 300), timing: .easeInEaseOut(duration: Constants.manualAnimationDuration))

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let animation = try waitForCommittedAnimation(forKey: "position")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame, position: (60, 120) -> (150, 300)
    let tickTime = animation.beginTime + animation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: animation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 60 + 90 * progress - 50, y: 120 + 180 * progress - 100, width: 100, height: 200))

    // then: when the animation is removed (finished), a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 100, y: 200, width: 100, height: 200)
  }

  func test_onLiveFrameChange_explicitAnimation_positionXChanged() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an explicit position.x animation is added, position.x: 60 -> 150
    layer.position.x = 150
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.manualAnimationDuration
    animation.fromValue = 60
    animation.toValue = 150
    layer.add(animation, forKey: "position.x")

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "position.x")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 + 90 * progress, y: 20, width: 100, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 100, y: 20, width: 100, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_positionXChanged_additive() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an additive position.x animation is added, position.x: 60 -> 150
    layer.animate(keyPath: "position.x", to: 150, timing: .easeInEaseOut(duration: Constants.manualAnimationDuration))

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "position.x")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 + 90 * progress, y: 20, width: 100, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 100, y: 20, width: 100, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_positionYChanged() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an explicit position.y animation is added, position.y: 120 -> 300
    layer.position.y = 300
    let animation = CABasicAnimation(keyPath: "position.y")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.manualAnimationDuration
    animation.fromValue = 120
    animation.toValue = 300
    layer.add(animation, forKey: "position.y")

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "position.y")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10, y: 20 + 180 * progress, width: 100, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 10, y: 200, width: 100, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_positionYChanged_additive() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an additive position.y animation is added, position.y: 120 -> 300
    layer.animate(keyPath: "position.y", to: 300, timing: .easeInEaseOut(duration: Constants.manualAnimationDuration))

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "position.y")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10, y: 20 + 180 * progress, width: 100, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 10, y: 200, width: 100, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_boundsChanged() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an explicit bounds animation is added, bounds: (0, 0, 100, 200) -> (10, 20, 110, 220)
    layer.bounds = CGRect(x: 10, y: 20, width: 110, height: 220)
    let animation = CABasicAnimation(keyPath: "bounds")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.manualAnimationDuration
    animation.fromValue = CGRect(x: 0, y: 0, width: 100, height: 200)
    animation.toValue = CGRect(x: 10, y: 20, width: 110, height: 220)
    layer.add(animation, forKey: "bounds")

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20 - 10 * progress, width: 100 + 10 * progress, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 10, width: 110, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_boundsChanged_additive() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an additive bounds animation is added, bounds: (0, 0, 100, 200) -> (10, 20, 110, 220)
    layer.animate(
      keyPath: "bounds",
      timing: .easeInEaseOut(duration: Constants.manualAnimationDuration),
      from: {
        let fromRect = ($0.value(forKeyPath: "bounds") as! CGRect) // swiftlint:disable:this force_cast
        let toRect = CGRect(x: 10, y: 20, width: 110, height: 220)
        return CGRect(
          x: fromRect.x - toRect.x,
          y: fromRect.y - toRect.y,
          width: fromRect.width - toRect.width,
          height: fromRect.height - toRect.height
        )
      },
      to: { _ in CGRect.zero },
      model: { _ in CGRect(x: 10, y: 20, width: 110, height: 220) },
      updateAnimation: {
        $0.isAdditive = true
      }
    )

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20 - 10 * progress, width: 100 + 10 * progress, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 10, width: 110, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_boundsOriginChanged() throws {
    var capturedFrames: [(CALayer, CGRect)] = []

    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
    }

    layer.bounds.origin = CGPoint(x: 10, y: 20)
    let animationDuration = Constants.explicitAnimationDuration
    let animation = CABasicAnimation(keyPath: "bounds.origin")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = animationDuration
    animation.fromValue = CGPoint(x: 0, y: 0)
    animation.toValue = CGPoint(x: 10, y: 20)
    layer.add(animation, forKey: "bounds.origin")

    wait(timeout: animationDuration + 0.05) // wait until the animation is finished

    // bounds.origin change doesn't affect the frame
    expect(capturedFrames.count) == 0
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeChanged() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an explicit bounds.size animation is added, size: (100, 200) -> (110, 220)
    layer.bounds.size = CGSize(width: 110, height: 220)
    let animation = CABasicAnimation(keyPath: "bounds.size")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.manualAnimationDuration
    animation.fromValue = CGSize(width: 100, height: 200)
    animation.toValue = CGSize(width: 110, height: 220)
    layer.add(animation, forKey: "bounds.size")

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds.size")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20 - 10 * progress, width: 100 + 10 * progress, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 10, width: 110, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeWidthChanged() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an explicit bounds.size.width animation is added, width: 100 -> 110
    layer.bounds.size.width = 110
    let animation = CABasicAnimation(keyPath: "bounds.size.width")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.manualAnimationDuration
    animation.fromValue = 100
    animation.toValue = 110
    layer.add(animation, forKey: "bounds.size.width")

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds.size.width")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20, width: 100 + 10 * progress, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 20, width: 110, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeWidthChanged_additive() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an additive bounds.size.width animation is added, width: 100 -> 110
    layer.animate(keyPath: "bounds.size.width", to: 110, timing: .easeInEaseOut(duration: Constants.manualAnimationDuration))

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds.size.width")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20, width: 100 + 10 * progress, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 20, width: 110, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeHeightChanged() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an explicit bounds.size.height animation is added, height: 200 -> 220
    layer.bounds.size.height = 220
    let animation = CABasicAnimation(keyPath: "bounds.size.height")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.manualAnimationDuration
    animation.fromValue = 200
    animation.toValue = 220
    layer.add(animation, forKey: "bounds.size.height")

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds.size.height")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10, y: 20 - 10 * progress, width: 100, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 10, y: 10, width: 100, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeHeightChanged_additive() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an additive bounds.size.height animation is added, height: 200 -> 220
    layer.animate(keyPath: "bounds.size.height", to: 220, timing: .easeInEaseOut(duration: Constants.manualAnimationDuration))

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds.size.height")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10, y: 20 - 10 * progress, width: 100, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 10, y: 10, width: 100, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_frameChanged() throws {
    // given: a live frame observer
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: an additive frame animation is added, frame: (10, 20, 100, 200) -> (20, 40, 110, 220),
    // which adds additive "position" and "bounds.size" animations
    layer.animateFrame(to: CGRect(x: 20, y: 40, width: 110, height: 220), timing: .easeInEaseOut(duration: Constants.manualAnimationDuration))

    // stop real render-driven ticks once the animations are committed, then drive ticks manually
    let positionAnimation = try waitForCommittedAnimation(forKey: "position")
    let sizeAnimation = try waitForCommittedAnimation(forKey: "bounds.size")
    expect(sizeAnimation.beginTime) == positionAnimation.beginTime // committed in the same transaction
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = positionAnimation.beginTime + positionAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: positionAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 + 10 * progress, y: 20 + 20 * progress, width: 100 + 10 * progress, height: 200 + 20 * progress))

    // then: when the animations are finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 20, y: 40, width: 110, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_explicitAnimation_frameChanged_overlap() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActions {
        if layer.animationKeys()?.contains("bounds.size-1") == true {
          expectation.fulfill()
        }
      }
    }

    layer.animateFrame(to: CGRect(x: 20, y: 40, width: 110, height: 220), timing: .easeInEaseOut(duration: 0.5))
    wait(timeout: 0.1)
    layer.animateFrame(to: CGRect(x: 30, y: 50, width: 120, height: 230), timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActions {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 30, y: 50, width: 120, height: 230)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeChanged_twice() throws {
    // given: a live frame observer on a layer that will run two sequential resize animations
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let secondAnimationExpectation = XCTestExpectation(description: "tick second animation")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActions, layer.animationKeys()?.contains("bounds.size-2") == true {
        secondAnimationExpectation.fulfill()
      }
    }

    // when: the first explicit bounds.size animation runs
    layer.bounds.size = CGSize(width: 110, height: 220)
    let firstAnimation = CABasicAnimation(keyPath: "bounds.size")
    firstAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    firstAnimation.duration = Constants.explicitAnimationDuration
    firstAnimation.fromValue = CGSize(width: 100, height: 200)
    firstAnimation.toValue = CGSize(width: 110, height: 220)
    layer.add(firstAnimation, forKey: "bounds.size-1")

    if isGitHubActions {
      wait(timeout: 0.2)
    } else {
      waiter.wait() // wait until the first animation is finished
      expect(capturedFrames.count) > 2
    }

    // then: the first animation should produce live updates.
    // On GitHub Actions we intentionally avoid asserting the exact final frame because timing
    // can still be in-flight when this assertion runs.
    let firstAnimationFrameCount = capturedFrames.count
    if !isGitHubActions {
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 10, width: 110, height: 220)
    }

    // when: a second explicit bounds.size animation runs after the first one has completed
    layer.bounds.size = CGSize(width: 120, height: 240)
    let secondAnimation = CABasicAnimation(keyPath: "bounds.size")
    secondAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    secondAnimation.duration = Constants.explicitAnimationDuration
    secondAnimation.fromValue = CGSize(width: 110, height: 220)
    secondAnimation.toValue = CGSize(width: 120, height: 240)
    layer.add(secondAnimation, forKey: "bounds.size-2")

    if isGitHubActions {
      wait(for: [secondAnimationExpectation], timeout: 1)
      expect(capturedFrames.count) > firstAnimationFrameCount
    } else {
      waiter.wait() // wait until the second animation is finished

      // then: callbacks should continue for the second animation and end at the second target frame
      expect(capturedFrames.count) > firstAnimationFrameCount
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 0, y: 0, width: 120, height: 240)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  // MARK: - Implicit Animation

  func test_onLiveFrameChange_implicitAnimation_positionChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // old position is (60, 120)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActions {
        expectation.fulfill()
      }
    }

    layer.position = CGPoint(x: 150, y: 300)
    wait(timeout: 1e-6) // wait until next runloop

    let positionAnimation = try (layer.animation(forKey: "position") as? CABasicAnimation).unwrap()
    expect(positionAnimation.duration) == 0.25

    if isGitHubActions {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 100, y: 200, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_implicitAnimation_positionXChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // given: a live frame observer, old position is (60, 120)
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: position.x changes with an implicit animation
    CATransaction.begin()
    CATransaction.setAnimationDuration(Constants.manualAnimationDuration)
    layer.position.x = 150
    CATransaction.commit()

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "position")
    expect(committedAnimation.duration) == Constants.manualAnimationDuration
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 + 90 * progress, y: 20, width: 100, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 100, y: 20, width: 100, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_implicitAnimation_positionYChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // given: a live frame observer, old position is (60, 120)
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: position.y changes with an implicit animation
    CATransaction.begin()
    CATransaction.setAnimationDuration(Constants.manualAnimationDuration)
    layer.position.y = 300
    CATransaction.commit()

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "position")
    expect(committedAnimation.duration) == Constants.manualAnimationDuration
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10, y: 20 + 180 * progress, width: 100, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 10, y: 200, width: 100, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_implicitAnimation_boundsOriginChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // old bounds is (100, 200)

    var capturedFrames: [(CALayer, CGRect)] = []

    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
    }

    layer.bounds.origin = CGPoint(x: 10, y: 20)
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    wait(timeout: boundsAnimation.duration + 0.05) // wait until the animation is finished

    expect(capturedFrames.count) == 0 // bounds.origin change doesn't affect the frame
  }

  func test_onLiveFrameChange_implicitAnimation_boundsSizeChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // given: a live frame observer, old bounds is (100, 200)
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: bounds.size changes with an implicit animation
    CATransaction.begin()
    CATransaction.setAnimationDuration(Constants.manualAnimationDuration)
    layer.bounds.size = CGSize(width: 110, height: 220)
    CATransaction.commit()

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds")
    expect(committedAnimation.duration) == Constants.manualAnimationDuration
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20 - 10 * progress, width: 100 + 10 * progress, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 10, width: 110, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_implicitAnimation_boundsSizeWidthChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // given: a live frame observer, old bounds is (100, 200)
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: bounds.size.width changes with an implicit animation
    CATransaction.begin()
    CATransaction.setAnimationDuration(Constants.manualAnimationDuration)
    layer.bounds.size.width = 110
    CATransaction.commit()

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds")
    expect(committedAnimation.duration) == Constants.manualAnimationDuration
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20, width: 100 + 10 * progress, height: 200))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 20, width: 110, height: 200)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_implicitAnimation_boundsSizeHeightChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // given: a live frame observer, old bounds is (100, 200)
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: bounds.size.height changes with an implicit animation
    CATransaction.begin()
    CATransaction.setAnimationDuration(Constants.manualAnimationDuration)
    layer.bounds.size.height = 220
    CATransaction.commit()

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds")
    expect(committedAnimation.duration) == Constants.manualAnimationDuration
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10, y: 20 - 10 * progress, width: 100, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 10, y: 10, width: 100, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_implicitAnimation_boundsChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // given: a live frame observer, old bounds is (100, 200)
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: bounds changes with an implicit animation
    CATransaction.begin()
    CATransaction.setAnimationDuration(Constants.manualAnimationDuration)
    layer.bounds = CGRect(x: 10, y: 20, width: 110, height: 220)
    CATransaction.commit()

    // stop real render-driven ticks once the animation is committed, then drive ticks manually
    let committedAnimation = try waitForCommittedAnimation(forKey: "bounds")
    expect(committedAnimation.duration) == Constants.manualAnimationDuration
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame
    let tickTime = committedAnimation.beginTime + committedAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10 - 5 * progress, y: 20 - 10 * progress, width: 100 + 10 * progress, height: 200 + 20 * progress))

    // then: when the animation is finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 5, y: 10, width: 110, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_implicitAnimation_frameChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // given: a live frame observer, old frame is (10, 20, 100, 200)
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // when: frame changes with implicit animations, which animates both "position" and "bounds"
    CATransaction.begin()
    CATransaction.setAnimationDuration(Constants.manualAnimationDuration)
    layer.frame = CGRect(x: 10, y: 20, width: 110, height: 220)
    CATransaction.commit()

    // stop real render-driven ticks once the animations are committed, then drive ticks manually
    let positionAnimation = try waitForCommittedAnimation(forKey: "position")
    let boundsAnimation = try waitForCommittedAnimation(forKey: "bounds")
    expect(positionAnimation.duration) == Constants.manualAnimationDuration
    expect(boundsAnimation.duration) == Constants.manualAnimationDuration
    expect(boundsAnimation.beginTime) == positionAnimation.beginTime // committed in the same transaction
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the interpolated frame. the frame origin stays constant: the position and
    // bounds animations progress together, keeping the frame origin at (10, 20) while the size interpolates.
    let tickTime = positionAnimation.beginTime + positionAnimation.duration * 0.5
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: positionAnimation, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 10, y: 20, width: 100 + 10 * progress, height: 200 + 20 * progress))

    // then: when the animations are finished, a tick reports the final model frame
    layer.removeAllAnimations()
    layer.test.tick(now: tickTime)
    expect(capturedFrames.count) == 2
    try expect(capturedFrames.last.unwrap()) == CGRect(x: 10, y: 20, width: 110, height: 220)
    expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
  }

  func test_onLiveFrameChange_secondSession_hasFreshTickStatistics() throws {
    // given: a live frame observer that has completed an animation session.
    // the completed session's tick statistics must not leak into the next session: the average tick duration is
    // used as a lookahead in the progress calculation, so stale statistics that include the idle gap between the
    // sessions would make the next session report frames jumped toward (or beyond) the animation's end value.
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // session 1: animate position.x: 60 -> 150, tick a few times, then finish
    layer.position.x = 150
    let animation1 = CABasicAnimation(keyPath: "position.x")
    animation1.timingFunction = CAMediaTimingFunction(name: .linear)
    animation1.duration = Constants.manualAnimationDuration
    animation1.fromValue = 60
    animation1.toValue = 150
    layer.add(animation1, forKey: "position.x")

    let committedAnimation1 = try waitForCommittedAnimation(forKey: "position.x")
    layer.test.removeLiveFrameDisplayLayer()
    layer.test.tick(now: committedAnimation1.beginTime + 1)
    layer.test.tick(now: committedAnimation1.beginTime + 2)
    expect(layer.test.liveFrameTickCount) == 2

    // session 1 ends: the animation is finished and the final tick tears down the session
    layer.removeAllAnimations()
    layer.test.tick(now: committedAnimation1.beginTime + 3)
    expect(layer.test.liveFrameTickCount) == 0 // tick statistics are reset

    // when: session 2 animates position.x back: 150 -> 60
    capturedFrames.removeAll()
    layer.position.x = 60
    let animation2 = CABasicAnimation(keyPath: "position.x")
    animation2.timingFunction = CAMediaTimingFunction(name: .linear)
    animation2.duration = Constants.manualAnimationDuration
    animation2.fromValue = 150
    animation2.toValue = 60
    layer.add(animation2, forKey: "position.x")

    let committedAnimation2 = try waitForCommittedAnimation(forKey: "position.x")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    expect(layer.test.liveFrameTickCount) == 0

    // then: a mid-animation tick reports the exact interpolated frame with fresh tick statistics,
    // not a frame jumped to the end value
    let tickTime = committedAnimation2.beginTime + committedAnimation2.duration * 0.25
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation2, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 100 - 90 * progress, y: 20, width: 100, height: 200))
    try expect(capturedFrames.last.unwrap().origin.x) > 50 // not jumped to the end value (10)
  }

  func test_onLiveFrameChange_newSession_withUnrelatedAnimation_resetsTickStatistics() throws {
    // given: a layer with an unrelated long-lived animation, so that the live frame tick never sees an empty
    // animation list, which means the tick-based session teardown (and its tick statistics reset) never runs
    let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    opacityAnimation.duration = Constants.manualAnimationDuration
    opacityAnimation.fromValue = 1
    opacityAnimation.toValue = 0.99
    layer.add(opacityAnimation, forKey: "opacity")

    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // session 1: a position.x animation with some ticks
    layer.position.x = 150
    let animation1 = CABasicAnimation(keyPath: "position.x")
    animation1.timingFunction = CAMediaTimingFunction(name: .linear)
    animation1.duration = Constants.manualAnimationDuration
    animation1.fromValue = 60
    animation1.toValue = 150
    layer.add(animation1, forKey: "position.x")

    let committedAnimation1 = try waitForCommittedAnimation(forKey: "position.x")
    layer.test.removeLiveFrameDisplayLayer()
    layer.test.tick(now: committedAnimation1.beginTime + 1)
    layer.test.tick(now: committedAnimation1.beginTime + 2)
    expect(layer.test.liveFrameTickCount) == 2

    // session 1 ends: the position animation is removed, but the opacity animation keeps the layer's animation
    // list non-empty, so a tick doesn't tear down the session, leaving the tick statistics stale
    layer.removeAnimation(forKey: "position.x")
    layer.test.tick(now: committedAnimation1.beginTime + 3)
    expect(layer.test.liveFrameTickCount) == 3 // stale tick statistics, not reset
    let staleFirstTickTime = layer.test.liveFrameFirstTickTime
    expect(staleFirstTickTime) == committedAnimation1.beginTime + 1

    // when: a new position.x animation starts a new display run session
    layer.position.x = 60
    let animation2 = CABasicAnimation(keyPath: "position.x")
    animation2.timingFunction = CAMediaTimingFunction(name: .linear)
    animation2.duration = Constants.manualAnimationDuration
    animation2.fromValue = 150
    animation2.toValue = 60
    layer.add(animation2, forKey: "position.x")

    // then: the new session resets the stale tick statistics (the first tick time either becomes 0 (reset) or the
    // new session's first real tick time, but not the stale value)
    expect(self.layer.test.liveFrameFirstTickTime).toEventuallyNot(beEqual(to: staleFirstTickTime))

    // then: a manual mid-animation tick reports the exact interpolated frame with fresh tick statistics
    let committedAnimation2 = try waitForCommittedAnimation(forKey: "position.x")
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll()
    let tickTime = committedAnimation2.beginTime + committedAnimation2.duration * 0.25
    layer.test.tick(now: tickTime)
    let progress = expectedProgress(of: committedAnimation2, tickTime: tickTime)
    expect(capturedFrames.count) == 1
    try expectFrame(capturedFrames.last, toBe: CGRect(x: 100 - 90 * progress, y: 20, width: 100, height: 200))
  }

  // MARK: - Deterministic Ticks

  func test_onLiveFrameChange_manualTicks_deterministicFrames() throws {
    // given: a live frame observer with an explicit position animation, with the display layer removed so that
    // real render-driven ticks stop, allowing this test to drive ticks manually at exact times.
    var capturedFrames: [CGRect] = []
    layer.onLiveFrameChange { _, frame in
      capturedFrames.append(frame)
    }

    // animate position x: 60 -> 150 (frame.x: 10 -> 100), linear, over 2s
    layer.position = CGPoint(x: 150, y: 120)
    let animation = CABasicAnimation(keyPath: "position")
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.duration = 2
    animation.fromValue = CGPoint(x: 60, y: 120)
    animation.toValue = CGPoint(x: 150, y: 120)
    layer.add(animation, forKey: "position")

    // wait until the animation is committed, i.e. its begin time is resolved to an absolute time
    expect((self.layer.animation(forKey: "position")?.beginTime ?? 0) > 0).toEventually(beTrue())

    // stop real render-driven ticks. this also resets the tick statistics, so manual ticks below start fresh.
    layer.test.removeLiveFrameDisplayLayer()
    capturedFrames.removeAll() // drop frames captured by any real tick that fired before the removal
    expect(layer.test.liveFrameTickCount) == 0 // tick statistics are fresh, manual ticks are deterministic

    let beginTime = try layer.animation(forKey: "position").unwrap().beginTime
    let duration: TimeInterval = 2

    // when: driving ticks manually at exact times
    // - tick 1 at 25% time: lookahead is 16ms (first tick) -> time progress = (0.5 + 0.016) / 2 = 0.258
    // - tick 2 at 50% time: lookahead is 0.5s (tick interval) -> time progress = (1.0 + 0.5) / 2 = 0.75
    // - tick 3 at 75% time: lookahead is 0.5s -> time progress = (1.5 + 0.5) / 2 = 1 (end value)
    // - tick 4 at 100% time: time progress is clamped to 1 -> same frame as tick 3, deduplicated
    layer.test.tick(now: beginTime + duration * 0.25)
    layer.test.tick(now: beginTime + duration * 0.5)
    layer.test.tick(now: beginTime + duration * 0.75)
    layer.test.tick(now: beginTime + duration)

    // then: the captured frames are the exact interpolated values (linear timing: progress == time progress),
    // frame.x = 10 + 90 * progress
    expect(capturedFrames.count) == 3
    expect(capturedFrames[0].origin.x).to(beApproximatelyEqual(to: 10 + 90 * 0.258, within: 0.01))
    expect(capturedFrames[1].origin.x).to(beApproximatelyEqual(to: 10 + 90 * 0.75, within: 0.01))
    expect(capturedFrames[2].origin.x).to(beApproximatelyEqual(to: 100, within: 0.01))
    for frame in capturedFrames {
      expect(frame.origin.y) == 20
      expect(frame.size) == CGSize(width: 100, height: 200)
    }
  }

  // MARK: - Constants

  private enum Constants {
    static let explicitAnimationDuration: TimeInterval = 0.1

    /// The animation duration for tests that drive ticks manually.
    /// Long enough that the animation can't finish before the manual ticks run, even on a stalled test machine.
    static let manualAnimationDuration: TimeInterval = 60
  }
}

/// Whether the tests are running on GitHub Actions.
///
/// These live-frame tests are timing-sensitive: they rely on render-server display ticks during a
/// short (0.1s) animation and infer completion from a quiet window. On loaded CI runners (both macOS
/// and iOS simulators) the render loop can stall longer than that window, which makes exact-frame
/// assertions flaky. On CI we relax those assertions to only verify that callbacks fire.
private let isGitHubActions: Bool = Environment.isGitHubActions

/// A helper class to wait for the tick to finish.
private class TickWaiter: XCTestCase { // swiftlint:disable:this private_unit_test

  private var delayToken: (any DelayTaskType)?
  private var waitExpectation: XCTestExpectation?

  private let delayDuration: TimeInterval = 0.1

  func tick() {
    delayToken?.cancel()
    delayToken = delay(delayDuration, leeway: .zero) { [weak self] in
      self?.delayToken = nil
      self?.waitExpectation?.fulfill()
    }
  }

  func wait() {
    let waitExpectation = XCTestExpectation(description: "wait for tick to finish")
    self.waitExpectation = waitExpectation
    wait(for: [waitExpectation], timeout: 1)
    self.waitExpectation = nil
  }
}
