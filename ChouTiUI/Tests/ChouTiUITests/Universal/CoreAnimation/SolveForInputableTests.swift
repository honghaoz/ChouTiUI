//
//  SolveForInputableTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/25/26.
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

import ChouTi
import ChouTiUI

class SolveForInputableTests: XCTestCase {

  func test_solveForInput_objectDoesNotRespondToSelector() {
    // Create an NSObject that conforms to SolveForInputable but doesn't
    // actually implement the private _solveForInput: method
    let object = FakeTimingFunction()

    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message.hasPrefix("object doesn't respond to selector")) == true
    }

    let result = object.solveForInput(0.5)
    expect(result) == nil

    Assert.resetTestAssertionFailureHandler()
  }
}

/// A fake timing function that conforms to SolveForInputable but doesn't
/// respond to the private _solveForInput: selector.
private final class FakeTimingFunction: NSObject, SolveForInputable {}
