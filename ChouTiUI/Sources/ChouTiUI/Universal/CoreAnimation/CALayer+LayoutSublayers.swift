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

import ObjectiveC
import QuartzCore

import ChouTi

private enum AssociateKey {
  static var layoutSublayersBlocks: UInt8 = 0
  static var originalClass: UInt8 = 0
  static var viewLayoutToken: UInt8 = 0
}

public extension CALayer {

  typealias LayoutSublayersBlocks = OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer) -> Void>>

  private var layoutSublayersBlocks: LayoutSublayersBlocks {
    get {
      getAssociatedObject(for: &AssociateKey.layoutSublayersBlocks) as? LayoutSublayersBlocks ?? LayoutSublayersBlocks()
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.layoutSublayersBlocks)
    }
  }

  /// Adds a block to be called when the layer calls `layoutSublayers()`.
  ///
  /// This method should be called on the main thread.
  ///
  /// Calling this method will dynamically swizzle the layer's class to override `layoutSublayers()`.
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
        revertLayoutSublayers()
      }
    }
    token.store(in: &layoutSublayersBlocks)

    swizzleLayoutSublayers()

    #if canImport(AppKit)
    hookViewLayout()
    #endif

    return token
  }

  private func swizzleLayoutSublayers() {
    guard let originalClass: AnyClass = getAssociatedObject(for: &AssociateKey.originalClass) as? AnyClass ?? object_getClass(self) else {
      ChouTi.assertFailure("Failed to get original class")
      return
    }

    if getAssociatedObject(for: &AssociateKey.originalClass) == nil {
      setAssociatedObject(originalClass, for: &AssociateKey.originalClass)
    }

    let subclassName = "ChouTiUI_\(NSStringFromClass(originalClass))"

    // check if we already have a swizzled class
    if let existingClass = NSClassFromString(subclassName) {
      object_setClass(self, existingClass)
      return
    }

    // create a new subclass
    guard let subclass = objc_allocateClassPair(originalClass, subclassName, 0) else {
      ChouTi.assertFailure("Failed to create subclass for CALayer isa swizzling")
      return
    }

    // get the layoutSublayers method from CALayer
    let layoutSublayersSelector = #selector(CALayer.layoutSublayers)
    guard let originalMethod = class_getInstanceMethod(originalClass, layoutSublayersSelector) else {
      ChouTi.assertFailure("Failed to get layoutSublayers method")
      return
    }

    // get the original implementation
    typealias LayoutSublayersFunction = @convention(c) (AnyObject, Selector) -> Void
    let originalImplementation = unsafeBitCast(
      class_getMethodImplementation(originalClass, layoutSublayersSelector),
      to: LayoutSublayersFunction.self
    )

    // create the new implementation
    let newImplementation: @convention(block) (CALayer) -> Void = { layer in
      // call super implementation
      originalImplementation(layer, layoutSublayersSelector)

      // call the custom blocks
      for token in layer.layoutSublayersBlocks.values {
        token.value(layer)
      }
    }

    // add the method to the subclass
    let methodTypeEncoding = method_getTypeEncoding(originalMethod)
    let newIMP = imp_implementationWithBlock(newImplementation)
    class_addMethod(subclass, layoutSublayersSelector, newIMP, methodTypeEncoding)

    // register the new class
    objc_registerClassPair(subclass)

    // change the instance's class
    object_setClass(self, subclass)
  }

  private func revertLayoutSublayers() {
    guard let originalClass = getAssociatedObject(for: &AssociateKey.originalClass) as? AnyClass else {
      ChouTi.assertFailure("Cannot revert: original class not found")
      return
    }

    object_setClass(self, originalClass)

    // clean up the stored original class
    setAssociatedObject(nil as AnyClass?, for: &AssociateKey.originalClass)

    #if canImport(AppKit)
    unhookViewLayout()
    #endif
  }

  #if canImport(AppKit)
  private func hookViewLayout() {
    // check if this layer has a view (is a backing layer)
    guard let view = self.delegate as? View else {
      return
    }

    // check if we've already hooked this view
    if getAssociatedObject(for: &AssociateKey.viewLayoutToken) != nil {
      return
    }

    // Hook into the view's layout
    let token = view.onLayoutSubviews { view in
      view.layer?.setNeedsLayout()
      view.layer?.layoutIfNeeded()
    }

    setAssociatedObject(token, for: &AssociateKey.viewLayoutToken)
  }

  private func unhookViewLayout() {
    guard let token = getAssociatedObject(for: &AssociateKey.viewLayoutToken) as? CancellableToken else {
      return
    }

    token.cancel()
    removeAssociatedObject(for: &AssociateKey.viewLayoutToken)
  }
  #endif
}
