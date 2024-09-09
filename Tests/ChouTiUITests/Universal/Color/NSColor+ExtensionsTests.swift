//
//  NSColor+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/7/24.
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

import ChouTiTest

import ChouTiUI

class NSColor_ExtensionsTests: XCTestCase {

  func test_isRGB() {
    expect(NSColor.red.isRGB) == true
    expect(NSColor.controlAccentColor.isRGB) == false
    expect(NSColor.clear.isRGB) == false
    expect(NSColor.black.isRGB) == false
    expect(NSColor(patternImage: NSImage()).isRGB) == false
    expect(NSColor.blackRGB.isRGB) == true
  }

  func test_isGray() {
    expect(NSColor.red.isGray) == false
    expect(NSColor.controlAccentColor.isGray) == false
    expect(NSColor.clear.isGray) == true
    expect(NSColor.black.isGray) == true
    expect(NSColor(patternImage: NSImage()).isGray) == false
    expect(NSColor.blackRGB.isGray) == false
  }
}

class NSColorSpace_Model_ExtensionsTests: XCTestCase {

  func test_isRGB() {
    expect(NSColorSpace.Model.rgb.isRGB) == true
    expect(NSColorSpace.Model.gray.isRGB) == false
    expect(NSColorSpace.Model.patterned.isRGB) == false
  }

  func test_isGray() {
    expect(NSColorSpace.Model.rgb.isGray) == false
    expect(NSColorSpace.Model.gray.isGray) == true
    expect(NSColorSpace.Model.patterned.isGray) == false
  }

  func test_isPatterned() {
    expect(NSColorSpace.Model.rgb.isPatterned) == false
    expect(NSColorSpace.Model.gray.isPatterned) == false
    expect(NSColorSpace.Model.patterned.isPatterned) == true
  }
}

#endif
