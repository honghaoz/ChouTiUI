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
    title = "Layer Shape"
    isReleasedWhenClosed = false
    center()

    overrideTheme = .dark

    // setup layer-backed content view
    let contentView = NSView()
    contentView.wantsLayer = true
    self.contentView = contentView

    addLayerWithShape()
    layerLiveFrame()
    layerLiveFrame2()
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
    layer.backgroundColor = NSColor.red.cgColor
    layer.background = .linearGradient(
      LinearGradientColor([.red, .blue], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))
    )
    layer.frame = CGRect(x: 125, y: 100, width: 50, height: 100)
    contentView?.layer?.addSublayer(layer)

    layer.shape = SuperEllipse(cornerRadius: 16, roundingCorners: [.topLeft, .bottomRight]) // Rectangle(cornerRadius: 16, roundingCorners: [.topLeft, .bottomRight])

    let layer2 = BaseCALayer()
    layer2.isGeometryFlipped = true
    layer2.frame = layer.frame
    layer2.backgroundColor = Color.yellow.cgColor
    contentView?.layer?.insertSublayer(layer2, at: 0)

    onMainAsync(delay: 1) {
      layer.animateFrame(to: CGRect(x: 50, y: 20, width: 100, height: 150), timing: .spring(response: 3))
      layer2.animateFrame(to: CGRect(x: 50, y: 20, width: 100, height: 150), timing: .spring(response: 3))
    }

    onMainAsync(delay: 1.5) {
      layer.animateFrame(to: CGRect(x: 100, y: 10, width: 200, height: 200), timing: .spring(response: 1))
      layer2.animateFrame(to: CGRect(x: 100, y: 10, width: 200, height: 200), timing: .spring(response: 1))
    }

    onMainAsync(delay: 4) {
      layer.animateShape(
        to: SuperEllipse(cornerRadius: 64, roundingCorners: [.topLeft, .bottomRight, .topRight, .bottomLeft]),
        timing: .spring(response: 2)
      )
    }

    onMainAsync(delay: 7) {
      layer.animateShape(
        from: SuperEllipse(cornerRadius: 128, roundingCorners: [.topLeft, .bottomRight, .topRight, .bottomLeft]),
        to: SuperEllipse(cornerRadius: 64, roundingCorners: [.topLeft, .bottomRight, .topRight, .bottomLeft]),
        timing: .spring(response: 2)
      )
    }
  }

  private func layerLiveFrame() {
    let layer = CALayer()
    layer.delegate = CALayer.DisableImplicitAnimationDelegate.shared
    layer.isGeometryFlipped = true
    layer.backgroundColor = NSColor.red.withAlphaComponent(0.8).cgColor
    layer.frame = CGRect(x: 400, y: 100, width: 50, height: 100)
    contentView?.layer?.addSublayer(layer)

    let layer2 = CALayer()
    layer2.delegate = CALayer.DisableImplicitAnimationDelegate.shared
    layer2.isGeometryFlipped = true
    layer2.frame = layer.frame
    layer2.backgroundColor = Color.yellow.cgColor
    contentView?.layer?.insertSublayer(layer2, at: 0)

    onMainAsync(delay: 1) {
      let newSize = CGSize(width: 150, height: 200)
      layer.bounds.size = newSize
      layer.animate(keyPath: "bounds.size", timing: .spring(response: 1), from: { _ in CGSize(width: 50, height: 100) }, to: { _ in newSize })
    }

    layer.onLiveFrameChange { [weak layer2] _, frame in
      print("frame: \(frame)")
      layer2?.frame = frame
    }
  }

  private func layerLiveFrame2() {
    let layer = CALayer()
    layer.isGeometryFlipped = true
    layer.backgroundColor = NSColor.red.withAlphaComponent(0.8).cgColor
    layer.frame = CGRect(x: 600, y: 100, width: 50, height: 100)
    contentView?.layer?.addSublayer(layer)

    let layer2 = CALayer()
    layer2.delegate = CALayer.DisableImplicitAnimationDelegate.shared
    layer2.isGeometryFlipped = true
    layer2.frame = layer.frame
    layer2.backgroundColor = Color.yellow.cgColor
    contentView?.layer?.insertSublayer(layer2, at: 0)

    onMainAsync(delay: 1) {
      let newSize = CGSize(width: 150, height: 200)
      layer.bounds.size = newSize
    }

    layer.onLiveFrameChange { [weak layer2] _, frame in
      print("frame2: \(frame)")
      layer2?.frame = frame
    }
  }
}
