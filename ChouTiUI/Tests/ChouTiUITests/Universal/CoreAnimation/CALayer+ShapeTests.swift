//
//  CALayer+ShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/22/22.
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

class CALayer_ShapeTests: XCTestCase {

  func test_shape() {
    let layer = CALayer()

    // initially nil
    expect(layer.shape) == nil
    expect(layer.mask) == nil

    // set a rectangle shape
    let rectangle = SuperEllipse(cornerRadius: SuperEllipse.CornerRadius(topLeft: 1, topRight: 2, bottomRight: 3, bottomLeft: 4))
    layer.shape = rectangle
    expect(layer.shape?.isEqual(to: rectangle)) == true
    expect(layer.mask?.frame) == layer.bounds

    // set the same shape again
    layer.shape = rectangle
    expect(layer.shape?.isEqual(to: rectangle)) == true
    expect(layer.mask?.frame) == layer.bounds

    // set a circle shape
    let circle = Circle()
    layer.shape = circle
    expect(layer.shape.isEqual(to: circle)) == true
    expect(layer.mask?.frame) == layer.bounds

    // set back to nil
    layer.shape = nil
    expect(layer.shape) == nil
    expect(layer.mask) == nil
  }

  func test_shape_maskIsRemoved_sameShape() {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    let rectangle = Rectangle()
    layer.shape = rectangle
    expect(layer.mask) != nil

    // remove the mask
    layer.mask = nil
    expect(layer.mask) == nil

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "should have mask layer"
    }

    // set the same shape again
    layer.shape = rectangle
    expect(layer.mask) != nil // should create a new mask layer

    Assert.resetTestAssertionFailureHandler()
  }

  func test_shape_maskIsRemoved_differentShape() {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    let rectangle = Rectangle()
    layer.shape = rectangle
    expect(layer.mask) != nil

    // remove the mask
    layer.mask = nil
    expect(layer.mask) == nil

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "should have mask layer"
    }

    // set a different shape
    let circle = Circle()
    layer.shape = circle
    expect(layer.mask) != nil // should create a new mask layer

    Assert.resetTestAssertionFailureHandler()
  }

  // MARK: - Size Change No Animation

  func test_shape_noAnimation_boundsChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.delegate = CALayer.DisableImplicitAnimationDelegate.shared
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 300)
    wait(timeout: 1e-6) // wait until next runloop

    expect(layer.animationKeys()) == nil
    expect(layer.mask?.animationKeys()) == nil
  }

  // MARK: - Size Change Explicit Animation

  func test_shape_explicitAnimation_boundsChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 300)
    let animation = CABasicAnimation(keyPath: "bounds")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = 0.1
    animation.fromValue = CGRect(x: 0, y: 0, width: 100, height: 100)
    animation.toValue = CGRect(x: 0, y: 0, width: 200, height: 300)
    layer.add(animation, forKey: "bounds")

    wait(timeout: 1e-6) // wait until next runloop

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.1
  }

  func test_shape_explicitAnimation_boundsSizeChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds.size = CGSize(width: 200, height: 300)
    let animation = CABasicAnimation(keyPath: "bounds.size")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = 0.1
    animation.fromValue = CGSize(width: 100, height: 100)
    animation.toValue = CGSize(width: 200, height: 300)
    layer.add(animation, forKey: "bounds.size")

    wait(timeout: 1e-6) // wait until next runloop

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.1
  }

  func test_shape_explicitAnimation_boundsSizeWidthChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds.size.width = 200
    let animation = CABasicAnimation(keyPath: "bounds.size.width")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = 0.1
    animation.fromValue = 100
    animation.toValue = 200
    layer.add(animation, forKey: "bounds.size.width")

    wait(timeout: 1e-6) // wait until next runloop

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.1
  }

  func test_shape_explicitAnimation_boundsSizeHeightChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds.size.height = 300
    let animation = CABasicAnimation(keyPath: "bounds.size.height")
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.duration = 0.1
    animation.fromValue = 100
    animation.toValue = 300
    layer.add(animation, forKey: "bounds.size.height")

    wait(timeout: 1e-6) // wait until next runloop

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.1
  }

  // MARK: - Size Change Implicit Animation

  func test_boundsChange_implicitAnimation_boundsChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 300)
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.25
  }

  func test_boundsChange_implicitAnimation_boundsSizeChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds.size = CGSize(width: 200, height: 300)
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.25
  }

  func test_boundsChange_implicitAnimation_boundsSizeWidthChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds.size.width = 200
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.25
  }

  func test_boundsChange_implicitAnimation_boundsSizeHeightChanged() throws {
    let window = TestWindow()

    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds.size.height = 300
    wait(timeout: 1e-6) // wait until next runloop

    let boundsAnimation = try (layer.animation(forKey: "bounds") as? CABasicAnimation).unwrap()
    expect(boundsAnimation.duration) == 0.25

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.toValue as! CGPath)) === (layer.mask as? CAShapeLayer)?.path // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.25
  }

  // MARK: - Shape Animation

  func test_shapeAnimation_noShape_fromShapeIsNil() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "layer has no shape and no from shape"
    }

    layer.animateShape(to: Circle(), timing: .easeInEaseOut(duration: 0.25))

    Assert.resetTestAssertionFailureHandler()
  }

  func test_shapeAnimation_hasShape_noMaskLayer() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()
    layer.mask = nil

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "no mask layer"
    }

    layer.animateShape(to: Circle(), timing: .easeInEaseOut(duration: 0.25))

    Assert.resetTestAssertionFailureHandler()
  }

  func test_shapeAnimation_hasShape_fromShapeIsNil() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()

    layer.animateShape(to: Circle(), timing: .easeInEaseOut(duration: 0.25))

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.fromValue as! CGPath).pathElements()) == Rectangle().path(in: layer.bounds).pathElements() // swiftlint:disable:this force_cast
    expect((maskPathAnimation.toValue as! CGPath).pathElements()) == Circle().path(in: layer.bounds).pathElements() // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.25
    expect(maskPathAnimation.timingFunction) == CAMediaTimingFunction(name: .easeInEaseOut)

    expect(layer.shape?.isEqual(to: Circle())) == true
  }

  func test_shapeAnimation_noShape_fromShapeIsNotNil() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    layer.animateShape(from: Capsule(), to: Circle(), timing: .easeInEaseOut(duration: 0.25))

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.fromValue as! CGPath).pathElements()) == Capsule().path(in: layer.bounds).pathElements() // swiftlint:disable:this force_cast
    expect((maskPathAnimation.toValue as! CGPath).pathElements()) == Circle().path(in: layer.bounds).pathElements() // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.25
    expect(maskPathAnimation.timingFunction) == CAMediaTimingFunction(name: .easeInEaseOut)

    expect(layer.shape?.isEqual(to: Circle())) == true
  }

  func test_shapeAnimation_hasShape_fromShapeIsNotNil() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
    layer.shape = Rectangle()

    layer.animateShape(from: Capsule(), to: Circle(), timing: .easeInEaseOut(duration: 0.25))

    let maskPathAnimation = try (layer.mask?.animation(forKey: "path") as? CABasicAnimation).unwrap()
    expect(maskPathAnimation.keyPath) == "path"
    expect((maskPathAnimation.fromValue as! CGPath).pathElements()) == Capsule().path(in: layer.bounds).pathElements() // swiftlint:disable:this force_cast
    expect((maskPathAnimation.toValue as! CGPath).pathElements()) == Circle().path(in: layer.bounds).pathElements() // swiftlint:disable:this force_cast
    expect(maskPathAnimation.isAdditive) == false
    expect(maskPathAnimation.duration) == 0.25
    expect(maskPathAnimation.timingFunction) == CAMediaTimingFunction(name: .easeInEaseOut)

    expect(layer.shape?.isEqual(to: Circle())) == true
  }
}
