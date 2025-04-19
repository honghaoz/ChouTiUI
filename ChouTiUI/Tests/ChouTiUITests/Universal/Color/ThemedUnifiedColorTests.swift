//
//  ThemedUnifiedColorTests.swift
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

import ChouTi
import ChouTiUI

class ThemedUnifiedColorTests: XCTestCase {

  func test_init_with_unified_color() {
    // different color
    do {
      let color = ThemedUnifiedColor(light: .linearGradient(LinearGradientColor(colors: [.red, .blue])), dark: .linearGradient(LinearGradientColor(colors: [.red, .yellow])))
      expect(color.light) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.dark) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
      expect(color.resolve(for: .light)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.resolve(for: .dark)) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
    }

    // same color
    do {
      let color = ThemedUnifiedColor(.linearGradient(LinearGradientColor(colors: [.red, .blue])))
      expect(color.light) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.dark) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.resolve(for: .light)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.resolve(for: .dark)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    }
  }

  func test_init_with_solid_color() {
    // different color
    do {
      let color = ThemedUnifiedColor(light: .red, dark: .blue)
      expect(color.light) == .color(.red)
      expect(color.dark) == .color(.blue)
      expect(color.resolve(for: .light)) == .color(.red)
      expect(color.resolve(for: .dark)) == .color(.blue)
    }

    // same color
    do {
      let color = ThemedUnifiedColor(.red)
      expect(color.light) == .color(.red)
      expect(color.dark) == .color(.red)
      expect(color.resolve(for: .light)) == .color(.red)
      expect(color.resolve(for: .dark)) == .color(.red)
    }
  }

  func test_init_with_linear_gradient_color() {
    let color = ThemedUnifiedColor(light: .linearGradient(LinearGradientColor(colors: [.red, .blue])), dark: .linearGradient(LinearGradientColor(colors: [.red, .yellow])))
    expect(color.light) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    expect(color.dark) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
    expect(color.resolve(for: .light)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    expect(color.resolve(for: .dark)) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
  }

  func test_init_with_radial_gradient_color() {
    let color = ThemedUnifiedColor(light: .radialGradient(RadialGradientColor(colors: [.red, .blue], startPoint: .bottom, endPoint: .top)), dark: .radialGradient(RadialGradientColor(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom)))
    expect(color.light) == .radialGradient(RadialGradientColor(colors: [.red, .blue], startPoint: .bottom, endPoint: .top))
    expect(color.dark) == .radialGradient(RadialGradientColor(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom))
    expect(color.resolve(for: .light)) == .radialGradient(RadialGradientColor(colors: [.red, .blue], startPoint: .bottom, endPoint: .top))
    expect(color.resolve(for: .dark)) == .radialGradient(RadialGradientColor(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom))
  }

  func test_init_with_angular_gradient_color() {
    let color = ThemedUnifiedColor(light: .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .top)), dark: .angularGradient(AngularGradientColor(colors: [.red, .yellow], centerPoint: .center, aimingPoint: .bottom)))
    expect(color.light) == .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .top))
    expect(color.dark) == .angularGradient(AngularGradientColor(colors: [.red, .yellow], centerPoint: .center, aimingPoint: .bottom))
    expect(color.resolve(for: .light)) == .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .top))
    expect(color.resolve(for: .dark)) == .angularGradient(AngularGradientColor(colors: [.red, .yellow], centerPoint: .center, aimingPoint: .bottom))
  }

  func test_init_with_themedColor() {
    let themedColor = ThemedColor(.red)
    let color = ThemedUnifiedColor(themedColor)
    expect(color.light) == .color(.red)
    expect(color.dark) == .color(.red)
    expect(color.resolve(for: .light)) == .color(.red)
    expect(color.resolve(for: .dark)) == .color(.red)
  }

  func test_color_to_themedUnifiedColor() {
    let color = Color.red
    expect(color.themedUnifiedColor) == ThemedUnifiedColor(.red)
  }

  func test_unifiedColor_to_themedUnifiedColor() {
    let unifiedColor: UnifiedColor = .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    expect(unifiedColor.themedUnifiedColor) == ThemedUnifiedColor(light: .linearGradient(LinearGradientColor(colors: [.red, .blue])), dark: .linearGradient(LinearGradientColor(colors: [.red, .blue])))
  }

  func test_themedColor_to_themedUnifiedColor() {
    let themedColor = ThemedColor(.red)
    expect(themedColor.themedUnifiedColor) == ThemedUnifiedColor(themedColor)
  }
}
