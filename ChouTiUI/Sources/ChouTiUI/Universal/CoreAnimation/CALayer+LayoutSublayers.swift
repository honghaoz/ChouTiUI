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

// MARK: - KVO Interaction

// This implementation uses isa-swizzling to intercept layoutSublayers calls. It's important to understand
// how this interacts with KVO (Key-Value Observing), which also uses isa-swizzling.
//
// The implementation follows the same pattern as View+LayoutSubviews:
// - Pattern 1: Our Swizzle First, Then KVO (creates subclass, then KVO wraps it)
// - Pattern 2: KVO First, Then Our Swizzle (modifies original class method)

private extension CALayer {

  private enum AssociateKey {
    static var layoutSublayersBlocks: UInt8 = 0
    static var originalClass: UInt8 = 0
    static var isSwizzlingOriginalMethod: UInt8 = 0
    static var hasExecutedLayoutCallbacks: UInt8 = 0
    static var kvoDeallocationToken: UInt8 = 0

    static var viewLayoutToken: UInt8 = 0
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

  /// The original class of the layer.
  private var originalClass: AnyClass? {
    get {
      getAssociatedObject(for: &AssociateKey.originalClass) as? AnyClass
    }
    set {
      if let newValue {
        setAssociatedObject(newValue, for: &AssociateKey.originalClass)
      } else {
        removeAssociatedObject(for: &AssociateKey.originalClass)
      }
    }
  }

  /// Tracks if the layer is swizzling the original method.
  private var isSwizzlingOriginalMethod: Bool {
    get {
      getAssociatedObject(for: &AssociateKey.isSwizzlingOriginalMethod) as? Bool ?? false
    }
    set {
      if newValue == true {
        setAssociatedObject(newValue, for: &AssociateKey.isSwizzlingOriginalMethod)
      } else {
        removeAssociatedObject(for: &AssociateKey.isSwizzlingOriginalMethod)
      }
    }
  }

  /// Tracks if the layer has executed layout callbacks.
  ///
  /// This is used to avoid double execution when both original class method AND subclass method are swizzled.
  private var hasExecutedLayoutCallbacks: Bool {
    get {
      getAssociatedObject(for: &AssociateKey.hasExecutedLayoutCallbacks) as? Bool ?? false
    }
    set {
      if newValue == true {
        setAssociatedObject(newValue, for: &AssociateKey.hasExecutedLayoutCallbacks)
      } else {
        removeAssociatedObject(for: &AssociateKey.hasExecutedLayoutCallbacks)
      }
    }
  }

  /// Tracks if the layer has added deallocation cleanup for resetting the original method implementation.
  private var kvoDeallocationToken: CancellableToken? {
    get {
      getAssociatedObject(for: &AssociateKey.kvoDeallocationToken) as? CancellableToken
    }
    set {
      if let newValue {
        setAssociatedObject(newValue, for: &AssociateKey.kvoDeallocationToken)
      } else {
        removeAssociatedObject(for: &AssociateKey.kvoDeallocationToken)
      }
    }
  }
}

public extension CALayer {

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
        if isSwizzlingOriginalMethod {
          restoreOriginalMethod()
        } else {
          revertToOriginClass()
        }
      }
    }
    token.store(in: &layoutSublayersBlocks)

    swizzleLayoutSublayers()

    #if canImport(AppKit)
    hookViewLayout()
    #endif

    return token
  }

  // MARK: - Swizzle

  private static let layoutSublayersSelector = #selector(CALayer.layoutSublayers)

  private typealias LayoutSublayersFunction = @convention(c) (AnyObject, Selector) -> Void

  private func swizzleLayoutSublayers() {
    guard let currentClass: AnyClass = object_getClass(self) else {
      ChouTi.assertFailure("Failed to get current class")
      return
    }

    let currentClassName = NSStringFromClass(currentClass)

    // Check if current class is a KVO class
    let isKVOClass = currentClassName.contains("NSKVONotifying_")

    // Determine the original class
    let storedOriginalClass: AnyClass? = self.originalClass

    let originalClass: AnyClass
    let needsSwizzling: Bool

    if let storedOriginalClass {
      // already swizzled this instance
      originalClass = storedOriginalClass
      needsSwizzling = false
    } else if isKVOClass {
      // KVO was added first, get the real original class from KVO's superclass
      guard let superClass = class_getSuperclass(currentClass) else {
        ChouTi.assertFailure("Failed to get original class from KVO's superclass")
        return
      }
      originalClass = superClass
      needsSwizzling = true
    } else {
      // No KVO on this instance, current class is the original
      originalClass = currentClass
      needsSwizzling = true
    }

    // If we don't need swizzling (already swizzled), just return
    guard needsSwizzling else {
      return
    }

    // store the original class if not already stored
    if storedOriginalClass == nil {
      self.originalClass = originalClass
    }

    if isKVOClass {
      // this is a KVO class, swizzle the method on the original class
      swizzleOriginalMethod(originalClass: originalClass, selector: CALayer.layoutSublayersSelector)
    } else {
      // this is a non-KVO class, create a subclass
      swizzleToSubclass(originalClass: originalClass, selector: CALayer.layoutSublayersSelector)
    }
  }

  // MARK: - Non-KVO Classes

  private func swizzleToSubclass(originalClass: AnyClass, selector: Selector) {
    let subclassName = "ChouTiUI_\(NSStringFromClass(originalClass))"

    if let existingClass = NSClassFromString(subclassName) {
      // we already have the subclass defined, use it
      object_setClass(self, existingClass)
    } else {
      // create a new subclass
      guard let subclass = objc_allocateClassPair(originalClass, subclassName, 0) else {
        ChouTi.assertFailure("Failed to create subclass for CALayer isa swizzling")
        return
      }

      guard let originalMethod = class_getInstanceMethod(originalClass, selector) else {
        ChouTi.assertFailure("Failed to get layoutSublayers method")
        return
      }

      // get the original implementation
      let originalImplementation = unsafeBitCast(
        class_getMethodImplementation(originalClass, selector),
        to: LayoutSublayersFunction.self
      )

      // create the new implementation
      let newImplementation: @convention(block) (CALayer) -> Void = { layer in
        // call super implementation
        layer.hasExecutedLayoutCallbacks = false
        originalImplementation(layer, selector)

        // call the custom blocks if needed
        if layer.hasExecutedLayoutCallbacks == false {
          for token in layer.layoutSublayersBlocks.values {
            token.value(layer)
          }
        }
      }

      // add the method to the subclass
      let methodTypeEncoding = method_getTypeEncoding(originalMethod)
      let newIMP = imp_implementationWithBlock(newImplementation)
      class_addMethod(subclass, selector, newIMP, methodTypeEncoding)

      // register the new class
      objc_registerClassPair(subclass)

      // change the instance's class
      object_setClass(self, subclass)
    }
  }

  private func revertToOriginClass() {
    guard let originalClass else {
      ChouTi.assertFailure("Cannot revert: original class not found")
      return
    }

    guard let currentClass = object_getClass(self) else {
      ChouTi.assertFailure("Cannot revert: failed to get current class")
      return
    }

    // check if we're already on the original class
    guard currentClass != originalClass else {
      // already reverted, just clean up
      self.originalClass = nil
      #if canImport(AppKit)
      unhookViewLayout()
      #endif
      return
    }

    let currentClassName = NSStringFromClass(currentClass)
    let expectedClassName = "ChouTiUI_\(NSStringFromClass(originalClass))"

    // Safety check: only revert if the current class is our swizzled class
    guard currentClassName == expectedClassName else {
      // The class has been changed (likely by KVO)
      // We should NOT revert to the original class as it would break KVO
      #if canImport(AppKit)
      unhookViewLayout()
      #endif
      return
    }

    object_setClass(self, originalClass)
    self.originalClass = nil

    #if canImport(AppKit)
    unhookViewLayout()
    #endif
  }

  // MARK: - KVO Classes

  /// Tracks which original classes have been swizzled when KVO is active.
  private static var swizzledClasses: Set<String> = []
  private static let swizzledClassesLock = NSLock()

  /// Stores IMPs for swizzled methods to keep them alive
  /// Keys:
  /// - "\(originalClassName)": The new swizzled IMP
  /// - "original_\(originalClassName)": The original IMP (for restoration)
  private static var swizzledMethodIMPs: [String: IMP] = [:]
  private static let swizzledMethodIMPsLock = NSLock()

  /// Tracks how many instances of each original class have callbacks (for KVO case cleanup).
  /// Key is the original class name, value is the count of instances with callbacks.
  private static var kvoInstanceCallbackCounts: [String: Int] = [:]
  private static let kvoInstanceCallbackCountsLock = NSLock()

  /// Swizzles the layoutSublayers method directly on the original class when KVO is active.
  private func swizzleOriginalMethod(originalClass: AnyClass, selector: Selector) {
    // mark this instance as using method swizzling
    self.isSwizzlingOriginalMethod = true

    let originalClassName = NSStringFromClass(originalClass)

    // increment the callback count for this original class
    CALayer.incrementKVOCallbackCount(for: originalClassName)

    // observe deallocation to handle deallocation before token cancellation
    if self.kvoDeallocationToken == nil {
      let token = self.onDeallocate {
        CALayer.decrementKVOCallbackCount(for: originalClass)
      }
      self.kvoDeallocationToken = token
    }

    // check if we've already swizzled this original class
    CALayer.swizzledClassesLock.lock()
    let alreadySwizzled = CALayer.swizzledClasses.contains(originalClassName)
    if !alreadySwizzled {
      CALayer.swizzledClasses.insert(originalClassName)
    }
    CALayer.swizzledClassesLock.unlock()

    if alreadySwizzled {
      // already swizzled, nothing to do
      return
    }

    guard let originalMethod = class_getInstanceMethod(originalClass, selector) else {
      ChouTi.assertFailure("Failed to get layoutSublayers method from original class")
      return
    }

    // store the original IMP before modifying (so we can restore it later)
    let originalIMP = method_getImplementation(originalMethod)

    // get the original implementation from the original class
    let originalImplementation = unsafeBitCast(
      class_getMethodImplementation(originalClass, selector),
      to: LayoutSublayersFunction.self
    )

    // create the new implementation
    let newImplementation: @convention(block) (CALayer) -> Void = { layer in
      // call super implementation
      layer.hasExecutedLayoutCallbacks = false
      originalImplementation(layer, selector)

      // call the custom blocks if needed
      if layer.hasExecutedLayoutCallbacks == false {
        for token in layer.layoutSublayersBlocks.values {
          token.value(layer)
        }

        layer.hasExecutedLayoutCallbacks = true
      }
    }

    // modify the method on the original class
    let newIMP = imp_implementationWithBlock(newImplementation)
    method_setImplementation(originalMethod, newIMP)

    // store both IMPs to keep them alive and allow restoration
    CALayer.swizzledMethodIMPsLock.lock()
    CALayer.swizzledMethodIMPs["original_\(originalClassName)"] = originalIMP // for restoration
    CALayer.swizzledMethodIMPs[originalClassName] = newIMP // to keep it alive
    CALayer.swizzledMethodIMPsLock.unlock()
  }

  private func restoreOriginalMethod() {
    // if this instance was using KVO swizzling, decrement the callback count
    guard let originalClass else {
      ChouTi.assertFailure("Cannot revert: original class not found")
      return
    }

    CALayer.decrementKVOCallbackCount(for: originalClass)

    self.kvoDeallocationToken?.cancel()
    self.kvoDeallocationToken = nil
    self.originalClass = nil
    self.isSwizzlingOriginalMethod = false

    #if canImport(AppKit)
    unhookViewLayout()
    #endif
  }

  private static func incrementKVOCallbackCount(for originalClassName: String) {
    kvoInstanceCallbackCountsLock.lock()
    kvoInstanceCallbackCounts[originalClassName, default: 0] += 1
    kvoInstanceCallbackCountsLock.unlock()
  }

  private static func decrementKVOCallbackCount(for originalClass: AnyClass) {
    let originalClassName = NSStringFromClass(originalClass)

    kvoInstanceCallbackCountsLock.lock()
    let count = kvoInstanceCallbackCounts[originalClassName, default: 0] - 1
    kvoInstanceCallbackCountsLock.unlock()

    if count <= 0 {
      ChouTi.assert(count == 0, "over decrementing callback count", metadata: [
        "originalClassName": originalClassName,
        "count": "\(count)",
      ])

      // no more instances with callbacks - restore the original method!
      if let originalMethod = class_getInstanceMethod(originalClass, CALayer.layoutSublayersSelector) {
        swizzledMethodIMPsLock.lock()
        let originalIMP = swizzledMethodIMPs["original_\(originalClassName)"]
        swizzledMethodIMPsLock.unlock()

        if let originalIMP = originalIMP {
          // restore the original implementation
          method_setImplementation(originalMethod, originalIMP)
        } else {
          ChouTi.assertFailure("Failed to find original IMP for restoration")
        }

        // NOTE: We intentionally DO NOT call imp_removeBlock on the new IMP
        // Calling imp_removeBlock can cause crashes if the IMP is still referenced anywhere
        // The IMP will be cleaned up when the program exits
        // This is a minor memory leak but safer than crashing
      } else {
        ChouTi.assertFailure("Failed to get layoutSublayers method from original class for restoration")
      }

      // clean up tracking data
      swizzledClassesLock.lock()
      swizzledClasses.remove(originalClassName)
      swizzledClassesLock.unlock()

      swizzledMethodIMPsLock.lock()
      swizzledMethodIMPs.removeValue(forKey: "original_\(originalClassName)")
      swizzledMethodIMPs.removeValue(forKey: originalClassName)
      swizzledMethodIMPsLock.unlock()

      kvoInstanceCallbackCountsLock.lock()
      kvoInstanceCallbackCounts.removeValue(forKey: originalClassName)
      kvoInstanceCallbackCountsLock.unlock()
    } else {
      kvoInstanceCallbackCountsLock.lock()
      kvoInstanceCallbackCounts[originalClassName] = count
      kvoInstanceCallbackCountsLock.unlock()
    }
  }

  // MARK: - View Layout Hook (macOS)

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

    // hook into the view's layout
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
