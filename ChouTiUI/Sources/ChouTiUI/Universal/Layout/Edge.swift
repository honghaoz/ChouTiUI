//
//  Edge.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/18/22.
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

import Foundation

#if canImport(AppKit)
import AppKit
#endif

/// A type indicates one edge of a rectangle.
public enum Edge: Sendable {

  case top
  case left
  case bottom
  case right

  /// Flips the edge vertically.
  ///
  /// This is useful for `NSWindow` coordinates (bottom-left zero origin).
  public func flipped() -> Edge {
    switch self {
    case .top:
      return .bottom
    case .left:
      return .right
    case .bottom:
      return .top
    case .right:
      return .left
    }
  }

  #if canImport(AppKit)
  /// Converts the edge to `NSRectEdge`.
  ///
  /// Used in `NSPopover`.
  public var rectEdge: NSRectEdge {
    switch self {
    case .top:
      return .minY
    case .left:
      return .minX
    case .bottom:
      return .maxY
    case .right:
      return .maxX
    }
  }
  #endif
}
