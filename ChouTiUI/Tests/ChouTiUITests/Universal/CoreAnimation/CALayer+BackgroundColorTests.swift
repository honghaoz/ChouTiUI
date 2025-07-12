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
@_spi(Private) @testable import ChouTiUI
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
    let window = TestWindow()

    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.setBackgroundColor(LinearGradientColor(colors: [.red, .blue]))
    window.layer.addSublayer(layer)

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
    let window = TestWindow()

    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.setBackgroundColor(LinearGradientColor(colors: [.red, .blue]))
    let backgroundGradientLayer = try layer.backgroundGradientLayer.unwrap()

    window.layer.addSublayer(layer)

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

  func test_animation_solidToSolid() throws {
    // when layer has no background and backgroundColor
    do {
      let window = TestWindow()
      let layer = CALayer()
      window.layer.addSublayer(layer)

      layer.animateBackground(to: UnifiedColor.color(.green), timing: .easeInEaseOut(duration: 0.05))
      let animation = try (layer.animation(forKey: "backgroundColor").unwrap() as? CABasicAnimation).unwrap()
      expect(animation.fromValue as! CGColor) == Color.clear.cgColor // swiftlint:disable:this force_cast
      expect(animation.toValue as! CGColor) == Color.green.cgColor // swiftlint:disable:this force_cast
      expect(animation.duration) == 0.05
      expect(layer.test.solidColorAnimation) != nil
      expect(layer.test.solidColorAnimation).toEventually(beEqual(to: nil))
    }

    // when layer has no background but has backgroundColor
    do {
      let window = TestWindow()
      let layer = CALayer()
      layer.backgroundColor = Color.red.cgColor // <---
      window.layer.addSublayer(layer)

      layer.animateBackground(to: UnifiedColor.color(.green), timing: .easeInEaseOut(duration: 0.05))
      let animation = try (layer.animation(forKey: "backgroundColor").unwrap() as? CABasicAnimation).unwrap()
      expect(animation.fromValue as! CGColor) == Color.red.cgColor // swiftlint:disable:this force_cast
      expect(animation.toValue as! CGColor) == Color.green.cgColor // swiftlint:disable:this force_cast
      expect(animation.duration) == 0.05
      expect(layer.test.solidColorAnimation) != nil
      expect(layer.test.solidColorAnimation).toEventually(beEqual(to: nil))
    }

    // when layer has background
    do {
      let window = TestWindow()
      let layer = CALayer()
      layer.background = UnifiedColor.color(.red) // <---
      window.layer.addSublayer(layer)

      layer.animateBackground(to: UnifiedColor.color(.green), timing: .easeInEaseOut(duration: 0.05))
      let animation = try (layer.animation(forKey: "backgroundColor").unwrap() as? CABasicAnimation).unwrap()
      expect(animation.fromValue as! CGColor) == Color.red.cgColor // swiftlint:disable:this force_cast
      expect(animation.toValue as! CGColor) == Color.green.cgColor // swiftlint:disable:this force_cast
      expect(animation.duration) == 0.05
      expect(layer.test.solidColorAnimation) != nil
      expect(layer.test.solidColorAnimation).toEventually(beEqual(to: nil))
    }

    // when layer has background, to color is nil
    do {
      let window = TestWindow()
      let layer = CALayer()
      layer.background = UnifiedColor.color(.red) // <---
      window.layer.addSublayer(layer)

      layer.animateBackground(to: nil, timing: .easeInEaseOut(duration: 0.05))
      let animation = try (layer.animation(forKey: "backgroundColor").unwrap() as? CABasicAnimation).unwrap()
      expect(animation.fromValue as! CGColor) == Color.red.cgColor // swiftlint:disable:this force_cast
      expect(animation.toValue as! CGColor) == Color.clear.cgColor // swiftlint:disable:this force_cast
      expect(animation.duration) == 0.05
      expect(layer.test.solidColorAnimation) != nil
      expect(layer.test.solidColorAnimation).toEventually(beEqual(to: nil))
    }

    // when there's a solid animation in progress
    do {
      let window = TestWindow()
      let layer = CALayer()
      layer.background = UnifiedColor.color(.red)
      window.layer.addSublayer(layer)

      // first animation
      layer.animateBackground(to: UnifiedColor.color(.green), timing: .easeInEaseOut(duration: 0.2))
      var animation = try (layer.animation(forKey: "backgroundColor").unwrap() as? CABasicAnimation).unwrap()
      expect(animation.fromValue as! CGColor) == Color.red.cgColor // swiftlint:disable:this force_cast
      expect(animation.toValue as! CGColor) == Color.green.cgColor // swiftlint:disable:this force_cast
      expect(animation.duration) == 0.2
      expect(layer.test.solidColorAnimation) != nil

      wait(timeout: 0.1)
      // second animation
      let inProgressColor = try layer.presentation().unwrap().backgroundColor.unwrap()
      layer.animateBackground(to: UnifiedColor.color(.blue), timing: .easeInEaseOut(duration: 0.1))
      animation = try (layer.animation(forKey: "backgroundColor").unwrap() as? CABasicAnimation).unwrap()
      expect(animation.fromValue as! CGColor) != Color.green.cgColor // swiftlint:disable:this force_cast
      expect(animation.fromValue as! CGColor) == inProgressColor // swiftlint:disable:this force_cast
      expect(animation.toValue as! CGColor) == Color.blue.cgColor // swiftlint:disable:this force_cast
      expect(animation.duration) == 0.1
      expect(layer.test.solidColorAnimation) != nil

      wait(timeout: 0.051)
      expect(layer.test.solidColorAnimation) != nil // the first animation completion doesn't clear the solidColorAnimation
      expect(layer.test.solidColorAnimation).toEventually(beEqual(to: nil))
    }
  }

  func test_animation_solidToGradient() throws {
    let window = TestWindow()
    let layer = CALayer()
    layer.background = .color(.red)
    window.layer.addSublayer(layer)

    let gradient = LinearGradientColor([.red, .blue, .yellow], [0, 0.2, 1], .topLeft, .bottomRight)
    layer.animateBackground(to: UnifiedColor.linearGradient(gradient), timing: .easeInEaseOut(duration: 0.05))
    let animationLayer = try layer.test.animationGradientLayer.unwrap()
    expect(animationLayer.type) == .axial
    expect(animationLayer.colors as! [CGColor]) == [Color.red, .blue, .yellow].map(\.cgColor) // swiftlint:disable:this force_cast
    expect(animationLayer.locations as! [CGFloat]) == [0, 0.2, 1] // swiftlint:disable:this force_cast
    expect(animationLayer.startPoint) == UnitPoint.topLeft.cgPoint
    expect(animationLayer.endPoint) == UnitPoint.bottomRight.cgPoint

    let animation = try (animationLayer.animation(forKey: "colors").unwrap() as? CABasicAnimation).unwrap()
    expect(animation.fromValue as! [CGColor]) == [Color.red.cgColor, Color.red.cgColor, Color.red.cgColor] // swiftlint:disable:this force_cast
    expect(animation.toValue as! [CGColor]) == [Color.red.cgColor, Color.blue.cgColor, Color.yellow.cgColor] // swiftlint:disable:this force_cast
    expect(animation.duration) == 0.05
    expect(layer.test.solidColorAnimation) == nil
    expect(layer.test.animationGradientLayer) != nil
    expect(layer.test.animationGradientLayer).toEventually(beEqual(to: nil))
  }

  func test_animation_gradientToSolid() throws {
    let window = TestWindow()
    let layer = CALayer()
    window.layer.addSublayer(layer)

    let gradient = AngularGradientColor(colors: [.red, .blue, .yellow], locations: [0, 0.2, 1], startPoint: .topLeft, endPoint: .bottomRight)
    layer.animateBackground(from: UnifiedColor.angularGradient(gradient), to: .color(.red), timing: .easeInEaseOut(duration: 0.05))
    let animationLayer = try layer.test.animationGradientLayer.unwrap()
    expect(animationLayer.type) == .conic
    expect(animationLayer.colors as! [CGColor]) == [Color.red, .red, .red].map(\.cgColor) // swiftlint:disable:this force_cast
    expect(animationLayer.locations as! [CGFloat]) == [0, 0.2, 1] // swiftlint:disable:this force_cast
    expect(animationLayer.startPoint) == UnitPoint.topLeft.cgPoint
    expect(animationLayer.endPoint) == UnitPoint.bottomRight.cgPoint

    let animation = try (animationLayer.animation(forKey: "colors").unwrap() as? CABasicAnimation).unwrap()
    expect(animation.fromValue as! [CGColor]) == [Color.red.cgColor, Color.blue.cgColor, Color.yellow.cgColor] // swiftlint:disable:this force_cast
    expect(animation.toValue as! [CGColor]) == [Color.red.cgColor, Color.red.cgColor, Color.red.cgColor] // swiftlint:disable:this force_cast
    expect(animation.duration) == 0.05
    expect(layer.test.solidColorAnimation) == nil
    expect(layer.test.animationGradientLayer) != nil
    expect(layer.test.animationGradientLayer).toEventually(beEqual(to: nil))
  }

  func test_animation_gradientToGradient() throws {
    let window = TestWindow()
    let layer = CALayer()
    window.layer.addSublayer(layer)

    let fromGradient = AngularGradientColor(colors: [.red, .blue, .yellow], locations: [0, 0.2, 1], startPoint: .topLeft, endPoint: .bottomRight)
    let toGradient = AngularGradientColor(colors: [.black, .green, .purple], locations: [0, 0.7, 1], startPoint: .topRight, endPoint: .bottom)
    layer.animateBackground(
      from: UnifiedColor.angularGradient(fromGradient),
      to: UnifiedColor.angularGradient(toGradient),
      timing: .easeInEaseOut(duration: 0.05)
    )
    let animationLayer = try layer.test.animationGradientLayer.unwrap()
    expect(animationLayer.type) == .conic
    expect(animationLayer.colors as! [CGColor]) == [Color.black, .green, .purple].map(\.cgColor) // swiftlint:disable:this force_cast
    expect(animationLayer.locations as! [CGFloat]) == [0, 0.7, 1] // swiftlint:disable:this force_cast
    expect(animationLayer.startPoint) == UnitPoint.topRight.cgPoint
    expect(animationLayer.endPoint) == UnitPoint.bottom.cgPoint

    let animation = try (animationLayer.animation(forKey: "colors").unwrap() as? CABasicAnimation).unwrap()
    expect(animation.fromValue as! [CGColor]) == [Color.red.cgColor, Color.blue.cgColor, Color.yellow.cgColor] // swiftlint:disable:this force_cast
    expect(animation.toValue as! [CGColor]) == [Color.black.cgColor, Color.green.cgColor, Color.purple.cgColor] // swiftlint:disable:this force_cast
    expect(animation.duration) == 0.05
    expect(layer.test.solidColorAnimation) == nil
    expect(layer.test.animationGradientLayer) != nil
    expect(layer.test.animationGradientLayer).toEventually(beEqual(to: nil))
  }

  func test_inProgressGradientAnimation_linear() throws {
    let window = TestWindow()
    let layer = CALayer()
    layer.background = .linearGradient(LinearGradientColor([.red, .blue]))
    window.layer.addSublayer(layer)

    // Start first animation
    let firstGradient = LinearGradientColor([.green, .yellow])
    layer.animateBackground(to: UnifiedColor.linearGradient(firstGradient), timing: .easeInEaseOut(duration: 0.1))
    let animationLayer = try layer.test.animationGradientLayer.unwrap()
    expect(animationLayer.type) == .axial
    expect(layer.test.animationGradientLayer) != nil

    // Wait for animation to be in progress
    wait(timeout: 0.05)

    // Start second animation while first is in progress
    let secondGradient = LinearGradientColor([.purple, .orange])
    layer.animateBackground(to: UnifiedColor.linearGradient(secondGradient), timing: .easeInEaseOut(duration: 0.1))

    // Verify that the animation layer is still the same instance and properly configured
    expect(layer.test.animationGradientLayer) === animationLayer
    expect(animationLayer.type) == .axial
    expect(animationLayer.colors as! [CGColor]) == [Color.purple, .orange].map(\.cgColor) // swiftlint:disable:this force_cast

    // Verify animation exists on the layer
    expect(animationLayer.animation(forKey: "colors")) != nil
    expect(layer.test.animationGradientLayer) != nil
    expect(layer.test.animationGradientLayer).toEventually(beEqual(to: nil))
  }

  func test_inProgressGradientAnimation_radial() throws {
    let window = TestWindow()
    let layer = CALayer()
    layer.background = .radialGradient(RadialGradientColor(colors: [.red, .blue], centerPoint: .center, endPoint: .topRight))
    window.layer.addSublayer(layer)

    // Start first animation
    let firstGradient = RadialGradientColor(colors: [.green, .yellow], centerPoint: .center, endPoint: .bottom)
    layer.animateBackground(to: UnifiedColor.radialGradient(firstGradient), timing: .easeInEaseOut(duration: 0.1))
    let animationLayer = try layer.test.animationGradientLayer.unwrap()
    expect(animationLayer.type) == .radial
    expect(layer.test.animationGradientLayer) != nil

    // Wait for animation to be in progress
    wait(timeout: 0.05)

    // Start second animation while first is in progress
    let secondGradient = RadialGradientColor(colors: [.purple, .orange], centerPoint: .topLeft, endPoint: .bottomRight)
    layer.animateBackground(to: UnifiedColor.radialGradient(secondGradient), timing: .easeInEaseOut(duration: 0.1))

    // Verify that the animation layer is still the same instance and properly configured
    expect(layer.test.animationGradientLayer) === animationLayer
    expect(animationLayer.type) == .radial
    expect(animationLayer.colors as! [CGColor]) == [Color.purple, .orange].map(\.cgColor) // swiftlint:disable:this force_cast
    expect(animationLayer.startPoint) == UnitPoint.topLeft.cgPoint
    expect(animationLayer.endPoint) == UnitPoint.bottomRight.cgPoint

    // Verify animation exists on the layer
    expect(animationLayer.animation(forKey: "colors")) != nil
    expect(layer.test.animationGradientLayer) != nil
    expect(layer.test.animationGradientLayer).toEventually(beEqual(to: nil))
  }

  func test_inProgressGradientAnimation_angular() throws {
    let window = TestWindow()
    let layer = CALayer()
    layer.background = .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .top))
    window.layer.addSublayer(layer)

    // Start first animation
    let firstGradient = AngularGradientColor(colors: [.green, .yellow], centerPoint: .center, aimingPoint: .bottom)
    layer.animateBackground(to: UnifiedColor.angularGradient(firstGradient), timing: .easeInEaseOut(duration: 0.1))
    let animationLayer = try layer.test.animationGradientLayer.unwrap()
    expect(animationLayer.type) == .conic
    expect(layer.test.animationGradientLayer) != nil

    // Wait for animation to be in progress
    wait(timeout: 0.05)

    // Start second animation while first is in progress
    let secondGradient = AngularGradientColor(colors: [.purple, .orange], centerPoint: .topLeft, aimingPoint: .bottomRight)
    layer.animateBackground(to: UnifiedColor.angularGradient(secondGradient), timing: .easeInEaseOut(duration: 0.1))

    // Verify that the animation layer is still the same instance and properly configured
    expect(layer.test.animationGradientLayer) === animationLayer
    expect(animationLayer.type) == .conic
    expect(animationLayer.colors as! [CGColor]) == [Color.purple, .orange].map(\.cgColor) // swiftlint:disable:this force_cast
    expect(animationLayer.startPoint) == UnitPoint.topLeft.cgPoint
    expect(animationLayer.endPoint) == UnitPoint.bottomRight.cgPoint

    // Verify animation exists on the layer
    expect(animationLayer.animation(forKey: "colors")) != nil
    expect(layer.test.animationGradientLayer) != nil
    expect(layer.test.animationGradientLayer).toEventually(beEqual(to: nil))
  }

  func test_inProgressGradientAnimation_animationGradientLayerHasSizeAnimation() throws {
    // verify that animating the layer size while animating the gradient color will add a size animation to the animation layer
    let window = TestWindow()
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    window.layer.addSublayer(layer)

    // Start gradient animation
    let firstGradient = LinearGradientColor([.red, .blue])
    layer.animateBackground(to: UnifiedColor.linearGradient(firstGradient), timing: .easeInEaseOut(duration: 0.05))
    let animationGradientLayer = try layer.test.animationGradientLayer.unwrap()

    // Verify initial state
    expect(animationGradientLayer.animationKeys()) == ["colors"]
    expect(animationGradientLayer.frame) == layer.bounds

    // Animate layer size while gradient animation is in progress
    layer.animateFrame(to: CGRect(x: 0, y: 0, width: 200, height: 150), timing: .spring())

    let waitExpectation = expectation(description: "wait for size animation")

    RunLoop.main.perform {
      // Verify that the animation gradient layer has size synchronization animations
      expect(animationGradientLayer.animationKeys()) == ["colors", "position", "bounds.size"]

      // Verify that the frame is updated
      expect(animationGradientLayer.frame) == CGRect(x: 0, y: 0, width: 200, height: 150)

      // Verify that the animations are the expected types
      expect(animationGradientLayer.animation(forKey: "position")) != nil
      expect(animationGradientLayer.animation(forKey: "bounds.size")) != nil

      waitExpectation.fulfill()
    }

    wait(for: [waitExpectation])

    // Verify cleanup eventually happens
    expect(layer.test.animationGradientLayer).toEventually(beEqual(to: nil))
  }

  func test_animation_mismatchedGradient() throws {
    let window = TestWindow()
    let layer = CALayer()
    window.layer.addSublayer(layer)

    let linearGradient = LinearGradientColor([.red, .blue])
    let radialGradient = RadialGradientColor(colors: [.green, .yellow], centerPoint: .center, endPoint: .bottom)

    Assert.setTestAssertionFailureHandler { message, _, _, _, _ in
      expect(message) == "mismatch gradient layer type"
    }

    layer.animateBackground(
      from: UnifiedColor.linearGradient(linearGradient),
      to: UnifiedColor.radialGradient(radialGradient),
      timing: .easeInEaseOut(duration: 0.05)
    )

    Assert.resetTestAssertionFailureHandler()
  }
}
