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

    VStack {
      Spacer()

      HStack(spacing: 48) {
        // direct layer
        ColorNode(.white.opacity(0.2))
          .cornerRadius(16)
          .border(color: .red, width: 4)
          .map {
            if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
              $0.borderOffset(borderOffset)
            } else {
              $0
            }
          }
          .animation(.easeInEaseOut(duration: 1))
          .frame(width: .flexible, height: 120)
          .overlay {
            LabelNode("CALayer.borderOffset")
              .font(.systemFont(ofSize: 12, weight: .semibold))
              .textColor(.white)
          }
          .overlay {
            LayerNode()
              .cornerRadius(16)
              .border(color: .red.opacity(0.5), width: 4)
          }

        // BorderLayer with borderOffset
        LayerNode(make: { _ in
          BorderLayerOffsetDemoLayer(variant: .cornerRadiusOffset, borderOffset: borderOffset)
        }, update: { layer, _ in
          layer.demoOffset = borderOffset
        })
        .frame(width: .flexible, height: 120)
        .overlay {
          LabelNode("BorderLayer.cornerRadius(offset:)")
            .font(.systemFont(ofSize: 12, weight: .semibold))
            .textColor(.white)
        }

        // BorderLayer with mask
        LayerNode(make: { _ in
          BorderLayerOffsetDemoLayer(variant: .shapeMask, borderOffset: borderOffset)
        }, update: { layer, _ in
          layer.demoOffset = borderOffset
        })
        .frame(width: .flexible, height: 120)
        .overlay {
          LabelNode("BorderLayer.shape(Rectangle, offset:)")
            .font(.systemFont(ofSize: 12, weight: .semibold))
            .textColor(.white)
        }
      }
      .padding(horizontal: 48)

      Spacer()
    }

    LabelNode("Border offset: \(borderOffset.rounded())")
      .textColor(.white)

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
      contentRect: NSRect(x: 0, y: 0, width: 1024, height: 512),
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

private final class BorderLayerOffsetDemoLayer: CALayer {

  enum Variant {
    case cornerRadiusOffset
    case shapeMask
  }

  private let variant: Variant
  private let contentLayer = CALayer()
  private let referenceLayer = CALayer()
  private let borderLayer = BorderLayer()

  var demoOffset: CGFloat {
    didSet {
      updateBorderMask()
    }
  }

  init(variant: Variant, borderOffset: CGFloat) {
    self.variant = variant
    self.demoOffset = borderOffset
    super.init()

    contentLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    contentLayer.backgroundColor = Color.white.opacity(0.2).cgColor
    addSublayer(contentLayer)

    referenceLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    referenceLayer.borderColor = Color.red.opacity(0.5).cgColor
    referenceLayer.borderWidth = 4
    addSublayer(referenceLayer)

    borderLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    borderLayer.borderContent = .color(.red)
    borderLayer.borderWidth = 4
    addSublayer(borderLayer)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  override func layoutSublayers() {
    super.layoutSublayers()

    let cornerRadius: CGFloat = 16

    contentLayer.frame = bounds
    contentLayer.cornerRadius = cornerRadius
    contentLayer.cornerCurve = .continuous

    referenceLayer.frame = bounds
    referenceLayer.cornerRadius = cornerRadius
    referenceLayer.cornerCurve = .continuous

    borderLayer.frame = bounds

    updateBorderMask(cornerRadius: cornerRadius)
  }

  private func updateBorderMask(cornerRadius: CGFloat = 16) {
    switch variant {
    case .cornerRadiusOffset:
      if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
        borderLayer.borderMask = .cornerRadius(cornerRadius, offset: demoOffset)
      } else {
        borderLayer.borderMask = .shape(Rectangle(cornerRadius: cornerRadius), offset: demoOffset)
      }
    case .shapeMask:
      borderLayer.borderMask = .shape(Rectangle(cornerRadius: cornerRadius), offset: demoOffset)
    }
    borderLayer.setNeedsLayout()
  }
}
