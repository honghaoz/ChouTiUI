//
//  LayoutRect.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/2/22.
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
import Foundation

/// A type represents a rectangle using LayoutDimension.
public struct LayoutRect: Equatable, Sendable {

  /// The zero rectangle, with zero origin and zero size.
  public static let zero: LayoutRect = LayoutRect(.zero, .zero)

  /// The origin of the rectangle.
  public let origin: LayoutPoint

  /// The size of the rectangle.
  public let size: LayoutSize

  /// Initializes a rectangle with the given origin and size.
  ///
  /// - Parameters:
  ///   - origin: The origin of the rectangle.
  ///   - size: The size of the rectangle.
  public init(_ origin: LayoutPoint, _ size: LayoutSize) {
    self.origin = origin
    self.size = size
  }

  /// Initializes a rectangle with the given origin and size.
  ///
  /// - Parameters:
  ///   - origin: The origin of the rectangle.
  ///   - size: The size of the rectangle.
  public init(origin: LayoutPoint, size: LayoutSize) {
    self.origin = origin
    self.size = size
  }

  /// Returns a Boolean value indicating whether the rectangle has zero origin and zero size.
  public func isZero() -> Bool {
    origin.isZero() && size.isZero()
  }

  /// Returns a CGRect with the given container size.
  ///
  /// - Parameters:
  ///   - size: The size of the container.
  public func cgRect(from size: CGSize) -> CGRect {
    CGRect(origin: origin.cgPoint(from: size), size: self.size.cgSize(from: size))
  }
}
