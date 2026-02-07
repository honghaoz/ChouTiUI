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
      if let maskLayer = mask {
        removeFullSizeTrackingLayer(maskLayer)
      }
      mask = nil

    case (nil, .some):
      // none -> new shape
      setupMaskLayer()

    case (.some, .some(let newShape)):
      if let existingMaskLayer = (mask as? CAShapeLayer).assert("should have mask layer") {
        // update the mask layer path so that if the bounds changes, the mask layer will be updated
        existingMaskLayer.frame = bounds
        existingMaskLayer.path = newShape.path(in: bounds)
      } else {
        // if no mask layer, create a new one
        setupMaskLayer()
      }
    }
  }

  private func setupMaskLayer() {
    guard let shape = self.shape else {
      ChouTi.assertFailure("shape is nil") // impossible, all call sites should have a shape
      return
    }

    let maskLayer = BaseCAShapeLayer()
    maskLayer.frame = bounds
    mask = maskLayer

    // make sure the mask layer follow the host layer's bounds
    addFullSizeTrackingLayer(maskLayer)

    // observe the mask layer's size change so that the mask layer's path can be updated, including when the host layer is animated.
    // we don't animate the mask layer's path here because the path animation can't be additive where the host layer usually animates its size change additively.
    // to make sure the mask layer's path is updated in sync with the host layer's size change, we use `onLiveFrameChange`.
    maskLayer.path = shape.path(in: bounds)
    maskLayer.onLiveFrameChange { (layer: CAShapeLayer, frame) in
      layer.path = shape.path(in: frame.origin(.zero))
    }
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
    let currentShape: any Shape
    switch (shape, fromShape) {
    case (nil, nil):
      ChouTi.assertFailure("layer has no shape and no from shape")
      return
    case (.some(let shape), nil):
      // use current shape
      currentShape = shape
    case (nil, .some(let fromShape)):
      // no shape, set from shape
      shape = fromShape
      currentShape = fromShape
    case (.some, .some(let fromShape)):
      currentShape = fromShape
    }

    guard let maskLayer = mask as? CAShapeLayer else {
      ChouTi.assertFailure("no mask layer")
      return
    }

    maskLayer.animate(
      keyPath: "path",
      timing: timing,
      from: { maskLayer in
        guard let maskLayer = maskLayer as? CAShapeLayer else {
          return currentShape.path(in: maskLayer.bounds) // impossible, maskLayer is always a CAShapeLayer
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

    shape = toShape
  }
}
