//
//  CGPathElement.Element.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/28/22.
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

// MARK: - CGPathElement.Element

public extension CGPathElement {

  /// Path element.
  enum Element: CustomStringConvertible, Equatable {

    case moveToPoint(CGPoint)
    case addLineToPoint(CGPoint)
    case addQuadCurveToPoint(_ control: CGPoint, _ point: CGPoint)
    case addCurveToPoint(_ control1: CGPoint, _ control2: CGPoint, _ point: CGPoint)
    case closeSubpath
    case unknown

    public var description: String {
      switch self {
      case .moveToPoint(let point):
        return "moveToPoint: \(point)"
      case .addLineToPoint(let point):
        return "addLineToPoint: \(point)"
      case .addQuadCurveToPoint(let control, let point):
        return "addQuadCurveToPoint, control: \(control), point: \(point)"
      case .addCurveToPoint(let control1, let control2, let point):
        return "addCurveToPoint, control1: \(control1), control2: \(control2), point: \(point)"
      case .closeSubpath:
        return "closeSubpath"
      case .unknown:
        return "unknown"
      }
    }
  }

  /// Path element.
  var element: Element {
    switch type {
    case .moveToPoint:
      return .moveToPoint(points[0])
    case .addLineToPoint:
      return .addLineToPoint(points[0])
    case .addQuadCurveToPoint:
      return .addQuadCurveToPoint(points[0], points[1])
    case .addCurveToPoint:
      return .addCurveToPoint(points[0], points[1], points[2])
    case .closeSubpath:
      return .closeSubpath
    @unknown default:
      return .unknown
    }
  }
}

// MARK: - CGPathElement + CustomStringConvertible

extension CGPathElement: CustomStringConvertible {

  public var description: String {
    element.description
  }
}

// MARK: - CGPathElementType + CustomStringConvertible

extension CGPathElementType: CustomStringConvertible {

  public var description: String {
    switch self {
    case .moveToPoint:
      return "moveToPoint"
    case .addLineToPoint:
      return "addLineToPoint"
    case .addQuadCurveToPoint:
      return "addQuadCurveToPoint"
    case .addCurveToPoint:
      return "addCurveToPoint"
    case .closeSubpath:
      return "closeSubpath"
    @unknown default:
      return "unknown(\(rawValue))"
    }
  }
}
