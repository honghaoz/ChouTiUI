//
//  UnifiedColorNodeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/13/25.
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

class UnifiedColorNodeTests: XCTestCase {

  func test_init() {
    _ = UnifiedColorNode(ThemedUnifiedColor(.red))
    _ = UnifiedColorNode(UnifiedColor.color(.red))
    _ = UnifiedColorNode(.red)
    _ = UnifiedColorNode(LinearGradientColor.clearGradientColor)
    _ = UnifiedColorNode(AngularGradientColor.clearGradientColor)
    _ = UnifiedColorNode(RadialGradientColor.clearGradientColor)
    _ = UnifiedColorNode(light: .red, dark: .blue)
    _ = UnifiedColorNode(light: LinearGradientColor.clearGradientColor, dark: LinearGradientColor.clearGradientColor)
    _ = UnifiedColorNode(light: AngularGradientColor.clearGradientColor, dark: AngularGradientColor.clearGradientColor)
    _ = UnifiedColorNode(light: RadialGradientColor.clearGradientColor, dark: RadialGradientColor.clearGradientColor)
  }

  func test_noRenderable() {
    var calledRenderable: Renderable?
    let view = ComposeView {
      Spacer(width: 0, height: 1)
      UnifiedColorNode(ThemedUnifiedColor(.red))
        .animation(.easeInEaseOut(duration: 1))
        .onUpdate { renderable, _ in
          calledRenderable = renderable
        }
    }

    view.refresh()
    expect(calledRenderable) == nil
  }

  func test_renderable() throws {
    var calledRenderable: Renderable?
    var calledContext: RenderableUpdateContext?
    let view = ComposeView {
      UnifiedColorNode(ThemedUnifiedColor(.red))
        .animation(.easeInEaseOut(duration: 1))
        .onUpdate { renderable, context in
          calledRenderable = renderable
          calledContext = context
        }
    }

    view.frame.size = CGSize(width: 100, height: 100)
    view.refresh()

    expect(try (calledRenderable.unwrap()).layer.background) == UnifiedColor.color(.red)
    expect(try (calledContext.unwrap()).animationTiming) == nil

    view.refresh()
    expect(try (calledContext.unwrap()).animationTiming) == .easeInEaseOut(duration: 1)
  }
}
