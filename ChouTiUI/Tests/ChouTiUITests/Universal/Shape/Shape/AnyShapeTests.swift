//
//  AnyShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/1/24.
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

class AnyShapeTests: XCTestCase {

  func test_redundantWrapping() {
    let shape = Rectangle()
    let wrapped1 = AnyShape(shape)
    let wrapped2 = AnyShape(wrapped1)

    expect(wrapped1.wrapped is Rectangle) == true
    expect(wrapped1.wrapped is AnyShape) == false
    expect(wrapped2.wrapped is Rectangle) == true
    expect(wrapped2.wrapped is AnyShape) == false
  }

  func test_path() {
    let frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    expect(Circle().path(in: frame)) == Circle().eraseToAnyShape().path(in: frame)
    expect(Rectangle(cornerRadius: 8).path(in: frame)) == Rectangle(cornerRadius: 8).eraseToAnyShape().path(in: frame)
  }

  func test_Equatable() {
    expect(AnyShape(Circle())) == AnyShape(Circle())
    expect(AnyShape(Circle())) != AnyShape(Rectangle())
    expect(AnyShape(Circle()).isEqual(to: Circle())) == true
  }

  func test_Hashable() {
    expect(Circle().hashValue) != Rectangle().hashValue
    expect(AnyShape(Circle()).hashValue) == AnyShape(Circle()).hashValue
    expect(AnyShape(Circle()).hashValue) != AnyShape(Rectangle()).hashValue

    let shape = Circle()
    let anyShape = AnyShape(shape)
    expect(anyShape.hashValue) == shape.hashValue
    expect(anyShape.hashValue) == anyShape.hashValue
    expect(anyShape) == anyShape

    let anyShape2 = AnyShape(anyShape)
    expect(anyShape.hashValue) == anyShape2.hashValue
    expect(anyShape) == anyShape2

    let anyShape3 = anyShape2.eraseToAnyShape()
    expect(anyShape.hashValue) == anyShape3.hashValue
    expect(anyShape) == anyShape3
  }
}
