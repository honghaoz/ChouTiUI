//
//  Layout.Alignment+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/18/22.
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

import ChouTiUI

class Layout_Alignment_ExtensionsTests: XCTestCase {

  func test_verticallyFlipped() {
    expect(Layout.Alignment.center.verticallyFlipped()) == Layout.Alignment.center
    expect(Layout.Alignment.left.verticallyFlipped()) == Layout.Alignment.left
    expect(Layout.Alignment.right.verticallyFlipped()) == Layout.Alignment.right
    expect(Layout.Alignment.top.verticallyFlipped()) == Layout.Alignment.bottom
    expect(Layout.Alignment.bottom.verticallyFlipped()) == Layout.Alignment.top
    expect(Layout.Alignment.topLeft.verticallyFlipped()) == Layout.Alignment.bottomLeft
    expect(Layout.Alignment.topRight.verticallyFlipped()) == Layout.Alignment.bottomRight
    expect(Layout.Alignment.bottomLeft.verticallyFlipped()) == Layout.Alignment.topLeft
    expect(Layout.Alignment.bottomRight.verticallyFlipped()) == Layout.Alignment.topRight
  }
}
