//
//  CAGradientLayer+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/5/21.
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

public extension CAGradientLayer {

  /// Set the background gradient color of the layer.
  ///
  /// - Parameters:
  ///   - gradientColor: The gradient color to set.
  func setBackgroundGradientColor(_ gradientColor: GradientColorType) {
    type = gradientColor.gradientLayerType

    colors = gradientColor.colors.map(\.cgColor)
    locations = gradientColor.locationNSNumbers

    startPoint = gradientColor.startPoint.cgPoint
    endPoint = gradientColor.endPoint.cgPoint

    // don't set gradientLayer.isOpaque to true, this can result in black color.
    // https://stackoverflow.com/questions/56327304/why-setting-isopaque-to-true-on-catextlayer-makes-the-background-black
    // by default, layer()?.isOpaque is false
    // layer()?.isOpaque = gradientColor.isOpaque
    isOpaque = false
  }

  /// Remove the background gradient color of the layer.
  func removeBackgroundGradientColor() {
    type = .axial

    colors = nil
    locations = nil

    startPoint = CGPoint(0.5, 0)
    endPoint = CGPoint(0.5, 1)

    isOpaque = false
  }
}
