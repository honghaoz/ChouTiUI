//
//  LayerBorderShapeChangeWindow.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/28/26.
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

/// Demonstrates `BorderLayer` shape-mask path refresh in two situations:
///
/// 1. Shape-only change (no size animation): path should update immediately.
/// 2. Animated size change: path should follow the live frame via `onLiveFrameChange`, not snap to the final geometry at animation start.
class LayerBorderShapeChangeWindow: NSWindow {

  private enum DemoShape: Int, CaseIterable {
    case rectangle
    case roundedRectangle
    case ellipse
    case capsule
    case circle
    case superEllipse

    var title: String {
      switch self {
      case .rectangle:
        return "Rectangle"
      case .roundedRectangle:
        return "Rounded Rect"
      case .ellipse:
        return "Ellipse"
      case .capsule:
        return "Capsule"
      case .circle:
        return "Circle"
      case .superEllipse:
        return "SuperEllipse"
      }
    }

    var shape: any Shape {
      switch self {
      case .rectangle:
        return Rectangle(cornerRadius: 0)
      case .roundedRectangle:
        return Rectangle(cornerRadius: 28)
      case .ellipse:
        return Ellipse()
      case .capsule:
        return Capsule()
      case .circle:
        return Circle()
      case .superEllipse:
        return SuperEllipse(cornerRadius: 40, roundingCorners: [.topLeft, .bottomRight])
      }
    }
  }

  private var selectedShape: DemoShape = .roundedRectangle {
    didSet {
      composeView.refresh()
    }
  }

  /// Fixed offset so shape-only changes keep offset constant.
  private let demoOffset: CGFloat = -8

  private lazy var composeView = ComposeView { [weak self] in
    let selectedShape = self?.selectedShape ?? .roundedRectangle
    let demoOffset = self?.demoOffset ?? -8

    VStack(spacing: 20) {
      Spacer()

      LayerNode(make: { _ in
        BorderLayerShapeChangeDemoLayer(shape: selectedShape.shape, offset: demoOffset)
      }, update: { layer, _ in
        layer.demoShape = selectedShape.shape
        layer.demoOffset = demoOffset
      })
      .frame(width: 360, height: 220)
      .overlay {
        LabelNode("BorderLayer.shape(\(selectedShape.title), offset: \(Int(demoOffset)))")
          .font(.systemFont(ofSize: 12, weight: .semibold))
          .textColor(.white)
      }

      VStack(spacing: 6) {
        LabelNode("1. Shape buttons — no size animation. Path should refresh immediately.")
          .font(.systemFont(ofSize: 13))
          .textColor(.secondaryLabelColor)

        HStack(spacing: 8) {
          for shape in DemoShape.allCases {
            ViewNode(make: { [weak self] _ in
              let button = NSButton(title: shape.title, target: nil, action: nil)
              button.bezelStyle = .rounded
              button.addAction { [weak self] in
                self?.selectedShape = shape
              }
              button.wantsLayer = true
              button.sizeToFit()
              return button
            })
            .fixedSize()
          }
        }
      }

      VStack(spacing: 6) {
        LabelNode("2. Resize buttons — size animation in flight. Path should morph with the frame (not snap).")
          .font(.systemFont(ofSize: 13))
          .textColor(.secondaryLabelColor)

        HStack(spacing: 8) {
          ViewNode(make: { _ in
            let button = NSButton(title: "Larger", target: nil, action: nil)
            button.bezelStyle = .rounded
            button.addAction {
              BorderLayerShapeChangeDemoLayer.inset.value -= 16
            }
            button.wantsLayer = true
            button.sizeToFit()
            return button
          })
          .fixedSize()

          ViewNode(make: { _ in
            let button = NSButton(title: "Smaller", target: nil, action: nil)
            button.bezelStyle = .rounded
            button.addAction {
              BorderLayerShapeChangeDemoLayer.inset.value += 16
            }
            button.wantsLayer = true
            button.sizeToFit()
            return button
          })
          .fixedSize()

          ViewNode(make: { _ in
            let button = NSButton(title: "Random Size", target: nil, action: nil)
            button.bezelStyle = .rounded
            button.addAction {
              BorderLayerShapeChangeDemoLayer.inset.value = CGFloat(Int.random(in: 8 ... 48))
            }
            button.wantsLayer = true
            button.sizeToFit()
            return button
          })
          .fixedSize()
        }
      }

      Spacer()
    }
  }

  init() {
    super.init(
      contentRect: NSRect(x: 0, y: 0, width: 960, height: 480),
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
    title = "Layer Border Shape Change"
    isReleasedWhenClosed = false
    center()

    let contentView = NSView()
    contentView.wantsLayer = true
    contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
    self.contentView = contentView

    contentView.addSubview(composeView)
    composeView.makeFullSizeInSuperView()
  }

  func show() {
    makeKeyAndOrderFront(nil)
  }

  func hide() {
    orderOut(nil)
  }
}

private final class BorderLayerShapeChangeDemoLayer: CALayer {

  /// Inset from the host bounds. Changing this with animation exercises the live path-update path.
  static let inset = Binding<CGFloat>(CGFloat(24))

  private let contentLayer = CALayer()
  private let borderLayer = BorderLayer()
  private var shouldAnimate = false

  var demoShape: any Shape {
    didSet {
      updateBorderMask()
    }
  }

  var demoOffset: CGFloat {
    didSet {
      updateBorderMask()
    }
  }

  init(shape: any Shape, offset: CGFloat) {
    self.demoShape = shape
    self.demoOffset = offset
    super.init()

    contentLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    contentLayer.backgroundColor = Color.white.opacity(0.2).cgColor
    addSublayer(contentLayer)

    borderLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    borderLayer.borderContent = .color(.red)
    borderLayer.borderWidth = 4
    addSublayer(borderLayer)

    updateBorderMask()
    observeInset()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  private func observeInset() {
    Self.inset.observe { [weak self] _, _ in
      self?.shouldAnimate = true
      self?.setNeedsLayout()
      self?.layoutIfNeeded()
    }
    .store(in: .shared)
  }

  override func layoutSublayers() {
    super.layoutSublayers()

    let targetFrame = bounds.inset(by: Self.inset.wrappedValue.clamped(to: 0...))

    if shouldAnimate {
      // Long duration so the morph vs snap difference is easy to see.
      contentLayer.animateFrame(to: targetFrame, timing: .easeInEaseOut(duration: 1.2))
      borderLayer.animateFrame(to: targetFrame, timing: .easeInEaseOut(duration: 1.2))
      shouldAnimate = false
    } else {
      contentLayer.frame = targetFrame
      borderLayer.frame = targetFrame
    }
  }

  private func updateBorderMask() {
    borderLayer.borderMask = .shape(demoShape, offset: demoOffset)
  }
}
