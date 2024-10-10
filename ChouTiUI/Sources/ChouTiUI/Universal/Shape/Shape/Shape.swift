//
//  Shape.swift
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
import QuartzCore

import ChouTi

/// A type that can provide a shape path.
public protocol Shape: Hashable, TypeEraseWrapperBaseType {

  /// Returns the shape path for the bounding rect.
  ///
  /// - Parameter rect: The bounding rect.
  /// - Returns: The shape path.
  func path(in rect: CGRect) -> CGPath

  /// Returns `true` if two shapes are equal.
  ///
  /// - Parameter shape: Any other shape.
  /// - Returns: `true` if two shapes are equal.
  func isEqual(to shape: any Shape) -> Bool

  /// Add this shape with another shape.
  ///
  /// - Parameter other: The other shape to add.
  /// - Returns: A new shape with the other shape added.
  func adding<S: Shape>(_ other: S) -> CombinedShape<Self, S>

  /// Difference this shape with another shape.
  ///
  /// - Parameter other: The other shape to difference.
  /// - Returns: A new shape with the other shape differenced.
  func differencing<S: Shape>(_ other: S) -> CombinedShape<Self, S>
}

// MARK: - Default implementation

public extension Shape {

  func isEqual(to shape: any Shape) -> Bool {
    self.eraseToAnyShape() == shape.eraseToAnyShape()
  }

  func adding<S: Shape>(_ other: S) -> CombinedShape<Self, S> {
    CombinedShape(mainShape: self, subShape: other, mode: .add)
  }

  func differencing<S: Shape>(_ other: S) -> CombinedShape<Self, S> {
    CombinedShape(mainShape: self, subShape: other, mode: .difference)
  }
}

// MARK: - isEqual for Optional Shape

public extension Shape? {

  /// Compares `Shape?` with `Shape?`.
  func isEqual(to shape: (any Shape)?) -> Bool {
    switch (self, shape) {
    case (.none, .none):
      return true
    case (.none, .some):
      return false
    case (.some, .none):
      return false
    case (.some(let lShape), .some(let rShape)):
      return lShape.isEqual(to: rShape)
    }
  }
}
