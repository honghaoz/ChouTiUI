//
//  LayerBackgroundWindow.swift
//  ChouTiUI
//
//  Created by Honghao on 7/7/25.
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

import AppKit
import ChouTi
@_spi(Private) import ChouTiUI
@_spi(Private) import ComposeUI

class LayerBackgroundWindow: NSWindow {

  init() {
    super.init(
      contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )

    print("\(self) initialized")

    setupWindow()
  }

  deinit {
    print("\(self) deallocated")
  }

  private func setupWindow() {
    title = "Layer Background"
    isReleasedWhenClosed = false
    center()

    // setup layer-backed content view
    let contentView = NSView()
    contentView.wantsLayer = true
    contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
    self.contentView = contentView

    addLayerWithBackground()
    addLayerWithBackground2()
    addLayerWithBackground3()
  }

  // Show the window.
  func show() {
    makeKeyAndOrderFront(nil)
  }

  // Close without releasing (hide)
  func hide() {
    orderOut(nil)
  }

  private func addLayerWithBackground() {
    let layer = CALayer()
    layer.borderColor = NSColor.black.cgColor
    layer.borderWidth = 1
    layer.background = .linearGradient(
      LinearGradientColor([.red, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))
    )
    layer.frame = CGRect(x: 25, y: 50, width: 50, height: 100)
    contentView?.layer?.addSublayer(layer)

    delay(1) {
      // gradient -> solid
      // animate frame additively
      layer.animateBackground(from: nil, to: .color(.orange), timing: .easeInEaseOut(duration: 2))
      layer.animateFrame(to: CGRect(x: 100, y: 20, width: 100, height: 150), timing: .spring(response: 2))
    }
    .then(delay: 0.5) {
      // animate frame additively again
      layer.animateFrame(to: CGRect(x: 25, y: 100, width: 50, height: 100), timing: .spring(response: 2))
    }
    .then(delay: 3) {
      // animation from solid to gradient
      layer.animateBackground(
        to: .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .topRight)),
        timing: .easeInEaseOut(duration: 2.5)
      )
    }
    .then(delay: 0.5) {
      // animate frame non-additively
      let targetFrame = CGRect(x: 50, y: 20, width: 100, height: 50)
      layer.animate(
        keyPath: "position",
        timing: .spring(response: 2),
        from: { layer in layer.position },
        to: { layer in layer.position(from: targetFrame) }
      )
      layer.animate(
        keyPath: "bounds.size",
        timing: .spring(response: 2),
        from: { layer in layer.bounds.size },
        to: { _ in targetFrame.size }
      )
    }
    .then(delay: 0.5) {
      // animate frame non-additively again, which interrupts the previous animation
      let targetFrame = CGRect(x: 100, y: 60, width: 50, height: 100)
      layer.animate(
        keyPath: "position",
        timing: .spring(response: 2),
        from: { layer in layer.presentation()!.position }, // swiftlint:disable:this force_unwrapping
        to: { layer in layer.position(from: targetFrame) }
      )
      layer.animate(
        keyPath: "bounds.size",
        timing: .spring(response: 2),
        from: { layer in layer.presentation()!.bounds.size }, // swiftlint:disable:this force_unwrapping
        to: { _ in targetFrame.size }
      )
    }
  }

  private func addLayerWithBackground2() {
    let layer = CALayer()
    layer.borderColor = NSColor.black.cgColor
    layer.borderWidth = 1
    layer.background = .color(.orange)
    layer.frame = CGRect(x: 200, y: 20, width: 50, height: 100)
    contentView?.layer?.addSublayer(layer)

    // animate to gradient color with 1 second duration
    layer.animateBackground(
      to: .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .topRight)),
      timing: .easeInEaseOut(duration: 1)
    )

    // animate frame with 2 seconds duration
    // test that when the underlying animation gradient layer is removed while the frame animation is in progress, no animation artifact is created
    layer.animate(
      keyPath: "bounds.size",
      timing: .linear(duration: 2),
      from: { layer in layer.bounds.size },
      to: { _ in CGSize(width: 100, height: 20) }
    )
  }

  private func addLayerWithBackground3() {
    let layer = CALayer()
    layer.borderColor = NSColor.black.cgColor
    layer.borderWidth = 1
    layer.background = .color(.orange)
    layer.frame = CGRect(x: 200, y: 150, width: 100, height: 50)
    contentView?.layer?.addSublayer(layer)

    delay(1) {
      // solid to gradient
      layer.animateBackground(from: .color(.orange), to: .angularGradient(AngularGradientColor(colors: [.green, .red, .blue], centerPoint: .center, aimingPoint: .topRight)), timing: .easeInEaseOut(duration: 2))
      layer.animateFrame(to: CGRect(x: 250, y: 200, width: 150, height: 75), timing: .spring(response: 2))
    }
    .then(delay: 2) {
      // gradient to gradient
      layer.animateBackground(to: .angularGradient(AngularGradientColor(colors: [.red, .blue, .yellow], centerPoint: .center, aimingPoint: .topRight)), timing: .easeInEaseOut(duration: 2))
      layer.animateFrame(to: CGRect(x: 200, y: 150, width: 100, height: 50), timing: .spring(response: 2))
    }
    .then(delay: 1) {
      // gradient to solid
      layer.animateBackground(to: .color(.orange), timing: .easeInEaseOut(duration: 2))
      layer.animateFrame(to: CGRect(x: 200, y: 150, width: 100, height: 50), timing: .spring(response: 2))
    }
  }
}
