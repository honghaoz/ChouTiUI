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

// MARK: - KVO Interaction

// This implementation uses isa-swizzling to intercept layout calls. It's important to understand
// how this interacts with KVO (Key-Value Observing), which also uses isa-swizzling.
//
// Ideal pattern:
// 1. Call onLayoutSubviews() first. The class becomes: ChouTiUI_NSView
// 2. Setup KVO observation later. The class becomes: NSKVONotifying_ChouTiUI_NSView
// 3. Remove KVO observation later. The class becomes: ChouTiUI_NSView
// 4. Cancel onLayoutSubviews() later. The class reverts to the original class: NSView
//
// Other patterns are also supported, but may not be as clean.
// - Pattern 1: Our Swizzle First, Then KVO
//   - Timeline:
//     - Call onLayoutSubviews() -> class becomes: ChouTiUI_NSView
//     - Setup KVO observation -> class becomes: NSKVONotifying_ChouTiUI_NSView
//     - Cancel onLayoutSubviews() -> class stays: NSKVONotifying_ChouTiUI_NSView
//     - Remove KVO observation -> class becomes: ChouTiUI_NSView (won't revert to the original class)
//
//   This pattern ended up with a subclass of the original class. To revert to the original class, you can call
//    onLayoutSubviews() again then cancel it.
//
// - Pattern 2: KVO First, Then Our Swizzle
//   - Timeline:
//     - Setup KVO observation -> class becomes: NSKVONotifying_NSView
//     - Call onLayoutSubviews() -> class stays: NSKVONotifying_NSView, the method is swizzled on the original class
//     - Cancel onLayoutSubviews() -> class stays: NSKVONotifying_NSView, the method is restored to the original implementation
//     - Remove KVO observation -> class becomes: NSView
//
//   This pattern could be ended up with a clean state. However, during the process, the original class method is modified,
//   which may break other mechanisms that also modify the original class method.

private extension View {

  private enum AssociateKey {
    static var layoutSubviewsBlocks: UInt8 = 0
    static var originalClass: UInt8 = 0
    static var isSwizzlingOriginalMethod: UInt8 = 0
    static var hasExecutedLayoutCallbacks: UInt8 = 0
    static var kvoDeallocationToken: UInt8 = 0
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

  /// The original class of the view.
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

  /// Tracks if the view is swizzling the original method.
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

  /// Tracks if the view has executed layout callbacks.
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

  /// Tracks if the view has added deallocation cleanup for resetting the original method implementation.
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

public extension View {

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
        if isSwizzlingOriginalMethod {
          restoreOriginalMethod()
        } else {
          revertToOriginClass()
        }
      }
    }
    token.store(in: &layoutSubviewsBlocks)

    swizzleLayoutSubviews()

    return token
  }

  // MARK: - Swizzle

  #if canImport(AppKit)
  private static let layoutSubviewsSelector = #selector(NSView.layout)
  #else
  private static let layoutSubviewsSelector = #selector(UIView.layoutSubviews)
  #endif

  private typealias LayoutSubviewsFunction = @convention(c) (AnyObject, Selector) -> Void

  private func swizzleLayoutSubviews() {
    /// Case 1: Our swizzling first then KVO
    ///
    /// If the instance was swizzled by our swizzling first then KVO, a KVO class (NSKVONotifying_ChouTiUI_*) is created on top of our swizzled class (ChouTiUI_*).
    ///
    /// In this case:
    /// - If we swizzle again, no new swizzling will be done.
    /// - If we KVO again, no new KVO class will be created.
    ///
    /// If we cancel the swizzling before KVO, since the KVO class is inherited from our swizzled class, we can't revert the class.
    /// Then if we cancel the KVO, the class will revert to their recorded original class, which is our swizzled class (ChouTiUI_*). At this point, the instance is left with our swizzled class.
    /// The instance can be reverted to the original class if we swizzle again and cancel the swizzling.
    ///
    /// If we cancel the KVO before swizzling, KVO will clean up its class and revert to their recorded original class, which is our swizzled class (ChouTiUI_*).
    /// Then if we cancel the swizzling, the class will revert to the original class.

    /// Case 2: KVO first then our swizzling
    ///
    /// If the instance was swizzled by KVO first then our swizzling, a KVO class (NSKVONotifying_*) is created on top of the original class. Our swizzling doesn't create a new class.
    /// Instead, our swizzling will modify the method on the original class. This will swizzle the method on all instances of the original class. This maybe not clean as we don't know if the original class has been swizzled by other mechanisms.
    /// However, we have to accept this potential risk as 1) we can't create a new subclass on top of a KVO class as KVO cleanup may break our swizzling and 2) we can't swizzle the method on the KVO class as KVO cleanup may remove the class and remove our swizzling.
    /// Therefore, the preferred pattern is to swizzle first then KVO.
    ///
    /// In this case:
    /// - If we swizzle again, we will swizzle the method directly on the original class.
    /// - If we KVO again, no new KVO class will be created.
    ///
    /// If we cancel the swizzling before KVO, we revert the method on the original class. At this point, the instance is clean.
    /// It possible that we swizzle again. To help clean up the swizzled method on the original class, we track how many instances of the original class have callbacks. When the count reaches zero, we restore the original method implementation.
    ///
    /// If we cancel the KVO before swizzling, KVO will clean up its class and revert to their recorded original class, which is the original class.
    /// At this point, the instance is with the original class with the method swizzled. Then if we cancel the swizzling, the class will revert its method to the original implementation. At this point, the instance is clean.

    guard let currentClass: AnyClass = object_getClass(self) else {
      ChouTi.assertFailure("Failed to get current class")
      return
    }

    let currentClassName = NSStringFromClass(currentClass)

    // Check if current class is a KVO class
    // KVO creates classes with names like "NSKVONotifying_OriginalClass" or "..NSKVONotifying_Module.Class"
    let isKVOClass = currentClassName.contains("NSKVONotifying_")

    // Determine the original class:
    // - If we have a stored original class, use that (instance was already swizzled)
    // - If KVO is active, use the KVO class's superclass
    // - Otherwise, use the current class
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
      // Note: Even if the class might be in swizzledKVOClasses (other KVO instances modified the original class),
      // we still create a subclass for this instance to keep isa swizzling (no KVO) and method swizzling (KVO) two separate mechanisms.
      // a `hasExecutedLayoutCallbacks` flag is used to avoid double execution caused by this.
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
      swizzleOriginalMethod(originalClass: originalClass, selector: View.layoutSubviewsSelector)
    } else {
      // this is a non-KVO class, create a subclass
      swizzleToSubclass(originalClass: originalClass, selector: View.layoutSubviewsSelector)
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
        ChouTi.assertFailure("Failed to create subclass for View isa swizzling")
        return
      }

      guard let originalMethod = class_getInstanceMethod(originalClass, selector) else {
        ChouTi.assertFailure("Failed to get layout method")
        return
      }

      // get the original implementation
      let originalImplementation = unsafeBitCast(
        class_getMethodImplementation(originalClass, selector),
        to: LayoutSubviewsFunction.self
      )

      // create the new implementation
      let newImplementation: @convention(block) (View) -> Void = { view in
        // call super implementation
        view.hasExecutedLayoutCallbacks = false
        originalImplementation(view, selector)

        // call the custom blocks if needed
        if view.hasExecutedLayoutCallbacks == false {
          for token in view.layoutSubviewsBlocks.values {
            token.value(view)
          }
        }
      }

      // add the method to the subclass
      let methodTypeEncoding = method_getTypeEncoding(originalMethod)
      let newIMP = imp_implementationWithBlock(newImplementation)
      class_addMethod(subclass, selector, newIMP, methodTypeEncoding)

      #if canImport(AppKit)
      // On macOS, override setFrameSize: and setBounds: to call setNeedsLayout: when they change
      // This ensures that layout() is called when frame/bounds change, matching UIKit behavior
      addSetFrameSizeOverride(to: subclass, originalClass: originalClass)
      addSetBoundsOverride(to: subclass, originalClass: originalClass)
      #endif

      // register the new class
      objc_registerClassPair(subclass)

      // change the instance's class
      object_setClass(self, subclass)
    }
  }

  #if canImport(AppKit)
  /// Adds setFrameSize: override to the subclass to ensure needsLayout is set when frame size changes
  private func addSetFrameSizeOverride(to subclass: AnyClass, originalClass: AnyClass) {
    let setFrameSizeSelector = #selector(NSView.setFrameSize(_:))

    guard let originalMethod = class_getInstanceMethod(originalClass, setFrameSizeSelector) else {
      ChouTi.assertFailure("Failed to get setFrameSize: method")
      return
    }

    // Get the original setFrameSize: implementation
    typealias SetFrameSizeFunction = @convention(c) (AnyObject, Selector, NSSize) -> Void
    let originalSetFrameSize = unsafeBitCast(
      class_getMethodImplementation(originalClass, setFrameSizeSelector),
      to: SetFrameSizeFunction.self
    )

    // Create new setFrameSize: implementation that calls setNeedsLayout:
    let newSetFrameSize: @convention(block) (NSView, NSSize) -> Void = { view, newSize in
      let oldSize = view.frame.size

      // Call original setFrameSize:
      originalSetFrameSize(view, setFrameSizeSelector, newSize)

      // Check if size actually changed by reading the new value after setting
      // This avoids floating point precision issues with direct comparison
      let actualNewSize = view.frame.size
      if !oldSize.equalTo(actualNewSize) {
        view.needsLayout = true
      }
    }

    let methodTypeEncoding = method_getTypeEncoding(originalMethod)
    let newIMP = imp_implementationWithBlock(newSetFrameSize)
    class_addMethod(subclass, setFrameSizeSelector, newIMP, methodTypeEncoding)
  }

  /// Adds setBounds: override to the subclass to ensure needsLayout is set when bounds change
  private func addSetBoundsOverride(to subclass: AnyClass, originalClass: AnyClass) {
    let setBoundsSelector = #selector(setter: NSView.bounds)

    guard let originalMethod = class_getInstanceMethod(originalClass, setBoundsSelector) else {
      ChouTi.assertFailure("Failed to get setBounds: method")
      return
    }

    // Get the original setBounds: implementation
    typealias SetBoundsFunction = @convention(c) (AnyObject, Selector, CGRect) -> Void
    let originalSetBounds = unsafeBitCast(
      class_getMethodImplementation(originalClass, setBoundsSelector),
      to: SetBoundsFunction.self
    )

    // Create new setBounds: implementation that calls setNeedsLayout:
    let newSetBounds: @convention(block) (NSView, CGRect) -> Void = { view, newBounds in
      let oldBounds = view.bounds

      // Call original setBounds:
      originalSetBounds(view, setBoundsSelector, newBounds)

      // Check if bounds actually changed by reading the new value after setting
      // This avoids floating point precision issues with direct comparison
      let actualNewBounds = view.bounds
      if !oldBounds.equalTo(actualNewBounds) {
        view.needsLayout = true
      }
    }

    let methodTypeEncoding = method_getTypeEncoding(originalMethod)
    let newIMP = imp_implementationWithBlock(newSetBounds)
    class_addMethod(subclass, setBoundsSelector, newIMP, methodTypeEncoding)
  }
  #endif

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
      return
    }

    let currentClassName = NSStringFromClass(currentClass)
    let expectedClassName = "ChouTiUI_\(NSStringFromClass(originalClass))"

    // Safety check: only revert if the current class is our swizzled class
    // If KVO or other mechanisms changed the class, we should NOT revert
    // to avoid breaking KVO or other isa-swizzling mechanisms
    guard currentClassName == expectedClassName else {
      // The class has been changed (likely by KVO: NSKVONotifying_ChouTiUI_OriginalClass)
      // We should NOT revert to the original class as it would break KVO.
      //
      // For this case, we will not revert to the original class and leave the class as is.
      return
    }

    object_setClass(self, originalClass)
    self.originalClass = nil
  }

  // MARK: - KVO Classes

  /// Tracks which original classes have been swizzled when KVO is active.
  private static var swizzledClasses: Set<String> = []
  private static let swizzledClassesLock = NSLock()

  /// Stores IMPs for swizzled methods to keep them alive
  /// Keys:
  /// - "\(originalClassName)": The new swizzled IMP
  /// - "original_\(originalClassName)": The original IMP (for restoration)
  /// - "setFrameSize_\(originalClassName)": The new swizzled IMP for setFrameSize:
  /// - "original_setFrameSize_\(originalClassName)": The original IMP for setFrameSize:
  /// - "setBounds_\(originalClassName)": The new swizzled IMP for setBounds:
  /// - "original_setBounds_\(originalClassName)": The original IMP for setBounds:
  private static var swizzledMethodIMPs: [String: IMP] = [:]
  private static let swizzledMethodIMPsLock = NSLock()

  /// Tracks how many instances of each original class have callbacks (for KVO case cleanup).
  /// Key is the original class name, value is the count of instances with callbacks.
  private static var kvoInstanceCallbackCounts: [String: Int] = [:]
  private static let kvoInstanceCallbackCountsLock = NSLock()

  /// Swizzles the layout method directly on the original class when KVO is active.
  ///
  /// This is used when KVO was set up before our swizzling. Instead of creating a new subclass,
  /// we modify the method on the original class. The KVO class will inherit this modification.
  ///
  /// Why we modify the original class:
  /// - We can't create a new subclass on top of a KVO class as KVO cleanup may break our subclassing.
  /// - We can't swizzle the method on the KVO class as KVO cleanup may remove the class and remove our swizzling.
  ///
  /// This is safe because:
  /// - The method implementation checks for per-instance callbacks using associated objects.
  /// - The swizzled method is on the original class, shared by all instances (KVO or not).
  /// - Only instances with callbacks will execute them (per-instance check via associated objects).
  private func swizzleOriginalMethod(originalClass: AnyClass, selector: Selector) {
    // mark this instance as using method swizzling
    self.isSwizzlingOriginalMethod = true

    let originalClassName = NSStringFromClass(originalClass)

    // increment the callback count for this original class
    View.incrementKVOCallbackCount(for: originalClassName)

    // observe deallocation to handle deallocation before token cancellation
    //
    // it's possible that the instance may deallocate directly without cancelling the cancellable token explicitly,
    // in this case, even though the cancellable token callback is still triggered, but the self is nil, hence the
    // decrement logic will not be executed.
    // to avoid this, we observe deallocation and decrement the callback count.
    if self.kvoDeallocationToken == nil {
      let token = self.onDeallocate {
        View.decrementKVOCallbackCount(for: originalClass)
      }
      self.kvoDeallocationToken = token
    }

    // check if we've already swizzled this original class
    //
    // note: we track by original class name, not KVO class name, because we're modifying the original class.
    View.swizzledClassesLock.lock()
    let alreadySwizzled = View.swizzledClasses.contains(originalClassName)
    if !alreadySwizzled {
      View.swizzledClasses.insert(originalClassName)
    }
    View.swizzledClassesLock.unlock()

    if alreadySwizzled {
      // already swizzled, nothing to do
      return
    }

    guard let originalMethod = class_getInstanceMethod(originalClass, selector) else {
      ChouTi.assertFailure("Failed to get layout method from original class")
      return
    }

    // store the original IMP before modifying (so we can restore it later)
    let originalIMP = method_getImplementation(originalMethod)

    // get the original implementation from the original class
    let originalImplementation = unsafeBitCast(
      class_getMethodImplementation(originalClass, selector),
      to: LayoutSubviewsFunction.self
    )

    // create the new implementation
    let newImplementation: @convention(block) (View) -> Void = { view in
      // call super implementation
      view.hasExecutedLayoutCallbacks = false
      originalImplementation(view, selector)

      // call the custom blocks if needed
      if view.hasExecutedLayoutCallbacks == false {
        for token in view.layoutSubviewsBlocks.values {
          token.value(view)
        }

        view.hasExecutedLayoutCallbacks = true
      }
    }

    // modify the method on the original class
    let newIMP = imp_implementationWithBlock(newImplementation)
    method_setImplementation(originalMethod, newIMP)

    // store both IMPs to keep them alive and allow restoration
    View.swizzledMethodIMPsLock.lock()
    View.swizzledMethodIMPs["original_\(originalClassName)"] = originalIMP // for restoration
    View.swizzledMethodIMPs[originalClassName] = newIMP // to keep it alive
    View.swizzledMethodIMPsLock.unlock()

    #if canImport(AppKit)
    // Also add frame/bounds setters to the original class
    // This ensures needsLayout is set when frame/bounds change on macOS
    addSetFrameSizeOverrideToOriginalClass(originalClass: originalClass, originalClassName: originalClassName)
    addSetBoundsOverrideToOriginalClass(originalClass: originalClass, originalClassName: originalClassName)
    #endif
  }

  #if canImport(AppKit)
  /// Adds setFrameSize: override to the original class (for KVO case)
  private func addSetFrameSizeOverrideToOriginalClass(originalClass: AnyClass, originalClassName: String) {
    let setFrameSizeSelector = #selector(NSView.setFrameSize(_:))

    guard let originalMethod = class_getInstanceMethod(originalClass, setFrameSizeSelector) else {
      ChouTi.assertFailure("Failed to get setFrameSize: method")
      return
    }

    // Store the original IMP before modifying
    let originalIMP = method_getImplementation(originalMethod)

    View.swizzledMethodIMPsLock.lock()
    View.swizzledMethodIMPs["original_setFrameSize_\(originalClassName)"] = originalIMP
    View.swizzledMethodIMPsLock.unlock()

    // Get the original setFrameSize: implementation
    typealias SetFrameSizeFunction = @convention(c) (AnyObject, Selector, NSSize) -> Void
    let originalSetFrameSize = unsafeBitCast(originalIMP, to: SetFrameSizeFunction.self)

    // Create new setFrameSize: implementation
    let newSetFrameSize: @convention(block) (NSView, NSSize) -> Void = { view, newSize in
      let oldSize = view.frame.size
      originalSetFrameSize(view, setFrameSizeSelector, newSize)
      let actualNewSize = view.frame.size
      if !oldSize.equalTo(actualNewSize) {
        view.needsLayout = true
      }
    }

    let newIMP = imp_implementationWithBlock(newSetFrameSize)
    method_setImplementation(originalMethod, newIMP)

    // Store the new IMP to keep it alive
    View.swizzledMethodIMPsLock.lock()
    View.swizzledMethodIMPs["setFrameSize_\(originalClassName)"] = newIMP
    View.swizzledMethodIMPsLock.unlock()
  }

  /// Adds setBounds: override to the original class (for KVO case)
  private func addSetBoundsOverrideToOriginalClass(originalClass: AnyClass, originalClassName: String) {
    let setBoundsSelector = #selector(setter: NSView.bounds)

    guard let originalMethod = class_getInstanceMethod(originalClass, setBoundsSelector) else {
      ChouTi.assertFailure("Failed to get setBounds: method")
      return
    }

    // Store the original IMP before modifying
    let originalIMP = method_getImplementation(originalMethod)

    View.swizzledMethodIMPsLock.lock()
    View.swizzledMethodIMPs["original_setBounds_\(originalClassName)"] = originalIMP
    View.swizzledMethodIMPsLock.unlock()

    // Get the original setBounds: implementation
    typealias SetBoundsFunction = @convention(c) (AnyObject, Selector, CGRect) -> Void
    let originalSetBounds = unsafeBitCast(originalIMP, to: SetBoundsFunction.self)

    // Create new setBounds: implementation
    let newSetBounds: @convention(block) (NSView, CGRect) -> Void = { view, newBounds in
      let oldBounds = view.bounds
      originalSetBounds(view, setBoundsSelector, newBounds)
      let actualNewBounds = view.bounds
      if !oldBounds.equalTo(actualNewBounds) {
        view.needsLayout = true
      }
    }

    let newIMP = imp_implementationWithBlock(newSetBounds)
    method_setImplementation(originalMethod, newIMP)

    // Store the new IMP to keep it alive
    View.swizzledMethodIMPsLock.lock()
    View.swizzledMethodIMPs["setBounds_\(originalClassName)"] = newIMP
    View.swizzledMethodIMPsLock.unlock()
  }
  #endif

  private func restoreOriginalMethod() {
    // if this instance was using KVO swizzling, decrement the callback count
    guard let originalClass else {
      ChouTi.assertFailure("Cannot restore: original class not found")
      return
    }

    View.decrementKVOCallbackCount(for: originalClass)

    self.kvoDeallocationToken?.cancel()
    self.kvoDeallocationToken = nil
    self.originalClass = nil
    self.isSwizzlingOriginalMethod = false
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
      if let originalMethod = class_getInstanceMethod(originalClass, View.layoutSubviewsSelector) {
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
        ChouTi.assertFailure("Failed to get layout method from original class for restoration")
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
}
