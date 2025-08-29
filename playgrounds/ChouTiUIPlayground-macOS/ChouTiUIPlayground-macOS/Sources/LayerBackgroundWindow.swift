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
    title = "Layer Background Window"
    isReleasedWhenClosed = false
    center()

    // setup layer-backed content view
    let contentView = NSView()
    contentView.wantsLayer = true
    contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
    self.contentView = contentView

    addLayerWithBackground()
    addLayerWithBackground2()
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

    onMainAsync(delay: 1) {
      layer.animateBackground(from: nil, to: .color(.orange), timing: .easeInEaseOut(duration: 2))

      // layer.animateBackground(from: .color(.red), to: .color(.blue), timing: .easeInEaseOut(duration: 2))

      // layer.animateBackground(
      //   from: .color(.red),
      //   to: .linearGradient(LinearGradientColor([.red, .blue, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   timing: .easeInEaseOut(duration: 2)
      // )

      // layer.animateBackground(
      //   from: .linearGradient(LinearGradientColor([.red, .blue, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   to: .color(.red),
      //   timing: .easeInEaseOut(duration: 2)
      // )

      // layer.animateBackground(
      //   from: .linearGradient(LinearGradientColor([.red, .blue, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   to: .linearGradient(LinearGradientColor([.blue, .yellow, .red], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   timing: .easeInEaseOut(duration: 2)
      // )

      // layer.animateBackground(
      //   from: .linearGradient(LinearGradientColor([.red, .blue], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   to: .linearGradient(LinearGradientColor([.red, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   timing: .easeInEaseOut(duration: 3)
      // )

      // layer.animateBackground(
      //   from: .linearGradient(LinearGradientColor([.red, .blue], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   to: .linearGradient(LinearGradientColor([.red, .blue, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   timing: .easeInEaseOut(duration: 3)
      // )

      // layer.animateBackground(
      //   from: .linearGradient(LinearGradientColor([.red, .orange, .yellow, .green], [0, 0.5, 1, 1], UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   to: .linearGradient(LinearGradientColor([.red, .orange, .yellow, .green], [0, 0.25, 0.5, 1], UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   timing: .easeInEaseOut(duration: 3)
      // )

      // layer.animateBackground(
      //   from: .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .topRight)),
      //   to: nil,
      //   timing: .easeInEaseOut(duration: 3)
      // )

      // layer.animateBackground(
      //   from: .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .topRight)),
      //   to: .linearGradient(LinearGradientColor([.red, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))),
      //   timing: .easeInEaseOut(duration: 3)
      // )
    }

    onMainAsync(delay: 3.4) {
      layer.animateBackground(
        to: .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .topRight)),
        timing: .easeInEaseOut(duration: 2.5)
      )
    }

    onMainAsync(delay: 1) {
      layer.animateFrame(to: CGRect(x: 100, y: 20, width: 100, height: 150), timing: .spring(response: 2))
    }

    onMainAsync(delay: 1.5) {
      layer.animateFrame(to: CGRect(x: 25, y: 100, width: 50, height: 100), timing: .spring(response: 2))
    }

    onMainAsync(delay: 5) {
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

    onMainAsync(delay: 5.5) {
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
    // test that removing the animation gradient layer won't create animation artifact.

    let layer = CALayer()
    layer.borderColor = NSColor.black.cgColor
    layer.borderWidth = 1
    layer.background = .color(.orange)
    layer.frame = CGRect(x: 200, y: 50, width: 50, height: 100)
    contentView?.layer?.addSublayer(layer)

    layer.animateBackground(
      to: .angularGradient(AngularGradientColor(colors: [.red, .blue], centerPoint: .center, aimingPoint: .topRight)),
      timing: .easeInEaseOut(duration: 1)
    )

    layer.animate(
      keyPath: "bounds.size",
      timing: .linear(duration: 2),
      from: { layer in layer.bounds.size },
      to: { _ in CGSize(width: 100, height: 20) }
    )
  }
}
