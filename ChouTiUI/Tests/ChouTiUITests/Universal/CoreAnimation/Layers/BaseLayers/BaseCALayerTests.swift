//
//  BaseCALayerTests.swift
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

final class BaseCALayerTests: XCTestCase {

  func test_init() {
    let layer = BaseCALayer()
    expect(layer.contents) == nil
    expect(layer.debugDescription.hasPrefix("<ChouTiUI.BaseCALayer:")) == true

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
    let layer = BaseCALayer()
    expect(layer.debugDescription.hasPrefix("<ChouTiUI.BaseCALayer:")) == true

    layer.setDebugDescription("Hello")
    expect(layer.debugDescription) == "Hello"
  }

  func test_init_withLayer() throws {
    let layer = BaseCALayer()
    layer.setDebugDescription("Hello")

    let testEnvironment = LayerTestEnvironment()
    testEnvironment.containerLayer.addSublayer(layer)

    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.5
    animation.duration = 1.0

    layer.add(animation, forKey: "opacity")

    wait(timeout: 0.05)

    let presentationLayer = try layer.presentation().unwrap()
    expect(presentationLayer.debugDescription) == "Hello"
  }

  func test_bindingObservationStorage() {
    let layer = BaseCALayer()
    Binding("").observe { _ in }.store(in: layer.bindingObservationStorage)
  }
}
