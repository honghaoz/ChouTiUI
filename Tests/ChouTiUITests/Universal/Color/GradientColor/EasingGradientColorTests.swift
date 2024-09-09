//
//  EasingGradientColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/8/24.
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

class GradientSegmentTests: XCTestCase {

  func test_init() {
    // default parameters
    do {
      let segment = GradientSegment(fromColor: .red, toColor: .blue)
      expect(segment.fromColor) == .red
      expect(segment.toColor) == .blue
      expect(segment.interpolationFunction(0.21, 0, 1, 1)) == Easing.Sine().easeInOut(0.21, 0, 1, 1)
      expect(segment.steps) == 10
      expect(segment.weight) == 1
    }

    // customized parameters
    do {
      let segment = GradientSegment(fromColor: .red, toColor: .blue, interpolationFunction: Easing.Cubic().easeInOut, steps: 20, weight: 2)
      expect(segment.fromColor) == .red
      expect(segment.toColor) == .blue
      expect(segment.interpolationFunction(0.21, 0, 1, 1)) == Easing.Cubic().easeInOut(0.21, 0, 1, 1)
      expect(segment.steps) == 20
      expect(segment.weight) == 2
    }
  }
}

class EasingGradientColorTests: XCTestCase {

  func test_init() {
    // empty segments
    do {
      let gradientColor = EasingGradientColor(segments: [])
      expect(gradientColor.segments.isEmpty) == true
      expect(gradientColor.colors) == []
      expect(gradientColor.locations) == []
    }

    // one segment
    do {
      let gradientColor = EasingGradientColor(segments: [GradientSegment(fromColor: .red, toColor: .blue)])
      expect(gradientColor.segments.count) == 1
      expect(gradientColor.colors.count) == 11
      expect(gradientColor.locations.count) == 11
      expect(gradientColor.locations) == [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
    }

    // two segments, equal weight
    do {
      let gradientColor = EasingGradientColor(segments: [
        GradientSegment(fromColor: .red, toColor: .blue),
        GradientSegment(fromColor: .blue, toColor: .green),
      ])
      expect(gradientColor.segments.count) == 2
      expect(gradientColor.colors.count) == 22
      expect(gradientColor.locations.count) == 22
    }

    // two segments, different weight
    do {
      let gradientColor = EasingGradientColor(segments: [
        GradientSegment(fromColor: .red, toColor: .blue, steps: 10, weight: 1),
        GradientSegment(fromColor: .blue, toColor: .green, steps: 10, weight: 3),
      ])
      expect(gradientColor.segments.count) == 2
      expect(gradientColor.colors.count) == 22
      expect(gradientColor.locations.count) == 22
      expect(gradientColor.locations) == [0.0, 0.025, 0.05, 0.075, 0.1, 0.125, 0.15, 0.175, 0.2, 0.225, 0.25, 0.25, 0.325, 0.4, 0.475, 0.55, 0.625, 0.7, 0.7749999999999999, 0.8500000000000001, 0.925, 1.0]
    }
  }

  func test_linearGradient() {
    do {
      let easing = Easing.Sine().easeInOut
      let linearGradient = LinearGradientColor(from: .blackRGB, to: .whiteRGB)
      expect(linearGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.9, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.8, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.7, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.6, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.4, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.3, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.2, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(linearGradient.locations) == [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
      expect(linearGradient.startPoint) == .top
      expect(linearGradient.endPoint) == .bottom
    }

    do {
      let easing = Easing.Cubic().easeInOut
      let linearGradient = LinearGradientColor(from: .blackRGB, to: .whiteRGB, interpolationFunction: easing, steps: 4)
      expect(linearGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.75, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.25, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(linearGradient.locations) == [0.0, 0.25, 0.5, 0.75, 1.0]
      expect(linearGradient.startPoint) == .top
      expect(linearGradient.endPoint) == .bottom
    }
  }

  func test_radialGradient() {
    do {
      let easing = Easing.Sine().easeInOut
      let radialGradient = RadialGradientColor(from: .blackRGB, to: .whiteRGB, centerPoint: .center, endPoint: .bottomRight)
      expect(radialGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.9, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.8, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.7, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.6, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.4, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.3, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.2, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(radialGradient.locations) == [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
      expect(radialGradient.centerPoint) == .center
      expect(radialGradient.endPoint) == .bottomRight
    }

    do {
      let easing = Easing.Cubic().easeInOut
      let radialGradient = RadialGradientColor(from: .blackRGB, to: .whiteRGB, interpolationFunction: easing, steps: 4, centerPoint: .center, endPoint: .bottomRight)
      expect(radialGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.75, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.25, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(radialGradient.locations) == [0.0, 0.25, 0.5, 0.75, 1.0]
      expect(radialGradient.centerPoint) == .center
      expect(radialGradient.endPoint) == .bottomRight
    }

    do {
      let easing = Easing.Sine().easeInOut
      let easingGradientColor = EasingGradientColor(segments: [
        GradientSegment(fromColor: .blackRGB, toColor: .whiteRGB, interpolationFunction: easing, steps: 4),
      ])
      let radialGradient = RadialGradientColor.centerRadial(easingGradientColor: easingGradientColor, radius: 0.5, aspectRatio: 2)
      expect(radialGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.75, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.25, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(radialGradient.locations) == [0.0, 0.25, 0.5, 0.75, 1.0]
      expect(radialGradient.centerPoint) == .center
      expect(radialGradient.endPoint) == UnitPoint(x: 0.75, y: 1.0)
    }

    do {
      let easing = Easing.Cubic().easeInOut
      let easingGradientColor = EasingGradientColor(segments: [
        GradientSegment(fromColor: .blackRGB, toColor: .whiteRGB, interpolationFunction: easing, steps: 4),
      ])
      let radialGradient = RadialGradientColor.centerRadial(easingGradientColor: easingGradientColor, diameter: .length, aspectRatio: 2)
      expect(radialGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.75, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.25, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(radialGradient.locations) == [0.0, 0.25, 0.5, 0.75, 1.0]
      expect(radialGradient.centerPoint) == .center
      expect(radialGradient.endPoint) == UnitPoint(x: 1.0, y: 1.5)
    }
  }

  func test_angularGradient() {
    do {
      let easing = Easing.Sine().easeInOut
      let angularGradient = AngularGradientColor(from: .blackRGB, to: .whiteRGB, centerPoint: .bottom, aimingPoint: .left)
      expect(angularGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.9, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.8, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.7, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.6, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.4, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.3, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.2, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(angularGradient.locations) == [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
      expect(angularGradient.centerPoint) == .bottom
      expect(angularGradient.aimingPoint) == .left
    }

    do {
      let easing = Easing.Cubic().easeInOut
      let angularGradient = AngularGradientColor(from: .blackRGB, to: .whiteRGB, interpolationFunction: easing, steps: 4, centerPoint: .bottom, aimingPoint: .left)
      expect(angularGradient.colors.map { $0.hexString(includeAlpha: true) }) == [
        Color.blackRGB(easing(1, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.75, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.5, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0.25, 0, 1, 1)).hexString(includeAlpha: true),
        Color.blackRGB(easing(0, 0, 1, 1)).hexString(includeAlpha: true),
      ]
      expect(angularGradient.locations) == [0.0, 0.25, 0.5, 0.75, 1.0]
      expect(angularGradient.centerPoint) == .bottom
      expect(angularGradient.aimingPoint) == .left
    }
  }
}
