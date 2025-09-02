//
//  CALayer+Shape.swift
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import CoreGraphics
import QuartzCore

import ChouTi
@_spi(Private) import ComposeUI

/**
 Extends `CALayer` to support shape.
 */

private enum AssociateKey {
  static var shape: UInt8 = 0
}

public extension CALayer {

  /// The shape of the layer.
  var shape: (any Shape)? {
    get {
      getAssociatedObject(for: &AssociateKey.shape) as? (any Shape)
    }
    set {
      let oldShape = shape
      setAssociatedObject(newValue, for: &AssociateKey.shape)
      updateShape(oldShape: oldShape)
    }
  }

  private func updateShape(oldShape: (any Shape)?) {
    switch (oldShape, shape) {
    case (nil, nil),
         (.some, nil):
      // remove shape
      mask = nil

    case (nil, .some):
      // none -> new shape
      setupMaskLayer()

    case (.some(let oldShape), .some(let newShape)):
      // only update shape if shape changes
      if !oldShape.isEqual(to: newShape) {
        if let existingMaskLayer = (mask as? CAShapeLayer).assert("should have mask layer") {
          // reuse
          existingMaskLayer.path = newShape.path(in: bounds)
        } else {
          setupMaskLayer()
        }
      }
    }
  }

  private func setupMaskLayer() {
    guard let shape = self.shape else {
      return
    }

    let maskLayer = BaseCAShapeLayer()
    maskLayer.path = shape.path(in: bounds)
    mask = maskLayer

    addFullSizeTrackingLayer(maskLayer, onBoundsChange: { [weak self, weak maskLayer] context in
      guard let shape = self?.shape, let maskLayer = maskLayer else {
        return
      }

      let layer = context.hostLayer

      // update model
      maskLayer.path = shape.path(in: layer.bounds)

      // add animation
      guard let animationCopy = layer.animations()
        .first(where: { ($0 as? CAPropertyAnimation)?.keyPath == "bounds.size" })?.copy() as? CABasicAnimation
      else {
        return
      }

      animationCopy.keyPath = "path"
      animationCopy.isAdditive = false
      animationCopy.fromValue = maskLayer.presentation()?.path
      animationCopy.toValue = maskLayer.path
      maskLayer.add(animationCopy, forKey: "path")
    })
  }

  /// Animate the shape of the layer.
  ///
  /// The layer's shape will be updated to the new shape.
  ///
  /// - Parameters:
  ///   - fromShape: The from shape. If `nil`, the current shape will be used. Default is `nil`.
  ///   - toShape: The to shape.
  ///   - timing: The timing of the animation.
  func animateShape(from fromShape: (any Shape)? = nil, to toShape: any Shape, timing: AnimationTiming) {
    switch (shape, fromShape) {
    case (nil, nil):
      ChouTi.assertFailure("layer has no shape and no from shape")
      return
    case (.some, nil):
      // use current shape
      break
    case (nil, .some(let fromShape)),
         (.some, .some(let fromShape)):
      // from shape is specified, set the shape
      shape = fromShape
    }

    guard let currentShape = shape, let maskLayer = mask as? CAShapeLayer else {
      ChouTi.assertFailure("no mask layer")
      return
    }

    maskLayer.animate(
      keyPath: "path",
      timing: timing,
      from: { maskLayer in
        guard let maskLayer = maskLayer as? CAShapeLayer else {
          return currentShape.path(in: maskLayer.bounds)
        }
        if fromShape == nil {
          // no from shape, use the current in-flight shape
          return maskLayer.presentation()?.path ?? currentShape.path(in: maskLayer.bounds)
        } else {
          return currentShape.path(in: maskLayer.bounds)
        }
      },
      to: { maskLayer in toShape.path(in: maskLayer.bounds) }
    )
  }
}
