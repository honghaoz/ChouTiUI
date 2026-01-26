//
//  BorderMetalLayerTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/14/25.
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
import ChouTiUI

class BorderMetalLayerTests: XCTestCase {

  func test_updateBorder() {
    let borderLayer = BorderMetalLayer()
    borderLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    borderLayer.updateBorder(width: 2, content: .color(.red), shape: Circle(), bounds: borderLayer.bounds, scale: 2)
    expect(borderLayer.contents) != nil
  }

  func test_updateBorder_withDefaultBoundsAndScale() {
    let borderLayer = BorderMetalLayer()
    borderLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    borderLayer.contentsScale = 2

    // call without bounds and scale, should use self.bounds and contentsScale
    borderLayer.updateBorder(width: 2, content: .color(.red), shape: Circle())
    expect(borderLayer.contents) != nil
  }

  func test_updateBorder_noDrawable() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "Failed to get drawable or command buffer"
    }

    let borderLayer = BorderMetalLayer()
    borderLayer.updateBorder(width: 2, content: .color(.red), shape: Circle(), bounds: CGRect(x: 0, y: 0, width: 100, height: 50), scale: 2)
    expect(borderLayer.contents) != nil

    Assert.resetTestAssertionFailureHandler()
  }
}
