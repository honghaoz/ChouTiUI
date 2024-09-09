//
//  GradientColor.swift
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

/// A gradient color.
public enum GradientColor: GradientColorType, Equatable, Hashable {

  public static let clearGradientColor: GradientColor = .linearGradient(.clearGradientColor)

  case linearGradient(LinearGradientColor)
  case radialGradient(RadialGradientColor)
  case angularGradient(AngularGradientColor)

  public var gradientColor: GradientColorType {
    switch self {
    case .linearGradient(let gradient):
      return gradient
    case .radialGradient(let gradient):
      return gradient
    case .angularGradient(let gradient):
      return gradient
    }
  }

  public var colors: [Color] { gradientColor.colors }
  public var locations: [CGFloat]? { gradientColor.locations }
  public var startPoint: UnitPoint { gradientColor.startPoint }
  public var endPoint: UnitPoint { gradientColor.endPoint }
  public var gradientLayerType: CAGradientLayerType { gradientColor.gradientLayerType }

  public func withComponents(colors: [Color], locations: [CGFloat]?, startPoint: UnitPoint, endPoint: UnitPoint) -> Self {
    switch self {
    case .linearGradient(let gradient):
      return .linearGradient(gradient.withComponents(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint))
    case .radialGradient(let gradient):
      return .radialGradient(gradient.withComponents(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint))
    case .angularGradient(let gradient):
      return .angularGradient(gradient.withComponents(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint))
    }
  }
}
