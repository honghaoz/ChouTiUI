//
//  RectCorner+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/15/24.
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

import QuartzCore

import ChouTiTest

import ChouTiUI

class RectCorner_ExtensionsTests: XCTestCase {

  func test_static() {
    expect(RectCorner.none) == []
    expect(RectCorner.all) == [.topLeft, .topRight, .bottomLeft, .bottomRight]
  }

  func test_init() {
    expect(RectCorner(cornerMask: [])) == []
    expect(RectCorner(cornerMask: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner])) == [.topLeft, .topRight, .bottomLeft, .bottomRight]
  }

  func test_cornerMask() {
    expect(RectCorner.topLeft.cornerMask) == CACornerMask.layerMinXMinYCorner
    expect(RectCorner.topRight.cornerMask) == CACornerMask.layerMaxXMinYCorner
    expect(RectCorner.bottomLeft.cornerMask) == CACornerMask.layerMinXMaxYCorner
    expect(RectCorner.bottomRight.cornerMask) == CACornerMask.layerMaxXMaxYCorner
  }
}
