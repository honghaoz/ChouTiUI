//
//  CASpringAnimation+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/1/25.
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

import QuartzCore

import ChouTiTest

import ChouTiUI
@_spi(Private) import ComposeUI

class CASpringAnimation_ExtensionsTests: XCTestCase {

  func test_solveForInput() throws {
    let springAnimation = try (CABasicAnimation.makeAnimation(.spring(dampingRatio: 1, response: 1)) as? CASpringAnimation).unwrap()
    try expect(springAnimation.solveForInput(0.0).unwrap()) == 0
    try expect(springAnimation.solveForInput(0.25).unwrap()) == 0.56196046
    try expect(springAnimation.solveForInput(0.5).unwrap()) == 0.89003396
    try expect(springAnimation.solveForInput(0.75).unwrap()) == 0.976705
    try expect(springAnimation.solveForInput(1.0).unwrap()) == 0.99546117
  }

  func test_durationForEpsilon() throws {
    let springAnimation = try (CABasicAnimation.makeAnimation(.spring(dampingRatio: 1, response: 1)) as? CASpringAnimation).unwrap()
    try expect(springAnimation.durationForEpsilon(0.01).unwrap()) == 1.0999999999999999
    try expect(springAnimation.durationForEpsilon(0.02).unwrap()) == 0.9999999999999999
    try expect(springAnimation.durationForEpsilon(0.03).unwrap()) == 0.8999999999999999
    try expect(springAnimation.durationForEpsilon(0.04).unwrap()) == 0.7999999999999999
    try expect(springAnimation.durationForEpsilon(0.05).unwrap()) == 0.7999999999999999
  }
}
