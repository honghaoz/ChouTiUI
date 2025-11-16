//
//  View+onLayoutSubviewsTests.swift
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

import ChouTiTest

import ChouTi
@testable import ChouTiUI

private let viewClassName: String = {
  #if os(macOS)
  return "NSView"
  #else
  return "UIView"
  #endif
}()

class View_onLayoutSubviewsTests: XCTestCase {

  func test_onLayoutSubviews_singleBlock() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    // initial state
    expect(getClassName(view)) == viewClassName

    // add callback
    var callCount = 0
    var calledView: View?
    weak var token: CancellableToken?
    token = view.onLayoutSubviews { view in
      callCount += 1
      calledView = view
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 1
    expect(calledView) === view

    // trigger again
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 2
    expect(calledView) === view

    // cancel callback
    token?.cancel()
    expect(getClassName(view)) == viewClassName

    // trigger again - should not call the block
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSubviews_multipleBlocks() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    // add callback 1
    var callCount1 = 0
    var calledView1: View?
    weak var token1: CancellableToken?
    token1 = view.onLayoutSubviews { _ in
      callCount1 += 1
      calledView1 = view
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 1
    expect(calledView1) === view

    // add callback 2
    var callCount2 = 0
    var calledView2: View?
    weak var token2: CancellableToken?
    token2 = view.onLayoutSubviews { _ in
      callCount2 += 1
      calledView2 = view
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 2
    expect(calledView1) === view
    expect(callCount2) == 1
    expect(calledView2) === view

    // add callback 3
    var callCount3 = 0
    var calledView3: View?
    weak var token3: CancellableToken?
    token3 = view.onLayoutSubviews { _ in
      callCount3 += 1
      calledView3 = view
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 3
    expect(calledView1) === view
    expect(callCount2) == 2
    expect(calledView2) === view
    expect(callCount3) == 1
    expect(calledView3) === view

    // cancel callback 2
    token2?.cancel()
    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)" // still swizzled because of callbacks 1 and 3

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 4
    expect(callCount2) == 2 // not called
    expect(callCount3) == 2

    // cancel callback 1
    token1?.cancel()
    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)" // still swizzled because of callback 3

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 4 // not called
    expect(callCount2) == 2 // not called
    expect(callCount3) == 3

    // cancel callback 3
    token3?.cancel()
    expect(getClassName(view)) == viewClassName // reverted after all blocks removed

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 4 // not called
    expect(callCount2) == 2 // not called
    expect(callCount3) == 3 // not called
  }

  func test_onLayoutSubviews_executionOrder() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    var executionOrder: [Int] = []

    view.onLayoutSubviews { _ in
      executionOrder.append(1)
    }

    view.onLayoutSubviews { _ in
      executionOrder.append(2)
    }

    view.onLayoutSubviews { _ in
      executionOrder.append(3)
    }

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(executionOrder) == [1, 2, 3]

    executionOrder = []
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(executionOrder) == [1, 2, 3]
  }

  func test_onLayoutSubviews_callSuperFirst() {
    class CustomView: View {

      static var callOrders: [Int] = []

      #if os(macOS)
      override func layout() {
        super.layout()
        CustomView.callOrders.append(1)
      }
      #else
      override func layoutSubviews() {
        super.layoutSubviews()
        CustomView.callOrders.append(1)
      }
      #endif
    }

    let customView = CustomView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    customView.onLayoutSubviews { _ in
      CustomView.callOrders.append(2)
    }

    customView.setNeedsLayout()
    customView.layoutIfNeeded()
    expect(CustomView.callOrders) == [1, 2]
  }

  func test_onLayoutSubviews_calledOnBoundsChange_plainView() {
    // on macOS, NSView won't set `needsLayout` to true when the bounds change, which means the `layout()` method will not be called.
    // on iOS, UIView will set "needs layout" flag to true when the bounds change, which means the `layoutSubviews()` method will be called.
    class CustomView: View {
      #if os(macOS)
      override func layout() { // swiftlint:disable:this unneeded_override
        super.layout()
      }
      #else
      override func layoutSubviews() { // swiftlint:disable:this unneeded_override
        super.layoutSubviews()
      }
      #endif
    }

    let testWindow = TestWindow()

    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    #if os(macOS)
    testWindow.contentView?.addSubview(view)
    #else
    testWindow.rootViewController?.view.addSubview(view)
    #endif

    view.setNeedsLayout()
    view.layoutIfNeeded()

    var callCount = 0
    view.onLayoutSubviews { _ in
      callCount += 1
    }

    view.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    view.layoutIfNeeded()
    expect(callCount) == 1

    view.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
    view.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSubviews_calledOnBoundsChange_customView() {
    // on macOS, NSView won't set `needsLayout` to true when the bounds change, which means the `layout()` method will not be called.
    // on iOS, UIView will set "needs layout" flag to true when the bounds change, which means the `layoutSubviews()` method will be called.
    class CustomView: View {
      #if os(macOS)
      override func layout() { // swiftlint:disable:this unneeded_override
        super.layout()
      }
      #else
      override func layoutSubviews() { // swiftlint:disable:this unneeded_override
        super.layoutSubviews()
      }
      #endif
    }

    let testWindow = TestWindow()

    let view = CustomView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    #if os(macOS)
    testWindow.contentView?.addSubview(view)
    #else
    testWindow.rootViewController?.view.addSubview(view)
    #endif

    view.setNeedsLayout()
    view.layoutIfNeeded()

    var callCount = 0
    view.onLayoutSubviews { _ in
      callCount += 1
    }

    view.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
    view.layoutIfNeeded()
    expect(callCount) == 1

    view.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
    view.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSubviews_calledOnFrameChange_plainView() {
    // on macOS, a custom NSView subclass that overrides layout() will have `needsLayout` set to true when the frame change, then trigger `layout()` to layout the view.
    // however, a plain NSView will not have `needsLayout` set to true when the frame change, which means the `layout()` method will not be called.
    //
    // on iOS, any UIView will have "needs layout" flag set to true when the frame change and trigger `layoutSubviews()` to layout the view.
    let testWindow = TestWindow()

    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    #if os(macOS)
    testWindow.contentView?.addSubview(view)
    #else
    testWindow.rootViewController?.view.addSubview(view)
    #endif

    view.setNeedsLayout()
    view.layoutIfNeeded()

    var callCount = 0
    view.onLayoutSubviews { _ in
      callCount += 1
    }

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    view.layoutIfNeeded()
    expect(callCount) == 1

    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    view.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSubviews_calledOnFrameChange_customView() {
    // on macOS, a custom NSView subclass that overrides layout() will have `needsLayout` set to true when the frame change, then trigger `layout()` to layout the view.
    // however, a plain NSView will not have `needsLayout` set to true when the frame change, which means the `layout()` method will not be called.
    //
    // on iOS, any UIView will have "needs layout" flag set to true when the frame change and trigger `layoutSubviews()` to layout the view.

    class CustomView: View {
      #if os(macOS)
      override func layout() { // swiftlint:disable:this unneeded_override
        super.layout()
      }
      #else
      override func layoutSubviews() { // swiftlint:disable:this unneeded_override
        super.layoutSubviews()
      }
      #endif
    }

    let testWindow = TestWindow()

    let view = CustomView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    #if os(macOS)
    testWindow.contentView?.addSubview(view)
    #else
    testWindow.rootViewController?.view.addSubview(view)
    #endif

    view.setNeedsLayout()
    view.layoutIfNeeded()

    var callCount = 0
    view.onLayoutSubviews { _ in
      callCount += 1
    }

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    view.layoutIfNeeded()
    expect(callCount) == 1

    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    view.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSubviews_subclass() {
    #if os(macOS)
    class CustomView: NSView {
      var customLayoutCalled = false

      override func layout() {
        super.layout()
        customLayoutCalled = true
      }
    }
    #else
    class CustomView: UIView {
      var customLayoutCalled = false

      override func layoutSubviews() {
        super.layoutSubviews()
        customLayoutCalled = true
      }
    }
    #endif

    let customView = CustomView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    customView.wantsLayer = true
    #endif

    var blockCalled = false
    customView.onLayoutSubviews { _ in
      blockCalled = true
    }

    // trigger layout
    customView.setNeedsLayout()
    customView.layoutIfNeeded()

    // both the original layout and the block should be called
    expect(customView.customLayoutCalled) == true
    expect(blockCalled) == true
  }

  func test_onLayoutSubviews_fromBackgroundThread() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    let expectation = XCTestExpectation(description: "")
    let backgroundQueue = DispatchQueue.make(label: "background")

    backgroundQueue.async {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "Should be on main thread. Message: \"\""
        expect(metadata["queue"]) == "background"
        expect(metadata["thread"]) == Thread.current.description
      }
      view.onLayoutSubviews { _ in }
      Assert.resetTestAssertionFailureHandler()

      expectation.fulfill()
    }
  }

  func test_onLayoutSubviews_cancelInBlock() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    var callCount = 0
    var token: CancellableToken?
    token = view.onLayoutSubviews { _ in
      callCount += 1
      token?.cancel()
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 1
    expect(getClassName(view)) == viewClassName

    // trigger again - should not call the block
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 1
  }

  func test_onLayoutSubviews_tokenDeallocated() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    var callCount = 0
    autoreleasepool {
      let token = view.onLayoutSubviews { _ in
        callCount += 1
      }
      _ = token // use token to prevent warning

      expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

      view.setNeedsLayout()
      view.layoutIfNeeded()
      expect(callCount) == 1
    }

    // token is deallocated, but the block should still be there
    // because the token is stored in the layoutSubviewsBlocks dictionary
    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSubviews_sharedSwizzledClass() {
    let view1 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let view2 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    view1.onLayoutSubviews { _ in }
    view2.onLayoutSubviews { _ in }

    expect(getClassName(view1)) == "ChouTiUI_\(viewClassName)"
    expect(getClassName(view2)) == "ChouTiUI_\(viewClassName)"
  }

  func test_onLayoutSubviews_multipleSubclasses() {
    class CustomView1: View {
      var customLayoutCalled = false
    }
    class CustomView2: View {
      var customLayoutCalled = false
    }

    let view1 = CustomView1(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    expect(getClassName(view1)) == "_TtCFC13ChouTiUITests26View_onLayoutSubviewsTests40test_onLayoutSubviews_multipleSubclassesFT_T_L_11CustomView1"
    let view2 = CustomView2(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    expect(getClassName(view2)) == "_TtCFC13ChouTiUITests26View_onLayoutSubviewsTests40test_onLayoutSubviews_multipleSubclassesFT_T_L_11CustomView2"

    view1.onLayoutSubviews { _ in }
    view2.onLayoutSubviews { _ in }

    // each subclass should have its own swizzled class
    expect(getClassName(view1)) == "ChouTiUI__TtCFC13ChouTiUITests26View_onLayoutSubviewsTests40test_onLayoutSubviews_multipleSubclassesFT_T_L_11CustomView1"
    expect(getClassName(view2)) == "ChouTiUI__TtCFC13ChouTiUITests26View_onLayoutSubviewsTests40test_onLayoutSubviews_multipleSubclassesFT_T_L_11CustomView2"
  }

  // MARK: - KVO Interaction Tests

  func test_onLayoutSubviews_swizzle_then_KVO() {
    // swizzle, KVO, unKVO, unswizzle
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    expect(getClassName(view)) == viewClassName

    // add our swizzle
    var layoutCount = 0
    let token = view.onLayoutSubviews { _ in
      layoutCount += 1
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // add KVO - it should create NSKVONotifying class
    var kvoCallCount = 0
    let observation = view.observe(\.frame, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_ChouTiUI_\(viewClassName)"

    // both callbacks should work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 1

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel KVO
    observation.invalidate()
    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // cancel our swizzle
    token.cancel()
    expect(getClassName(view)) == viewClassName // the class is reverted to the original class

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 1 // should not be called
  }

  func test_onLayoutSubviews_swizzle_then_KVO2() {
    // swizzle, KVO, unswizzle, unKVO
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    expect(getClassName(view)) == viewClassName

    // add our swizzle
    var layoutCount1 = 0
    let token1 = view.onLayoutSubviews { _ in
      layoutCount1 += 1
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // add KVO - it should create NSKVONotifying class
    var kvoCallCount = 0
    let observation = view.observe(\.frame, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_ChouTiUI_\(viewClassName)"

    // both callbacks should work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount1) == 1

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel our swizzle first
    token1.cancel()

    // should stay as NSKVONotifying class
    expect(getClassName(view)) == "NSKVONotifying_ChouTiUI_\(viewClassName)"

    // KVO should still work
    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvoCallCount) == 2

    // clean up KVO
    observation.invalidate()
    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)" // the class is left with our swizzled class

    // add our swizzle again
    var layoutCount2 = 0
    let token2 = view.onLayoutSubviews { _ in
      layoutCount2 += 1
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount1) == 1 // should not be called
    expect(layoutCount2) == 1

    // cancel our swizzle again
    token2.cancel()
    expect(getClassName(view)) == viewClassName // the class is reverted to the original class
  }

  func test_onLayoutSubviews_swizzle_then_KVO_then_swizzle() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    // add first swizzle callback
    var layoutCount1 = 0
    let token1 = view.onLayoutSubviews { _ in
      layoutCount1 += 1
    }

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"

    // add KVO
    var kvoCallCount = 0
    let observation = view.observe(\.frame, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_ChouTiUI_\(viewClassName)"

    // add second swizzle callback
    var layoutCount2 = 0
    let token2 = view.onLayoutSubviews { _ in
      layoutCount2 += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_ChouTiUI_\(viewClassName)" // should still be the same KVO class

    // test all callbacks work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 1

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // remove first layout callback
    token1.cancel()
    expect(getClassName(view)) == "NSKVONotifying_ChouTiUI_\(viewClassName)" // should still be the same KVO class

    // second callback should still work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount1) == 1 // should not be called
    expect(layoutCount2) == 2

    // Remove second layout callback
    token2.cancel()
    expect(getClassName(view)) == "NSKVONotifying_ChouTiUI_\(viewClassName)" // should still be the same KVO class

    // KVO should still work
    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvoCallCount) == 2 // should still be called

    // clean up
    observation.invalidate()

    expect(getClassName(view)) == "ChouTiUI_\(viewClassName)"
  }

  func test_onLayoutSubviews_KVO_then_swizzle() {
    // KVO, swizzle, unswizzle, unKVO
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    // add KVO first
    var kvoCallCount = 0
    let observation = view.observe(\.frame, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)"

    // add our swizzle
    var layoutCount = 0
    let token = view.onLayoutSubviews { _ in
      layoutCount += 1
    }

    // class should remain as KVO class
    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)"

    // both callbacks should work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 1

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel our swizzle
    token.cancel()

    // class should still be KVO class
    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)"

    // KVO should still work
    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvoCallCount) == 2 // should still be called

    // layout callback should not be called
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 1 // should not be called

    // clean up KVO
    observation.invalidate()
    expect(getClassName(view)) == viewClassName // the class is reverted to the original class
  }

  func test_onLayoutSubviews_KVO_then_swizzle2() {
    // KVO, swizzle, unKVO, unswizzle
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    // add KVO first
    var kvoCallCount = 0
    let observation = view.observe(\.frame, options: [.new]) { _, _ in
      kvoCallCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)"

    // add our swizzle
    var layoutCount = 0
    let token = view.onLayoutSubviews { _ in
      layoutCount += 1
    }

    // class should remain as KVO class
    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)"

    // both callbacks should work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 1

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvoCallCount) == 1

    // cancel KVO
    observation.invalidate()
    expect(getClassName(view)) == viewClassName // the class is reverted to the original class

    // cancel our swizzle
    token.cancel()
    expect(getClassName(view)) == viewClassName

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 1 // should not be called
  }

  func test_onLayoutSubviews_KVO_then_swizzle_then_KVO() {
    let view = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view.wantsLayer = true
    #endif

    // add first KVO
    var kvo1CallCount = 0
    let observation1 = view.observe(\.frame, options: [.new]) { _, _ in
      kvo1CallCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)"

    // add our swizzle
    var layoutCount = 0
    let token = view.onLayoutSubviews { _ in
      layoutCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)"

    // add second KVO (should reuse the same KVO class)
    var kvo2CallCount = 0
    let observation2 = view.observe(\.frame, options: [.new]) { _, _ in
      kvo2CallCount += 1
    }

    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)" // should still be the same KVO class

    // test all callbacks work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 1

    view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    expect(kvo1CallCount) == 1
    expect(kvo2CallCount) == 1

    // remove first KVO
    observation1.invalidate()
    expect(getClassName(view)) == "NSKVONotifying_\(viewClassName)" // should still be the same KVO class

    // test all callbacks work
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount) == 2

    // Directly change bounds to ensure KVO fires
    let previousKvo2Count = kvo2CallCount
    view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    expect(kvo1CallCount) == 1 // Not incremented (observation removed)
    expect(kvo2CallCount) > previousKvo2Count // Should increment

    // Clean up
    token.cancel()
    observation2.invalidate()
  }

//  func test_onLayoutSubviews_kvoMethodRestoration() {
//    // This test verifies that when KVO is active and we add callbacks, the original method
//    // is restored when all callbacks are removed
//
//    let view1 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//    let view2 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  // #if os(macOS)
//    view1.wantsLayer = true
//    view2.wantsLayer = true
  // #endif
//
//    // Add KVO to view1
//    var observations: [NSKeyValueObservation] = []
//    let observation1 = view1.observe(\.frame, options: [.new]) { _, _ in }
//    observations.append(observation1)
//
//    let kvoClassName1 = getClassName(view1)
//    expect(kvoClassName1.hasPrefix("NSKVONotifying_") || kvoClassName1.hasPrefix("..NSKVONotifying_")) == true
//
//    // Add KVO to view2
//    let observation2 = view2.observe(\.frame, options: [.new]) { _, _ in }
//    observations.append(observation2)
//
//    // Add callbacks to both views
//    var callCount1 = 0
//    var callCount2 = 0
//
//    let token1 = view1.onLayoutSubviews { _ in
//      callCount1 += 1
//    }
//
//    let token2 = view2.onLayoutSubviews { _ in
//      callCount2 += 1
//    }
//
//    // Trigger layout
//    view1.setNeedsLayout()
//    view1.layoutIfNeeded()
//    expect(callCount1) == 1
//
//    view2.setNeedsLayout()
//    view2.layoutIfNeeded()
//    expect(callCount2) == 1
//
//    // Remove callback from view1 (but view2 still has callback)
//    token1.cancel()
//
//    // view2 should still work
//    view2.setNeedsLayout()
//    view2.layoutIfNeeded()
//    expect(callCount2) == 2
//
//    // Remove callback from view2 (now all callbacks are gone)
//    token2.cancel()
//
//    // At this point, the original method should be restored
//    // We can't directly test if the method is restored, but we can verify
//    // that new views of the same class don't execute callbacks
//    let view3 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
  // #if os(macOS)
//    view3.wantsLayer = true
  // #endif
//
//    var callCount3 = 0
//    let shouldNotBeCalled: (View) -> Void = { _ in
//      callCount3 += 1
//    }
//
//    // Trigger layout on view3 WITHOUT adding a callback
//    // If the method wasn't restored, this might still execute callbacks (which would be wrong)
//    view3.setNeedsLayout()
//    view3.layoutIfNeeded()
//    expect(callCount3) == 0  // Should be 0 because we didn't add a callback
//
//    // Clean up
//    observations.removeAll()
//  }

//  func test_composeView() {
//    let testWindow = TestWindow()
//    let composeView = ComposeView {
//      ColorNode(.red)
//    }
//    composeView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//
//    testWindow.contentView?.addSubview(composeView)
//    composeView.setNeedsLayout()
//    composeView.layoutIfNeeded()
//    composeView.refresh()
//
//    var callCount = 0
//    composeView.onLayoutSubviews { _ in
//      callCount += 1
//    }
//
//    composeView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//    composeView.layoutIfNeeded()
//    expect(callCount) == 1
//  }

  func test_onLayoutSubviews_KVO_then_swizzle_unswizzle_then_swizzle() {
    class CustomView: View {

      static var callOrders: [Int] = []

      #if os(macOS)
      override func layout() {
        super.layout()
        CustomView.callOrders.append(1)
      }
      #else
      override func layoutSubviews() {
        super.layoutSubviews()
        CustomView.callOrders.append(1)
      }
      #endif
    }

    let view = CustomView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    #if os(macOS)
    view.wantsLayer = true
    #endif

    let customViewClassName = NSStringFromClass(CustomView.self)
    expect(getClassName(view)) == customViewClassName

    // add KVO
    let observation = view.observe(\.frame, options: [.new]) { _, _ in }
    expect(getClassName(view)) == "NSKVONotifying_\(customViewClassName)"

    // add swizzle
    var layoutCount1 = 0
    let token1 = view.onLayoutSubviews { _ in
      layoutCount1 += 1
    }
    expect(getClassName(view)) == "NSKVONotifying_\(customViewClassName)" // the original class method is swizzled, class doesn't change

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount1) == 1 // should trigger layout callback

    // remove swizzle
    token1.cancel()
    expect(getClassName(view)) == "NSKVONotifying_\(customViewClassName)"

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount1) == 1 // no swizzle, no callback

    // add swizzle again
    var layoutCount2 = 0
    _ = view.onLayoutSubviews { _ in
      layoutCount2 += 1
    }
    expect(getClassName(view)) == "NSKVONotifying_\(customViewClassName)"

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(layoutCount1) == 1 // should not be called
    expect(layoutCount2) == 1 // second swizzle, trigger layout callback

    // remove KVO
    observation.invalidate()
    expect(getClassName(view)) == customViewClassName // the class is reverted to the original class
  }

  func test_onLayoutSubviews_KVO_with_swizzle_together() {
    // test one instance with KVO and swizzle and another instance with swizzle only
    // the second instance should not trigger redundant layout callback
    let view1 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view1.wantsLayer = true
    #endif

    // add KVO
    let observation1 = view1.observe(\.frame, options: [.new]) { _, _ in }

    var layoutCount1 = 0
    let token1 = view1.onLayoutSubviews { _ in
      layoutCount1 += 1
    }

    let view2 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view2.wantsLayer = true
    #endif

    var layoutCount2 = 0
    let token2 = view2.onLayoutSubviews { _ in
      layoutCount2 += 1
    }

    view1.setNeedsLayout()
    view1.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 0

    view2.setNeedsLayout()
    view2.layoutIfNeeded()
    expect(layoutCount1) == 1
    expect(layoutCount2) == 1

    // clean up
    observation1.invalidate()
    token1.cancel()
    token2.cancel()
  }

  func test_onLayoutSubviews_KVO_swizzle_dealloc() {
    var view1: View! = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view1?.wantsLayer = true
    #endif

    expect(getClassName(view1)) == viewClassName

    // add KVO
    let observation = view1.observe(\.frame, options: [.new]) { _, _ in }
    expect(getClassName(view1)) == "NSKVONotifying_\(viewClassName)"

    // add swizzle
    var layoutCount1 = 0
    view1.onLayoutSubviews { _ in
      layoutCount1 += 1
    }
    expect(getClassName(view1)) == "NSKVONotifying_\(viewClassName)"

    view1.setNeedsLayout()
    view1.layoutIfNeeded()
    expect(layoutCount1) == 1

    // deallocate view, should reset the original class's method implementation
    view1 = nil

    // create a new view
    let view2 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    #if os(macOS)
    view2.wantsLayer = true
    #endif

    // add swizzle
    var layoutCount2 = 0
    view2.onLayoutSubviews { _ in
      layoutCount2 += 1
    }

    // it should trigger layout callback correctly
    view2.setNeedsLayout()
    view2.layoutIfNeeded()
    expect(layoutCount2) == 1

    // clean up
    observation.invalidate()
  }
}
