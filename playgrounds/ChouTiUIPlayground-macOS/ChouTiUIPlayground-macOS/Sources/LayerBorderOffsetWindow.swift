//
//  LayerBorderOffsetWindow.swift
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

import AppKit
import ChouTi
@_spi(Private) import ChouTiUI
@_spi(Private) import ComposeUI

class LayerBorderOffsetWindow: NSWindow {

  private var sliderValue: CGFloat = 0.5 {
    didSet {
      composeView.refresh()
    }
  }

  private lazy var composeView = ComposeView { [weak self] in
    let borderOffset: CGFloat = 200 * ((self?.sliderValue ?? 0) - 0.5)

    ColorNode(.white.opacity(0.2))
      .cornerRadius(16)
      .border(color: .red, width: 4)
      .borderOffset(borderOffset)
      .animation(.easeInEaseOut(duration: 1))
      .overlay {
        LabelNode("Border offset: \(borderOffset.rounded())")
      }
      .overlay {
        LayerNode()
          .cornerRadius(16)
          .border(color: .red.opacity(0.5), width: 4)
      }
      .padding(50)

    HStack {
      LabelNode("Border offset:")
        .offset(y: -2)

      Spacer(width: 8, height: 0)

      ViewNode(make: { [weak self] _ in
        let slider = NSSlider()
        slider.addAction { [weak self] in
          self?.sliderValue = CGFloat($0)
        }
        slider.doubleValue = 0.5
        slider.wantsLayer = true
        return slider
      })
      .frame(width: 200, height: 60)
    }
  }

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
    title = "Layer Border Offset"
    isReleasedWhenClosed = false
    center()

    // setup layer-backed content view
    let contentView = NSView()
    contentView.wantsLayer = true
    contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
    self.contentView = contentView

    contentView.addSubview(composeView)
    composeView.makeFullSizeInSuperView()
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
