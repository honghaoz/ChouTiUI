//
//  CALayer+AnimationExtensions.swift
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

public extension CALayer {

  /// Return all animations on the layer.
  /// - Returns: A sequence of all animations.
  func animations() -> AnySequence<CAAnimation> {
    guard let animationKeys = animationKeys() else {
      return AnySequence(EmptyCollection())
    }

    return AnySequence(
      animationKeys
        .compactMap { animation(forKey: $0) }
        .lazy
    )
  }

  /// Get layer's size change animation.
  ///
  /// This is a convenience method that returns the first animation that changes the layer's size.
  /// It checks for key paths related to bounds and size changes.
  ///
  /// This is useful for adding a size synchronization animation to sublayers when the parent layer's size changes with an animation.
  ///
  /// - Returns: Size change animation.
  func sizeAnimation() -> CABasicAnimation? {
    animations().first(where: { animation in
      (animation as? CABasicAnimation)?.keyPath == "bounds" ||
        (animation as? CABasicAnimation)?.keyPath == "bounds.size" ||
        (animation as? CABasicAnimation)?.keyPath == "bounds.size.width" ||
        (animation as? CABasicAnimation)?.keyPath == "bounds.size.height"
    }) as? CABasicAnimation
  }
}
