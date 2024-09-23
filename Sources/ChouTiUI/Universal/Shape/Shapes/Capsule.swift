//
//  Capsule.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/16/21.
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

import ChouTi

public extension Shape where Self == Capsule {

  /// A capsule shape.
  static var capsule: Capsule { Capsule.capsule }
}

/// A capsule shape.
///
/// - Note: Using `BezierPath(roundedRect:cornerRadius:)` with 1/2 of width or height as the corner radius won't generate a correct capsule shape. See [BezierPath.shapeBreakRatio](x-source-tag://BezierPath.shapeBreakRatio) for more information.
public struct Capsule: Shape, OffsetableShape {

  static let capsule = Capsule()

  public init() {}

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    if rect.width == rect.height {
      return CGPath(ellipseIn: rect, transform: nil)
    } else {
      let radius = 1 / 2 * min(rect.width, rect.height)
      let path = BezierPath()
      if rect.width > rect.height {
        /**
          horizontal
          ┌───────────────┐
          │               │
          └───────────────┘
         */
        path.move(to: CGPoint(rect.maxX - radius, rect.minY))
        path.addArc(
          withCenter: CGPoint(x: rect.maxX - radius, y: rect.midY),
          radius: radius,
          startAngle: .pi / 2,
          endAngle: -.pi / 2,
          clockwise: true
        )
        path.addLine(to: CGPoint(rect.minX + radius, rect.maxY))
        path.addArc(
          withCenter: CGPoint(x: rect.minX + radius, y: rect.midY),
          radius: radius,
          startAngle: -.pi / 2,
          endAngle: .pi / 2,
          clockwise: true
        )
        path.close()
      } else {
        /**
          vertical
          ┌───┐
          │   │
          │   │
          │   │
          │   │
          └───┘
         */
        path.move(to: CGPoint(rect.minX, rect.minY + radius))
        path.addArc(
          withCenter: CGPoint(x: rect.midX, y: rect.minY + radius),
          radius: radius,
          startAngle: .pi,
          endAngle: 0,
          clockwise: true
        )
        path.addLine(to: CGPoint(rect.maxX, rect.maxY - radius))
        path.addArc(
          withCenter: CGPoint(x: rect.midX, y: rect.maxY - radius),
          radius: radius,
          startAngle: 0,
          endAngle: .pi,
          clockwise: true
        )
        path.close()
      }
      return path.cgPath
    }
  }

  // MARK: - OffsetableShape

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    path(in: rect.expanded(by: offset))
  }
}
