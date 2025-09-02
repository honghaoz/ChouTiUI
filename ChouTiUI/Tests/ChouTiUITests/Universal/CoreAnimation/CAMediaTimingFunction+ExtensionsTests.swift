//
//  CAMediaTimingFunction+ExtensionsTests.swift
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

class CAMediaTimingFunction_ExtensionsTests: XCTestCase {

  func test_solveForInput_linear() {
    let timingFunction = CAMediaTimingFunction(name: .linear)

    try expect(timingFunction.solveForInput(0.0).unwrap()) == 0
    try expect(timingFunction.solveForInput(0.25).unwrap()) == 0.25
    try expect(timingFunction.solveForInput(0.5).unwrap()) == 0.5
    try expect(timingFunction.solveForInput(0.75).unwrap()) == 0.75
    try expect(timingFunction.solveForInput(1.0).unwrap()) == 1.0
  }

  func test_solveForInput_easeIn() {
    let timingFunction = CAMediaTimingFunction(name: .easeIn)

    try expect(timingFunction.solveForInput(0.0).unwrap()) == 0
    try expect(timingFunction.solveForInput(0.25).unwrap()) == 0.09346466
    try expect(timingFunction.solveForInput(0.5).unwrap()) == 0.31535682
    try expect(timingFunction.solveForInput(0.75).unwrap()) == 0.6218605
    try expect(timingFunction.solveForInput(1.0).unwrap()) == 1.0
  }

  func test_solveForInput_easeOut() {
    let timingFunction = CAMediaTimingFunction(name: .easeOut)

    try expect(timingFunction.solveForInput(0.0).unwrap()) == 0
    try expect(timingFunction.solveForInput(0.25).unwrap()) == 0.37813953
    try expect(timingFunction.solveForInput(0.5).unwrap()) == 0.6846432
    try expect(timingFunction.solveForInput(0.75).unwrap()) == 0.9065353
    try expect(timingFunction.solveForInput(1.0).unwrap()) == 1.0
  }

  func test_solveForInput_easeInOut() throws {
    let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

    try expect(timingFunction.solveForInput(0.0).unwrap()) == 0
    try expect(timingFunction.solveForInput(0.25).unwrap()) == 0.12916191
    try expect(timingFunction.solveForInput(0.5).unwrap()) == 0.5
    try expect(timingFunction.solveForInput(0.75).unwrap()) == 0.8708381
    try expect(timingFunction.solveForInput(1.0).unwrap()) == 1.0
  }

  func test_solveForInput_monotonicity() {
    // test that the timing function is monotonic (non-decreasing)
    let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

    var previousResult: Float = 0.0
    let testValues: [Float] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

    for inputValue in testValues {
      if let result = timingFunction.solveForInput(inputValue) {
        expect(result) >= previousResult
        previousResult = result
      } else {
        XCTFail("solveForInput should not return nil for input \(inputValue)")
      }
    }
  }
}
