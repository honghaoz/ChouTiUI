//
//  PathBlockShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/23/24.
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

import CoreGraphics

import ChouTiTest

import ChouTiUI

final class PathBlockShapeTests: XCTestCase {

  func test_path() {
    let shape = PathBlockShape(.key("100") { rect in
      CGPath(rect: rect, transform: nil)
    })

    expect(shape.path(in: CGRect(0, 0, 100, 100))) == CGPath(rect: CGRect(0, 0, 100, 100), transform: nil)
  }

  func test_equal() {
    let shape1 = PathBlockShape(.key("100") { rect in
      CGPath(rect: rect, transform: nil)
    })
    let shape2 = PathBlockShape(.key("100") { rect in
      CGPath(rect: rect, transform: nil)
    })
    let shape3 = PathBlockShape(.key("200") { rect in
      CGPath(rect: rect, transform: nil)
    })
    let shape4 = PathBlockShape(.key(123) { rect in
      CGPath(rect: rect, transform: nil)
    })

    expect(shape1) == shape2
    expect(shape1) != shape3
    expect(shape1) != shape4
  }
}
