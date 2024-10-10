//
//  UnifiedColorTests.swift
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

import ChouTiTest

import ChouTiUI

class UnifiedColorTests: XCTestCase {

  func test_solidColor_gradientColor() {
    do {
      let unifiedColor: UnifiedColor = .color(.red)
      expect(unifiedColor.solidColor) == .red
      expect(unifiedColor.gradientColor) == nil
      expect(unifiedColor.isSolidColor) == true
      expect(unifiedColor.isGradientColor) == false
    }

    do {
      let unifiedColor: UnifiedColor = .gradient(.linearGradient(LinearGradientColor(colors: [.red, .blue])))
      expect(unifiedColor.solidColor) == nil
      expect(unifiedColor.gradientColor as? LinearGradientColor) == LinearGradientColor(colors: [.red, .blue])
      expect(unifiedColor.isSolidColor) == false
      expect(unifiedColor.isGradientColor) == true
    }
  }

  func test_isOpaque() {
    do {
      let unifiedColor: UnifiedColor = .color(.red)
      expect(unifiedColor.isOpaque) == true
    }

    do {
      let unifiedColor: UnifiedColor = .color(.clear)
      expect(unifiedColor.isOpaque) == false
    }

    do {
      let unifiedColor: UnifiedColor = .gradient(.linearGradient(LinearGradientColor(colors: [.red, .blue])))
      expect(unifiedColor.isOpaque) == true
    }

    do {
      let unifiedColor: UnifiedColor = .gradient(.linearGradient(LinearGradientColor(colors: [.clear, .blue])))
      expect(unifiedColor.isOpaque) == false
    }

    do {
      let unifiedColor: UnifiedColor = .gradient(.linearGradient(LinearGradientColor(colors: [.clear, .clear])))
      expect(unifiedColor.isOpaque) == false
    }
  }

  func test_adjustOpacity() {
    do {
      let unifiedColor: UnifiedColor = .color(.red)
      let newColor = unifiedColor.opacity { $0 * 0.5 }
      expect(newColor) == .color(.red.opacity(0.5))
    }

    do {
      let unifiedColor: UnifiedColor = .gradient(.linearGradient(LinearGradientColor(colors: [.red, .blue])))
      let newColor = unifiedColor.opacity { $0 * 0.5 }
      expect(newColor) == .gradient(.linearGradient(LinearGradientColor(colors: [.red.opacity(0.5), .blue.opacity(0.5)])))
    }
  }

  func test_convenience_factory_methods() {
    do {
      let unifiedColor: UnifiedColor = .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(unifiedColor) == .gradient(.linearGradient(LinearGradientColor(colors: [.red, .blue])))
    }

    do {
      let unifiedColor: UnifiedColor = .radialGradient(RadialGradientColor(colors: [.red, .blue], startPoint: .center, endPoint: .center))
      expect(unifiedColor) == .gradient(.radialGradient(RadialGradientColor(colors: [.red, .blue], startPoint: .center, endPoint: .center)))
    }

    do {
      let unifiedColor: UnifiedColor = .angularGradient(AngularGradientColor(colors: [.red, .blue], startPoint: .center, endPoint: .center))
      expect(unifiedColor) == .gradient(.angularGradient(AngularGradientColor(colors: [.red, .blue], startPoint: .center, endPoint: .center)))
    }
  }

  func test_color_as_unifiedColor() {
    let color: Color = .red
    let unifiedColor: UnifiedColor = color.unifiedColor
    expect(unifiedColor) == .color(.red)
  }
}
