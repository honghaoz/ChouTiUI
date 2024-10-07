//
//  NSTextField+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/6/24.
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

import ChouTiTest

import ChouTiUI

final class NSTextField_ExtensionsTests: XCTestCase {

  func test_numberOfLines() {
    let textField = NSTextField()
    textField.maximumNumberOfLines = 2
    expect(textField.numberOfLines) == 2

    textField.numberOfLines = 3
    expect(textField.numberOfLines) == 3
  }

  func test_attributedText() {
    let textField = NSTextField()
    let attributedText = NSAttributedString(string: "Hello, World!")
    textField.attributedStringValue = attributedText
    expect(textField.attributedText) == attributedText

    textField.attributedText = attributedText
    expect(textField.attributedText) == attributedText
  }

  func test_textAlignment() {
    let textField = NSTextField()
    textField.alignment = .center
    expect(textField.textAlignment) == .center

    textField.textAlignment = .left
    expect(textField.textAlignment) == .left
  }
}

#endif
