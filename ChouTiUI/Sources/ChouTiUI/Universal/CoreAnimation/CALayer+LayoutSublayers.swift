//
//  CALayer+LayoutSublayers.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/8/25.
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

#if canImport(AppKit)
import AppKit
#endif

import ChouTi

private extension CALayer {

  private enum AssociateKey {
    static var layoutSublayersBlocks: UInt8 = 0
    static var layoutSublayersInterceptToken: UInt8 = 0
    static var viewLayoutInterceptToken: UInt8 = 0
  }

  private typealias LayoutSublayersBlocks = OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer) -> Void>>

  private var layoutSublayersBlocks: LayoutSublayersBlocks {
    get {
      getAssociatedObject(for: &AssociateKey.layoutSublayersBlocks) as? LayoutSublayersBlocks ?? LayoutSublayersBlocks()
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.layoutSublayersBlocks)
    }
  }

  private var layoutSublayersInterceptToken: CancellableToken? {
    get {
      getAssociatedObject(for: &AssociateKey.layoutSublayersInterceptToken) as? CancellableToken
    }
    set {
      if let newValue {
        setAssociatedObject(newValue, for: &AssociateKey.layoutSublayersInterceptToken)
      } else {
        removeAssociatedObject(for: &AssociateKey.layoutSublayersInterceptToken)
      }
    }
  }

  #if canImport(AppKit)
  private var viewLayoutInterceptToken: CancellableToken? {
    get {
      getAssociatedObject(for: &AssociateKey.viewLayoutInterceptToken) as? CancellableToken
    }
    set {
      if let newValue {
        setAssociatedObject(newValue, for: &AssociateKey.viewLayoutInterceptToken)
      } else {
        removeAssociatedObject(for: &AssociateKey.viewLayoutInterceptToken)
      }
    }
  }
  #endif
}

public extension CALayer {

  /// Adds a block to be called when the layer calls `layoutSublayers()`.
  ///
  /// This method should be called on the main thread.
  ///
  /// Calling this method will intercept the layer's `layoutSublayers()` implementation.
  /// The custom block will be called after the original `layoutSublayers()` implementation.
  ///
  /// on macOS, if the layer is a view's backing layer, this method will automatically hook into the view's
  /// layout cycle to ensure `layoutSublayers()` is called when the view performs layout, providing
  /// consistent behavior across macOS and iOS.
  ///
  /// The block will be called in the order of the blocks being added.
  ///
  /// Example:
  /// ```swift
  /// // add layoutSublayers block without cancelling it
  /// layer.onLayoutSublayers { layer in
  ///   print("layoutSublayers called")
  /// }
  ///
  /// // add layoutSublayers block and cancel it
  /// let token = layer.onLayoutSublayers { layer in
  ///   print("layoutSublayers called")
  /// }
  ///
  /// // cancel the block
  /// token.cancel()
  /// ```
  ///
  /// Note: Whenever possible, it's recommended to use layer delegate's `CALayerDelegate.layoutSublayers(of:)` method instead of this method.
  ///
  /// - Parameters:
  ///   - block: The block to be called when the layer calls `layoutSublayers()`. It will be called with the layer.
  /// - Returns: A cancellable token that can be used to remove the block.
  @discardableResult
  func onLayoutSublayers(_ block: @escaping (CALayer) -> Void) -> CancellableToken {
    assertOnMainThread()

    let token = ValueCancellableToken(value: block) { [weak self] token in
      guard let self else {
        return
      }
      token.remove(from: &self.layoutSublayersBlocks)

      if layoutSublayersBlocks.isEmpty {
        unhookLayoutSublayers()
        #if canImport(AppKit)
        unhookViewLayout()
        #endif
      }
    }
    token.store(in: &layoutSublayersBlocks)

    hookLayoutSublayersIfNeeded()
    #if canImport(AppKit)
    hookViewLayoutIfNeeded()
    #endif

    return token
  }

  // MARK: - Intercept

  private func hookLayoutSublayersIfNeeded() {
    guard layoutSublayersInterceptToken == nil else {
      return
    }

    let token = intercept(selector: #selector(CALayer.layoutSublayers)) { object, _, callOriginal in
      callOriginal()

      guard let layer = object as? CALayer else {
        return
      }

      for token in layer.layoutSublayersBlocks.values {
        token.value(layer)
      }
    }

    layoutSublayersInterceptToken = token
  }

  private func unhookLayoutSublayers() {
    layoutSublayersInterceptToken?.cancel()
    layoutSublayersInterceptToken = nil
  }

  // MARK: - View Layout Hook (AppKit)

  #if canImport(AppKit)
  private func hookViewLayoutIfNeeded() {
    guard viewLayoutInterceptToken == nil else {
      return
    }

    guard let view = self.delegate as? NSView else {
      return
    }

    let token = view.intercept(selector: #selector(NSView.layout)) { object, _, callOriginal in
      callOriginal()

      guard let view = object as? NSView else {
        return
      }

      view.layer?.setNeedsLayout()
      view.layer?.layoutIfNeeded()
    }

    viewLayoutInterceptToken = token
  }

  private func unhookViewLayout() {
    viewLayoutInterceptToken?.cancel()
    viewLayoutInterceptToken = nil
  }
  #endif
}
