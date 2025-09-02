//
//  LayerShapeWindow.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/30/25.
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

class LayerShapeWindow: NSWindow {

  init() {
    super.init(
      contentRect: NSRect(x: 0, y: 0, width: 800, height: 300),
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
    title = "Layer Shape Window"
    isReleasedWhenClosed = false
    center()

    // setup layer-backed content view
    let contentView = NSView()
    contentView.wantsLayer = true
    contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
    self.contentView = contentView

    addLayerWithShape()
  }

  // Show the window.
  func show() {
    makeKeyAndOrderFront(nil)
  }

  // Close without releasing (hide)
  func hide() {
    orderOut(nil)
  }

  private func addLayerWithShape() {
    let layer = BaseCALayer()
    layer.isGeometryFlipped = true
    // layer.borderColor = NSColor.black.cgColor
    // layer.borderWidth = 1
    layer.backgroundColor = NSColor.red.cgColor
    layer.background = .linearGradient(
      LinearGradientColor([.red, .blue], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))
    )
    layer.frame = CGRect(x: 25, y: 50, width: 50, height: 100)
    contentView?.layer?.addSublayer(layer)

    layer.shape = SuperEllipse(cornerRadius: 16, roundingCorners: [.topLeft, .bottomRight]) // Rectangle(cornerRadius: 16, roundingCorners: [.topLeft, .bottomRight])

    let layer2 = BaseCALayer()
    layer2.isGeometryFlipped = true
    layer2.frame = layer.frame
    layer2.backgroundColor = Color.yellow.cgColor
    contentView?.layer?.insertSublayer(layer2, at: 0)

    onMainAsync(delay: 1) {
      layer.animateFrame(to: CGRect(x: 100, y: 20, width: 500, height: 150), timing: .spring(response: 3))
      layer2.animateFrame(to: CGRect(x: 100, y: 20, width: 500, height: 150), timing: .spring(response: 3))

//      layer.animateFrame(to: CGRect(x: 100, y: 20, width: 500, height: 150), timing: .easeInEaseOut(duration: 1))
//      layer2.animateFrame(to: CGRect(x: 100, y: 20, width: 500, height: 150), timing: .easeInEaseOut(duration: 1))
    }

    onMainAsync(delay: 1.5) {
      layer.animateFrame(to: CGRect(x: 50, y: 10, width: 200, height: 200), timing: .spring(response: 1))
      layer2.animateFrame(to: CGRect(x: 50, y: 10, width: 200, height: 200), timing: .spring(response: 1))

//      layer.animateFrame(to: CGRect(x: 50, y: 10, width: 200, height: 200), timing: .easeInEaseOut(duration: 0.5))
//      layer2.animateFrame(to: CGRect(x: 50, y: 10, width: 200, height: 200), timing: .easeInEaseOut(duration: 0.5))
    }

    onMainAsync(delay: 3) {
      layer.shape = Capsule()
    }
  }
}
