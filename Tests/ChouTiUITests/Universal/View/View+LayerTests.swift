//
//  View+LayerTests.swift
//
//  Created by Honghao Zhang on 1/6/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest
import ChouTiUI
import ChouTi

class View_LayerTests: XCTestCase {

  func test_layer() {
    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif
    expect(view.layer()) != nil
  }

  func test_unsafeLayer() {
    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif
    expect(view.unsafeLayer) != nil
  }

  #if os(macOS)
  func test_notLayerBacked() {
    let view = NSView()

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "NSView should set `wantsLayer == true`."
    }

    expect(view.layer()) == nil

    Assert.resetTestAssertionFailureHandler()
  }
  #endif
}
