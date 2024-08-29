//
//  LineWrapMode.swift
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

/// Line wrap mode.
public enum LineWrapMode: Hashable {

  case byWord
  case byChar

  /// The line break mode in AppKit/UIKit.
  public var lineBreakMode: NSLineBreakMode {
    switch self {
    case .byWord:
      return .byWordWrapping
    case .byChar:
      return .byCharWrapping
    }
  }
}
