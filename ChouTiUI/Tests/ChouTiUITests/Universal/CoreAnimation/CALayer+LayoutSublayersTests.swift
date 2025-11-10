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

    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"

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

    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"

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

    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"

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

    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"

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
    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers" // still swizzled because of callbacks 1 and 3

    // trigger layoutSublayers
    layer.setNeedsLayout()
    layer.layoutIfNeeded()
    expect(callCount1) == 4
    expect(callCount2) == 2 // not called
    expect(callCount3) == 2

    // cancel callback 1
    token1?.cancel()
    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers" // still swizzled because of callback 3

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

    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"

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

      expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"

      layer.setNeedsLayout()
      layer.layoutIfNeeded()
      expect(callCount) == 1
    }

    // token is deallocated, but the block should still be there
    // because the token is stored in the layoutSublayersBlocks dictionary
    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"

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
    expect(getClassName(layer1)) == "CALayer_ChouTiUI_LayoutSublayers"
    expect(getClassName(layer2)) == "CALayer_ChouTiUI_LayoutSublayers"
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
    expect(getClassName(layer1)) == "_TtCFC13ChouTiUITests28CALayer_LayoutSublayersTests41test_onLayoutSublayers_multipleSubclassesFT_T_L_12CustomLayer1_ChouTiUI_LayoutSublayers"
    expect(getClassName(layer2)) == "_TtCFC13ChouTiUITests28CALayer_LayoutSublayersTests41test_onLayoutSublayers_multipleSubclassesFT_T_L_12CustomLayer2_ChouTiUI_LayoutSublayers"
  }

  func test_onLayoutSublayers_viewLayer() {
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
    expect(getClassName(view)) == "NSView_ChouTiUI_LayoutSubviews"
    expect(getClassName(layer)) == "NSViewBackingLayer_ChouTiUI_LayoutSublayers"
    #else
    expect(getClassName(view)) == "UIView"
    expect(getClassName(layer)) == "CALayer_ChouTiUI_LayoutSublayers"
    #endif

    // view's layout cycle should trigger layoutSublayers
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 1
    
    // Second call should also work
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
}
