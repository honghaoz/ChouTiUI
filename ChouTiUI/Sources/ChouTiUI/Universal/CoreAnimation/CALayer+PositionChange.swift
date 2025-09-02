//
//  CALayer+PositionChange.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/31/25.
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

/**
 Extends `CALayer` to support position change callbacks.
 */

private enum AssociateKey {
  static var positionChangeBlocks: UInt8 = 0
  static var positionKVOObservation: UInt8 = 0
}

public extension CALayer {

  private var positionChangeBlocks: OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGPoint, CGPoint) -> Void>> {
    get {
      getAssociatedObject(for: &AssociateKey.positionChangeBlocks) as? OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGPoint, CGPoint) -> Void>> ?? OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGPoint, CGPoint) -> Void>>()
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.positionChangeBlocks)
    }
  }

  /// This observation will be deallocated when the host object deallocates.
  private var positionKVOObservation: NSKeyValueObservation? {
    get { getAssociatedObject(for: &AssociateKey.positionKVOObservation) as? NSKeyValueObservation }
    set { setAssociatedObject(newValue, for: &AssociateKey.positionKVOObservation) }
  }

  /// Adds a block to be called when the layer's position change.
  ///
  /// This method should be called on the main thread.
  ///
  /// - Parameters:
  ///   - block: The block to be called when the position change. It will be called with the layer, the old position, and the new position.
  /// - Returns: A cancellable token that can be used to remove the block.
  @discardableResult
  func onPositionChange(block: @escaping (_ layer: CALayer, _ old: CGPoint, _ new: CGPoint) -> Void) -> CancellableToken {
    assertOnMainThread()

    let token = ValueCancellableToken(value: block) { [weak self] token in
      guard let self else {
        return
      }
      token.remove(from: &self.positionChangeBlocks)

      // stop position KVO observation if there's no callbacks
      if positionChangeBlocks.isEmpty {
        self.tearDownKVOObservation()
      }
    }
    token.store(in: &positionChangeBlocks)

    setUpKVOObservation()

    return token
  }

  private func setUpKVOObservation() {
    guard positionKVOObservation == nil else {
      return
    }

    positionKVOObservation = observe(\.position, options: [.old, .new]) { [weak self] layer, change in
      guard let self else {
        return
      }
      for token in self.positionChangeBlocks.values {
        token.value(
          self,
          change.oldValue.assert("unexpected nil old value") ?? layer.position,
          change.newValue.assert("unexpected nil new value") ?? layer.position
        )
      }
    }
  }

  private func tearDownKVOObservation() {
    positionKVOObservation?.invalidate()
    positionKVOObservation = nil
  }
}

// MARK: - Testing

#if DEBUG

extension CALayer.Test {

  var positionKVOObservation: NSKeyValueObservation? {
    host.positionKVOObservation
  }
}

#endif
