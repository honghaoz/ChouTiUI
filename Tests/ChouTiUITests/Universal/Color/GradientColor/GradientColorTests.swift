//
//  GradientColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/25/22.
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
import QuartzCore

import ChouTiTest

import ChouTiUI

class GradientColorTests: XCTestCase {

  func test_clear() {
    let gradient = GradientColor.clearGradientColor
    expect(gradient) == GradientColor.linearGradient(LinearGradientColor.clearGradientColor)
  }

  func test_linearGradient() {
    let linearGradient = LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight)
    let gradient = GradientColor.linearGradient(linearGradient)
    expect(gradient.gradientColor as? LinearGradientColor) == linearGradient
    expect(gradient.colors) == [.red, .green, .blue]
    expect(gradient.locations) == [0.25, 0.5, 0.75]
    expect(gradient.startPoint) == .topLeft
    expect(gradient.endPoint) == .bottomRight
    expect(gradient.gradientLayerType) == .axial
  }

  func test_radialGradient() {
    let radialGradient = RadialGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomLeft)
    let gradient = GradientColor.radialGradient(radialGradient)
    expect(gradient.gradientColor as? RadialGradientColor) == radialGradient
    expect(gradient.colors) == [.red, .green, .blue]
    expect(gradient.locations) == [0.25, 0.5, 0.75]
    expect(gradient.startPoint) == .topLeft
    expect(gradient.endPoint) == .bottomLeft
    expect(gradient.gradientLayerType) == .radial
  }

  func test_angularGradient() {
    let angularGradient = AngularGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomLeft)
    let gradient = GradientColor.angularGradient(angularGradient)
    expect(gradient.gradientColor as? AngularGradientColor) == angularGradient
    expect(gradient.colors) == [.red, .green, .blue]
    expect(gradient.locations) == [0.25, 0.5, 0.75]
    expect(gradient.startPoint) == .topLeft
    expect(gradient.endPoint) == .bottomLeft
    expect(gradient.gradientLayerType) == .conic
  }

  func test_withComponents() {
    // linearGradient
    do {
      let gradient = GradientColor.linearGradient(LinearGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomRight))
      let newGradient = gradient.withComponents(colors: [.blue, .green, .red], locations: [0.75, 0.5, 0.25], startPoint: .bottomRight, endPoint: .topLeft)
      expect(newGradient.colors) == [.blue, .green, .red]
      expect(newGradient.locations) == [0.75, 0.5, 0.25]
      expect(newGradient.startPoint) == .bottomRight
      expect(newGradient.endPoint) == .topLeft
      expect(newGradient.gradientLayerType) == .axial
    }

    // radialGradient
    do {
      let gradient = GradientColor.radialGradient(RadialGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomLeft))
      let newGradient = gradient.withComponents(colors: [.blue, .green, .red], locations: [0.75, 0.5, 0.25], startPoint: .bottomLeft, endPoint: .topLeft)
      expect(newGradient.colors) == [.blue, .green, .red]
      expect(newGradient.locations) == [0.75, 0.5, 0.25]
      expect(newGradient.startPoint) == .bottomLeft
      expect(newGradient.endPoint) == .topLeft
      expect(newGradient.gradientLayerType) == .radial
    }

    // angularGradient
    do {
      let gradient = GradientColor.angularGradient(AngularGradientColor(colors: [.red, .green, .blue], locations: [0.25, 0.5, 0.75], startPoint: .topLeft, endPoint: .bottomLeft))
      let newGradient = gradient.withComponents(colors: [.blue, .green, .red], locations: [0.75, 0.5, 0.25], startPoint: .bottomLeft, endPoint: .topLeft)
      expect(newGradient.colors) == [.blue, .green, .red]
      expect(newGradient.locations) == [0.75, 0.5, 0.25]
      expect(newGradient.startPoint) == .bottomLeft
      expect(newGradient.endPoint) == .topLeft
      expect(newGradient.gradientLayerType) == .conic
    }
  }
}
