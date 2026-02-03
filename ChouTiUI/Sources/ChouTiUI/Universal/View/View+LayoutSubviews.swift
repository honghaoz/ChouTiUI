//
//  View+LayoutSubviews.swift
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

import ObjectiveC

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import ChouTi

private extension View {

  private enum AssociateKey {
    static var layoutSubviewsBlocks: UInt8 = 0
    static var layoutSubviewsInterceptToken: UInt8 = 0
    static var frameBoundsInterceptTokenGroup: UInt8 = 0
  }

  private typealias LayoutSubviewsBlocks = OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(View) -> Void>>

  private var layoutSubviewsBlocks: LayoutSubviewsBlocks {
    get {
      getAssociatedObject(for: &AssociateKey.layoutSubviewsBlocks) as? LayoutSubviewsBlocks ?? LayoutSubviewsBlocks()
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.layoutSubviewsBlocks)
    }
  }

  private var layoutSubviewsInterceptToken: CancellableToken? {
    get {
      getAssociatedObject(for: &AssociateKey.layoutSubviewsInterceptToken) as? CancellableToken
    }
    set {
      if let newValue {
        setAssociatedObject(newValue, for: &AssociateKey.layoutSubviewsInterceptToken)
      } else {
        removeAssociatedObject(for: &AssociateKey.layoutSubviewsInterceptToken)
      }
    }
  }

  #if canImport(AppKit)
  private var frameBoundsInterceptTokenGroup: CancellableToken? {
    get {
      getAssociatedObject(for: &AssociateKey.frameBoundsInterceptTokenGroup) as? CancellableToken
    }
    set {
      if let newValue {
        setAssociatedObject(newValue, for: &AssociateKey.frameBoundsInterceptTokenGroup)
      } else {
        removeAssociatedObject(for: &AssociateKey.frameBoundsInterceptTokenGroup)
      }
    }
  }
  #endif
}

public extension View {

  /// Adds a block to be called when the view performs layout.
  ///
  /// This method should be called on the main thread.
  ///
  /// Calling this method will intercept the view's layout method:
  /// - On macOS: `layout()`
  /// - On iOS/tvOS/visionOS: `layoutSubviews()`
  ///
  /// The custom block will be called after the original layout implementation.
  /// The block will be called in the order of the blocks being added.
  ///
  /// Example:
  /// ```swift
  /// // add layout block without cancelling it
  /// view.onLayoutSubviews { view in
  ///   print("layout called")
  /// }
  ///
  /// // add layout block and cancel it
  /// let token = view.onLayoutSubviews { view in
  ///   print("layout called")
  /// }
  ///
  /// // cancel the block
  /// token.cancel()
  /// ```
  ///
  /// - Parameters:
  ///   - block: The block to be called when the view performs layout. It will be called with the view.
  /// - Returns: A cancellable token that can be used to remove the block.
  @discardableResult
  func onLayoutSubviews(_ block: @escaping (View) -> Void) -> CancellableToken {
    assertOnMainThread()

    let token = ValueCancellableToken(value: block) { [weak self] token in
      guard let self else {
        return
      }
      token.remove(from: &self.layoutSubviewsBlocks)

      if layoutSubviewsBlocks.isEmpty {
        unhookLayoutSubviews()
        #if canImport(AppKit)
        unhookFrameBounds()
        #endif
      }
    }
    token.store(in: &layoutSubviewsBlocks)

    hookLayoutSubviewsIfNeeded()
    #if canImport(AppKit)
    hookFrameBoundsIfNeeded()
    #endif

    return token
  }

  // MARK: - Intercept

  #if canImport(AppKit)
  private static let layoutSubviewsSelector = #selector(NSView.layout)
  #else
  private static let layoutSubviewsSelector = #selector(UIView.layoutSubviews)
  #endif

  private func hookLayoutSubviewsIfNeeded() {
    guard layoutSubviewsInterceptToken == nil else {
      return
    }

    let token = intercept(selector: View.layoutSubviewsSelector) { object, _, callOriginal in
      callOriginal()

      guard let view = object as? View else {
        return
      }

      for token in view.layoutSubviewsBlocks.values {
        token.value(view)
      }
    }

    layoutSubviewsInterceptToken = token
  }

  private func unhookLayoutSubviews() {
    layoutSubviewsInterceptToken?.cancel()
    layoutSubviewsInterceptToken = nil
  }

  // MARK: - Frame/Bounds Hooks (AppKit)

  #if canImport(AppKit)
  private func hookFrameBoundsIfNeeded() {
    guard frameBoundsInterceptTokenGroup == nil else {
      return
    }

    let frameToken = intercept(selector: #selector(NSView.setFrameSize(_:))) { (object, _, newSize: CGSize, callOriginal) in
      guard let view = object as? View else {
        callOriginal(newSize)
        return
      }

      let oldSize = view.frame.size
      callOriginal(newSize)
      let actualNewSize = view.frame.size
      if !oldSize.equalTo(actualNewSize) {
        view.needsLayout = true
      }
    }

    let boundsToken = intercept(selector: #selector(setter: NSView.bounds)) { (object, _, newBounds: CGRect, callOriginal) in
      guard let view = object as? View else {
        callOriginal(newBounds)
        return
      }

      let oldBounds = view.bounds
      callOriginal(newBounds)
      let actualNewBounds = view.bounds
      if !oldBounds.equalTo(actualNewBounds) {
        view.needsLayout = true
      }
    }

    frameBoundsInterceptTokenGroup = CancellableTokenGroup(tokens: [frameToken, boundsToken]) { _ in }
  }

  private func unhookFrameBounds() {
    frameBoundsInterceptTokenGroup?.cancel()
    frameBoundsInterceptTokenGroup = nil
  }
  #endif
}
