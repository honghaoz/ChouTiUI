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
  static var shapeMaskLayer: UInt8 = 0
}

public extension CALayer {

  /// The shape of the layer.
  ///
  /// Setting a shape installs a shape-managed mask layer on the layer. The mask layer automatically follows the
  /// layer's bounds, including when the layer's bounds is animated.
  ///
  /// The shape API manages the layer's `mask`. Avoid setting the layer's `mask` directly when using the shape API.
  /// The interactions between the shape and the mask:
  /// - Setting a shape replaces the layer's existing mask, if any, with the shape-managed mask layer. This includes
  ///   a mask you set directly before setting the shape.
  /// - Setting the shape to `nil` removes the shape-managed mask layer. If the layer has no shape installed, or the
  ///   mask was changed externally after the shape was set, the current mask is left untouched, since the mask is
  ///   not managed by the shape API.
  /// - Changing the mask externally (removing or replacing) while a shape is installed breaks the shape: the mask no
  ///   longer follows the layer's bounds and the shape is no longer rendered. The shape is not restored
  ///   automatically, and reading `shape` still returns the previously set shape. The shape-managed mask layer is
  ///   reinstalled the next time the shape is set, via this property or `animateShape`.
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

  /// The mask layer installed by the `shape` API.
  ///
  /// This is used to distinguish the shape-managed mask layer from a mask layer set by the user directly, and to
  /// clean up the tracking of a previously installed mask layer if the mask is removed externally.
  private var shapeMaskLayer: BaseCAShapeLayer? {
    get {
      (getAssociatedObject(for: &AssociateKey.shapeMaskLayer) as? WeakBox<BaseCAShapeLayer>)?.object
    }
    set {
      setAssociatedObject(newValue.map { WeakBox($0) }, for: &AssociateKey.shapeMaskLayer)
    }
  }

  private func updateShape(oldShape: (any Shape)?) {
    switch (oldShape, shape) {
    case (nil, nil):
      // no shape before and after: nothing to do. don't touch the mask, since it's not installed by the shape API.
      break

    case (.some, nil):
      // remove shape.
      //
      // only remove the mask if it's still the shape-installed one: if the mask was replaced externally after the
      // shape was set, the replacement is a deliberate, later action, so removing the shape shouldn't destroy it.
      if let maskLayer = shapeMaskLayer.assertNotNil("should have shape mask layer") {
        removeFullSizeTrackingLayer(maskLayer)
        if mask === maskLayer {
          mask = nil
        }
        shapeMaskLayer = nil
      }

    case (nil, .some):
      // none -> new shape
      setupMaskLayer()

    case (.some, .some(let newShape)):
      let existingMaskLayer = (mask as? CAShapeLayer).assertNotNil("should have mask layer")
      if let existingMaskLayer, existingMaskLayer === shapeMaskLayer {
        // update the mask layer path so that if the bounds changes, the mask layer will be updated
        CATransaction.disableAnimations { // disable the implicit animation for the path change
          existingMaskLayer.frame = bounds
          existingMaskLayer.path = newShape.path(in: bounds)
        }
      } else {
        // the mask is missing or replaced externally, reinstall the mask layer to restore the shape
        ChouTi.assert(existingMaskLayer == nil, "mask layer should be the shape-installed mask layer")
        setupMaskLayer()
      }
    }
  }

  private func setupMaskLayer() {
    guard let shape = self.shape else {
      ChouTi.assertFailure("shape is nil") // impossible, all call sites should have a shape
      return
    }

    // clean up the tracking of a previously installed mask layer, if any. this can happen when the mask is removed
    // externally (e.g. `layer.mask = nil`) and a new shape is set: without the cleanup, the old mask layer would be
    // tracked (and retained) by the host layer forever.
    if let previousMaskLayer = shapeMaskLayer {
      removeFullSizeTrackingLayer(previousMaskLayer)
    }

    let maskLayer = BaseCAShapeLayer()
    maskLayer.frame = bounds
    mask = maskLayer
    shapeMaskLayer = maskLayer

    // make sure the mask layer follow the host layer's bounds
    addFullSizeTrackingLayer(maskLayer)

    // observe the mask layer's size change so that the mask layer's path can be updated, including when the host layer is animated.
    // we don't animate the mask layer's path here because the path animation can't be additive where the host layer usually animates its size change additively.
    // to make sure the mask layer's path is updated in sync with the host layer's size change, we use `onLiveFrameChange`.
    //
    // the block reads the host layer's current shape (instead of capturing the shape at setup time) so that shape
    // updates after the setup are reflected on later frame changes.
    maskLayer.path = shape.path(in: bounds)
    maskLayer.onLiveFrameChange { [weak self] (layer: CAShapeLayer, frame) in
      guard let shape = self?.shape else {
        return
      }
      layer.path = shape.path(in: frame.origin(.zero))
    }
  }

  /// Animate the shape of the layer.
  ///
  /// The layer's shape will be updated to the new shape.
  ///
  /// - Note: If the layer's mask was changed externally after the shape was set, the animation is skipped and the
  ///   new shape is applied directly, reinstalling the shape-managed mask layer.
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

    guard let maskLayer = mask as? CAShapeLayer, maskLayer === shapeMaskLayer else {
      ChouTi.assertFailure("no mask layer")
      // the mask is missing or replaced externally, skip the animation and set the shape directly to restore the shape
      shape = toShape
      return
    }

    maskLayer.animate(
      keyPath: "path",
      timing: timing,
      from: { maskLayer in
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
