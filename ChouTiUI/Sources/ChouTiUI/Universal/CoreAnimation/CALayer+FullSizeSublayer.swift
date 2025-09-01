//
//  CALayer+FullSizeSublayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/12/25.
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

import ChouTi
@_spi(Private) import ComposeUI

public extension CALayer {

  /// Add a sublayer that fills the bounds of the layer.
  ///
  /// The sublayer will always follow the bounds of the layer, including when the layer is animated.
  ///
  /// Be sure to call `removeFullSizeSublayer` when the sublayer is no longer needed.
  ///
  /// - Parameters:
  ///   - sublayer: The sublayer to add.
  ///   - index: The index to insert the sublayer at. If not provided, the sublayer will be added to the top.
  func addFullSizeSublayer(_ sublayer: CALayer, at index: UInt32? = nil) {
    CATransaction.disableAnimations { // disable the implicit animation to avoid ghost layer
      sublayer.frame = bounds
      if let index {
        insertSublayer(sublayer, at: index)
      } else {
        addSublayer(sublayer)
      }
    }

    fullSizeSublayers[ObjectIdentifier(sublayer)] = sublayer
    addFullSizeTrackingLayer(sublayer)

    // add the bounds change listener
    if boundsToken == nil {
      boundsToken = onBoundsChange { [weak self] _, oldBounds, newBounds in
        self?.boundsChanged(oldBounds, newBounds)
      }
    }
  }

  /// Remove a full size sublayer.
  ///
  /// - Parameter sublayer: The sublayer to remove.
  func removeFullSizeSublayer(_ sublayer: CALayer) {
    CATransaction.disableAnimations { // disable the implicit animation to avoid animation artifact
      sublayer.removeFromSuperlayer()
    }

    fullSizeSublayers.removeValue(forKey: ObjectIdentifier(sublayer))
    removeFullSizeTrackingLayer(sublayer)

    if fullSizeSublayers.isEmpty {
      boundsToken?.cancel()
      boundsToken = nil
    }
  }

  private func boundsChanged(_ oldBounds: CGRect, _ newBounds: CGRect) {
    for (key, sublayer) in fullSizeSublayers {
      if sublayer.superlayer !== self {
        // the sublayer is no longer a sublayer of the layer, remove it from the fullSizeSublayers
        fullSizeSublayers.removeValue(forKey: key)
        removeFullSizeTrackingLayer(sublayer)
      }
    }

    if fullSizeSublayers.isEmpty {
      boundsToken?.cancel()
      boundsToken = nil
    }
  }
}

private extension CALayer {

  private enum AssociateKey {
    static var boundsToken: UInt8 = 0
    static var fullSizeSublayers: UInt8 = 0
  }

  /// The token for the bounds change listener.
  var boundsToken: CancellableToken? {
    get { getAssociatedObject(for: &AssociateKey.boundsToken) as? CancellableToken }
    set { setAssociatedObject(newValue, for: &AssociateKey.boundsToken) }
  }

  /// The sublayers that fill the bounds of the layer.
  var fullSizeSublayers: OrderedDictionary<ObjectIdentifier, CALayer> {
    get { getAssociatedObject(for: &AssociateKey.fullSizeSublayers) as? OrderedDictionary<ObjectIdentifier, CALayer> ?? [:] }
    set { setAssociatedObject(newValue, for: &AssociateKey.fullSizeSublayers) }
  }
}

// MARK: - Testing

#if DEBUG

extension CALayer.Test {

  var fullSizeSublayerBoundsToken: CancellableToken? {
    host.boundsToken
  }

  var fullSizeSublayers: OrderedDictionary<ObjectIdentifier, CALayer> {
    host.fullSizeSublayers
  }
}

#endif
