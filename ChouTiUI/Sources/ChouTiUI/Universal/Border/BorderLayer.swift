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

/// A layer that can render a border.
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

  override public var cornerRadius: CGFloat {
    get {
      return super.cornerRadius
    }
    set { // swiftlint:disable:this unused_setter_value
      ChouTi.assertFailure("cornerRadius is not supported on BorderLayer, use borderContent instead.")
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

  // TODO: support color with shape border
  //
  // /// The layer for `BorderContent.color`.
  // private var borderContentColorLayer: CALayer?

  /// The layer for `BorderContent.gradient`.
  private var borderContentGradientLayer: CAGradientLayer?

  /// The layer for `BorderContent.layer`.
  private var borderContentExternalLayer: CALayer?

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
  private var borderMaskLayer: CALayer?

  // MARK: - Initialization

  override public init() {
    super.init()

    // turn off implicit animations
    self.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
  }

  override public init(layer: Any) {
    guard let layer = layer as? BorderLayer else {
      fatalError("expect the `layer` to be the same type during a ca animation.") // swiftlint:disable:this fatal_error
    }

    super.init(layer: layer)
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  // MARK: - Layout

  override public func layoutSublayers() {
    super.layoutSublayers()

    switch (borderContent, borderMask) {
    case (.color(let color), .cornerRadius(let cornerRadius, let borderWidth, let cornerCurve, let offset)):
      // reset border content layer
      self.borderContentGradientLayer?.removeFromSuperlayer()
      self.borderContentGradientLayer = nil
      self.borderContentExternalLayer?.removeFromSuperlayer()
      self.borderContentExternalLayer = nil

      // reset border mask layer
      self.borderMaskLayer = nil
      self.mask = nil

      // use layer's border directly
      super.borderColor = color.cgColor
      super.borderWidth = borderWidth
      super.cornerRadius = cornerRadius
      self.cornerCurve = cornerCurve
      self.borderOffset = offset

    case (.color(let color), .shape(let shape)):
      resetBorderStyle()
      // TODO: support color with shape border

    case (.gradient, _),
         (.layer, _):
      resetBorderStyle()

      // 1) set up border content layer
      switch borderContent {
      case .color:
        break // not applicable
      case .gradient(let gradient):
        self.borderContentExternalLayer?.removeFromSuperlayer()
        self.borderContentExternalLayer = nil

        let borderContentGradientLayer = self.borderContentGradientLayer ?? {
          let gradientLayer = CAGradientLayer()
          gradientLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
          self.borderContentGradientLayer = gradientLayer
          return gradientLayer
        }()

        borderContentGradientLayer.background = .gradient(gradient)
        addSublayer(borderContentGradientLayer)

        // extend the content layer's bounds by the border mask's offset so that the border with offset can have effect on it.
        borderContentGradientLayer.frame = bounds.expanded(by: borderMask.boundsExtendedOffset)

      case .layer(let contentLayer):
        self.borderContentGradientLayer?.removeFromSuperlayer()
        self.borderContentGradientLayer = nil

        if contentLayer.superlayer !== self {
          contentLayer.removeFromSuperlayer()
          addSublayer(contentLayer)
        }
        self.borderContentExternalLayer = contentLayer

        // turn off implicit animations
        if contentLayer.delegate == nil {
          contentLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
        } else if contentLayer.strongDelegate !== CALayer.DisableImplicitAnimationDelegate.shared {
          ChouTi.assertFailure("border content layer's delegate should be nil", metadata: [
            "layer": "\(contentLayer)",
            "layer.delegate": "\(contentLayer.delegate)",
          ])
        }

        // extend the content layer's bounds by the border mask's offset so that the border with offset can have effect on it.
        contentLayer.frame = bounds.expanded(by: borderMask.boundsExtendedOffset)
      }

      // 2) set up border mask layer
      let borderMaskLayer = self.borderMaskLayer ?? {
        let borderMaskLayer = CALayer()
        borderMaskLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
        self.borderMaskLayer = borderMaskLayer
        return borderMaskLayer
      }()

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
  }

  private func resetBorderStyle() {
    super.borderColor = Color.black.cgColor
    super.borderWidth = 0
    super.cornerRadius = 0
    self.cornerCurve = .continuous
    self.borderOffset = 0
  }

  // TODO: support animations
  // public func animate() {}
}
