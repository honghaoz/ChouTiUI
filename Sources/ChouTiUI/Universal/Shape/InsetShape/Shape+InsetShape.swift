//
//  Shape+InsetShape.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/17/24.
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

public extension Shape {

  /// Creates a new shape with inset amount.
  ///
  /// - Note: This differs from `offset(by:)` in that it applies the inset amount to the bounding rect rather than offsetting the entire shape.
  ///
  /// - Parameters:
  ///   - amount: The inset amount to be applied to the shape.
  /// - Returns: A new shape with the specified inset amount.
  func inset(by amount: CGFloat) -> InsetShape<Self> {
    if amount == 0 {
      return InsetShape(shape: self)
    } else {
      return InsetShape(shape: self, insets: LayoutEdgeInsets(amount))
    }
  }

  /// Creates a new shape with inset amount.
  ///
  /// - Parameters:
  ///   - top: The top inset amount.
  ///   - left: The left inset amount.
  ///   - bottom: The bottom inset amount.
  ///   - right: The right inset amount.
  /// - Returns: A new shape with the specified inset amounts.
  func inset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> InsetShape<Self> {
    if top == 0, left == 0, bottom == 0, right == 0 {
      return InsetShape(shape: self)
    } else {
      return InsetShape(shape: self, insets: LayoutEdgeInsets(top: .absolute(top), left: .absolute(left), bottom: .absolute(bottom), right: .absolute(right)))
    }
  }

  /// Creates a new shape with inset amount.
  ///
  /// - Parameters:
  ///   - top: The top inset amount.
  ///   - left: The left inset amount.
  ///   - bottom: The bottom inset amount.
  ///   - right: The right inset amount.
  /// - Returns: A new shape with the specified inset amounts.
  @inlinable
  @inline(__always)
  func inset(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> InsetShape<Self> {
    inset(top: top, left: left, bottom: bottom, right: right)
  }

  /// Creates a new shape with inset amount.
  ///
  /// - Parameters:
  ///   - horizontal: The horizontal inset amount.
  ///   - vertical: The vertical inset amount.
  /// - Returns: A new shape with the specified inset amounts.
  func inset(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> InsetShape<Self> {
    if horizontal == 0, vertical == 0 {
      return InsetShape(shape: self)
    } else {
      return InsetShape(shape: self, insets: LayoutEdgeInsets(top: .absolute(vertical), left: .absolute(horizontal), bottom: .absolute(vertical), right: .absolute(horizontal)))
    }
  }

  /// Creates a new shape with inset amount.
  ///
  /// - Parameters:
  ///   - insets: The insets to be applied to the shape.
  /// - Returns: A new shape with the specified insets.
  func inset(insets: LayoutEdgeInsets) -> InsetShape<Self> {
    if insets.isZero() {
      return InsetShape(shape: self)
    } else {
      return InsetShape(shape: self, insets: insets)
    }
  }
}
