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
    /// The layer will be added to the border layer as a sublayer.
    /// The layer's frame will be set to the border layer's bounds adjusted by the border mask's offset.
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
    ///   - offset: The offset of the border in points. Positive value to make the border outward/bigger, negative value to make the border inward/smaller. The default value is `0`.
    case cornerRadius(_ cornerRadius: CGFloat, cornerCurve: CALayerCornerCurve = .continuous, offset: CGFloat = 0)

    /// A shape border.
    ///
    /// - Parameters:
    ///   - shape: The shape of the border. If the offset is not 0, the shape should be preferably an `OffsetableShape`.
    ///   - offset: The offset of the border in points. Positive value to make the border outward/bigger, negative value to make the border inward/smaller. The default value is 0.
    case shape(_ shape: any Shape, offset: CGFloat = 0)

    fileprivate var offset: CGFloat {
      switch self {
      case .cornerRadius(_, _, let offset),
           .shape(_, let offset):
        return offset
      }
    }
  }

  /// The mask of the border. The default value is a zero corner radius border.
  public var borderMask: BorderMask = .cornerRadius(0) // TODO: do we need to trigger setNeedsLayout?

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

    // special case: use layer's border directly if the layer's border can be used directly
    if case .color(let color) = borderContent,
       case .cornerRadius(let cornerRadius, let cornerCurve, let offset) = borderMask,
       usesNativeBorderOffset
    {
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
      super.borderWidth = borderWidthValue
      super.cornerRadius = cornerRadius
      self.cornerCurve = cornerCurve
      if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
        self.borderOffset = offset
      }

      return
    }

    // normal case: use border content and border mask to create the border

    // 1) set up border content layer
    let borderContentFrame = bounds.expanded(by: max(0, borderMask.offset)) // extend the content layer's bounds by the border mask's offset so that the border with offset can have effect on it

    switch borderContent {
    case .color(let color):
      setupBorderContentColorLayer(color: color, borderContentFrame: borderContentFrame)
    case .gradient(let gradient):
      setupBorderContentGradientLayer(gradient: gradient, borderContentFrame: borderContentFrame)
    case .layer(let contentLayer):
      setupBorderContentExternalLayer(contentLayer: contentLayer, borderContentFrame: borderContentFrame)
    }

    // 2) set up border mask layer
    resetBorderStyle()

    switch borderMask {
    case .cornerRadius(let cornerRadius, let cornerCurve, let offset):
      updateMaskLayerForCornerRadius(
        cornerRadius,
        cornerCurve: cornerCurve,
        offset: offset,
        borderContentFrame: borderContentFrame
      )
    case .shape(let shape, let offset):
      updateMaskLayerForShape(
        shape,
        offset: offset,
        borderContentFrame: borderContentFrame
      )
    }
  }

  // MARK: - Helpers

  #if DEBUG
  /// Test override for `usesNativeBorderOffset`.
  fileprivate var testUsesNativeBorderOffset: Bool?
  #endif

  /// Whether to use the native "borderOffset" property for border.
  fileprivate var usesNativeBorderOffset: Bool {
    #if DEBUG
    if let testUsesNativeBorderOffset {
      return testUsesNativeBorderOffset
    }
    #endif

    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      return true // CALayer supports native "borderOffset" property since macOS 15, iOS 18, tvOS 18, visionOS 2.0
    } else {
      return false
    }
  }

  /// Setup the border content to be a solid color layer.
  private func setupBorderContentColorLayer(color: Color, borderContentFrame: CGRect) {
    // reset unused border content layers
    self.borderContentGradientLayer?.removeFromSuperlayer()
    self.borderContentGradientLayer = nil
    self.borderContentExternalLayer?.removeFromSuperlayer()
    self.borderContentExternalLayer = nil

    // set up border content color layer
    let borderContentColorLayer = self.borderContentColorLayer ?? {
      let colorLayer = CALayer()
      colorLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
      self.borderContentColorLayer = colorLayer
      return colorLayer
    }()

    borderContentColorLayer.background = .color(color)
    borderContentColorLayer.contentsScale = contentsScale

    addSublayer(borderContentColorLayer)

    // below code order matters, the size animation should be added before the frame is set to the new bounds.

    // add size sync animation so that the border content layer can follow the bounds change
    if let sizeAnimation = self.sizeAnimation() {
      borderContentColorLayer.addFrameAnimation(
        from: borderContentColorLayer.frame, // old frame
        to: borderContentFrame,
        presentationBounds: borderContentColorLayer.presentation()?.frame,
        with: sizeAnimation
      )
    }

    // and set the frame to the border content frame
    borderContentColorLayer.frame = borderContentFrame
  }

  private func setupBorderContentGradientLayer(gradient: GradientColor, borderContentFrame: CGRect) {
    // reset unused border content layers
    self.borderContentColorLayer?.removeFromSuperlayer()
    self.borderContentColorLayer = nil
    self.borderContentExternalLayer?.removeFromSuperlayer()
    self.borderContentExternalLayer = nil

    // set up border content gradient layer
    let borderContentGradientLayer = self.borderContentGradientLayer ?? {
      let gradientLayer = CAGradientLayer()
      gradientLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
      self.borderContentGradientLayer = gradientLayer
      return gradientLayer
    }()

    borderContentGradientLayer.setBackgroundGradientColor(gradient)
    borderContentGradientLayer.contentsScale = contentsScale

    addSublayer(borderContentGradientLayer)

    // below code order matters, the size animation should be added before the frame is set to the new bounds.

    // add size sync animation so that the border content layer can follow the bounds change
    if let sizeAnimation = self.sizeAnimation() {
      borderContentGradientLayer.addFrameAnimation(
        from: borderContentGradientLayer.frame, // old frame
        to: borderContentFrame,
        presentationBounds: borderContentGradientLayer.presentation()?.frame,
        with: sizeAnimation
      )
    }

    // and set the frame to the border content frame
    borderContentGradientLayer.frame = borderContentFrame
  }

  private func setupBorderContentExternalLayer(contentLayer: CALayer, borderContentFrame: CGRect) {
    // reset unused border content layers
    self.borderContentColorLayer?.removeFromSuperlayer()
    self.borderContentColorLayer = nil
    self.borderContentGradientLayer?.removeFromSuperlayer()
    self.borderContentGradientLayer = nil

    // set up border content external layer
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

    // below code order matters, the size animation should be added before the frame is set to the new bounds.
    // if the contentLayer has a full size tracking layer, setting the frame will trigger the full size tracking logic,
    // which will check the contentLayer's size change animation and use it as a reference animation for the contentLayer's full size tracking layer.
    // to make sure the contentLayer's full size tracking layer can see the size change animation,
    // the size animation should be added before the frame is set to the new bounds.

    // add size sync animation so that the border content layer can follow the bounds change
    if let sizeAnimation = self.sizeAnimation() {
      contentLayer.addFrameAnimation(
        from: contentLayer.frame, // old frame
        to: borderContentFrame,
        presentationBounds: contentLayer.presentation()?.frame,
        with: sizeAnimation
      )
    }

    // and set the frame to the border content frame
    contentLayer.frame = borderContentFrame
  }

  private func resetBorderStyle() {
    super.borderColor = Color.black.cgColor
    super.borderWidth = 0
    super.cornerRadius = 0
    self.cornerCurve = .continuous
    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      self.borderOffset = 0
    }
  }

  private func updateMaskLayerForCornerRadius(_ cornerRadius: CGFloat,
                                              cornerCurve: CALayerCornerCurve,
                                              offset: CGFloat,
                                              borderContentFrame: CGRect)
  {
    let borderMaskLayer: CALayer
    if let existingMaskLayer = self.borderMaskLayer, (existingMaskLayer as? MaskShapeLayer) == nil {
      borderMaskLayer = existingMaskLayer
    } else {
      let newMaskLayer = CALayer()
      newMaskLayer.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
      self.borderMaskLayer = newMaskLayer
      borderMaskLayer = newMaskLayer
    }

    if mask !== borderMaskLayer {
      mask = borderMaskLayer
    }
    borderMaskLayer.contentsScale = contentsScale

    // Pre-iOS 18/macOS 15 compatibility mode emulates borderOffset by moving and resizing the mask layer.
    let maskFrame = usesNativeBorderOffset ? bounds : borderContentFrame.expanded(by: min(offset, 0))

    if let sizeAnimation = self.sizeAnimation() {
      borderMaskLayer.addFrameAnimation(
        from: borderMaskLayer.frame, // old frame
        to: maskFrame,
        presentationBounds: borderMaskLayer.presentation()?.frame,
        with: sizeAnimation
      )
    }

    borderMaskLayer.frame = maskFrame

    borderMaskLayer.cornerRadius = usesNativeBorderOffset ? cornerRadius : max(0, cornerRadius + offset)
    borderMaskLayer.borderWidth = borderWidthValue
    borderMaskLayer.cornerCurve = cornerCurve
    if usesNativeBorderOffset, #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      borderMaskLayer.borderOffset = offset
    }
  }

  private func updateMaskLayerForShape(_ shape: any Shape,
                                       offset: CGFloat,
                                       borderContentFrame: CGRect)
  {
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

    // add size sync animation so that the border mask layer can follow the bounds change
    if let sizeAnimation = self.sizeAnimation() {
      borderMaskLayer.addFrameAnimation(
        from: borderMaskLayer.frame, // old frame
        to: borderContentFrame,
        presentationBounds: borderMaskLayer.presentation()?.frame,
        with: sizeAnimation
      )
    }

    borderMaskLayer.frame = borderContentFrame

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
      let boundsExtendedOffset = max(0, offset)
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

    // add path animation so that the border mask layer can follow the bounds change
    if let pathAnimation = self.sizeAnimation()?.copy() as? CABasicAnimation {
      pathAnimation.keyPath = "path"
      pathAnimation.isAdditive = false
      pathAnimation.fromValue = borderMaskLayer.presentation()?.path
      pathAnimation.toValue = borderMaskLayer.path
      borderMaskLayer.add(pathAnimation, forKey: "path")
    }

    borderMaskLayer.lineWidth = 2 * borderWidthValue // double width so half is inside, half is outside
  }

  // TODO: support animations
  // public func animate() {}
}

// MARK: - Testing

#if DEBUG

extension BorderLayer.Test {

  var usesNativeBorderOffset: Bool {
    get {
      (self.host as! BorderLayer).usesNativeBorderOffset // swiftlint:disable:this force_cast
    }
    set {
      (self.host as! BorderLayer).testUsesNativeBorderOffset = newValue // swiftlint:disable:this force_cast
    }
  }
}

#endif

// MARK: - MaskShapeLayer

/// A masked shape layer.
///
/// - The layer has a mask that clips the layer's content with a path.
/// - The layer is a shape layer, it can set stroke, fill, etc.
private class MaskShapeLayer: CAShapeLayer {

  /// The path of the mask.
  ///
  /// - Parameter bounds: The bounds of the layer.
  /// - Returns: The path of the mask.
  var maskPath: ((CGRect) -> CGPath) = { CGPath(rect: $0, transform: nil) } {
    didSet {
      updateMaskPath()
    }
  }

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
    let maskLayerOldPath = maskLayer.path

    let maskLayerNewPath = maskPath(bounds)
    maskLayer.frame = bounds
    maskLayer.path = maskLayerNewPath

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
        pathAnimation.fromValue = maskLayer.presentation()?.path ?? maskLayerOldPath
        pathAnimation.toValue = maskLayerNewPath
        maskLayer.add(pathAnimation, forKey: "path")
      }
    }
  }

  private func updateMaskPath() {
    guard let maskLayer = mask as? CAShapeLayer else {
      return
    }

    maskLayer.path = maskPath(bounds)
  }
}
