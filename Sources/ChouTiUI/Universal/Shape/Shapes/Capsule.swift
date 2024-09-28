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
public struct Capsule: Shape, OffsetableShape {

  /// The style of the capsule.
  public enum Style: Hashable {

    /// A continuous capsule.
    case continuous

    /// A circular capsule.
    case circular
  }

  static let capsule = Capsule()

  public let style: Capsule.Style

  /// Creates a capsule with the given style.
  ///
  /// - Parameters:
  ///   - style: The style of the capsule.
  public init(style: Capsule.Style = .continuous) {
    self.style = style
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    if rect.width == rect.height {
      return CGPath(ellipseIn: rect, transform: nil)
    } else {
      switch style {
      case .continuous:
        return continuousPath(in: rect)
      case .circular:
        return circularPath(in: rect)
      }
    }
  }

  private func continuousPath(in rect: CGRect) -> CGPath {
    BezierPath(roundedRect: rect, cornerRadius: 1 / 2 * min(rect.width, rect.height)).cgPath
  }

  private func circularPath(in rect: CGRect) -> CGPath {
    let radius = 1 / 2 * min(rect.width, rect.height)
    let path = BezierPath()
    if rect.width > rect.height {
      /**
        horizontal
        ┌───────────────┐
        │               │
        └───────────────┘
       */

      // top right
      path.move(to: CGPoint(rect.maxX - radius, rect.minY))
      // right arc
      path.addArc(
        withCenter: CGPoint(x: rect.maxX - radius, y: rect.midY),
        radius: radius,
        startAngle: .pi * 1.5,
        endAngle: .pi * 0.5,
        clockwise: true
      )
      // bottom left
      path.addLine(to: CGPoint(rect.minX + radius, rect.maxY))
      // left arc
      path.addArc(
        withCenter: CGPoint(x: rect.minX + radius, y: rect.midY),
        radius: radius,
        startAngle: .pi * 0.5,
        endAngle: .pi * 1.5,
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

      // top left
      path.move(to: CGPoint(rect.minX, rect.minY + radius))
      // top arc
      path.addArc(
        withCenter: CGPoint(x: rect.midX, y: rect.minY + radius),
        radius: radius,
        startAngle: .pi,
        endAngle: 0,
        clockwise: true
      )
      // bottom right
      path.addLine(to: CGPoint(rect.maxX, rect.maxY - radius))
      // bottom arc
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

  // MARK: - OffsetableShape

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    path(in: rect.expanded(by: offset))
  }
}
