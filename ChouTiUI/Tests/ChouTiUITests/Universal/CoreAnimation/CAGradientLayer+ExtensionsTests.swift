//
//  CAGradientLayer+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/11/24.
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

class CAGradientLayer_ExtensionsTests: XCTestCase {

  func test_setBackgroundGradientColor() {
    let layer = CAGradientLayer()
    layer.setBackgroundGradientColor(
      LinearGradientColor(colors: [.red, .blue, .yellow], locations: [0, 0.2, 1], startPoint: .left, endPoint: .right)
    )

    expect(layer.type) == .axial
    expect(layer.colors as? [CGColor]) == [Color.red.cgColor, Color.blue.cgColor, Color.yellow.cgColor]
    expect(layer.locations) == [0, 0.2, 1]
    expect(layer.startPoint) == CGPoint(x: 0, y: 0.5)
    expect(layer.endPoint) == CGPoint(x: 1, y: 0.5)
    expect(layer.isOpaque) == false
  }

  func test_removeBackgroundGradientColor() {
    let layer = CAGradientLayer()

    layer.setBackgroundGradientColor(
      LinearGradientColor(colors: [.red, .blue, .yellow], locations: [0, 0.2, 1], startPoint: .left, endPoint: .right)
    )

    layer.removeBackgroundGradientColor()

    expect(layer.type) == .axial
    expect(layer.colors as? [CGColor]) == nil
    expect(layer.locations) == nil
    expect(layer.startPoint) == CGPoint(x: 0.5, y: 0)
    expect(layer.endPoint) == CGPoint(x: 0.5, y: 1)
    expect(layer.isOpaque) == false
  }
}
