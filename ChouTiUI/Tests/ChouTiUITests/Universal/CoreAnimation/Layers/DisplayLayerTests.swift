//
//  DisplayLayerTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/2/25.
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

class DisplayLayerTests: XCTestCase {

  func test_init() {
    let layer = DisplayLayer()

    // test default values
    expect(layer.value) == 0
    expect(layer.onDisplay) == nil

    // test that delegate is set to disable implicit animations
    expect(layer.delegate) != nil
    expect(layer.delegate is CALayer.DisableImplicitAnimationDelegate) == true
  }

  func test_initWithLayer() {
    let originalLayer = DisplayLayer()
    originalLayer.value = 42.5
    originalLayer.onDisplay = { _ in }

    let copiedLayer = DisplayLayer(layer: originalLayer)
    expect(copiedLayer.value) == 42.5
    expect(copiedLayer.onDisplay) != nil
  }

  func test_valueProperty() {
    let layer = DisplayLayer()

    // test initial value
    expect(layer.value) == 0

    // test setting value
    layer.value = 123.456
    expect(layer.value) == 123.456

    // test negative value
    layer.value = -789.012
    expect(layer.value) == -789.012
  }

  func test_needsDisplayForKey() {
    // test that "value" key triggers display
    expect(DisplayLayer.needsDisplay(forKey: "value")) == true

    // test that other keys use superclass behavior
    expect(DisplayLayer.needsDisplay(forKey: "bounds")) == CALayer.needsDisplay(forKey: "bounds")
    expect(DisplayLayer.needsDisplay(forKey: "position")) == CALayer.needsDisplay(forKey: "position")
    expect(DisplayLayer.needsDisplay(forKey: "unknownKey")) == CALayer.needsDisplay(forKey: "unknownKey")
  }

  func test_onDisplay() {
    let window = TestWindow()

    let layer = DisplayLayer()
    window.layer.addSublayer(layer)

    wait(timeout: 0.05) // wait for the layer's presentation layer to be created

    let animation = CABasicAnimation(keyPath: "value")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 1
    layer.add(animation, forKey: "value")

    let expectation = self.expectation(description: "onDisplay callback")
    layer.onDisplay = { value in
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
    expect(layer.onDisplay) != nil
  }

  func test_onDisplay_duplicateValues() {
    let window = TestWindow()

    let layer = DisplayLayer()
    layer.value = 50
    window.layer.addSublayer(layer)

    wait(timeout: 0.05) // wait for the layer's presentation layer to be created

    var capturedValues: [Double] = []
    layer.onDisplay = { value in
      capturedValues.append(value)
    }

    // first display
    layer.display()
    expect(capturedValues) == [50]

    // second display, presentation layer's value is the same
    layer.display()
    expect(capturedValues) == [50]
  }

  func test_onDisplay_withoutPresentationLayer() {
    let layer = DisplayLayer()
    // don't add the layer to the window's layer hierarchy so that the presentation layer is not created

    layer.onDisplay = { _ in
      fail("onDisplay should not be called")
    }

    layer.display()
  }

  func test_run() throws {
    let window = TestWindow()

    let layer = DisplayLayer()
    window.layer.addSublayer(layer)

    wait(timeout: 0.05) // wait for the layer's presentation layer to be created

    var callCount = 0
    layer.run(for: 0.1) {
      callCount += 1
    }

    let animation = try (layer.animation(forKey: "value") as? CABasicAnimation).unwrap()
    expect(animation.fromValue as? Double) == 0
    expect(animation.toValue as? Double) == 1
    expect(animation.duration).to(beApproximatelyEqual(to: 0.11, within: 1e-6))

    wait(timeout: 0.15)

    expect(layer.onDisplay) == nil // onDisplay should be nil because the animation is removed
  }

  func test_run_multipleCalls() throws {
    let window = TestWindow()

    let layer = DisplayLayer()
    window.layer.addSublayer(layer)

    wait(timeout: 0.05) // wait for the layer's presentation layer to be created

    layer.run(for: 0.1) {}
    layer.run(for: 0.2) {}

    let animation = try (layer.animation(forKey: "value") as? CABasicAnimation).unwrap()
    expect(animation.fromValue as? Double) == 0
    expect(animation.toValue as? Double) == 1
    expect(animation.duration).to(beApproximatelyEqual(to: 0.22, within: 1e-6))
  }
}
