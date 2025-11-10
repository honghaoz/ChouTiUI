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

private enum AssociateKey {
  static var layoutSubviewsBlocks: UInt8 = 0
  static var originalClass: UInt8 = 0
}

public extension View {

  typealias LayoutSubviewsBlocks = OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(View) -> Void>>

  private var layoutSubviewsBlocks: LayoutSubviewsBlocks {
    get {
      getAssociatedObject(for: &AssociateKey.layoutSubviewsBlocks) as? LayoutSubviewsBlocks ?? LayoutSubviewsBlocks()
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.layoutSubviewsBlocks)
    }
  }

  /// Adds a block to be called when the view performs layout.
  ///
  /// This method should be called on the main thread.
  ///
  /// Calling this method will dynamically swizzle the view's class to override the layout method:
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
        revertLayoutSubviews()
      }
    }
    token.store(in: &layoutSubviewsBlocks)

    swizzleLayoutSubviews()

    return token
  }

  private func swizzleLayoutSubviews() {
    guard let originalClass: AnyClass = getAssociatedObject(for: &AssociateKey.originalClass) as? AnyClass ?? object_getClass(self) else {
      ChouTi.assertFailure("Failed to get original class")
      return
    }

    if getAssociatedObject(for: &AssociateKey.originalClass) == nil {
      setAssociatedObject(originalClass, for: &AssociateKey.originalClass)
    }

    let subclassName = "\(NSStringFromClass(originalClass))_ChouTiUI_LayoutSubviews"

    // check if we already have a swizzled class
    if let existingClass = NSClassFromString(subclassName) {
      object_setClass(self, existingClass)
      return
    }

    // create a new subclass
    guard let subclass = objc_allocateClassPair(originalClass, subclassName, 0) else {
      ChouTi.assertFailure("Failed to create subclass for View isa swizzling")
      return
    }

    #if canImport(AppKit)
    let layoutSubviewsSelector = #selector(NSView.layout)
    #else
    let layoutSubviewsSelector = #selector(UIView.layoutSubviews)
    #endif

    guard let originalMethod = class_getInstanceMethod(originalClass, layoutSubviewsSelector) else {
      ChouTi.assertFailure("Failed to get layout method")
      return
    }

    // get the original implementation
    typealias LayoutSubviewsFunction = @convention(c) (AnyObject, Selector) -> Void
    let originalImplementation = unsafeBitCast(
      class_getMethodImplementation(originalClass, layoutSubviewsSelector),
      to: LayoutSubviewsFunction.self
    )

    // create the new implementation
    let newImplementation: @convention(block) (View) -> Void = { view in
      // call super implementation
      originalImplementation(view, layoutSubviewsSelector)

      // call the custom blocks
      for token in view.layoutSubviewsBlocks.values {
        token.value(view)
      }
    }

    // add the method to the subclass
    let methodTypeEncoding = method_getTypeEncoding(originalMethod)
    let newIMP = imp_implementationWithBlock(newImplementation)
    class_addMethod(subclass, layoutSubviewsSelector, newIMP, methodTypeEncoding)

    // register the new class
    objc_registerClassPair(subclass)

    // change the instance's class
    object_setClass(self, subclass)
  }

  private func revertLayoutSubviews() {
    guard let originalClass = getAssociatedObject(for: &AssociateKey.originalClass) as? AnyClass else {
      ChouTi.assertFailure("Cannot revert: original class not found")
      return
    }

    object_setClass(self, originalClass)

    // clean up the stored original class
    setAssociatedObject(nil as AnyClass?, for: &AssociateKey.originalClass)
  }
}
