//
//  TextTruncationMode.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 12/24/23.
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
#endif

#if canImport(UIKit)
import UIKit
#endif

import QuartzCore

/// Text truncation mode.
public enum TextTruncationMode: Hashable {

  /// No truncation.
  case none

  /// Truncate the text from the head.
  case head

  /// Truncate the text from the tail.
  case tail

  /// Truncate the text from the middle.
  case middle

  /// The line break mode in AppKit/UIKit.
  public var lineBreakMode: NSLineBreakMode {
    switch self {
    case .none:
      return .byClipping
    case .head:
      return .byTruncatingHead
    case .tail:
      return .byTruncatingTail
    case .middle:
      return .byTruncatingMiddle
    }
  }

  /// The text layer truncation mode in Core Animation.
  public var textLayerTruncationMode: CATextLayerTruncationMode {
    switch self {
    case .none:
      return .none
    case .head:
      return .start
    case .tail:
      return .end
    case .middle:
      return .middle
    }
  }
}
