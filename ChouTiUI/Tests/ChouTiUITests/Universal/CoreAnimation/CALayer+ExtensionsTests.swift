//
//  CALayer+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/6/24.
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

import ChouTiUI

class CALayer_ExtensionsTests: XCTestCase {

  func test_init_frame() {
    let layer = CALayer(frame: CGRect(x: 10, y: 20, width: 100, height: 100))
    expect(layer.frame) == CGRect(x: 10, y: 20, width: 100, height: 100)
  }

  func test_backedView() {
    #if os(macOS)
    do {
      expect(CALayer().backedView) == nil
    }

    // layer-backed view
    do {
      let view = View()
      view.wantsLayer = true
      expect(view.unsafeLayer.backedView) === view
    }
    #else
    let view = View()
    expect(view.layer.backedView) === view
    #endif
  }

  func test_presentingView() {
    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif

    expect(view.unsafeLayer.presentingView) === view

    let sublayer = CALayer()
    expect(sublayer.presentingView) == nil

    view.unsafeLayer.addSublayer(sublayer)
    expect(sublayer.presentingView) === view

    let subSublayer = CALayer()
    sublayer.addSublayer(subSublayer)
    expect(subSublayer.presentingView) === view
  }

  func test_borderOffset() {
    let layer = CALayer()

    // default value
    expect(layer.borderOffset) == 0
    expect(layer.value(forKey: "borderOffset") as? CGFloat) == 0

    // set value
    layer.borderOffset = 10
    expect(layer.borderOffset) == 10
    expect(layer.value(forKey: "borderOffset") as? CGFloat) == 10

    layer.setValue(20, forKey: "borderOffset")
    expect(layer.borderOffset) == 20
    expect(layer.value(forKey: "borderOffset") as? CGFloat) == 20
  }

  func test_strongDelegate() {
    class Delegate: NSObject, CALayerDelegate {

      let onDeallocate: () -> Void

      init(onDeallocate: @escaping () -> Void) {
        self.onDeallocate = onDeallocate
      }

      deinit {
        onDeallocate()
      }

      func display(_ layer: CALayer) {
        // Do nothing
      }
    }

    let layer = CALayer()

    var isDeallocated = false
    layer.strongDelegate = Delegate(onDeallocate: {
      isDeallocated = true
    })
    weak var weakDelegate: (any CALayerDelegate)? = layer.strongDelegate

    expect(layer.strongDelegate) === weakDelegate
    expect(layer.delegate) === weakDelegate
    expect(isDeallocated) == false

    layer.strongDelegate = nil
    expect(layer.strongDelegate) == nil
    expect(layer.delegate) == nil
    expect(isDeallocated) == true
  }
}
