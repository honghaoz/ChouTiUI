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
      let color = ThemedUnifiedColor(lightColor: .linearGradient(LinearGradientColor(colors: [.red, .blue])), darkColor: .linearGradient(LinearGradientColor(colors: [.red, .yellow])))
      expect(color.lightColor) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.darkColor) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
      expect(color.color(for: .light)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.color(for: .dark)) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
    }

    // same color
    do {
      let color = ThemedUnifiedColor(.linearGradient(LinearGradientColor(colors: [.red, .blue])))
      expect(color.lightColor) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.darkColor) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.color(for: .light)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
      expect(color.color(for: .dark)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    }
  }

  func test_init_with_solid_color() {
    // different color
    do {
      let color = ThemedUnifiedColor(lightColor: .red, darkColor: .blue)
      expect(color.lightColor) == .color(.red)
      expect(color.darkColor) == .color(.blue)
      expect(color.color(for: .light)) == .color(.red)
      expect(color.color(for: .dark)) == .color(.blue)
    }

    // same color
    do {
      let color = ThemedUnifiedColor(.red)
      expect(color.lightColor) == .color(.red)
      expect(color.darkColor) == .color(.red)
      expect(color.color(for: .light)) == .color(.red)
      expect(color.color(for: .dark)) == .color(.red)
    }
  }

  func test_init_with_linear_gradient_color() {
    let color = ThemedUnifiedColor(lightColor: LinearGradientColor(colors: [.red, .blue]), darkColor: LinearGradientColor(colors: [.red, .yellow]))
    expect(color.lightColor) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    expect(color.darkColor) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
    expect(color.color(for: .light)) == .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    expect(color.color(for: .dark)) == .linearGradient(LinearGradientColor(colors: [.red, .yellow]))
  }

  func test_init_with_radial_gradient_color() {
    let color = ThemedUnifiedColor(lightColor: RadialGradientColor(colors: [.red, .blue], startPoint: .bottom, endPoint: .top), darkColor: RadialGradientColor(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom))
    expect(color.lightColor) == .radialGradient(RadialGradientColor(colors: [.red, .blue], startPoint: .bottom, endPoint: .top))
    expect(color.darkColor) == .radialGradient(RadialGradientColor(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom))
    expect(color.color(for: .light)) == .radialGradient(RadialGradientColor(colors: [.red, .blue], startPoint: .bottom, endPoint: .top))
    expect(color.color(for: .dark)) == .radialGradient(RadialGradientColor(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom))
  }

  func test_init_with_angular_gradient_color() {
    let color = ThemedUnifiedColor(lightColor: AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .top), darkColor: AngularGradientColor(colors: [.red, .yellow], centerPoint: .center, aimingPoint: .bottom))
    expect(color.lightColor) == .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .top))
    expect(color.darkColor) == .angularGradient(AngularGradientColor(colors: [.red, .yellow], centerPoint: .center, aimingPoint: .bottom))
    expect(color.color(for: .light)) == .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .top))
    expect(color.color(for: .dark)) == .angularGradient(AngularGradientColor(colors: [.red, .yellow], centerPoint: .center, aimingPoint: .bottom))
  }

  func test_init_with_themedColor() {
    let themedColor = ThemedColor(.red)
    let color = ThemedUnifiedColor(themedColor)
    expect(color.lightColor) == .color(.red)
    expect(color.darkColor) == .color(.red)
    expect(color.color(for: .light)) == .color(.red)
    expect(color.color(for: .dark)) == .color(.red)
  }

  func test_color_to_themedUnifiedColor() {
    let color = Color.red
    expect(color.themedUnifiedColor) == ThemedUnifiedColor(.red)
  }

  func test_unifiedColor_to_themedUnifiedColor() {
    let unifiedColor: UnifiedColor = .linearGradient(LinearGradientColor(colors: [.red, .blue]))
    expect(unifiedColor.themedUnifiedColor) == ThemedUnifiedColor(lightColor: .linearGradient(LinearGradientColor(colors: [.red, .blue])), darkColor: .linearGradient(LinearGradientColor(colors: [.red, .blue])))
  }

  func test_themedColor_to_themedUnifiedColor() {
    let themedColor = ThemedColor(.red)
    expect(themedColor.themedUnifiedColor) == ThemedUnifiedColor(themedColor)
  }
}
