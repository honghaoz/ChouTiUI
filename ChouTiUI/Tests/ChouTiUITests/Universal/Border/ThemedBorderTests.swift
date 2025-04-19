//
//  ThemedBorderTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/29/22.
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

import Foundation

import ChouTiTest

import ChouTiUI

class ThemedBorderTests: XCTestCase {

  func test() {
    // with light and dark border
    do {
      let themedBorder = ThemedBorder(light: Border(Color.red, 1), dark: Border(Color.blue, 2))
      expect(themedBorder.light) == Border(Color.red, 1)
      expect(themedBorder.dark) == Border(Color.blue, 2)

      expect(themedBorder.resolve(for: .light)) == Border(Color.red, 1)
      expect(themedBorder.resolve(for: .dark)) == Border(Color.blue, 2)
    }

    // with border for both light and dark theme
    do {
      let themedBorder = ThemedBorder(Border(Color.red, 1))
      expect(themedBorder.light) == Border(Color.red, 1)
      expect(themedBorder.dark) == Border(Color.red, 1)

      expect(themedBorder.resolve(for: .light)) == Border(Color.red, 1)
      expect(themedBorder.resolve(for: .dark)) == Border(Color.red, 1)
    }
  }

  func test_border_themedBorder() {
    let themedBorder = Border(Color.red, 1).themedBorder
    expect(themedBorder.light) == Border(Color.red, 1)
    expect(themedBorder.dark) == Border(Color.red, 1)

    expect(themedBorder.resolve(for: .light)) == Border(Color.red, 1)
    expect(themedBorder.resolve(for: .dark)) == Border(Color.red, 1)
  }
}
