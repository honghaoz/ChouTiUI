//
//  CALayer+BackgroundColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/12/24.
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
@_spi(Private) import ChouTiUI
@_spi(Private) import ComposeUI

class CALayer_BackgroundColorTests: XCTestCase {

  func test_fromNoColor_toNoColor() {
    let layer = CALayer()
    layer.isOpaque = true

    layer.background = nil
    expect(layer.backgroundColor) == nil
    expect(layer.isOpaque) == false
    expect(layer.backgroundGradientLayer) == nil
  }

  func test_fromNoColor_toSolidColor() {
    let layer = CALayer()

    // set opaque color
    do {
      layer.background = UnifiedColor.color(.red)
      expect(layer.backgroundColor) == Color.red.cgColor
      expect(layer.isOpaque) == true
      expect(layer.backgroundGradientLayer) == nil
    }

    // set non-opaque color
    do {
      layer.background = UnifiedColor.color(.green.opacity(0.5))
      expect(layer.backgroundColor) == Color.green.withAlphaComponent(0.5).cgColor
      expect(layer.isOpaque) == false
      expect(layer.backgroundGradientLayer) == nil
    }
  }

  func test_fromNoColor_toGradient() {
    let layer = CALayer()
    let sublayer = CALayer()
    layer.addSublayer(sublayer)

    layer.background = .linearGradient(LinearGradientColor([.red, .blue]))
    expect(layer.backgroundColor) == nil
    expect(layer.isOpaque) == false
    expect(layer.backgroundGradientLayer) != nil
    expect(layer.backgroundGradientLayer?.frame) == layer.bounds
    expect(layer.sublayers?.first) === layer.backgroundGradientLayer // gradient layer is added to the root layer

    // change bounds
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    expect(layer.backgroundGradientLayer?.frame) == layer.bounds

    // hack to test when gradient layer is removed
    layer.backgroundGradientLayer?.removeFromSuperlayer()

    Assert.setTestAssertionFailureHandler { message, _, _, _, _ in
      expect(message) == "bounds change call must have gradient background layer"
    }

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)

    Assert.resetTestAssertionFailureHandler()
  }

  func test_fromSolidColor_toNoColor() {
    let layer = CALayer()
    layer.background = UnifiedColor.color(.red)

    layer.background = nil
    expect(layer.backgroundColor) == nil
    expect(layer.isOpaque) == false
    expect(layer.backgroundGradientLayer) == nil
  }

  func test_fromSolidColor_toSolidColor() {
    let layer = CALayer()
    layer.background = UnifiedColor.color(.red)

    layer.background = UnifiedColor.color(.green)
    expect(layer.backgroundColor) == Color.green.cgColor
    expect(layer.isOpaque) == true
    expect(layer.backgroundGradientLayer) == nil
  }

  func test_fromSolidColor_toGradient() {
    let layer = CALayer()
    layer.background = UnifiedColor.color(.red)

    layer.background = .linearGradient(LinearGradientColor([.red, .blue]))
    expect(layer.backgroundColor) == nil
    expect(layer.isOpaque) == false
    expect(layer.backgroundGradientLayer) != nil
    expect(layer.backgroundGradientLayer?.frame) == layer.bounds
    expect(layer.sublayers?.first) === layer.backgroundGradientLayer // gradient layer is added to the root layer
  }

  func test_fromGradient_toNoColor() {
    let layer = CALayer()
    layer.background = .linearGradient(LinearGradientColor([.red, .blue]))

    layer.background = nil
    expect(layer.backgroundColor) == nil
    expect(layer.isOpaque) == false
    expect(layer.backgroundGradientLayer) == nil
  }

  func test_fromGradient_toSolidColor() {
    let layer = CALayer()
    layer.background = .linearGradient(LinearGradientColor([.red, .blue]))

    layer.background = UnifiedColor.color(.green)
    expect(layer.backgroundColor) == Color.green.cgColor
    expect(layer.isOpaque) == true
    expect(layer.backgroundGradientLayer) == nil
  }

  func test_fromGradient_toGradient() {
    let layer = CALayer()
    layer.background = .linearGradient(LinearGradientColor([.red, .blue]))

    layer.background = .linearGradient(LinearGradientColor([.green, .yellow]))
    expect(layer.backgroundColor) == nil
    expect(layer.isOpaque) == false
    expect(layer.backgroundGradientLayer) != nil
    expect(layer.backgroundGradientLayer?.frame) == layer.bounds
  }

  func test_setBackgroundColor_solid() {
    let layer = CALayer()
    layer.setBackgroundColor(.red)
    expect(layer.backgroundColor) == Color.red.cgColor
  }

  func test_setBackgroundColor_gradient() {
    let layer = CALayer()

    layer.setBackgroundColor(LinearGradientColor(colors: [.red, .blue]))
    expect(layer.backgroundColor) == nil
    expect(layer.backgroundGradientLayer?.type) == CAGradientLayerType.axial

    layer.setBackgroundColor(RadialGradientColor(colors: [.red, .blue], centerPoint: .center, endPoint: .bottom))
    expect(layer.backgroundColor) == nil
    expect(layer.backgroundGradientLayer?.type) == CAGradientLayerType.radial

    layer.setBackgroundColor(AngularGradientColor(colors: [.red, .yellow], centerPoint: .center, aimingPoint: .top))
    expect(layer.backgroundColor) == nil
    expect(layer.backgroundGradientLayer?.type) == CAGradientLayerType.conic
  }

  func test_removeBackgroundColor() {
    let layer = CALayer()
    layer.setBackgroundColor(.red)
    layer.removeBackgroundColor()
    expect(layer.backgroundColor) == nil
  }

  func test_boundsChange_nonAdditiveAnimation_beforeBoundsChange() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.setBackgroundColor(LinearGradientColor(colors: [.red, .blue]))
    let backgroundGradientLayer = try layer.backgroundGradientLayer.unwrap()

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
      expect(backgroundGradientLayer.animationKeys()) == ["position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }

  func test_boundsChange_nonAdditiveAnimation_afterBoundsChange() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.setBackgroundColor(LinearGradientColor(colors: [.red, .blue]))
    let backgroundGradientLayer = try layer.backgroundGradientLayer.unwrap()

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
      expect(backgroundGradientLayer.animationKeys()) == ["position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }

  func test_boundsChange_additiveAnimation() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.setBackgroundColor(LinearGradientColor(colors: [.red, .blue]))
    let backgroundGradientLayer = try layer.backgroundGradientLayer.unwrap()

    // additive animation, animation added before the bounds change
    layer.animateFrame(to: CGRect(x: 0, y: 0, width: 150, height: 200), timing: .spring())

    let waitExpectation = expectation(description: "wait")

    RunLoop.main.perform {
      expect(backgroundGradientLayer.animationKeys()) == ["position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }

  func test_boundsChange_implicitAnimation() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.setBackgroundColor(LinearGradientColor(colors: [.red, .blue]))
    let backgroundGradientLayer = try layer.backgroundGradientLayer.unwrap()

    #if canImport(AppKit)
    let window = NSWindow(
      contentRect: CGRect(x: 0, y: 0, width: 500, height: 500),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )
    window.contentView?.wantsLayer = true
    window.contentView?.layer?.addSublayer(layer)
    #else
    let window = UIWindow()
    window.layer.addSublayer(layer)
    #endif

    // wait for the layer to have a presentation layer
    wait(timeout: 0.05)

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 300)

    let waitExpectation = expectation(description: "wait")

    RunLoop.main.perform {
      expect(backgroundGradientLayer.animationKeys()) == ["position", "bounds.size"]
      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])
  }
}
