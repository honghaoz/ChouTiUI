//
//  AnimationDelegateTests.swift
//  ChouTiUI
//
//  Created by Honghao on 7/11/25.
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
import ChouTiUI

class AnimationDelegateTests: XCTestCase {

  func test() {
    let didStartExpectation = expectation(description: "didStart")
    didStartExpectation.assertForOverFulfill = true
    let didStopExpectation = expectation(description: "didStop")
    didStopExpectation.assertForOverFulfill = true

    let animation = CABasicAnimation(keyPath: "backgroundColor")
    animation.fromValue = Color.red.cgColor
    animation.toValue = Color.blue.cgColor
    animation.duration = 0.1
    animation.delegate = AnimationDelegate(
      animationDidStart: { animation in
        didStartExpectation.fulfill()
      },
      animationDidStop: { animation, finished in
        if finished {
          didStopExpectation.fulfill()
        }
      }
    )

    let window = TestWindow()

    let layer = CALayer()
    layer.backgroundColor = Color.red.cgColor

    window.layer.addSublayer(layer)

    layer.add(animation, forKey: "backgroundColor")

    wait(for: [didStartExpectation, didStopExpectation], timeout: 0.5)
  }

  func test_redundantCalls() {
    let animation = CABasicAnimation(keyPath: "backgroundColor")

    var didStartCount = 0
    var didStopCount = 0

    let delegate = AnimationDelegate(
      animationDidStart: { animation in
        didStartCount += 1
      },
      animationDidStop: { animation, finished in
        didStopCount += 1
      }
    )

    delegate.animationDidStart(animation)
    delegate.animationDidStop(animation, finished: true)

    expect(didStartCount) == 1
    expect(didStopCount) == 1

    // redundant calls

    var assertionCount = 0
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      switch assertionCount {
      case 0:
        expect(message) == "animation already started"
        expect(metadata["animation"]) == "\(animation)"
      case 1:
        expect(message) == "animation already stopped"
        expect(metadata["animation"]) == "\(animation)"
      default:
        fail("unexpected assertion")
      }

      assertionCount += 1
    }

    delegate.animationDidStart(animation)
    delegate.animationDidStop(animation, finished: true)

    expect(didStartCount) == 1
    expect(didStopCount) == 1

    Assert.resetTestAssertionFailureHandler()
  }
}
