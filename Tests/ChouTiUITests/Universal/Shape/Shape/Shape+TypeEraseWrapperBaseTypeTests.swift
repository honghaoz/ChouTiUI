//
//  Shape+TypeEraseWrapperBaseTypeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/5/24.
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

import XCTest
import ChouTiTest

import ChouTiUI

class Shape_TypeEraseWrapperBaseTypeTests: XCTestCase {

//  func test_nonOffsetableShape_casting() {
//    let shape = Symbol.Help()
//    expect(shape.as(Symbol.Help.self)) != nil
//    expect(shape.as((any Shape).self)) != nil
//    expect(shape.as((any OffsetableShape).self)) == nil
//
//    let anyShape: any Shape = AnyShape(shape)
//    expect(anyShape as? Symbol.Help) == nil // can't cast
//    expect(anyShape.as(Symbol.Help.self)) != nil // can cast
//    expect(anyShape.as((any OffsetableShape).self)) == nil
//  }

  func test_offsetableShape_casting() {
    let shape = Rectangle()
    expect(shape.as(Rectangle.self)) != nil
    expect(shape.as((any Shape).self)) != nil
    expect(shape.as((any OffsetableShape).self)) != nil

    let anyShape: any Shape = AnyShape(shape)
    expect(anyShape as? Rectangle) == nil // can't cast
    expect(anyShape.as(Rectangle.self)) != nil // can cast
    expect(anyShape.as((any OffsetableShape).self)) != nil // can cast

    let anyOffsetableShape: any OffsetableShape = AnyOffsetableShape(shape)
    expect(anyOffsetableShape as? Rectangle) == nil // can't cast
    expect(anyOffsetableShape.as(Rectangle.self)) != nil // can cast
    expect(anyOffsetableShape.as((any OffsetableShape).self)) != nil // can cast
  }

//  func test_nonOffsetableShape_is() {
//    let shape = Symbol.Help()
//    expect(shape.is(Symbol.Help.self)) == true
//    expect(shape.is((any Shape).self)) == true
//    expect(shape.is((any OffsetableShape).self)) == false
//
//    let anyShape: any Shape = AnyShape(shape)
//    expect(anyShape.is(Symbol.Help.self)) == true
//    expect(anyShape.is((any OffsetableShape).self)) == false
//  }

  func test_offsetableShape_is() {
    let shape = Rectangle()
    expect(shape.is(Rectangle.self)) == true
    expect(shape.is((any Shape).self)) == true
    expect(shape.is((any OffsetableShape).self)) == true

    let anyShape: any Shape = AnyShape(shape)
    expect(anyShape.is(Rectangle.self)) == true
    expect(anyShape.is((any OffsetableShape).self)) == true

    let anyOffsetableShape: any OffsetableShape = AnyOffsetableShape(shape)
    expect(anyOffsetableShape.is(Rectangle.self)) == true
    expect(anyOffsetableShape.is((any OffsetableShape).self)) == true
  }
}
