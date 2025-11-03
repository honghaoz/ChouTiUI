//
//  CALayer+FullSizeTrackingLayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/30/25.
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

  /// The context for the bounds change.
  struct BoundsChangeContext {

    /// The host layer that the tracking layer is tracking.
    public let hostLayer: CALayer

    /// The tracking layer that is tracking the host layer.
    public let trackingLayer: CALayer

    /// The old bounds of the host layer.
    public let oldBounds: CGRect

    /// The new bounds of the host layer.
    public let newBounds: CGRect
  }

  /// Add a layer that follows the bounds of the layer.
  ///
  /// The layer's frame will always follow the bounds of the layer, including when the layer is animated.
  ///
  /// This is useful to make a layer's mask layer follow the bounds of the layer.
  ///
  /// Be sure to call `removeFullSizeTrackingLayer` when the layer is no longer need to track.
  ///
  /// - Parameters:
  ///   - layer: The layer to track.
  ///   - onBoundsChange: The block to be called when the bounds change. It will be called with a context containing the host layer, the tracking layer, the old bounds, the new bounds, and the timestamp.
  func addFullSizeTrackingLayer(_ layer: CALayer,
                                onBoundsChange: ((_ context: BoundsChangeContext) -> Void)? = nil)
  {
    fullSizeTrackingLayers[ObjectIdentifier(layer)] = LayerTrackingInfo(layer: layer, onBoundsChange: onBoundsChange)

    // add the bounds change listener
    if boundsToken == nil {
      boundsToken = self.onBoundsChange { [weak self] _, oldBounds, newBounds in
        self?.boundsChanged(oldBounds, newBounds)
      }
    }
  }

  /// Remove a full size tracking layer.
  ///
  /// - Parameter layer: The tracking layer to remove.
  func removeFullSizeTrackingLayer(_ layer: CALayer) {
    fullSizeTrackingLayers.removeValue(forKey: ObjectIdentifier(layer))

    if fullSizeTrackingLayers.isEmpty {
      boundsToken?.cancel()
      boundsToken = nil
    }
  }

  private func boundsChanged(_ oldBounds: CGRect, _ newBounds: CGRect) {
    for (_, layerTrackingInfo) in fullSizeTrackingLayers {
      let layer = layerTrackingInfo.layer
      let onBoundsChange = layerTrackingInfo.onBoundsChange

      layer.frame = newBounds

      RunLoop.main.perform { // schedule to the next run loop to make sure the animation added after the bounds change can be found
        self.addSizeSynchronizationAnimation(to: layer, oldBounds: oldBounds, newBounds: newBounds)
        onBoundsChange?(BoundsChangeContext(hostLayer: self, trackingLayer: layer, oldBounds: oldBounds, newBounds: newBounds))
      }
    }
  }

  /// Add size synchronization animation to the layer so that the layer can always follow the host layer's size.
  private func addSizeSynchronizationAnimation(to layer: CALayer, oldBounds: CGRect, newBounds: CGRect) {
    guard let sizeAnimation = self.sizeAnimation() else {
      return
    }

    layer.addFrameAnimation(
      from: oldBounds,
      to: newBounds,
      presentationBounds: self.presentation()?.bounds,
      with: sizeAnimation
    )
  }
}

private extension CALayer {

  private enum AssociateKey {
    static var boundsToken: UInt8 = 0
    static var fullSizeTrackingLayers: UInt8 = 0
  }

  /// The token for the bounds change listener.
  private var boundsToken: CancellableToken? {
    get { getAssociatedObject(for: &AssociateKey.boundsToken) as? CancellableToken }
    set { setAssociatedObject(newValue, for: &AssociateKey.boundsToken) }
  }

  struct LayerTrackingInfo {
    let layer: CALayer
    let onBoundsChange: ((_ context: BoundsChangeContext) -> Void)?
  }

  /// The layers that track the bounds of the layer.
  private var fullSizeTrackingLayers: OrderedDictionary<ObjectIdentifier, LayerTrackingInfo> {
    get { getAssociatedObject(for: &AssociateKey.fullSizeTrackingLayers) as? OrderedDictionary<ObjectIdentifier, LayerTrackingInfo> ?? [:] }
    set { setAssociatedObject(newValue, for: &AssociateKey.fullSizeTrackingLayers) }
  }
}
