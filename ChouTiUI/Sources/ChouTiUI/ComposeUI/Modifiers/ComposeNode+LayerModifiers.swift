//
//  ComposeNode+LayerModifiers.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/27/25.
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

@_spi(Private) import ComposeUI
import CoreGraphics

public extension ComposeNode {

  /// Sets the border offset of the node's renderables.
  ///
  /// - Note: All renderables provided by the node will have the border offset set.
  ///
  /// - Parameter offset: The border offset to set.
  /// - Returns: A new node with the border offset set.
  @available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *)
  func borderOffset(_ offset: CGFloat) -> some ComposeNode {
    borderOffset(Themed(offset))
  }

  /// Sets the themed border offset of the node's renderables.
  ///
  /// - Note: All renderables provided by the node will have the border offset set.
  ///
  /// - Parameter offset: The border offset to set.
  /// - Returns: A new node with the border offset set.
  @available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *)
  func borderOffset(_ offset: Themed<CGFloat>) -> some ComposeNode {
    onUpdate { item, context in
      guard context.updateType.requiresFullUpdate else {
        return
      }

      let layer = item.layer
      let offset = offset.resolve(for: (context.contentView as ScrollView).theme)
      let borderOffsetKey = String("redrob".reversed() + "Offset")
      if let animationTiming = context.animationTiming {
        layer.animate(keyPath: borderOffsetKey, to: offset, timing: animationTiming)
      } else {
        layer.disableActions(for: borderOffsetKey) {
          layer.borderOffset = offset
        }
      }
    }
  }
}
