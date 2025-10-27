//
//  CALayer+BoundsChange.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/23/22.
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
 Extends `CALayer` to support bounds change callbacks.
 */

private enum AssociateKey {
  static var boundsChangeBlocks: UInt8 = 0
  static var boundsKVOObservation: UInt8 = 0
}

public extension CALayer {

  private var boundsChangeBlocks: OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGRect, CGRect) -> Void>> {
    get {
      getAssociatedObject(for: &AssociateKey.boundsChangeBlocks) as? OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGRect, CGRect) -> Void>> ?? OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGRect, CGRect) -> Void>>()
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.boundsChangeBlocks)
    }
  }

  /// This observation will be deallocated when the host object deallocates.
  private var boundsKVOObservation: NSKeyValueObservation? {
    get { getAssociatedObject(for: &AssociateKey.boundsKVOObservation) as? NSKeyValueObservation }
    set { setAssociatedObject(newValue, for: &AssociateKey.boundsKVOObservation) }
  }

  /// Adds a block to be called when the layer's bounds change.
  ///
  /// This method should be called on the main thread. This method may not be called immediately when the bounds change is caused by a window resize or other system-level changes.
  ///
  /// - Parameters:
  ///   - block: The block to be called when the bounds change. It will be called with the layer, the old bounds, and the new bounds.
  /// - Returns: A cancellable token that can be used to remove the block.
  @discardableResult
  func onBoundsChange(block: @escaping (_ layer: CALayer, _ old: CGRect, _ new: CGRect) -> Void) -> CancellableToken {
    assertOnMainThread()

    let token = ValueCancellableToken(value: block) { [weak self] token in
      guard let self else {
        return
      }
      token.remove(from: &self.boundsChangeBlocks)

      // stop bounds KVO observation if there's no callbacks
      if boundsChangeBlocks.isEmpty {
        self.tearDownKVOObservation()
      }
    }
    token.store(in: &boundsChangeBlocks)

    setUpKVOObservation()

    return token
  }

  private func setUpKVOObservation() {
    guard boundsKVOObservation == nil else {
      return
    }

    boundsKVOObservation = observe(\.bounds, options: [.old, .new]) { [weak self] layer, change in
      guard let self else {
        return
      }
      for token in self.boundsChangeBlocks.values {
        token.value(
          self,
          change.oldValue.assert("unexpected nil old value") ?? layer.bounds,
          change.newValue.assert("unexpected nil new value") ?? layer.bounds
        )
      }
    }
  }

  private func tearDownKVOObservation() {
    boundsKVOObservation?.invalidate()
    boundsKVOObservation = nil
  }
}

// MARK: - Testing

#if DEBUG

extension CALayer.Test {

  var boundsKVOObservation: NSKeyValueObservation? {
    host.boundsKVOObservation
  }
}

#endif
