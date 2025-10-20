//
//  LayerBorderWindow.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/14/25.
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

class LayerBorderWindow: NSWindow {

  init() {
    super.init(
      contentRect: NSRect(x: 0, y: 0, width: 800, height: 800),
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
    title = "Layer Border"
    isReleasedWhenClosed = false
    center()

    // setup layer-backed content view
    self.contentView = {
      let contentView = NSView()
      contentView.wantsLayer = true
      contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
      return contentView
    }()

    let contentView = ComposeView {
      VStack(spacing: 10) {
        LayerNode(make: { _ in
          BorderMetalLayerDemoLayer()
        })
        .frame(width: .flexible, height: 300)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 0)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .green]))), offset: 0)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          let borderContentLayer = BaseCALayer()
          borderContentLayer.backgroundColor = Color.yellow.cgColor
          return BorderLayerDemoLayer(borderContent: .layer(borderContentLayer), offset: 0)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), offset: .pixel)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 1)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 10)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 20)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), offset: -10)
        })
        .frame(width: .flexible, height: 200)

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), offset: -20)
        })
        .frame(width: .flexible, height: 200)
      }
      .padding(horizontal: 50)
    }

    self.contentView?.addSubview(contentView)
    contentView.makeFullSizeInSuperView()
  }

  // Show the window.
  func show() {
    makeKeyAndOrderFront(nil)
  }

  // Close without releasing (hide)
  func hide() {
    orderOut(nil)
  }
}

private class BorderMetalLayerDemoLayer: CALayer {

  override init() {
    super.init()

    let metalLayer = BorderMetalLayer()
    metalLayer.frame = CGRect(x: 10, y: 10, width: 250, height: 150)
    self.addSublayer(metalLayer)

    let shape = CombinedShape(
      mainShape: CombinedShape(
        mainShape: SuperEllipse(cornerRadius: 50, roundingCorners: [.topLeft, .bottomRight]),
        subShape: Circle().inset(by: 20),
        mode: .difference
      ),
      subShape: Circle().inset(by: 40),
      mode: .difference
    )

    metalLayer.updateBorder(
      width: 10,
      content: .linearGradient(
        startColor: .red,
        endColor: .blue,
        startPoint: .left,
        endPoint: .right
      ),
      shape: shape
    )

    delay(1) {
      metalLayer.animateFrame(
        to: CGRect(x: 20, y: 30, width: 200, height: 200),
        timing: .spring(response: 2)
      )
    }

    metalLayer.onLiveFrameChange { layer, rect in
      let metalLayer = layer as! BorderMetalLayer // swiftlint:disable:this force_cast

      metalLayer.updateBorder(
        width: 10,
        content: .linearGradient(
          startColor: .red,
          endColor: .blue,
          startPoint: .left,
          endPoint: .right
        ),
        shape: shape,
        bounds: CGRect(origin: .zero, size: rect.size),
        scale: rect.size == layer.bounds.size ? nil : 1
      )
    }

    metalLayer.backgroundColor = Color.yellow.cgColor
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }
}

private class BorderLayerDemoLayer: CALayer {

  private lazy var contentLayer = BaseCALayer()
  private lazy var borderLayer = BorderLayer()

  init(borderContent: BorderLayer.BorderContent, offset: CGFloat) {
    super.init()

    contentLayer.backgroundColor = Color.red.cgColor
    contentLayer.cornerRadius = 30
    contentLayer.cornerCurve = .continuous
    addSublayer(contentLayer)

    borderLayer.borderContent = borderContent
    borderLayer.borderMask = .cornerRadius(contentLayer.cornerRadius, borderWidth: 10, offset: offset)
    addSublayer(borderLayer)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  override func layoutSublayers() {
    super.layoutSublayers()
    contentLayer.frame = bounds.inset(by: 20)
    borderLayer.frame = contentLayer.frame
  }
}
