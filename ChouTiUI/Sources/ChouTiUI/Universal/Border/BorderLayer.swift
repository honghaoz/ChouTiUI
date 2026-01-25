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

  /// Border width for the border.
  override public var borderWidth: CGFloat {
    get {
      return super.borderWidth
    }
    set {
      // forward the border width to the underlying "borderWidthValue" property without changing the super.borderWidth
      // since we manage the border width style manually
      borderWidthValue = newValue
      setNeedsLayout()
    }
  }

  /// The actual border width value.
  private var borderWidthValue: CGFloat = 1

  /// Unsupported. Use `borderContent` instead.
  override public var borderColor: CGColor? {
    get {
      return super.borderColor
    }
    set { // swiftlint:disable:this unused_setter_value
      ChouTi.assertFailure("borderColor is not supported on BorderLayer, use borderContent instead.")
    }
  }

  /// Unsupported. Use `borderMask` instead.
  override public var cornerRadius: CGFloat {
    get {
      return super.cornerRadius
    }
    set { // swiftlint:disable:this unused_setter_value
      ChouTi.assertFailure("cornerRadius is not supported on BorderLayer, use borderMask instead.")
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
    ///   - cornerCurve: The corner curve of the border. The default value is `continuous`.
    ///   - offset: The offset of the border in points. Positive value to make the border outward/bigger, negative value to make the border inward/smaller. The default value is 0.
    case cornerRadius(_ cornerRadius: CGFloat, cornerCurve: CALayerCornerCurve = .continuous, offset: CGFloat = 0)

    /// A shape border.
    ///
    /// - Parameters:
    ///   - shape: The shape of the border. If the offset is not 0, the shape should be preferably an `OffsetableShape`.
    ///   - offset: The offset of the border in points. Positive value to make the border outward/bigger, negative value to make the border inward/smaller. The default value is 0.
    case shape(_ shape: any Shape, offset: CGFloat = 0)

    /// The offset to be added to the bounds of the border layer (host layer) bounds, for the content layer and border mask layer.
    ///
    /// - When the offset is positive, the bounds of the content/mask layer will be extended by the offset.
    /// - When the offset is negative, the bounds of the content/mask layer won't be changed.
    fileprivate var boundsExtendedOffset: CGFloat {
      switch self {
      case .cornerRadius(_, _, let offset),
           .shape(_, let offset):
        return offset > 0 ? offset : 0
      }
    }
  }

  /// The mask of the border. The default value is a zero corner radius border.
  public var borderMask: BorderMask = .cornerRadius(0, offset: 0) // TODO: do we need to trigger setNeedsLayout?

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
    borderWidthValue = layer.borderWidthValue
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  // MARK: - Layout

  override public func layoutSublayers() {
    super.layoutSublayers()

    switch (borderContent, borderMask) {
    case (.color(let color), .cornerRadius(let cornerRadius, let cornerCurve, let offset)):
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
      super.borderWidth = borderWidthValue
      self.cornerCurve = cornerCurve
      self.borderOffset = offset

    case (.color(let color), .shape(let shape, let offset)):
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
      borderContentColorLayer.contentsScale = contentsScale

      addSublayer(borderContentColorLayer)

      let borderContentColorLayerOldFrame = borderContentColorLayer.frame

      // extend the content layer's bounds by the border mask's offset so that the border with offset can have effect on it.
      borderContentColorLayer.frame = bounds.expanded(by: borderMask.boundsExtendedOffset)

      // add size sync animation so that the border content layer can follow the bounds change
      if let sizeAnimation = self.sizeAnimation() {
        borderContentColorLayer.addFrameAnimation(
          from: borderContentColorLayerOldFrame,
          to: borderContentColorLayer.frame,
          presentationBounds: borderContentColorLayer.presentation()?.frame,
          with: sizeAnimation
        )
      }

      // 2) set up border mask layer with shape
      resetBorderStyle()
      updateMaskLayer(for: shape, borderWidth: borderWidthValue, offset: offset, borderContentFrame: borderContentColorLayer.frame)

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
        borderContentGradientLayer.contentsScale = contentsScale

        addSublayer(borderContentGradientLayer)

        let borderContentGradientLayerOldFrame = borderContentGradientLayer.frame
        borderContentGradientLayer.frame = borderContentFrame

        // add size sync animation so that the border content layer can follow the bounds change
        if let sizeAnimation = self.sizeAnimation() {
          borderContentGradientLayer.addFrameAnimation(
            from: borderContentGradientLayerOldFrame,
            to: borderContentGradientLayer.frame,
            presentationBounds: borderContentGradientLayer.presentation()?.frame,
            with: sizeAnimation
          )
        }

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

        contentLayer.contentsScale = contentsScale

        let contentLayerOldFrame = contentLayer.frame
        contentLayer.frame = borderContentFrame

        // add size sync animation so that the border content layer can follow the bounds change
        if let sizeAnimation = self.sizeAnimation() {
          contentLayer.addFrameAnimation(
            from: contentLayerOldFrame,
            to: contentLayer.frame,
            presentationBounds: contentLayer.presentation()?.frame,
            with: sizeAnimation
          )
        }
      }

      // 2) set up border mask layer
      resetBorderStyle()

      switch borderMask {
      case .cornerRadius(let cornerRadius, let cornerCurve, let offset):
        let borderMaskLayer = self.borderMaskLayer ?? {
          let borderMaskLayer = CALayer()
          borderMaskLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
          self.borderMaskLayer = borderMaskLayer
          return borderMaskLayer
        }()

        if mask !== borderMaskLayer {
          mask = borderMaskLayer
        }

        borderMaskLayer.contentsScale = contentsScale

        let borderMaskLayerOldFrame = borderMaskLayer.frame
        borderMaskLayer.frame = bounds

        // add size sync animation so that the border mask layer can follow the bounds change
        if let sizeAnimation = self.sizeAnimation() {
          borderMaskLayer.addFrameAnimation(
            from: borderMaskLayerOldFrame,
            to: borderMaskLayer.frame,
            presentationBounds: borderMaskLayer.presentation()?.frame,
            with: sizeAnimation
          )
        }

        borderMaskLayer.cornerRadius = cornerRadius
        borderMaskLayer.borderWidth = borderWidthValue
        borderMaskLayer.cornerCurve = cornerCurve
        borderMaskLayer.borderOffset = offset
      case .shape(let shape, let offset):
        updateMaskLayer(for: shape, borderWidth: borderWidthValue, offset: offset, borderContentFrame: borderContentFrame)
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
    borderMaskLayer.contentsScale = contentsScale

    let borderMaskLayerOldFrame = borderMaskLayer.frame

    borderMaskLayer.frame = borderContentFrame

    // add size sync animation so that the border mask layer can follow the bounds change
    if let sizeAnimation = self.sizeAnimation() {
      borderMaskLayer.addFrameAnimation(
        from: borderMaskLayerOldFrame,
        to: borderMaskLayer.frame,
        presentationBounds: borderMaskLayer.presentation()?.frame,
        with: sizeAnimation
      )
    }

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

      // add path animation so that the border mask layer can follow the bounds change
      if let pathAnimation = self.sizeAnimation()?.copy() as? CABasicAnimation {
        pathAnimation.keyPath = "path"
        pathAnimation.isAdditive = false
        pathAnimation.fromValue = borderMaskLayer.presentation()?.path
        pathAnimation.toValue = borderMaskLayer.path
        borderMaskLayer.add(pathAnimation, forKey: "path")
      }

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

      // add path animation so that the border mask layer can follow the bounds change
      if let pathAnimation = self.sizeAnimation()?.copy() as? CABasicAnimation {
        pathAnimation.keyPath = "path"
        pathAnimation.isAdditive = false
        pathAnimation.fromValue = borderMaskLayer.presentation()?.path
        pathAnimation.toValue = borderMaskLayer.path
        borderMaskLayer.add(pathAnimation, forKey: "path")
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
    mask = maskLayer
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

    let maskLayerOldBounds = maskLayer.frame
    maskLayer.frame = bounds
    maskLayer.path = maskPath(bounds)

    if let sizeAnimation = self.sizeAnimation() {
      maskLayer.addFrameAnimation(
        from: maskLayerOldBounds,
        to: maskLayer.frame,
        presentationBounds: self.presentation()?.bounds,
        with: sizeAnimation
      )

      if let pathAnimation = sizeAnimation.copy() as? CABasicAnimation {
        pathAnimation.keyPath = "path"
        pathAnimation.isAdditive = false
        pathAnimation.fromValue = maskLayer.presentation()?.path
        pathAnimation.toValue = maskLayer.path
        maskLayer.add(pathAnimation, forKey: "path")
      }
    }
  }
}
