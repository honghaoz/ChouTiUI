//
//  View+Layer.swift
//
//  Created by Honghao Zhang on 1/6/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTi

public extension View {

  /// Get the backing CALayer.
  ///
  /// - Warning: On macOS, the view should be layer-backed (set `wantsLayer = true`). Accessing `layer` without setting `wantsLayer = true` will trigger an assertion.
  func layer() -> CALayer? {
    #if !os(macOS)
    return layer
    #else
    ChouTi.assert(layer != nil, "NSView should set `wantsLayer == true`.")
    return layer
    #endif
  }

  /// Get the backing CALayer.
  ///
  /// - Warning: On macOS, the view should be layer-backed (set `wantsLayer = true`). Accessing `unsafeLayer` without setting `wantsLayer = true` will crash.
  var unsafeLayer: CALayer {
    #if !os(macOS)
    return layer
    #else
    ChouTi.assert(layer != nil, "NSView should set `wantsLayer == true`.")
    return layer.unsafelyUnwrapped
    #endif
  }
}
