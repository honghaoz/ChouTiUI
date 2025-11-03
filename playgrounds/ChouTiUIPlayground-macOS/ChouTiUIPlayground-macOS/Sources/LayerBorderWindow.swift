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

    let contentView = ComposeView { [unowned self] in // swiftlint:disable:this unowned_variable
      ZStack {
        ComposeViewNode { [unowned self] in // swiftlint:disable:this unowned_variable
          self.makeMainContent()
        }
        .flexibleSize()
        .padding(bottom: Constants.toolbarHeight)

        self.makeToolbar().alignment(.bottom)
      }
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

  private func makeMainContent() -> ComposeNode {
    VStack(spacing: 10) {
      ///
      /// Metal
      ///

      LabelNode("Metal")
        .font(.systemFont(ofSize: 16, weight: .bold))

      LayerNode(make: { _ in
        BorderMetalLayerDemoLayer()
      })
      .frame(width: .flexible, height: 300)

      ///
      /// Gradient
      ///

      LabelNode("Gradient")
        .font(.systemFont(ofSize: 16, weight: .bold))

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), offset: 0)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Gradient, offset: 0")
          .textColor(.white)
      }

      ///
      /// Custom layer
      ///

      LabelNode("Custom layer")
        .font(.systemFont(ofSize: 16, weight: .bold))

      LayerNode(make: { context in
        let layer = CALayer()
        layer.background = .linearGradient(LinearGradientColor([.yellow, .orange]))
        return BorderLayerDemoLayer(borderContent: .layer(layer), offset: 0)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Custom layer, offset: 0")
          .textColor(.white)
      }

      LayerNode(make: { context in
        let layer = ComposeViewContentLayer()
        return BorderLayerDemoLayer(borderContent: .layer(layer), offset: 10)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Custom layer, offset: 0")
          .textColor(.white)
      }

      ///
      /// Solid color
      ///

      LabelNode("Solid color")
        .font(.systemFont(ofSize: 16, weight: .bold))

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 0)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: 0")
          .textColor(.white)
      }

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: .pixel)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: .pixel")
          .textColor(.white)
      }

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 1)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: 1")
          .textColor(.white)
      }

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 10)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: 10")
          .textColor(.white)
      }

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 20)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: 20")
          .textColor(.white)
      }

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: -10)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: -10")
          .textColor(.white)
      }

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: -20)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: -20")
          .textColor(.white)
      }

      LayerNode(make: { _ in
        BorderLayerDemoLayer(borderContent: .color(.yellow), offset: -20)
      })
      .frame(width: .flexible, height: 200)
      .overlay {
        LabelNode("Solid color, offset: -20")
          .textColor(.white)
      }

      ///
      /// Offsetable Shape
      ///

      LabelNode("Offsetable Shape")
        .font(.systemFont(ofSize: 16, weight: .bold))

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Capsule(), offset: 0)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Capsule, offset: 0")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Capsule(), offset: 0)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Capsule, offset: 0")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Capsule(), offset: .pixel)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Capsule, offset: .pixel")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Capsule(), offset: .pixel)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Capsule, offset: .pixel")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Capsule(), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Capsule, offset: 20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Capsule(), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Capsule, offset: 20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Ellipse(), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Ellipse, offset: 20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Ellipse(), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Ellipse, offset: 20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Circle(), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Circle, offset: 20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Circle(), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Circle, offset: 20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Rectangle(cornerRadius: 20), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Rectangle, offset: 20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Rectangle(cornerRadius: 20), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Rectangle, offset: 20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: SuperEllipse(cornerRadius: 50, roundingCorners: [.topLeft, .bottomRight]), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, SuperEllipse, offset: 20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: SuperEllipse(cornerRadius: 50, roundingCorners: [.topLeft, .bottomRight]), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, SuperEllipse, offset: 20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Capsule(), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Capsule, offset: -20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Capsule(), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Capsule, offset: -20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Ellipse(), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Ellipse, offset: -20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Ellipse(), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Ellipse, offset: -20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Circle(), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Circle, offset: -20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Circle(), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Circle, offset: -20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: Rectangle(cornerRadius: 20), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, Rectangle, offset: -20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: Rectangle(cornerRadius: 20), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, Rectangle, offset: -20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: SuperEllipse(cornerRadius: 50, roundingCorners: [.topLeft, .bottomRight]), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, SuperEllipse, offset: -20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: SuperEllipse(cornerRadius: 50, roundingCorners: [.topLeft, .bottomRight]), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, SuperEllipse, offset: -20")
            .textColor(.white)
        }
      }

      ///
      /// Non-offsetable shape
      ///

      LabelNode("Non-offsetable Shape")
        .font(.systemFont(ofSize: 16, weight: .bold))

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: NonOffsetableRectangle(cornerRadius: 20), offset: 0)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, NonOffsetableRectangle, offset: 0")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: NonOffsetableRectangle(cornerRadius: 20), offset: 0)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, NonOffsetableRectangle, offset: 0")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: NonOffsetableRectangle(cornerRadius: 20), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, NonOffsetableRectangle, offset: 20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: NonOffsetableRectangle(cornerRadius: 20), offset: 20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, NonOffsetableRectangle, offset: 20")
            .textColor(.white)
        }
      }

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .color(.yellow), shape: NonOffsetableRectangle(cornerRadius: 20), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Solid color, NonOffsetableRectangle, offset: -20")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          BorderLayerDemoLayer(borderContent: .gradient(.linearGradient(LinearGradientColor([.yellow, .cyan]))), shape: NonOffsetableRectangle(cornerRadius: 20), offset: -20)
        })
        .frame(width: .flexible, height: 200)
        .overlay {
          LabelNode("Gradient, NonOffsetableRectangle, offset: -20")
            .textColor(.white)
        }
      }

      ///
      /// Contents Scale
      ///

      LabelNode("Contents Scale")
        .font(.systemFont(ofSize: 16, weight: .bold))

      HStack(spacing: 10) {

        LayerNode(make: { _ in
          let layer = BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 0)
          layer.contentsScale = 1
          return layer
        })
        .frame(width: .flexible, height: 100)
        .overlay {
          LabelNode("Contents Scale: 1")
            .textColor(.white)
        }

        LayerNode(make: { _ in
          let layer = BorderLayerDemoLayer(borderContent: .color(.yellow), offset: 0)
          layer.contentsScale = 2
          return layer
        })
        .frame(width: .flexible, height: 100)
        .overlay {
          LabelNode("Contents Scale: 2")
            .textColor(.white)
        }
      }
    }
    .padding(horizontal: 50)
  }

  private func makeToolbar() -> ComposeNode {
    ZStack {
      ComposeViewNode {
        UnifiedColorNode(
          light: LinearGradientColor([.whiteRGB(0.98), .whiteRGB(0.8)]),
          dark: LinearGradientColor([.blackRGB(0.65), .blackRGB(0.8)])
        )
        .overlay(alignment: .top, content: {
          UnifiedColorNode(light: .whiteRGB, dark: .whiteRGB(0.5))
            .frame(width: .flexible, height: .halfPoint)
        })
        .dropShadow(color: .black, opacity: 0.3, radius: 1, offset: CGSize(width: 0, height: -1), path: { renderable in
          CGPath(rect: renderable.bounds.insetBy(dx: -4, dy: 0), transform: nil)
        })
        .animation(.easeInEaseOut(duration: 5))
      }
      .willInsert { renderable, context in
        (renderable.view as? ComposeView)?.animationBehavior = .dynamic { _, renderType in
          switch renderType {
          case .refresh(isAnimated: let isAnimated):
            return isAnimated
          case .scroll:
            return false
          case .boundsChange:
            return false
          }
        }
      }

      HStack {
        ViewNode(make: { _ in
          let button = NSButton(title: "Resize", target: nil, action: nil)
          button.addAction {
            BorderLayerDemoLayer.inset.value = CGFloat(Int.random(in: 5 ... 30))
          }
          button.wantsLayer = true
          button.sizeToFit()
          return button
        })
        .fixedSize()
      }
    }
    .frame(width: .flexible, height: Constants.toolbarHeight)
  }

  // MARK: - Constants

  private enum Constants {

    static let toolbarHeight: CGFloat = 38
  }
}

// MARK: - BorderMetalLayerDemoLayer

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

// MARK: - BorderLayerDemoLayer

private class BorderLayerDemoLayer: CALayer {

  static var inset = Binding<CGFloat>(CGFloat(20.0))

  private lazy var contentLayer = CAShapeLayer()
  private lazy var borderLayer = BorderLayer()

  override var contentsScale: CGFloat {
    get {
      return super.contentsScale
    }
    set {
      super.contentsScale = newValue
      contentLayer.contentsScale = newValue
      borderLayer.contentsScale = newValue
    }
  }

  init(borderContent: BorderLayer.BorderContent, offset: CGFloat) {
    super.init()

    contentLayer.strongDelegate = DisableImplicitAnimationDelegate.shared
    contentLayer.backgroundColor = Color.red.cgColor
    contentLayer.cornerRadius = 30
    contentLayer.cornerCurve = .continuous
    addSublayer(contentLayer)

    borderLayer.borderContent = borderContent
    borderLayer.borderMask = .cornerRadius(contentLayer.cornerRadius, borderWidth: 10, offset: offset)
    addSublayer(borderLayer)

    observeInset()
  }

  init(borderContent: BorderLayer.BorderContent, shape: some Shape, offset: CGFloat) {
    super.init()

    contentLayer.backgroundColor = Color.red.cgColor
    contentLayer.shape = shape
    contentLayer.strongDelegate = BoundsChangeDelegate(layoutSublayers: { layer in
      // TODO: update CALayer+BoundsChange.swift to use isa swizzling instead of KVO bounds change

      layer.shape = shape // to fix stale shape during window resizing

      guard let maskLayer = layer.mask as? CAShapeLayer, let animationCopy = layer.sizeAnimation()?.copy() as? CABasicAnimation else {
        return
      }

      animationCopy.keyPath = "path"
      animationCopy.isAdditive = false
      animationCopy.fromValue = maskLayer.presentation()?.path
      animationCopy.toValue = maskLayer.path
      maskLayer.add(animationCopy, forKey: "path")
    })
    addSublayer(contentLayer)

    borderLayer.borderContent = borderContent
    borderLayer.borderMask = .shape(shape, borderWidth: 10, offset: offset)
    addSublayer(borderLayer)

    observeInset()
  }

  private func observeInset() {
    BorderLayerDemoLayer.inset.observe { [weak self] inset, _ in
      self?.shouldAnimate = true
      self?.setNeedsLayout()
      self?.layoutIfNeeded()
    }
    .store(in: .shared)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  private var shouldAnimate: Bool = false

  override func layoutSublayers() {
    super.layoutSublayers()

    if shouldAnimate {
      contentLayer.animateFrame(to: bounds.inset(by: BorderLayerDemoLayer.inset.wrappedValue), timing: .easeInEaseOut(duration: 0.5))
      borderLayer.animateFrame(to: contentLayer.frame, timing: .easeInEaseOut(duration: 0.5))
      shouldAnimate = false
    } else {
      contentLayer.frame = bounds.inset(by: BorderLayerDemoLayer.inset.wrappedValue)
      borderLayer.frame = contentLayer.frame
    }
  }
}

// MARK: - ComposeViewContentLayer

private class ComposeViewContentLayer: CALayer {

  private let view: ComposeView

  override init() {

    view = ComposeView {
      HStack {
        VStack {
          ColorNode(.yellow)
          ColorNode(.blue)
          ColorNode(.green)
          ColorNode(.cyan)
        }
        VStack {
          ColorNode(.orange)
          ColorNode(.yellow)
          ColorNode(.purple)
        }
      }
    }

    super.init()

    addSublayer(view.contentView().unsafeLayer)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  override func layoutSublayers() {
    super.layoutSublayers()

    let oldBounds = bounds

    view.frame = bounds
    view.setNeedsLayout()
    view.layoutIfNeeded()

    if let sizeAnimation = self.sizeAnimation() {
      view.contentView().unsafeLayer.addFrameAnimation(
        from: oldBounds,
        to: bounds,
        presentationBounds: self.presentation()?.bounds,
        with: sizeAnimation
      )
    }
  }
}

// MARK: - BoundsChangeDelegate

private class BoundsChangeDelegate: NSObject, CALayerDelegate {

  private var layoutSublayersBlock: (CALayer) -> Void

  init(layoutSublayers: @escaping (CALayer) -> Void) {
    self.layoutSublayersBlock = layoutSublayers
  }

  func layoutSublayers(of layer: CALayer) {
    layoutSublayersBlock(layer)
  }

  private let null = NSNull()

  func action(for layer: CALayer, forKey event: String) -> CAAction? {
    null
  }
}

// MARK: - NonOffsetableRectangle

private struct NonOffsetableRectangle: Shape {

  let cornerRadius: CGFloat

  func path(in rect: CGRect) -> CGPath {
    BezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
  }
}
