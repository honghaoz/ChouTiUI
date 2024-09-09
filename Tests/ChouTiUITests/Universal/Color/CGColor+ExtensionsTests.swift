//
//  CGColor+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 2/26/22.
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
#endif

#if canImport(UIKit)
import UIKit
#endif

import CoreGraphics

import ChouTiTest

import ChouTiUI

class CGColor_ExtensionsTests: XCTestCase {

  func test_color() throws {
    #if canImport(AppKit)
    let color = try CGColor.rgba(red: 1, green: 0, blue: 0, alpha: 1, colorSpace: .sRGB()).unwrap().color
    expect(color) == NSColor.red
    #endif

    #if canImport(UIKit)
    let color = try CGColor.rgba(red: 1, green: 0, blue: 0, alpha: 1, colorSpace: .extendedSRGB()).unwrap().color
    expect(color) == UIColor.red
    #endif
  }

  func test_rgba() throws {
    let color = try CGColor.rgba(red: 1, green: 0, blue: 0, alpha: 1, colorSpace: .extendedSRGB()).unwrap()
    expect(color) == CGColor(colorSpace: .extendedSRGB(), components: [1, 0, 0, 1])
  }

  func test_usingColorSpace() throws {
    let color = try CGColor.rgba(red: 1, green: 0, blue: 0, alpha: 1, colorSpace: .extendedSRGB()).unwrap()
    let convertedColor = color.usingColorSpace(.sRGB())
    expect(convertedColor) == CGColor(colorSpace: .sRGB(), components: [1, 0, 0, 1])
  }
}
