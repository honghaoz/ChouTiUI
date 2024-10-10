//
//  InsetShape.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/3/21.
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

/// A shape with insets applied to the bounding rect.
///
/// - Note: This differs from `OffsetShape` in that it applies insets to the bounding rect rather than offsetting the entire shape.
public struct InsetShape<S: Shape>: Shape {

  /// The shape to be inset.
  public let shape: S

  /// The insets to be applied to the bounding rect.
  public let insets: LayoutEdgeInsets

  /// A flag indicating whether the insets are zero.
  private let isZeroInset: Bool

  /// Initializes an `InsetShape` with the specified shape with no insets.
  ///
  /// - Parameters:
  ///   - shape: The shape to be inset.
  public init(shape: S) {
    self.shape = shape
    self.insets = LayoutEdgeInsets.zero
    isZeroInset = true
  }

  /// Initializes an `InsetShape` with the specified shape and insets.
  ///
  /// - Parameters:
  ///   - shape: The shape to be inset.
  ///   - insets: The insets to be applied to the bounding rect.
  public init(shape: S, insets: LayoutEdgeInsets) {
    self.shape = shape
    self.insets = insets
    isZeroInset = insets.isZero()
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    if isZeroInset {
      return shape.path(in: rect)
    } else {
      let newRect = rect.inset(by: insets)
      return shape.path(in: newRect)
    }
  }
}

// MARK: - OffsetableShape

extension InsetShape: OffsetableShape where S: OffsetableShape {

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    let newRect = rect.inset(by: insets)
    return shape.path(in: newRect, offset: offset)
  }
}
