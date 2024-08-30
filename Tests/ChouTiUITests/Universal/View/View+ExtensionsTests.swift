//
//  View+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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
