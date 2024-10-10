//
//  Rectangle.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/23/21.
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

public extension Shape where Self == Rectangle {

  static var rectangle: Rectangle { Rectangle(cornerRadius: 0, roundingCorners: .all) }

  static func rectangle(_ cornerRadius: CGFloat, _ roundingCorners: RectCorner = .all) -> Rectangle {
    Rectangle(cornerRadius: cornerRadius, roundingCorners: roundingCorners)
  }

  static func rectangle(cornerRadius: CGFloat, roundingCorners: RectCorner = .all) -> Rectangle {
    Rectangle(cornerRadius: cornerRadius, roundingCorners: roundingCorners)
  }
}

/// A continuous rounded rectangle.
///
/// The shape's path is generated using `BezierPath`. The appearance of the rounded corners
/// depends on the relationship between `cornerRadius` and the rectangle's dimensions.
///
/// Note: The generated path may appear incorrect when the corner radius exceeds approximately
/// 1/3 of the rectangle's shorter edge. To ensure a correct path, it's recommended to use
/// `BezierPath.limitedCornerRadius(rect:)` to clamp the corner radius.
///
/// For more details, see:
/// - [BezierPath.shapeBreakRatio](x-source-tag://BezierPath.shapeBreakRatio)
/// - [BezierPath.limitedCornerRadius(rect:)](x-source-tag://BezierPath.limitedCornerRadius)
public struct Rectangle: Shape, OffsetableShape {

  public let cornerRadius: CGFloat
  public let roundingCorners: RectCorner

  /// Initializes a rounded rectangle.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius. Negative value will be clamped to 0.
  ///   - roundingCorners: The corners to be rounded.
  public init(cornerRadius: CGFloat = 0, roundingCorners: RectCorner = .all) {
    self.cornerRadius = max(0, cornerRadius)
    self.roundingCorners = roundingCorners
  }

  /// Initializes a rounded rectangle.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius. Negative value will be clamped to 0.
  ///   - roundingCorners: The corners to be rounded.
  public init(_ cornerRadius: CGFloat = 0, _ roundingCorners: RectCorner = .all) {
    self.cornerRadius = max(0, cornerRadius)
    self.roundingCorners = roundingCorners
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    if roundingCorners == .all {
      if cornerRadius == 0 {
        return BezierPath(rect: rect).cgPath
      } else {
        return BezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
      }
    } else {
      return BezierPath(roundedRect: rect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(cornerRadius, cornerRadius)).cgPath
    }
  }

  // MARK: - OffsetableShape

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    let newCornerRadius = cornerRadius == 0 ? 0 : (cornerRadius + offset).clamped(to: 0...)
    return Rectangle(newCornerRadius, roundingCorners)
      .path(in: rect.expanded(by: offset))
  }
}
