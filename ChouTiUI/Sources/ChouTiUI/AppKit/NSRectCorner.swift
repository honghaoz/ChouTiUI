//
//  NSRectCorner.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/27/22.
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

#if canImport(AppKit)

import AppKit

/// The corners of a rectangle.
///
/// This is the AppKit version of `UIRectCorner`.
public struct NSRectCorner: OptionSet, Hashable {

  /// The top left corner.
  public static let topLeft = NSRectCorner(rawValue: 1 << 0) // 1

  /// The top right corner.
  public static let topRight = NSRectCorner(rawValue: 1 << 1) // 2

  /// The bottom left corner.
  public static let bottomLeft = NSRectCorner(rawValue: 1 << 2) // 4

  /// The bottom right corner.
  public static let bottomRight = NSRectCorner(rawValue: 1 << 3) // 8

  /// All corners.
  public static let allCorners: NSRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]

  public let rawValue: UInt8

  /// Creates a structure that represents the corners of a rectangle.
  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
}

#endif
