//
//  AnyOffsetableShape.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 5/7/24.
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

/// A concrete type-erased `OffsetableShape`.
///
/// This type is useful when you need to store an `OffsetableShape` in a container that doesn't support generic types.
public struct AnyOffsetableShape: OffsetableShape, TypeEraseWrapper {

  /// The wrapped shape.
  public let wrapped: any OffsetableShape

  private let wrappedAsHashable: AnyHashable

  /// Creates a type-erased `OffsetableShape`.
  ///
  /// - Parameter shape: The shape to wrap.
  public init(_ shape: some OffsetableShape) {
    if let anyShape = shape as? AnyOffsetableShape { // avoid redundant wrapping
      self.wrapped = anyShape.wrapped
      self.wrappedAsHashable = anyShape.wrappedAsHashable
    } else {
      self.wrapped = shape
      self.wrappedAsHashable = AnyHashable(shape)
    }
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    wrapped.path(in: rect)
  }

  public func isEqual(to shape: any Shape) -> Bool {
    wrapped.isEqual(to: shape)
  }

  // MARK: - OffsetableShape

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    wrapped.path(in: rect, offset: offset)
  }

  // MARK: - Hashable

  public func hash(into hasher: inout Hasher) {
    hasher.combine(wrappedAsHashable)
  }

  // MARK: - Equatable

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.wrappedAsHashable == rhs.wrappedAsHashable
  }
}

public extension OffsetableShape {

  /// Returns a type-erased `AnyOffsetableShape` for this shape.
  @inlinable
  @inline(__always)
  func eraseToAnyOffsetableShape() -> AnyOffsetableShape {
    AnyOffsetableShape(self)
  }
}
