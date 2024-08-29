//
//  View+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 10/18/20.
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

class View_ExtensionsTests: XCTestCase {

  func testMakeFullSizeInSuperView() {
    // when has superview
    do {
      let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      let containerView = View(frame: frame)

      let view = View(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
      containerView.addSubview(view)

      view.makeFullSizeInSuperView()
      expect(view.frame) == containerView.bounds
      expect(view.autoresizingMask) == [.flexibleWidth, .flexibleHeight]

      // when container view changes size
      containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
      expect(view.frame) == containerView.bounds
    }

    // when there's no superview
    do {
      let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      let view = View(frame: frame)

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "missing superview"
      }

      view.makeFullSizeInSuperView()
      expect(view.frame) == frame
      expect(view.autoresizingMask) == []

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func testMakeFullWidthAndPinToTopInSuperView() {
    // when has superview
    do {
      let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      let containerView = View(frame: frame)

      let view = View(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
      containerView.addSubview(view)

      view.makeFullWidthAndPinToTopInSuperView(fixedHeight: 30)
      expect(view.frame) == CGRect(x: 0, y: 0, width: 100, height: 30)
      expect(view.autoresizingMask) == [.flexibleWidth, .flexibleBottomMargin]

      // when container view changes size
      containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
      expect(view.frame) == CGRect(x: 0, y: 0, width: 200, height: 30)
      expect(view.autoresizingMask) == [.flexibleWidth, .flexibleBottomMargin]
    }

    // when there's no superview
    do {
      let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      let view = View(frame: frame)

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "missing superview"
      }

      view.makeFullWidthAndPinToTopInSuperView(fixedHeight: 30)
      expect(view.frame) == frame
      expect(view.autoresizingMask) == []

      Assert.resetTestAssertionFailureHandler()
    }
  }
}