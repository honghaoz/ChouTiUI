//
//  CALayer+LayoutSublayersTests.swift
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

import ChouTiTest

import ChouTi
@testable import ChouTiUI

class CALayer_LayoutSublayersTests: XCTestCase {

  private var layer: CALayer!

  override func setUp() {
    super.setUp()

    layer = CALayer()
    layer.bounds.size = CGSize(width: 100, height: 100)
  }

  func test_onLayoutSublayers_singleBlock() {
    let layer: CALayer = layer

    // initial state
    expect(getClassName(layer)) == "CALayer"

    // add callback
    var callCount = 0
    var calledLayer: CALayer?
    weak var token: CancellableToken?
    token = layer.onLayoutSublayers { layer in
      callCount += 1
      calledLayer = layer
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount) == 1
    expect(calledLayer) === layer

    // trigger again
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount) == 2
    expect(calledLayer) === layer

    // cancel callback
    token?.cancel()
    expect(getClassName(layer)) == "CALayer"

    // trigger again - should not call the block
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSublayers_multipleBlocks() {
    let layer: CALayer = layer

    expect(getClassName(layer)) == "CALayer"

    // add callback 1
    var callCount1 = 0
    var calledLayer1: CALayer?
    weak var token1: CancellableToken?
    token1 = layer.onLayoutSublayers { layer in
      callCount1 += 1
      calledLayer1 = layer
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 1
    expect(calledLayer1) === layer

    // add callback 2
    var callCount2 = 0
    var calledLayer2: CALayer?
    weak var token2: CancellableToken?
    token2 = layer.onLayoutSublayers { layer in
      callCount2 += 1
      calledLayer2 = layer
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 2
    expect(calledLayer1) === layer
    expect(callCount2) == 1
    expect(calledLayer2) === layer

    // add callback 3
    var callCount3 = 0
    var calledLayer3: CALayer?
    weak var token3: CancellableToken?
    token3 = layer.onLayoutSublayers { layer in
      callCount3 += 1
      calledLayer3 = layer
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 3
    expect(calledLayer1) === layer
    expect(callCount2) == 2
    expect(calledLayer2) === layer
    expect(callCount3) == 1
    expect(calledLayer3) === layer

    // cancel callback 2
    token2?.cancel()
    expect(getClassName(layer)) == "ChouTiIMI_CALayer" // still swizzled because of callbacks 1 and 3

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 4
    expect(callCount2) == 2 // not called
    expect(callCount3) == 2

    // cancel callback 1
    token1?.cancel()
    expect(getClassName(layer)) == "ChouTiIMI_CALayer" // still swizzled because of callback 3

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 4 // not called
    expect(callCount2) == 2 // not called
    expect(callCount3) == 3

    // cancel callback 3
    token3?.cancel()
    expect(getClassName(layer)) == "CALayer" // reverted after all blocks removed

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 4 // not called
    expect(callCount2) == 2 // not called
    expect(callCount3) == 3 // not called
  }

  func test_onLayoutSublayers_executionOrder() {
    let layer: CALayer = layer

    var executionOrder: [Int] = []

    layer.onLayoutSublayers { _ in
      executionOrder.append(1)
    }

    layer.onLayoutSublayers { _ in
      executionOrder.append(2)
    }

    layer.onLayoutSublayers { _ in
      executionOrder.append(3)
    }

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(executionOrder) == [1, 2, 3]

    executionOrder = []
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(executionOrder) == [1, 2, 3]
  }

  func test_onLayoutSublayers_callSuperFirst() {
    class CustomLayer: CALayer {

      static var callOrders: [Int] = []

      override func layoutSublayers() {
        super.layoutSublayers()
        CustomLayer.callOrders.append(1)
      }
    }

    let customLayer = CustomLayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    customLayer.onLayoutSublayers { _ in
      CustomLayer.callOrders.append(2)
    }

    customLayer.setNeedsLayout()
    customLayer.layoutIfNeeded()
    expect(CustomLayer.callOrders) == [1, 2]
  }

  func test_onLayoutSublayers_calledOnBoundsChange() {
    let testWindow = TestWindow()

    let layer: CALayer = layer

    testWindow.layer.addSublayer(layer)

    var callCount = 0
    layer.onLayoutSublayers { _ in
      callCount += 1
    }

    // changing bounds should trigger layoutSublayers
    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    layer.layoutIfNeeded()
    expect(callCount) == 1

    layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
    layer.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSublayers_calledOnFrameChange() {
    let testWindow = TestWindow()

    let layer: CALayer = layer

    testWindow.layer.addSublayer(layer)

    var callCount = 0
    layer.onLayoutSublayers { _ in
      callCount += 1
    }

    // changing frame should trigger layoutSublayers
    layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    layer.layoutIfNeeded()
    expect(callCount) == 1

    layer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    layer.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSublayers_subclass() {
    class CustomLayer: CALayer {
      var customLayoutCalled = false

      override func layoutSublayers() {
        super.layoutSublayers()
        customLayoutCalled = true
      }
    }

    let customLayer = CustomLayer()
    customLayer.bounds.size = CGSize(width: 100, height: 100)

    var blockCalled = false
    customLayer.onLayoutSublayers { _ in
      blockCalled = true
    }

    // trigger layoutSublayers
    customLayer.setNeedsLayout()
    customLayer.layoutIfNeeded()

    // both the original layoutSublayers and the block should be called
    expect(customLayer.customLayoutCalled) == true
    expect(blockCalled) == true
  }

  func test_onLayoutSublayers_fromBackgroundThread() {
    let expectation = XCTestExpectation(description: "")
    let backgroundQueue = DispatchQueue.make(label: "background")

    backgroundQueue.async {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "Should be on main thread. Message: \"\""
        expect(metadata["queue"]) == "background"
        expect(metadata["thread"]) == Thread.current.description
      }
      self.layer.onLayoutSublayers { _ in }
      Assert.resetTestAssertionFailureHandler()

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  func test_onLayoutSublayers_cancelInBlock() {
    let layer: CALayer = layer

    var callCount = 0
    var token: CancellableToken?
    token = layer.onLayoutSublayers { _ in
      callCount += 1
      token?.cancel()
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount) == 1
    expect(getClassName(layer)) == "CALayer"

    // trigger again - should not call the block
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount) == 1
  }

  func test_onLayoutSublayers_tokenDeallocated() {
    let layer: CALayer = layer

    var callCount = 0

    autoreleasepool {
      let token = layer.onLayoutSublayers { _ in
        callCount += 1
      }
      _ = token // use token to prevent warning

      expect(getClassName(layer)) == "ChouTiIMI_CALayer"

      layer.setNeedsLayout()
      layer.layoutIfNeeded()
      expect(callCount) == 1
    }

    // token is deallocated, but the block should still be there
    // because the token is stored in the layoutSublayersBlocks dictionary
    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSublayers_sharedSwizzledClass() {
    let layer1 = CALayer()
    expect(getClassName(layer1)) == "CALayer"
    let layer2 = CALayer()
    expect(getClassName(layer2)) == "CALayer"

    layer1.onLayoutSublayers { _ in }
    layer2.onLayoutSublayers { _ in }

    // both layers should have the same swizzled class
    expect(getClassName(layer1)) == "ChouTiIMI_CALayer"
    expect(getClassName(layer2)) == "ChouTiIMI_CALayer"
  }

  func test_onLayoutSublayers_multipleSubclasses() {
    class CustomLayer1: CALayer {}
    class CustomLayer2: CALayer {}

    let layer1 = CustomLayer1()
    expect(getClassName(layer1)) == "_TtCFC13ChouTiUITests28CALayer_LayoutSublayersTests41test_onLayoutSublayers_multipleSubclassesFT_T_L_12CustomLayer1"
    let layer2 = CustomLayer2()
    expect(getClassName(layer2)) == "_TtCFC13ChouTiUITests28CALayer_LayoutSublayersTests41test_onLayoutSublayers_multipleSubclassesFT_T_L_12CustomLayer2"

    layer1.onLayoutSublayers { _ in }
    layer2.onLayoutSublayers { _ in }

    // each subclass should have its own swizzled class
    expect(getClassName(layer1)) == "ChouTiIMI__TtCFC13ChouTiUITests28CALayer_LayoutSublayersTests41test_onLayoutSublayers_multipleSubclassesFT_T_L_12CustomLayer1"
    expect(getClassName(layer2)) == "ChouTiIMI__TtCFC13ChouTiUITests28CALayer_LayoutSublayersTests41test_onLayoutSublayers_multipleSubclassesFT_T_L_12CustomLayer2"
  }

  func test_onLayoutSublayers_viewLayer() {
    // test view's layer calling layoutSublayers when the view is laid out

    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif
    let layer = view.unsafeLayer

    #if os(macOS)
    expect(getClassName(layer)) == "NSViewBackingLayer"
    expect(getClassName(view)) == "NSView"
    #else
    expect(getClassName(layer)) == "CALayer"
    expect(getClassName(view)) == "UIView"
    #endif

    var callCount = 0
    let token = layer.onLayoutSublayers { _ in
      callCount += 1
    }

    // view and layer (optionally) should be swizzled
    #if os(macOS)
    expect(getClassName(view)) == "ChouTiIMI_NSView"
    expect(getClassName(layer)) == "ChouTiIMI_NSViewBackingLayer"
    #else
    expect(getClassName(view)) == "UIView"
    expect(getClassName(layer)) == "ChouTiIMI_CALayer"
    #endif

    // view's layout cycle should trigger layoutSublayers
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 1

    // second call should also work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 2

    token.cancel()
    #if os(macOS)
    expect(getClassName(view)) == "NSView"
    expect(getClassName(layer)) == "NSViewBackingLayer"
    #else
    expect(getClassName(view)) == "UIView"
    expect(getClassName(layer)) == "CALayer"
    #endif

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount) == 2 // should not call the block again
  }

  func test_onLayoutSublayers_viewLayer_multipleCalls() {
    // test view's layer calling layoutSublayers when the view is laid out

    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif
    let layer = view.unsafeLayer

    #if os(macOS)
    expect(getClassName(layer)) == "NSViewBackingLayer"
    expect(getClassName(view)) == "NSView"
    #else
    expect(getClassName(layer)) == "CALayer"
    expect(getClassName(view)) == "UIView"
    #endif

    // when trigger onLayoutSublayers multiple times
    var callCount1 = 0
    let token1 = layer.onLayoutSublayers { _ in
      callCount1 += 1
    }

    var callCount2 = 0
    let token2 = layer.onLayoutSublayers { _ in
      callCount2 += 1
    }

    // view and layer (optionally) should be swizzled
    #if os(macOS)
    expect(getClassName(view)) == "ChouTiIMI_NSView"
    expect(getClassName(layer)) == "ChouTiIMI_NSViewBackingLayer"
    #else
    expect(getClassName(view)) == "UIView"
    expect(getClassName(layer)) == "ChouTiIMI_CALayer"
    #endif

    // view's layout cycle should trigger layoutSublayers
    // and should only call the block once with multiple onLayoutSublayers calls
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 1
    expect(callCount2) == 1

    // second call should also work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 2
    expect(callCount2) == 2

    token1.cancel()
    token2.cancel()

    #if os(macOS)
    expect(getClassName(view)) == "NSView"
    expect(getClassName(layer)) == "NSViewBackingLayer"
    #else
    expect(getClassName(view)) == "UIView"
    expect(getClassName(layer)) == "CALayer"
    #endif

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 2 // should not call the block again
    expect(callCount2) == 2 // should not call the block again
  }

  func test_onLayoutSublayers_swizzle_then_KVO() {
    // swizzle, KVO, unKVO, unswizzle
    let layer: CALayer = layer

    expect(getClassName(layer)) == "CALayer"

    // add our swizzle
    var layoutCount = 0
    let token = layer.onLayoutSublayers { _ in
      layoutCount += 1
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // add KVO - it should create NSKVONotifying class
    var kvoCallCount = 0
    let observation = layer.observe(\.bounds, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer"

    // both callbacks should work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 1

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel KVO
    observation.invalidate()
    // Note: CALayer KVO doesn't always revert the class immediately
    // expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // cancel our swizzle
    token.cancel()
    // After canceling, class should be back to either CALayer or still NSKVONotifying_ChouTiIMI_CALayer

    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 1 // should not be called
  }

  func test_onLayoutSublayers_swizzle_then_KVO2() {
    // swizzle, KVO, unswizzle, unKVO
    let layer: CALayer = layer

    expect(getClassName(layer)) == "CALayer"

    // add our swizzle
    var layoutCount1 = 0
    let token1 = layer.onLayoutSublayers { _ in
      layoutCount1 += 1
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // add KVO - it should create NSKVONotifying class
    var kvoCallCount = 0
    let observation = layer.observe(\.bounds, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer"

    // both callbacks should work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount1) == 1

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel our swizzle first
    token1.cancel()

    // should stay as NSKVONotifying class
    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer"

    // KVO should still work
    layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvoCallCount) == 2

    // clean up KVO
    observation.invalidate()
    // Note: CALayer KVO doesn't always revert the class immediately
    // expect(getClassName(layer)) == "ChouTiIMI_CALayer" // the class is left with our swizzled class

    // add our swizzle again
    var layoutCount2 = 0
    let token2 = layer.onLayoutSublayers { _ in
      layoutCount2 += 1
    }
    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer"

    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount1) == 1 // should not be called
    expect(layoutCount2) == 1

    // cancel our swizzle again
    token2.cancel()
  }

  func test_onLayoutSublayers_swizzle_then_KVO_then_swizzle() {
    let layer: CALayer = layer

    // add first swizzle callback
    var layoutCount1 = 0
    let token1 = layer.onLayoutSublayers { _ in
      layoutCount1 += 1
    }

    expect(getClassName(layer)) == "ChouTiIMI_CALayer"

    // add KVO
    var kvoCallCount = 0
    let observation = layer.observe(\.bounds, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer"

    // add second swizzle callback
    var layoutCount2 = 0
    let token2 = layer.onLayoutSublayers { _ in
      layoutCount2 += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer" // should still be the same KVO class

    // test all callbacks work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 1

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // remove first layout callback
    token1.cancel()
    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer" // should still be the same KVO class

    // second callback should still work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount1) == 1 // should not be called
    expect(layoutCount2) == 2

    // Remove second layout callback
    token2.cancel()
    expect(getClassName(layer)) == "NSKVONotifying_ChouTiIMI_CALayer" // should still be the same KVO class

    // KVO should still work
    layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvoCallCount) == 2 // should still be called

    // clean up
    observation.invalidate()
    // Note: CALayer KVO doesn't always revert the class predictably
  }

  func test_onLayoutSublayers_KVO_then_swizzle() {
    // KVO, swizzle, unswizzle, unKVO
    let layer: CALayer = layer

    // add KVO first
    var kvoCallCount = 0
    let observation = layer.observe(\.bounds, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_CALayer"

    // add our swizzle
    var layoutCount = 0
    let token = layer.onLayoutSublayers { _ in
      layoutCount += 1
    }

    // class should remain as KVO class
    expect(getClassName(layer)) == "NSKVONotifying_CALayer"

    // both callbacks should work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 1

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel our swizzle
    token.cancel()

    // class should still be KVO class
    expect(getClassName(layer)) == "NSKVONotifying_CALayer"

    // KVO should still work
    layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvoCallCount) == 2 // should still be called

    // layout callback should not be called
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 1 // should not be called

    // clean up KVO
    observation.invalidate()
    // Note: CALayer KVO doesn't always revert the class immediately
  }

  func test_onLayoutSublayers_KVO_then_swizzle2() {
    // KVO, swizzle, unKVO, unswizzle
    let layer: CALayer = layer

    // add KVO first
    var kvoCallCount = 0
    let observation = layer.observe(\.bounds, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_CALayer"

    // add our swizzle
    var layoutCount = 0
    let token = layer.onLayoutSublayers { _ in
      layoutCount += 1
    }

    // class should remain as KVO class
    expect(getClassName(layer)) == "NSKVONotifying_CALayer"

    // both callbacks should work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 1

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel KVO
    observation.invalidate()
    // Note: CALayer KVO doesn't always revert the class immediately

    // cancel our swizzle
    token.cancel()

    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 1 // should not be called
  }

  func test_onLayoutSublayers_KVO_then_swizzle_then_KVO() {
    let layer: CALayer = layer

    // add first KVO
    var kvo1CallCount = 0
    let observation1 = layer.observe(\.bounds, options: [.new]) { _, _ in
      kvo1CallCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_CALayer"

    // add our swizzle
    var layoutCount = 0
    let token = layer.onLayoutSublayers { _ in
      layoutCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_CALayer"

    // add second KVO (should reuse the same KVO class)
    var kvo2CallCount = 0
    let observation2 = layer.observe(\.bounds, options: [.new]) { _, _ in
      kvo2CallCount += 1
    }

    expect(getClassName(layer)) == "NSKVONotifying_CALayer" // should still be the same KVO class

    // test all callbacks work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 1

    layer.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvo1CallCount) == 1
    expect(kvo2CallCount) == 1

    // remove first KVO
    observation1.invalidate()
    expect(getClassName(layer)) == "NSKVONotifying_CALayer" // should still be the same KVO class

    // test all callbacks work
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount) == 2

    // Directly change bounds to ensure KVO fires
    let previousKvo2Count = kvo2CallCount
    layer.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvo1CallCount) == 1 // Not incremented (observation removed)
    expect(kvo2CallCount) > previousKvo2Count // Should increment

    // Clean up
    token.cancel()
    observation2.invalidate()
  }

  func test_onLayoutSublayers_KVO_then_swizzle_unswizzle_then_swizzle() {
    class CustomLayer: CALayer {
      static var callOrders: [Int] = []

      override func layoutSublayers() {
        super.layoutSublayers()
        CustomLayer.callOrders.append(1)
      }
    }

    let layer = CustomLayer()
    layer.bounds.size = CGSize(width: 100, height: 100)

    let customLayerClassName = NSStringFromClass(CustomLayer.self)
    expect(getClassName(layer)) == customLayerClassName

    // add KVO
    let observation = layer.observe(\.bounds, options: [.new]) { _, _ in }
    expect(getClassName(layer)) == "NSKVONotifying_\(customLayerClassName)"

    // add swizzle
    var layoutCount1 = 0
    let token1 = layer.onLayoutSublayers { _ in
      layoutCount1 += 1
    }
    expect(getClassName(layer)) == "NSKVONotifying_\(customLayerClassName)" // the original class method is swizzled, class doesn't change

    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount1) == 1 // should trigger layout callback

    // remove swizzle
    token1.cancel()
    expect(getClassName(layer)) == "NSKVONotifying_\(customLayerClassName)"

    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount1) == 1 // no swizzle, no additional callback

    // add swizzle again
    var layoutCount2 = 0
    _ = layer.onLayoutSublayers { _ in
      layoutCount2 += 1
    }
    expect(getClassName(layer)) == "NSKVONotifying_\(customLayerClassName)"

    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(layoutCount1) == 1 // should not be called
    expect(layoutCount2) == 1 // second swizzle, trigger layout callback

    // remove KVO
    observation.invalidate()
    // Note: CALayer KVO doesn't always revert the class immediately
  }

  func test_onLayoutSublayers_KVO_with_swizzle_together() {
    // test one instance with KVO and swizzle and another instance with swizzle only
    // the second instance should not trigger redundant layout callback
    let layer1 = CALayer()
    layer1.bounds.size = CGSize(width: 100, height: 100)

    // add KVO
    let observation1 = layer1.observe(\.bounds, options: [.new]) { _, _ in }

    var layoutCount1 = 0
    let token1 = layer1.onLayoutSublayers { _ in
      layoutCount1 += 1
    }

    let layer2 = CALayer()
    layer2.bounds.size = CGSize(width: 100, height: 100)

    var layoutCount2 = 0
    let token2 = layer2.onLayoutSublayers { _ in
      layoutCount2 += 1
    }

    layer1.setNeedsLayout()
    layer1.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 0

    layer2.setNeedsLayout()
    layer2.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 1

    // clean up
    observation1.invalidate()
    token1.cancel()
    token2.cancel()
  }

  func test_onLayoutSublayers_KVO_swizzle_dealloc() {
    var layer1: CALayer! = CALayer()
    layer1.bounds.size = CGSize(width: 100, height: 100)

    expect(getClassName(layer1)) == "CALayer"

    // add KVO
    let observation = layer1.observe(\.bounds, options: [.new]) { _, _ in }
    expect(getClassName(layer1)) == "NSKVONotifying_CALayer"

    // add swizzle
    var layoutCount1 = 0
    layer1.onLayoutSublayers { _ in
      layoutCount1 += 1
    }
    expect(getClassName(layer1)) == "NSKVONotifying_CALayer"

    layer1.setNeedsLayout()
    layer1.layoutIfNeeded()
    expect(layoutCount1) == 1

    // deallocate layer, should reset the original class's method implementation
    layer1 = nil

    // create a new layer
    let layer2 = CALayer()
    layer2.bounds.size = CGSize(width: 100, height: 100)

    // add swizzle
    var layoutCount2 = 0
    layer2.onLayoutSublayers { _ in
      layoutCount2 += 1
    }

    // it should trigger layout callback correctly
    layer2.setNeedsLayout()
    layer2.layoutIfNeeded()
    expect(layoutCount2) == 1

    // clean up
    observation.invalidate()
  }

  func test_onLayoutSublayers_duplicatedSwizzleOnSameLayerClass() {
    // when a KVO CALayer is swizzled, it will swizzle the original class's method implementation to call the custom blocks.
    // if another KVO CALayer subclass is created, it will also swizzle the subclass's method implementation to call the custom blocks.
    // this may create duplicated swizzles on the same layer class hierarchy.
    // this test is to ensure that the duplicated swizzles are handled correctly.

    class CustomLayer: CALayer {
      override func layoutSublayers() { // swiftlint:disable:this unneeded_override
        super.layoutSublayers()
      }
    }

    let layer1 = CALayer()
    let layer2 = CustomLayer()

    // add KVO to layer1
    let observation1 = layer1.observe(\.bounds, options: [.new]) { _, _ in }
    _ = observation1

    // add KVO to layer2
    let observation2 = layer2.observe(\.bounds, options: [.new]) { _, _ in }
    _ = observation2

    // add swizzle to layer1
    var layoutCount1 = 0
    let token1 = layer1.onLayoutSublayers { _ in
      layoutCount1 += 1
    }

    // add swizzle to layer2
    var layoutCount2 = 0
    let token2 = layer2.onLayoutSublayers { _ in
      layoutCount2 += 1
    }

    // now both CALayer and CustomLayer's layoutSublayers method are swizzled

    // trigger layout
    layer1.setNeedsLayout()
    layer1.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 0

    layer2.setNeedsLayout()
    layer2.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 1

    // clean up
    observation1.invalidate()
    observation2.invalidate()
    token1.cancel()
    token2.cancel()
    expect(getClassName(layer1)) == "NSKVONotifying_CALayer"
    expect(getClassName(layer2)) == "NSKVONotifying__TtCFC13ChouTiUITests28CALayer_LayoutSublayersTests56test_onLayoutSublayers_duplicatedSwizzleOnSameLayerClassFT_T_L_11CustomLayer"
  }
}
