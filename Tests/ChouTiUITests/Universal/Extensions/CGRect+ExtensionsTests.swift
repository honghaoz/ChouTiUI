//
//  CGRect+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/9/24.
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

class CGRect_ExtensionsTests: XCTestCase {

  func test_inset() {
    let rect = CGRect(0, 0, 100, 100)
    let insets = EdgeInsets(10, 20, 30, 40)
    let expected = CGRect(20, 10, 40, 60)
    expect(rect.inset(by: insets)) == expected
  }

  func test_expanded() {
    let rect = CGRect(0, 0, 100, 100)
    let insets = EdgeInsets(10, 20, 30, 40)
    let expected = CGRect(-20, -10, 160, 140)
    expect(rect.expanded(by: insets)) == expected
  }
}
