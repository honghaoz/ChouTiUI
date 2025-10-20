//
//  BorderLayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/22/22.
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

import Foundation
import QuartzCore
import ChouTi

public final class BorderLayer: CALayer {

  override public var borderWidth: CGFloat {
    get {
      return super.borderWidth
    }
    set { // swiftlint:disable:this unused_setter_value
      ChouTi.assertFailure("borderWidth is not supported on BorderLayer, use borderMask instead.")
    }
  }

  override public var borderColor: CGColor? {
    get {
      return super.borderColor
    }
    set { // swiftlint:disable:this unused_setter_value
      ChouTi.assertFailure("borderColor is not supported on BorderLayer, use borderContent instead.")
    }
  }

  // MARK: - Border Content

  /// The content of the border.
  public enum BorderContent {

    /// A solid color border.
    case color(_ color: Color)

    /// A gradient color border.
    case gradient(_ gradient: GradientColor)

    /// A custom layer as the border content.
    ///
    /// The layer's frame will be set to the border layer's bounds by default.
    /// If the border mask has an offset that is greater than 0, the layer's frame will be set to the border layer's bounds extended by the offset.
    case layer(_ layer: CALayer)
  }

  /// The content of the border. The default value is a solid black color border.
  public var borderContent: BorderContent = .color(.black)

  /// The content layer. For color and gradient only.
  private var borderContentLayer: CAGradientLayer?

  // MARK: - Border Mask

  /// The mask of the border.
  public enum BorderMask {

    /// A corner radius border.
    case cornerRadius(_ cornerRadius: CGFloat, borderWidth: CGFloat, cornerCurve: CALayerCornerCurve = .continuous, offset: CGFloat = 0)

    // case cornerRadii(_ cornerRadii: CACornerRadii, borderWidth: CGFloat, cornerCurve: CALayerCornerCurve = .continuous, offset: CGFloat = 0) // TODO: support CACornerRadii in border

    /// A shape border.
    case shape(_ shape: any Shape, borderWidth: CGFloat)

    /// The offset to be added to the bounds of the border layer, for the content layer.
    var boundsExtendedOffset: CGFloat {
      switch self {
      case .cornerRadius(_, _, _, let offset):
        return offset > 0 ? offset : 0
      case .shape:
        return 0
      }
    }
  }

  /// The mask of the border. The default value is a zero corner radius border with a width of 1.
  public var borderMask: BorderMask = .cornerRadius(0, borderWidth: 1, offset: 0)

  /// The mask layer.
  private let borderMaskLayer: CALayer

  // MARK: - Initialization

  override public init() {
    self.borderMaskLayer = CALayer()

    super.init()

    self.borderMaskLayer.borderColor = Color.black.cgColor

    // turn off implicit animations
    self.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    self.borderMaskLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
  }

  override public init(layer: Any) {
    guard let layer = layer as? BorderLayer else {
      fatalError("expect the `layer` to be the same type during a ca animation.") // swiftlint:disable:this fatal_error
    }

    self.borderContentLayer = layer.borderContentLayer
    self.borderMaskLayer = layer.borderMaskLayer

    super.init(layer: layer)

    self.borderContent = layer.borderContent
    self.borderMask = layer.borderMask
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  // MARK: - Layout

  override public func layoutSublayers() {
    super.layoutSublayers()

    // set up border content layer
    switch borderContent {
    case .color(let color):
      let borderContentLayer = setupBorderContentLayerIfNeeded()
      borderContentLayer.frame = bounds.expanded(by: borderMask.boundsExtendedOffset)

      borderContentLayer.background = .color(color)

    case .gradient(let gradient):
      let borderContentLayer = setupBorderContentLayerIfNeeded()
      borderContentLayer.frame = bounds.expanded(by: borderMask.boundsExtendedOffset)

      borderContentLayer.background = .gradient(gradient)

    case .layer(let contentLayer):
      if contentLayer.superlayer != self {
        contentLayer.removeFromSuperlayer()
        addSublayer(contentLayer)
      }

      // turn off implicit animations
      contentLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared

      // extend the content layer's bounds by the border mask's offset so that the border with offset can have effect on it.
      contentLayer.frame = bounds.expanded(by: borderMask.boundsExtendedOffset)
    }

    // set up border mask layer
    if mask !== borderMaskLayer {
      mask = borderMaskLayer
    }
    borderMaskLayer.frame = bounds

    switch borderMask {
    case .cornerRadius(let cornerRadius, let borderWidth, let cornerCurve, let offset):
      borderMaskLayer.cornerRadius = cornerRadius
      borderMaskLayer.borderWidth = borderWidth
      borderMaskLayer.cornerCurve = cornerCurve
      borderMaskLayer.borderOffset = offset
    case .shape(let shape):
      break // TODO: support shape in border mask
    }
  }

  /// Sets up the border content layer if the layer is not set up yet.
  /// - Returns: The border content layer.
  private func setupBorderContentLayerIfNeeded() -> CAGradientLayer {
    if let borderContentLayer = self.borderContentLayer {
      return borderContentLayer
    }

    let borderContentLayer = CAGradientLayer()
    borderContentLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    addSublayer(borderContentLayer)
    self.borderContentLayer = borderContentLayer

    return borderContentLayer
  }

  // TODO: support animations
  // public func animate() {}
}
