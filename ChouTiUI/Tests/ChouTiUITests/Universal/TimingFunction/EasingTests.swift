//
//  EasingTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/6/24.
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

import ChouTiTest

import ChouTiUI

class EasingTests: XCTestCase {

  func test_linear() {
    let linear = Easing.Linear()

    // 0
    expect(linear.easeIn(0, 0, 1, 1)) == 0
    expect(linear.easeOut(0, 0, 1, 1)) == 0
    expect(linear.easeInOut(0, 0, 1, 1)) == 0

    // 0.25
    expect(linear.easeIn(0.25, 0, 1, 1)) == 0.25
    expect(linear.easeOut(0.25, 0, 1, 1)) == 0.25
    expect(linear.easeInOut(0.25, 0, 1, 1)) == 0.25

    // 0.5
    expect(linear.easeIn(0.5, 0, 1, 1)) == 0.5
    expect(linear.easeOut(0.5, 0, 1, 1)) == 0.5
    expect(linear.easeInOut(0.5, 0, 1, 1)) == 0.5

    // 0.75
    expect(linear.easeIn(0.75, 0, 1, 1)) == 0.75
    expect(linear.easeOut(0.75, 0, 1, 1)) == 0.75
    expect(linear.easeInOut(0.5, 0, 1, 1)) == 0.5

    // 1
    expect(linear.easeIn(1, 0, 1, 1)) == 1
    expect(linear.easeOut(1, 0, 1, 1)) == 1
    expect(linear.easeInOut(1, 0, 1, 1)) == 1
  }

  func test_sine() {
    let sine = Easing.Sine()

    // 0
    expect(sine.easeIn(0, 0, 1, 1)) == 0
    expect(sine.easeOut(0, 0, 1, 1)) == 0
    expect(sine.easeInOut(0, 0, 1, 1)) == 0

    // 0.5
    expect(sine.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 1 - cos(.pi / 4), within: 1e-9))
    expect(sine.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: sin(.pi / 4), within: 1e-9))
    expect(sine.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(sine.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(sine.easeOut(1, 0, 1, 1)) == 1
    expect(sine.easeInOut(1, 0, 1, 1)) == 1
  }

  func test_quad() {
    let quad = Easing.Quad()

    // 0
    expect(quad.easeIn(0, 0, 1, 1)) == 0
    expect(quad.easeOut(0, 0, 1, 1)) == 0
    expect(quad.easeInOut(0, 0, 1, 1)) == 0

    // 0.5
    expect(quad.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.25, within: 1e-9))
    expect(quad.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.75, within: 1e-9))
    expect(quad.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(quad.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(quad.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(quad.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }

  func test_cubic() {
    let cubic = Easing.Cubic()

    // 0
    expect(cubic.easeIn(0, 0, 1, 1)) == 0
    expect(cubic.easeOut(0, 0, 1, 1)) == 0
    expect(cubic.easeInOut(0, 0, 1, 1)) == 0

    // 0.5
    expect(cubic.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.125, within: 1e-9))
    expect(cubic.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.875, within: 1e-9))
    expect(cubic.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(cubic.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(cubic.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(cubic.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }

  func test_quart() {
    let quart = Easing.Quart()

    // 0
    expect(quart.easeIn(0, 0, 1, 1)) == 0
    expect(quart.easeOut(0, 0, 1, 1)) == 0
    expect(quart.easeInOut(0, 0, 1, 1)) == 0

    // 0.5
    expect(quart.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.0625, within: 1e-9))
    expect(quart.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.9375, within: 1e-9))
    expect(quart.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(quart.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(quart.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(quart.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }

  func test_quint() {
    let quint = Easing.Quint()

    // 0
    expect(quint.easeIn(0, 0, 1, 1)) == 0
    expect(quint.easeOut(0, 0, 1, 1)) == 0
    expect(quint.easeInOut(0, 0, 1, 1)) == 0

    // 0.5
    expect(quint.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.03125, within: 1e-9))
    expect(quint.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.96875, within: 1e-9))
    expect(quint.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(quint.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(quint.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(quint.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }

  func test_expo() {
    let expo = Easing.Expo()

    // 0
    expect(expo.easeIn(0, 0, 1, 1)) == 0
    expect(expo.easeOut(0, 0, 1, 1)) == 0
    expect(expo.easeInOut(0, 0, 1, 1)) == 0

    expect(expo.easeIn(0.1, 0, 1, 1)) == 0.001953125
    expect(expo.easeOut(0.1, 0, 1, 1)) == 0.5
    expect(expo.easeInOut(0.1, 0, 1, 1)) == 0.001953125

    // 0.5
    expect(expo.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.03125, within: 1e-9))
    expect(expo.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.96875, within: 1e-9))
    expect(expo.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(expo.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(expo.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(expo.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }

  func test_circ() {
    let circ = Easing.Circ()

    // 0
    expect(circ.easeIn(0, 0, 1, 1)) == 0
    expect(circ.easeOut(0, 0, 1, 1)) == 0
    expect(circ.easeInOut(0, 0, 1, 1)) == 0

    // 0.5
    expect(circ.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.1339745962155614, within: 1e-9))
    expect(circ.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.8660254037844386, within: 1e-9))
    expect(circ.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(circ.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(circ.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(circ.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }

  func test_elastic() {
    // default
    do {
      let elastic = Easing.Elastic()

      // 0
      expect(elastic.easeIn(0, 0, 1, 1)) == 0
      expect(elastic.easeOut(0, 0, 1, 1)) == 0
      expect(elastic.easeInOut(0, 0, 1, 1)) == 0

      // 0.5
      expect(elastic.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: -0.015625000000000045, within: 1e-9))
      expect(elastic.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 1.015625, within: 1e-9))
      expect(elastic.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

      expect(elastic.easeInOut(0.1, 0, 1, 1)).to(beApproximatelyEqual(to: 0.000339156597005722, within: 1e-9))

      // 1
      expect(elastic.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
      expect(elastic.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
      expect(elastic.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    }

    // amplitude < 1
    do {
      let elastic = Easing.Elastic(amplitude: 0.5, period: 1)

      // 0
      expect(elastic.easeIn(0, 0, 1, 1)) == 0
      expect(elastic.easeOut(0, 0, 1, 1)) == 0
      expect(elastic.easeInOut(0, 0, 1, 1)) == 0

      // 0.5
      expect(elastic.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: -0.03125, within: 1e-9))
      expect(elastic.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 1.03125, within: 1e-9))
      expect(elastic.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

      // 1
      expect(elastic.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
      expect(elastic.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
      expect(elastic.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    }
  }

  func test_back() {
    let back = Easing.Back()

    // 0
    expect(back.easeIn(0, 0, 1, 1)) == 0
    expect(back.easeOut(0, 0, 1, 1)).to(beApproximatelyEqual(to: 0, within: 1e-9))
    expect(back.easeInOut(0, 0, 1, 1)) == 0

    // 0.5
    expect(back.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: -0.08769750000000004, within: 1e-9))
    expect(back.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 1.0876975, within: 1e-9))
    expect(back.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 1
    expect(back.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(back.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(back.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }

  func test_bounce() {
    let bounce = Easing.Bounce()

    // 0
    expect(bounce.easeIn(0, 0, 1, 1)) == 0
    expect(bounce.easeOut(0, 0, 1, 1)) == 0
    expect(bounce.easeInOut(0, 0, 1, 1)) == 0

    // 0.25
    expect(bounce.easeIn(0.25, 0, 1, 1)).to(beApproximatelyEqual(to: 0.02734375, within: 1e-9))
    expect(bounce.easeOut(0.25, 0, 1, 1)).to(beApproximatelyEqual(to: 0.47265625, within: 1e-9))
    expect(bounce.easeInOut(0.25, 0, 1, 1)).to(beApproximatelyEqual(to: 0.1171875, within: 1e-9))

    // 0.5
    expect(bounce.easeIn(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.234375, within: 1e-9))
    expect(bounce.easeOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.765625, within: 1e-9))
    expect(bounce.easeInOut(0.5, 0, 1, 1)).to(beApproximatelyEqual(to: 0.5, within: 1e-9))

    // 0.75
    expect(bounce.easeIn(0.75, 0, 1, 1)).to(beApproximatelyEqual(to: 0.52734375, within: 1e-9))
    expect(bounce.easeOut(0.75, 0, 1, 1)).to(beApproximatelyEqual(to: 0.97265625, within: 1e-9))
    expect(bounce.easeInOut(0.75, 0, 1, 1)).to(beApproximatelyEqual(to: 0.8828125, within: 1e-9))

    // 1
    expect(bounce.easeIn(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(bounce.easeOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
    expect(bounce.easeInOut(1, 0, 1, 1)).to(beApproximatelyEqual(to: 1, within: 1e-9))
  }
}
