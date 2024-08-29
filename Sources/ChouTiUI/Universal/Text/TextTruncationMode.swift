//
//  TextTruncationMode.swift
//
//  Created by Honghao Zhang on 12/24/23.
//  Copyright © 2024 ChouTi. All rights reserved.
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

  case none
  case head
  case tail
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
