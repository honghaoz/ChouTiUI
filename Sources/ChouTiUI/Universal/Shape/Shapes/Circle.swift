//
//  Circle.swift
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

import ChouTi

public extension Shape where Self == Circle {

  static var circle: Circle { Circle.circle }
}

/// A circle shape.
public struct Circle: Shape, OffsetableShape {

  static let circle = Circle()

  /// Creates a circle shape.
  public init() {}

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    CGPath(ellipseIn: rect, transform: nil)
  }

  // MARK: - OffsetableShape

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    path(in: rect.expanded(by: offset))
  }
}
