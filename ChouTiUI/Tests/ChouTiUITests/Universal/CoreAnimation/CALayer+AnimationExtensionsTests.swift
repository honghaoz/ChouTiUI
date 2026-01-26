//
//  CALayer+AnimationExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/25/22.
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

import ChouTiUI

class CALayer_AnimationExtensionsTests: XCTestCase {

  // MARK: - Animations

  func test_animations() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    // no animation
    expect(Array(layer.animations()).count) == 0

    // one animation
    do {
      layer.add(
        {
          let animation = CABasicAnimation(keyPath: "bounds.size")
          animation.fromValue = CGSize(width: 100, height: 100)
          animation.toValue = CGSize(width: 200, height: 200)
          return animation
        }(),
        forKey: "bounds.size"
      )

      let animations = Array(layer.animations())

      expect(animations.count) == 1
      expect(try (animations.first as? CABasicAnimation).unwrap().keyPath) == "bounds.size"
    }

    // two animations
    do {
      layer.add(
        {
          let animation = CABasicAnimation(keyPath: "position")
          animation.fromValue = CGPoint(x: 0, y: 0)
          animation.toValue = CGPoint(x: 100, y: 100)
          return animation
        }(),
        forKey: "position"
      )

      let animations = Array(layer.animations())

      expect(animations.count) == 2
      expect(try (animations.first as? CABasicAnimation).unwrap().keyPath) == "bounds.size"
      expect(try (animations.last as? CABasicAnimation).unwrap().keyPath) == "position"
    }
  }

  // MARK: - Size Animation

  func test_sizeAnimation_implicitAnimation() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    let window = TestWindow()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

    layer.bounds.size = CGSize(width: 200, height: 200)

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds"
  }

  func test_sizeAnimation_implicitAnimation_withExplicitAnimation() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    let window = TestWindow()
    window.layer.addSublayer(layer)

    // wait for the layer to have a presentation layer
    expect(layer.presentation()).toEventuallyNot(beNil())

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

    expect(layer.animationKeys()?.count) == 2

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds.size"
  }

  func test_sizeAnimation_bounds() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = CGRect(x: 0, y: 0, width: 100, height: 100)
        animation.toValue = CGRect(x: 0, y: 0, width: 200, height: 200)
        return animation
      }(),
      forKey: "bounds"
    )

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds"
  }

  func test_sizeAnimation_boundsSize() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size")
        animation.fromValue = CGSize(width: 100, height: 100)
        animation.toValue = CGSize(width: 200, height: 200)
        return animation
      }(),
      forKey: "bounds.size"
    )

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds.size"
  }

  func test_sizeAnimation_boundsSizeWidth() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.fromValue = 100
        animation.toValue = 200
        return animation
      }(),
      forKey: "bounds.size.width"
    )

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds.size.width"
  }

  func test_sizeAnimation_boundsSizeHeight() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size.height")
        animation.fromValue = 100
        animation.toValue = 200
        return animation
      }(),
      forKey: "bounds.size.height"
    )

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds.size.height"
  }

  func test_sizeAnimation_multipleAnimations() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size")
        animation.fromValue = CGSize(width: 100, height: 100)
        animation.toValue = CGSize(width: 200, height: 200)
        return animation
      }(),
      forKey: "bounds.size"
    )

    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.fromValue = 100
        animation.toValue = 200
        return animation
      }(),
      forKey: "bounds.size.width"
    )

    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size.height")
        animation.fromValue = 100
        animation.toValue = 200
        return animation
      }(),
      forKey: "bounds.size.height"
    )

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds.size.width"
  }

  func test_sizeAnimation_withNonPropertyAnimation() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    // add a non-property animation (CAAnimationGroup)
    layer.add(
      {
        let group = CAAnimationGroup()
        group.animations = [CABasicAnimation(keyPath: "opacity")]
        return group
      }(),
      forKey: "group"
    )

    // add a bounds animation
    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = CGRect(x: 0, y: 0, width: 100, height: 100)
        animation.toValue = CGRect(x: 0, y: 0, width: 200, height: 200)
        return animation
      }(),
      forKey: "bounds"
    )

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds"
  }

  func test_sizeAnimation_withTransitionAnimation() throws {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    // add a transition animation (not a CAPropertyAnimation)
    layer.add(
      {
        let transition = CATransition()
        transition.type = .fade
        return transition
      }(),
      forKey: "transition"
    )

    // add a bounds.size animation
    layer.add(
      {
        let animation = CABasicAnimation(keyPath: "bounds.size")
        animation.fromValue = CGSize(width: 100, height: 100)
        animation.toValue = CGSize(width: 200, height: 200)
        return animation
      }(),
      forKey: "bounds.size"
    )

    let sizeAnimation = try layer.sizeAnimation().unwrap()

    expect(sizeAnimation.keyPath) == "bounds.size"
  }
}
