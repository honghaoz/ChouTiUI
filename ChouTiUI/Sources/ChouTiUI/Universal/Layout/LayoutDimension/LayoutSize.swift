//
//  LayoutSize.swift
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

/// A type represents a size using LayoutDimension.
public struct LayoutSize: Equatable, Sendable {

  /// The zero size.
  public static let zero: LayoutSize = LayoutSize(.absolute(0), .absolute(0))

  /// The full size.
  public static let full: LayoutSize = LayoutSize(.relative(1), .relative(1))

  /// The width.
  public let width: LayoutDimension

  /// The height.
  public let height: LayoutDimension

  /// Initializes a size with the given width and height.
  ///
  /// - Parameters:
  ///   - width: The width.
  ///   - height: The height.
  public init(_ width: LayoutDimension, _ height: LayoutDimension) {
    self.width = width
    self.height = height
  }

  /// Initializes a size with the given width and height.
  ///
  /// - Parameters:
  ///   - width: The width.
  ///   - height: The height.
  public init(width: LayoutDimension, height: LayoutDimension) {
    self.width = width
    self.height = height
  }

  /// Initializes an absolute size with the given width and height.
  ///
  /// - Parameters:
  ///   - width: The absolute width.
  ///   - height: The absolute height.
  public init(width: CGFloat, height: CGFloat) {
    self.width = .absolute(width)
    self.height = .absolute(height)
  }

  /// Returns a Boolean value indicating whether the size has zero width and height.
  public func isZero() -> Bool {
    width.isZero() && height.isZero()
  }

  /// Returns a CGSize with the given container size.
  ///
  /// - Parameters:
  ///   - size: The size of the container.
  public func cgSize(from size: CGSize) -> CGSize {
    CGSize(width: width.length(from: size.width), height: height.length(from: size.height))
  }
}
