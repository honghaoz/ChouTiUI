//
//  Layout.Alignment+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/15/21.
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

/// The alignment of a subcomponent relative to its parent.
public extension Layout.Alignment {

  /// Flips the alignment vertically.
  ///
  /// This is useful for `NSWindow` coordinates (bottom-left zero origin).
  func verticallyFlipped() -> Layout.Alignment {
    switch self {
    case .center:
      return .center
    case .left:
      return .left
    case .right:
      return .right
    case .top:
      return .bottom
    case .bottom:
      return .top
    case .topLeft:
      return .bottomLeft
    case .topRight:
      return .bottomRight
    case .bottomLeft:
      return .topLeft
    case .bottomRight:
      return .topRight
    }
  }
}
