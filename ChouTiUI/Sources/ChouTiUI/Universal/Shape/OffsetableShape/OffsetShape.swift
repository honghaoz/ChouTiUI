//
//  OffsetShape.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 5/6/24.
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

/// A shape derived by applying an offset to another shape.
public struct OffsetShape<S: OffsetableShape>: OffsetableShape {

  /// The original shape.
  public let shape: S

  /// The offset amount.
  ///
  /// - Use positive value for outward/bigger path (left path).
  /// - Use negative value for inward/smaller path (right path).
  public let offset: CGFloat

  /// Creates an offset shape.
  ///
  /// - Parameters:
  ///   - shape: The original shape.
  ///   - offset: The offset amount.
  ///             Use positive value for outward/bigger path (left path).
  ///             Use negative value for inward/smaller path (right path).
  public init(shape: S, offset: CGFloat) {
    self.shape = shape
    self.offset = offset
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    shape.path(in: rect, offset: offset)
  }

  // MARK: - OffsetableShape

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    shape.path(in: rect, offset: self.offset + offset)
  }
}
