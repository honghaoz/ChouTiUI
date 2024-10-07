//
//  CALayer+DisableImplicitAnimationDelegateTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/6/24.
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

import QuartzCore

import ChouTiTest

import ChouTiUI

final class CALayer_DisableImplicitAnimationDelegateTests: XCTestCase {

  func test_disableImplicitAnimation() {
    // has implicit animations by default
    do {
      let tester = LayerImplicitAnimationTester()

      // wait for the window to be visible
      wait(timeout: 0.05)

      let implicitAnimations = tester.getImplicitAnimations()
      expect(implicitAnimations.compactMap(\.keyPath).sorted()) == ["bounds", "position"]
    }

    // disable implicit animations
    do {
      let tester = LayerImplicitAnimationTester()
      tester.layer.delegate = CALayer.DisableImplicitAnimationDelegate.shared

      // wait for the window to be visible
      wait(timeout: 0.05)

      let implicitAnimations = tester.getImplicitAnimations()
      expect(implicitAnimations.compactMap(\.keyPath).sorted()) == []
    }
  }
}

private class LayerImplicitAnimationTester {

  private let window: Window
  let layer: CALayer

  init() {
    layer = CALayer(frame: CGRect(x: 50, y: 50, width: 100, height: 100))

    #if os(macOS)
    window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
                      styleMask: [.titled, .closable, .miniaturizable, .resizable],
                      backing: .buffered,
                      defer: false)
    window.contentView?.wantsLayer = true
    window.contentView?.layer?.addSublayer(layer)
    #else
    window = UIWindow(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    window.layer.addSublayer(layer)
    #endif
  }

  func getImplicitAnimations() -> [CABasicAnimation] {
    layer.frame = CGRect(x: 10, y: 20, width: 40, height: 20)

    return layer.animationKeys()?.compactMap {
      layer.animation(forKey: $0) as? CABasicAnimation
    } ?? []
  }
}
