//
//  LayoutEdgeInsets.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/6/21.
//  Copyright © 2020 Honghao Zhang (github.com/honghaoz).
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

/// A type represents edge insets using LayoutDimension.
public struct LayoutEdgeInsets: Hashable, Sendable {

  /// The zero edge insets.
  public static let zero = LayoutEdgeInsets(0)

  /// The top edge inset.
  public let top: LayoutDimension

  /// The left edge inset.
  public let left: LayoutDimension

  /// The bottom edge inset.
  public let bottom: LayoutDimension

  /// The right edge inset.
  public let right: LayoutDimension

  /// Initializes an edge insets with the given top, left, bottom, and right edge insets.
  ///
  /// - Parameters:
  ///   - top: The top edge inset.
  ///   - left: The left edge inset.
  ///   - bottom: The bottom edge inset.
  ///   - right: The right edge inset.
  public init(top: LayoutDimension,
              left: LayoutDimension,
              bottom: LayoutDimension,
              right: LayoutDimension)
  {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  /// Initializes an edge insets with the given top, left, bottom, and right edge insets.
  ///
  /// - Parameters:
  ///   - top: The top edge inset.
  ///   - left: The left edge inset.
  ///   - bottom: The bottom edge inset.
  ///   - right: The right edge inset.
  public init(_ top: LayoutDimension,
              _ left: LayoutDimension,
              _ bottom: LayoutDimension,
              _ right: LayoutDimension)
  {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  /// Initializes an edge insets with the same amount for all edges.
  ///
  /// - Parameters:
  ///   - amount: The amount of the edge inset.
  public init(_ amount: CGFloat) {
    self.top = .absolute(amount)
    self.left = .absolute(amount)
    self.bottom = .absolute(amount)
    self.right = .absolute(amount)
  }

  /// Initializes an edge insets with the given edge insets.
  ///
  /// - Parameters:
  ///   - edgeInsets: The edge insets.
  public init(edgeInsets: EdgeInsets) {
    self.init(
      top: .absolute(edgeInsets.top),
      left: .absolute(edgeInsets.left),
      bottom: .absolute(edgeInsets.bottom),
      right: .absolute(edgeInsets.right)
    )
  }

  /// Returns a Boolean value indicating whether the edge insets is zero.
  public func isZero() -> Bool {
    top.isZero() && left.isZero() && bottom.isZero() && right.isZero()
  }

  /// Returns the edge insets from the given container size.
  ///
  /// - Parameters:
  ///   - cgSize: The container size.
  /// - Returns: The edge insets.
  public func edgeInsets(from containerSize: CGSize) -> EdgeInsets {
    let left = left.length(from: containerSize.width)
    let right = right.length(from: containerSize.width)
    let top = top.length(from: containerSize.height)
    let bottom = bottom.length(from: containerSize.height)
    return EdgeInsets(top: top, left: left, bottom: bottom, right: right)
  }
}
