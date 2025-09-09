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

  // MARK: - Explicit Animation

  func test_onLiveFrameChange_explicitAnimation_positionChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
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

    if isGitHubActionsMac {
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
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animate(keyPath: "position", to: CGPoint(x: 150, y: 300), timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 100, y: 200, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_positionXChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.position.x = 150

    let animation = CABasicAnimation(keyPath: "position.x")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.explicitAnimationDuration
    animation.fromValue = 60
    animation.toValue = 150
    layer.add(animation, forKey: "position.x")

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 100, y: 20, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_positionXChanged_additive() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animate(keyPath: "position.x", to: 150, timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 100, y: 20, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_positionYChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.position.y = 300

    let animation = CABasicAnimation(keyPath: "position.y")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.explicitAnimationDuration
    animation.fromValue = 120
    animation.toValue = 300
    layer.add(animation, forKey: "position.y")

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 10, y: 200, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_positionYChanged_additive() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animate(keyPath: "position.y", to: 300, timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 10, y: 200, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_boundsChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds = CGRect(x: 10, y: 20, width: 110, height: 220)
    let animation = CABasicAnimation(keyPath: "bounds")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.explicitAnimationDuration
    animation.fromValue = CGRect(x: 0, y: 0, width: 100, height: 200)
    animation.toValue = CGRect(x: 10, y: 20, width: 110, height: 220)
    layer.add(animation, forKey: "bounds")

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 10, width: 110, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_boundsChanged_additive() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animate(
      keyPath: "bounds",
      timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration),
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

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 10, width: 110, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
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
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds.size = CGSize(width: 110, height: 220)

    let animation = CABasicAnimation(keyPath: "bounds.size")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.explicitAnimationDuration
    animation.fromValue = CGSize(width: 100, height: 200)
    animation.toValue = CGSize(width: 110, height: 220)
    layer.add(animation, forKey: "bounds.size")

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 10, width: 110, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeWidthChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds.size.width = 110
    let animation = CABasicAnimation(keyPath: "bounds.size.width")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.explicitAnimationDuration
    animation.fromValue = 100
    animation.toValue = 110
    layer.add(animation, forKey: "bounds.size.width")

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 20, width: 110, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeWidthChanged_additive() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animate(keyPath: "bounds.size.width", to: 110, timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 20, width: 110, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeHeightChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds.size.height = 220
    let animation = CABasicAnimation(keyPath: "bounds.size.height")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = Constants.explicitAnimationDuration
    animation.fromValue = 200
    animation.toValue = 220
    layer.add(animation, forKey: "bounds.size.height")

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 10, y: 10, width: 100, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_boundsSizeHeightChanged_additive() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animate(keyPath: "bounds.size.height", to: 220, timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 10, y: 10, width: 100, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_frameChanged() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animateFrame(to: CGRect(x: 20, y: 40, width: 110, height: 220), timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 20, y: 40, width: 110, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_explicitAnimation_frameChanged_overlap() throws {
    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.animateFrame(to: CGRect(x: 20, y: 40, width: 110, height: 220), timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))
    layer.animateFrame(to: CGRect(x: 30, y: 50, width: 120, height: 230), timing: .easeInEaseOut(duration: Constants.explicitAnimationDuration))

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 30, y: 50, width: 120, height: 230)
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
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.position = CGPoint(x: 150, y: 300)
    wait(timeout: 1e-6) // wait until next runloop

    let positionAnimation = try (layer.animation(forKey: "position") as? CABasicAnimation).unwrap()
    expect(positionAnimation.duration) == 0.25

    if isGitHubActionsMac {
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

    // old position is (60, 120)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.position.x = 150
    wait(timeout: 1e-6) // wait until next runloop

    let positionAnimation = try (layer.animation(forKey: "position") as? CABasicAnimation).unwrap()
    expect(positionAnimation.duration) == 0.25

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 100, y: 20, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_implicitAnimation_positionYChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // old position is (60, 120)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.position.y = 300
    wait(timeout: 1e-6) // wait until next runloop

    let positionAnimation = try (layer.animation(forKey: "position") as? CABasicAnimation).unwrap()
    expect(positionAnimation.duration) == 0.25

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 10, y: 200, width: 100, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
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

    // old bounds is (100, 200)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds.size = CGSize(width: 110, height: 220)
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 10, width: 110, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_implicitAnimation_boundsSizeWidthChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // old bounds is (100, 200)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds.size.width = 110
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 20, width: 110, height: 200)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_implicitAnimation_boundsSizeHeightChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // old bounds is (100, 200)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds.size.height = 220
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 10, y: 10, width: 100, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_implicitAnimation_boundsChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // old bounds is (100, 200)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.bounds = CGRect(x: 10, y: 20, width: 110, height: 220)
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 5, y: 10, width: 110, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  func test_onLiveFrameChange_implicitAnimation_frameChanged() throws {
    layer.delegate = nil // remove the delegate to enable implicit animations

    // old bounds is (100, 200)

    let waiter = TickWaiter()
    var capturedFrames: [(CALayer, CGRect)] = []

    let expectation = XCTestExpectation(description: "tick")
    layer.onLiveFrameChange { layer, frame in
      capturedFrames.append((layer, frame))
      waiter.tick()
      if isGitHubActionsMac {
        expectation.fulfill()
      }
    }

    layer.frame = CGRect(x: 10, y: 20, width: 110, height: 220)
    wait(timeout: 1e-6) // wait until next runloop

    let positionAnimation = try (layer.animation(forKey: "position") as? CABasicAnimation).unwrap()
    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(positionAnimation.duration) == 0.25
    expect(boundsAnimation.duration) == 0.25

    if isGitHubActionsMac {
      wait(for: [expectation], timeout: 1)
    } else {
      waiter.wait() // wait until the animation is finished

      expect(capturedFrames.count) > 2
      try expect(capturedFrames.last.unwrap().0) === layer
      try expect(capturedFrames.last.unwrap().1) == CGRect(x: 10, y: 20, width: 110, height: 220)
      expect(layer.sublayers?.count ?? 0) == 0 // should have no display layer
    }
  }

  // MARK: - Constants

  private enum Constants {
    static let explicitAnimationDuration: TimeInterval = 0.1
  }
}

#if os(macOS)
private let isGitHubActionsMac: Bool = Environment.isGitHubActions
#else
private let isGitHubActionsMac: Bool = false
#endif

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
