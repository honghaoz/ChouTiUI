//
//  BaseNSTextFieldCellTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/9/23.
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
import ChouTi
@testable import ChouTiUI
import ChouTiTest

class BaseNSTextFieldCellTests: XCTestCase {

  func testInit() {
    let cell = BaseNSTextFieldCell()
    expect(cell.horizontalPadding) == 0
    expect(cell.verticalAlignment) == .center
  }

  func testAdjustRect() {
    let cell = BaseNSTextFieldCell()
    cell.stringValue = "hello world"
    cell.font = NSFont.systemFont(ofSize: 32)
    let boundingRect = NSRect(x: 0, y: 0, width: 100, height: 100)

    // when vertical alignment is center
    do {
      let drawingRect = cell.drawingRect(forBounds: boundingRect)
      expect(drawingRect) == CGRect(0.0, 12.0, 100.0, 76.0)
    }

    // when vertical alignment is top
    do {
      cell.verticalAlignment = .top
      let drawingRect = cell.drawingRect(forBounds: boundingRect)
      expect(drawingRect) == CGRect(0.0, 0.0, 100.0, 100) // hmm, why this has height 100?
    }

    // when vertical alignment is bottom
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "unsupported bottom alignment"
      }

      cell.verticalAlignment = .bottom
      let drawingRect = cell.drawingRect(forBounds: boundingRect)
      expect(drawingRect) == CGRect(0.0, 0.0, 100.0, 100)

      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_calls() {
    let cell = BaseNSTextFieldCell()
    cell.stringValue = "hello world"
    cell.font = NSFont.systemFont(ofSize: 32)
    let boundingRect = NSRect(x: 0, y: 0, width: 100, height: 100)

    cell.draw(withFrame: boundingRect, in: NSView())
    cell.drawInterior(withFrame: boundingRect, in: NSView())

    cell.edit(withFrame: boundingRect, in: NSView(), editor: NSText(), delegate: nil, event: nil)
    cell.select(withFrame: boundingRect, in: NSView(), editor: NSText(), delegate: nil, start: 0, length: 0)
  }
}

#endif
