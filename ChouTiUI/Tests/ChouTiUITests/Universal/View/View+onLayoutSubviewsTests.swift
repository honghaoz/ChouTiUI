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

    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"

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

    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"

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

    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"

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
    
    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"

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
    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews" // still swizzled because of callbacks 1 and 3

    // trigger layout
    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount1) == 4
    expect(callCount2) == 2 // not called
    expect(callCount3) == 2

    // cancel callback 1
    token1?.cancel()
    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews" // still swizzled because of callback 3

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
      override func layout() {
        super.layout()
      }
      #else
      override func layoutSubviews() {
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
      override func layout() {
        super.layout()
      }
      #else
      override func layoutSubviews() {
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
      override func layout() {
        super.layout()
      }
      #else
      override func layoutSubviews() {
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

    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"

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

      expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"

      view.setNeedsLayout()
      view.layoutIfNeeded()
      expect(callCount) == 1
    }

    // token is deallocated, but the block should still be there
    // because the token is stored in the layoutSubviewsBlocks dictionary
    expect(getClassName(view)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"

    view.setNeedsLayout()
    view.layoutIfNeeded()
    expect(callCount) == 2
  }

  func test_onLayoutSubviews_sharedSwizzledClass() {
    let view1 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let view2 = View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    view1.onLayoutSubviews { _ in }
    view2.onLayoutSubviews { _ in }

    expect(getClassName(view1)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"
    expect(getClassName(view2)) == "\(viewClassName)_ChouTiUI_LayoutSubviews"
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
    expect(getClassName(view1)) == "_TtCFC13ChouTiUITests26View_onLayoutSubviewsTests40test_onLayoutSubviews_multipleSubclassesFT_T_L_11CustomView1_ChouTiUI_LayoutSubviews"
    expect(getClassName(view2)) == "_TtCFC13ChouTiUITests26View_onLayoutSubviewsTests40test_onLayoutSubviews_multipleSubclassesFT_T_L_11CustomView2_ChouTiUI_LayoutSubviews"
  }
}
