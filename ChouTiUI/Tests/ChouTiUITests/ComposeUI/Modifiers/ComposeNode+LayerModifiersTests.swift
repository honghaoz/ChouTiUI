//
//  ComposeNode+LayerModifiersTests.swift
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest

import ChouTiUI
import ComposeUI

class ComposeNode_LayerModifiersTests: XCTestCase {

  // MARK: - Border Offset

  @available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *)
  func test_borderOffset() {
    // normal border offset value
    do {
      var layer: CALayer?
      let contentView = ComposeView {
        LayerNode()
          .borderOffset(5.0)
          .onInsert { renderable, _ in
            layer = renderable.layer
          }
      }

      contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
      contentView.refresh()

      expect(layer?.borderOffset) == 5.0
    }

    // themed border offset
    do {
      var layer: CALayer?
      let themedBorderOffset = Themed<CGFloat>(light: 8.0, dark: 3.0)
      let contentView = ComposeView {
        LayerNode()
          .borderOffset(themedBorderOffset)
          .onInsert { renderable, _ in
            layer = renderable.layer
          }
      }

      contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

      (contentView as ScrollView).overrideTheme = .light
      contentView.refresh()
      expect(layer?.borderOffset) == 8.0

      (contentView as ScrollView).overrideTheme = .dark
      contentView.refresh()
      expect(layer?.borderOffset) == 3.0
    }

    // multiple modifiers (last one wins)
    do {
      var layer: CALayer?
      let contentView = ComposeView {
        LayerNode()
          .borderOffset(3.0)
          .borderOffset(7.0) // this should win
          .onInsert { renderable, _ in
            layer = renderable.layer
          }
      }

      contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
      contentView.refresh()

      expect(layer?.borderOffset) == 7.0
    }

    // with animation
    do {
      var layer: CALayer?
      let contentView = ComposeView {
        LayerNode()
          .borderOffset(6.0)
          .animation(.easeInEaseOut(duration: 1))
          .onUpdate { renderable, context in
            layer = renderable.layer
          }
      }

      contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
      contentView.refresh(animated: true)
      contentView.refresh(animated: true)

      expect(layer?.borderOffset) == 6.0
      expect(layer?.animationKeys()?.contains("borderOffset")) == true
    }

    // early return when requiresFullUpdate is false
    do {
      var layer: CALayer?
      var borderOffset: CGFloat = 2

      let contentView = ComposeView {
        LayerNode()
          .borderOffset(borderOffset)
          .onUpdate { renderable, context in
            layer = renderable.layer
          }
      }

      contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
      contentView.refresh() // initial refresh

      expect(layer?.borderOffset) == 2

      // bounds change should not set new border offset
      borderOffset = 5
      contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
      contentView.setNeedsLayout()
      contentView.layoutIfNeeded()

      expect(layer?.borderOffset) == 2

      // refresh should set new border offset
      borderOffset = 5
      contentView.refresh()

      expect(layer?.borderOffset) == 5
    }
  }
}
