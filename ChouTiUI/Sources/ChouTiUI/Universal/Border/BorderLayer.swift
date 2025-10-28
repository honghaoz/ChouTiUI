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
    ///
    /// The layer's delegate should be nil. If you want to use a view as the border content, you should wrap the view's layer in a CALayer and use the wrapper layer as the border content.
    case layer(_ layer: CALayer)
  }

  /// The content of the border. The default value is a solid black color border.
  public var borderContent: BorderContent = .color(.black)

  /// The layer for `BorderContent.color` when the border mask uses shape.
  private var borderContentColorLayer: CALayer?

  /// The layer for `BorderContent.gradient`.
  private var borderContentGradientLayer: CAGradientLayer?

  /// The layer for `BorderContent.layer`.
  private var borderContentExternalLayer: CALayer?

  // MARK: - Border Mask

  /// The mask of the border.
  public enum BorderMask {

    /// A corner radius border.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius in points.
    ///   - borderWidth: The width of the border in points.
    ///   - cornerCurve: The corner curve of the border. The default value is `continuous`.
    ///   - offset: The offset of the border in points. Positive value to make the border outward/bigger, negative value to make the border inward/smaller. The default value is 0.
    case cornerRadius(_ cornerRadius: CGFloat, borderWidth: CGFloat, cornerCurve: CALayerCornerCurve = .continuous, offset: CGFloat = 0)

    /// A shape border.
    ///
    /// - Parameters:
    ///   - shape: The shape of the border. If the offset is not 0, the shape should be preferably an `OffsetableShape`.
    ///   - borderWidth: The width of the border in points.
    ///   - offset: The offset of the border in points. Positive value to make the border outward/bigger, negative value to make the border inward/smaller. The default value is 0.
    case shape(_ shape: any Shape, borderWidth: CGFloat, offset: CGFloat = 0)

    /// The offset to be added to the bounds of the border layer (host layer) bounds, for the content layer and border mask layer.
    ///
    /// - When the offset is positive, the bounds of the content/mask layer will be extended by the offset.
    /// - When the offset is negative, the bounds of the content/mask layer won't be changed.
    fileprivate var boundsExtendedOffset: CGFloat {
      switch self {
      case .cornerRadius(_, _, _, let offset),
           .shape(_, _, let offset):
        return offset > 0 ? offset : 0
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
      // solid color + corner radius
      // just use layer's border directly

      // reset border content layer
      self.borderContentColorLayer?.removeFromSuperlayer()
      self.borderContentColorLayer = nil
      self.borderContentGradientLayer?.removeFromSuperlayer()
      self.borderContentGradientLayer = nil
      self.borderContentExternalLayer?.removeFromSuperlayer()
      self.borderContentExternalLayer = nil

      // reset border mask layer
      self.borderMaskLayer = nil
      self.mask = nil

      // use layer's border directly
      super.borderColor = color.cgColor
      super.cornerRadius = cornerRadius
      super.borderWidth = borderWidth
      self.cornerCurve = cornerCurve
      self.borderOffset = offset

    case (.color(let color), .shape(let shape, let borderWidth, let offset)):
      // solid color + shape
      // use a color layer as the border content and a shape layer as the border mask

      // reset unused border content layers
      self.borderContentGradientLayer?.removeFromSuperlayer()
      self.borderContentGradientLayer = nil
      self.borderContentExternalLayer?.removeFromSuperlayer()
      self.borderContentExternalLayer = nil

      // 1) set up border content color layer
      let borderContentColorLayer = self.borderContentColorLayer ?? {
        let colorLayer = CALayer()
        colorLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
        self.borderContentColorLayer = colorLayer
        return colorLayer
      }()

      borderContentColorLayer.background = .color(color)
      addSublayer(borderContentColorLayer)
      // extend the content layer's bounds by the border mask's offset so that the border with offset can have effect on it.
      borderContentColorLayer.frame = bounds.expanded(by: borderMask.boundsExtendedOffset)
      borderContentColorLayer.contentsScale = contentsScale

      // 2) set up border mask layer with shape
      resetBorderStyle()
      updateMaskLayer(for: shape, borderWidth: borderWidth, offset: offset, borderContentFrame: borderContentColorLayer.frame)

    case (.gradient, _),
         (.layer, _):

      // 1) set up border content layer

      // extend the content layer's bounds by the border mask's offset so that the border with offset can have effect on it.
      let borderContentFrame = bounds.expanded(by: borderMask.boundsExtendedOffset)

      switch borderContent {
      case .color:
        break // not applicable
      case .gradient(let gradient):
        self.borderContentColorLayer?.removeFromSuperlayer()
        self.borderContentColorLayer = nil
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

        borderContentGradientLayer.frame = borderContentFrame
        borderContentGradientLayer.contentsScale = contentsScale

      case .layer(let contentLayer):
        self.borderContentColorLayer?.removeFromSuperlayer()
        self.borderContentColorLayer = nil
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
            "layer.delegate": String(describing: contentLayer.delegate),
          ])
        }

        contentLayer.frame = borderContentFrame
        contentLayer.contentsScale = contentsScale
      }

      // 2) set up border mask layer
      resetBorderStyle()

      switch borderMask {
      case .cornerRadius(let cornerRadius, let borderWidth, let cornerCurve, let offset):
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
        borderMaskLayer.contentsScale = contentsScale

        borderMaskLayer.cornerRadius = cornerRadius
        borderMaskLayer.borderWidth = borderWidth
        borderMaskLayer.cornerCurve = cornerCurve
        borderMaskLayer.borderOffset = offset
      case .shape(let shape, let borderWidth, let offset):
        updateMaskLayer(for: shape, borderWidth: borderWidth, offset: offset, borderContentFrame: borderContentFrame)
      }
    }
  }

  private func updateMaskLayer(for shape: any Shape, borderWidth: CGFloat, offset: CGFloat, borderContentFrame: CGRect) {
    let borderMaskLayer: MaskShapeLayer
    if let existingMaskLayer = self.borderMaskLayer as? MaskShapeLayer {
      borderMaskLayer = existingMaskLayer
    } else {
      borderMaskLayer = MaskShapeLayer()
      borderMaskLayer.fillColor = nil // no fill, only stroke
      borderMaskLayer.strokeColor = Color.black.cgColor // stroke to create border ring
      borderMaskLayer.fillRule = .nonZero
      self.borderMaskLayer = borderMaskLayer
    }

    if mask !== borderMaskLayer {
      mask = borderMaskLayer
    }
    borderMaskLayer.frame = borderContentFrame
    borderMaskLayer.contentsScale = contentsScale

    if let offsetableShape = shape as? (any OffsetableShape) {
      // Expanded logic:
      // ```
      // if offset > 0 {
      //   // border mask layer is expanded, should use the original bounds in the expanded bounds's coordinate system
      //   borderMaskLayer.path = offsetableShape.path(in: bounds.offsetBy(dx: offset, dy: offset), offset: offset)
      // } else {
      //   // border mask layer doesn't shrink, can just use the bounds directly
      //   borderMaskLayer.path = offsetableShape.path(in: bounds, offset: offset)
      // }
      // ```

      // Simple logic:
      let boundsExtendedOffset = borderMask.boundsExtendedOffset
      borderMaskLayer.path = offsetableShape.path(in: bounds.offsetBy(dx: boundsExtendedOffset, dy: boundsExtendedOffset), offset: offset)

      borderMaskLayer.maskPath = { borderMaskLayerBounds in
        // Expanded logic:
        // ```
        // if offset > 0 {
        //   // border mask layer is expanded, should use the original bounds
        //   offsetableShape.path(in: borderMaskLayerBounds.expanded(by: -offset), offset: offset)
        // } else {
        //   // border mask layer doesn't shrink, can just use the bounds directly
        //   offsetableShape.path(in: borderMaskLayerBounds, offset: offset)
        // }
        // ```

        // Simple logic:
        offsetableShape.path(in: borderMaskLayerBounds.expanded(by: -boundsExtendedOffset), offset: offset)
      }
    } else {
      // not offsetable shape
      if offset >= 0 {
        // the border mask layer is expanded, use the expanded bounds directly
        borderMaskLayer.path = shape.path(in: borderMaskLayer.bounds)
        borderMaskLayer.maskPath = shape.path(in:)
      } else {
        // the border mask layer doesn't shrink, should use the shrunk bounds
        borderMaskLayer.path = shape.path(in: bounds.expanded(by: offset))
        borderMaskLayer.maskPath = { bounds in shape.path(in: bounds.expanded(by: offset)) }
      }
    }
    borderMaskLayer.lineWidth = 2 * borderWidth // double width so half is inside, half is outside
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

/// A masked shape layer.
///
/// - The layer has a mask that clips the layer's content with a path.
/// - The layer is a shape layer, it can set stroke, fill, etc.
private class MaskShapeLayer: CAShapeLayer {

  /// The path of the mask.
  ///
  /// - Parameter bounds: The bounds of the layer.
  /// - Returns: The path of the mask.
  var maskPath: ((CGRect) -> CGPath) = { CGPath(rect: $0, transform: nil) }

  override var contentsScale: CGFloat {
    get {
      return super.contentsScale
    }
    set {
      super.contentsScale = newValue
      mask?.contentsScale = newValue
    }
  }

  override init() {
    super.init()

    strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared

    let maskLayer = CAShapeLayer()
    maskLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
    maskLayer.frame = bounds
    maskLayer.path = maskPath(bounds)
    mask = maskLayer

    addFullSizeTrackingLayer(maskLayer, onBoundsChange: { [weak self, weak maskLayer] context in
      guard let self, let maskLayer = maskLayer else {
        return
      }

      let layer = context.hostLayer

      // update model
      maskLayer.path = self.maskPath(layer.bounds)

      // add animation if bounds changes
      guard let animationCopy = layer.sizeAnimation()?.copy() as? CABasicAnimation else {
        return
      }

      animationCopy.keyPath = "path"
      animationCopy.isAdditive = false
      animationCopy.fromValue = maskLayer.presentation()?.path
      animationCopy.toValue = maskLayer.path
      maskLayer.add(animationCopy, forKey: "path")
    })
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    // swiftlint:disable:next fatal_error
    fatalError("init(coder:) is unavailable")
  }

  override init(layer: Any) {
    super.init(layer: layer)
  }

  override func layoutSublayers() {
    super.layoutSublayers()

    guard let maskLayer = mask as? CAShapeLayer else {
      return
    }

    // on macOS, when window is resized, the above `onBoundsChange` won't be called, so we need to update the mask layer's frame and path manually.
    maskLayer.frame = bounds
    maskLayer.path = maskPath(bounds)
  }
}
