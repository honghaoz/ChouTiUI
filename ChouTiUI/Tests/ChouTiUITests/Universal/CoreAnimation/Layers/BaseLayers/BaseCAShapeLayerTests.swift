//
//  BaseCAShapeLayerTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/6/24.
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

class BaseCAShapeLayerTests: XCTestCase {

  func test_init() {
    let layer = BaseCAShapeLayer()
    expect(layer.contents) == nil
    expect(layer.debugDescription.hasPrefix("<ChouTiUI.BaseCAShapeLayer:")) == true

    #if !os(macOS)
    expect(layer.cornerCurve) == CALayerCornerCurve.continuous
    #endif

    #if os(visionOS)
    expect(layer.wantsDynamicContentScaling) == true
    #else
    expect(layer.contentsScale) == Screen.mainScreenScale
    #endif

    expect(layer.strongDelegate) === CALayer.DisableImplicitAnimationDelegate.shared
  }

  func test_debugDescription() {
    let layer = BaseCAShapeLayer()
    expect(layer.debugDescription.hasPrefix("<ChouTiUI.BaseCAShapeLayer:")) == true

    layer.setDebugDescription("Hello")
    expect(layer.debugDescription) == "Hello"
  }

  func test_init_withLayer() throws {
    let layer = BaseCAShapeLayer()
    layer.setDebugDescription("Hello")

    let testEnvironment = LayerTestEnvironment()
    testEnvironment.containerLayer.addSublayer(layer)

    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.5
    animation.duration = 1.0

    layer.add(animation, forKey: "opacity")

    expect(layer.presentation()?.debugDescription).toEventually(beEqual(to: "Hello"))
  }

  func test_bindingObservationStorage() {
    let layer = BaseCAShapeLayer()
    Binding("").observe { _ in }.store(in: layer.bindingObservationStorage)
  }
}
