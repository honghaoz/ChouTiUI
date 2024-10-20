//
//  BorderTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/15/21.
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

final class BorderTests: XCTestCase {

  func test_init() {
    // unified color
    do {
      let border1 = Border(color: .color(.red), width: 1)
      expect(border1.color) == .color(.red)
      expect(border1.width) == 1

      let border2 = Border(.color(.red), 1)
      expect(border2.color) == .color(.red)
      expect(border2.width) == 1
    }

    // solid color
    do {
      let border1 = Border(color: .red, width: 1)
      expect(border1.color) == .color(.red)
      expect(border1.width) == 1

      let border2 = Border(.red, 1)
      expect(border2.color) == .color(.red)
      expect(border2.width) == 1
    }

    // linear gradient
    do {
      let border1 = Border(color: LinearGradientColor(colors: [.red, .green], locations: [0, 1]), width: 1)
      expect(border1.color) == .linearGradient(LinearGradientColor(colors: [.red, .green], locations: [0, 1]))
      expect(border1.width) == 1

      let border2 = Border(LinearGradientColor(colors: [.red, .green], locations: [0, 1]), 1)
      expect(border2.color) == .linearGradient(LinearGradientColor(colors: [.red, .green], locations: [0, 1]))
      expect(border2.width) == 1
    }

    // radial gradient
    do {

      let border1 = Border(color: RadialGradientColor(colors: [.red, .green], centerPoint: .center, endPoint: .top), width: 1)
      expect(border1.color) == .radialGradient(RadialGradientColor(colors: [.red, .green], centerPoint: .center, endPoint: .top))
      expect(border1.width) == 1

      let border2 = Border(RadialGradientColor(colors: [.red, .green], centerPoint: .center, endPoint: .top), 1)
      expect(border2.color) == .radialGradient(RadialGradientColor(colors: [.red, .green], centerPoint: .center, endPoint: .top))
      expect(border2.width) == 1
    }

    // angular gradient
    do {

      let border1 = Border(color: AngularGradientColor(colors: [.red, .green], startPoint: .center, endPoint: .top), width: 1)
      expect(border1.color) == .angularGradient(AngularGradientColor(colors: [.red, .green], startPoint: .center, endPoint: .top))
      expect(border1.width) == 1

      let border2 = Border(AngularGradientColor(colors: [.red, .green], startPoint: .center, endPoint: .top), 1)
      expect(border2.color) == .angularGradient(AngularGradientColor(colors: [.red, .green], startPoint: .center, endPoint: .top))
      expect(border2.width) == 1
    }
  }
}
