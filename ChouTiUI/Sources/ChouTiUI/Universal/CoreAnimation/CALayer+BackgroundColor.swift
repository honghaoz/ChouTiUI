//
//  CALayer+BackgroundColor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/24/22.
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import CoreGraphics
import QuartzCore

import ChouTi
@_spi(Private) import ComposeUI

/**
 Extends `CALayer` to support unified background color.
 */

private enum AssociateKey {
  static var background: UInt8 = 0
  static var backgroundGradientLayer: UInt8 = 0
  static var animationGradientLayer: UInt8 = 0
  static var solidColorAnimation: UInt8 = 0
}

public extension CALayer {

  /// The unified background color of this layer.
  var background: UnifiedColor? {
    get {
      getAssociatedObject(for: &AssociateKey.background) as? UnifiedColor
    }
    set {
      let oldBackground = background
      setAssociatedObject(newValue, for: &AssociateKey.background)
      updateBackground(oldBackground: oldBackground)
    }
  }

  /// An optional gradient layer used as the background layer.
  @_spi(Private)
  private(set) var backgroundGradientLayer: BaseCAGradientLayer? {
    get {
      getAssociatedObject(for: &AssociateKey.backgroundGradientLayer) as? BaseCAGradientLayer
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.backgroundGradientLayer)
    }
  }

  private func updateBackground(oldBackground: UnifiedColor?) {
    switch (oldBackground, background) {
    case (nil, nil):
      ChouTi.assert(backgroundGradientLayer == nil)
      backgroundColor = nil
      isOpaque = false
      backgroundGradientLayer = nil

    case (nil, .some(let newBackgroundColor)):
      // add new background color
      ChouTi.assert(backgroundGradientLayer == nil)

      switch newBackgroundColor {
      case .gradient(let gradient):
        backgroundColor = nil
        isOpaque = false

        // add gradient
        let gradientLayer = BaseCAGradientLayer()
        gradientLayer.setBackgroundGradientColor(gradient.gradientColor)
        addFullSizeSublayer(gradientLayer, at: 0)
        backgroundGradientLayer = gradientLayer

      case .color(let color):
        // add solid color
        backgroundColor = color.cgColor
        isOpaque = color.isOpaque
      }

    case (_, nil):
      // remove background color
      backgroundColor = nil
      isOpaque = false
      backgroundGradientLayer.map { self.removeFullSizeSublayer($0) }
      backgroundGradientLayer = nil

    case (.some(let oldBackgroundColor), .some(let newBackgroundColor)):
      switch (oldBackgroundColor, newBackgroundColor) {
      case (.gradient, .gradient(let newGradient)):
        // gradient -> gradient
        backgroundColor = nil
        isOpaque = false

        // reuse gradient
        ChouTi.assert(backgroundGradientLayer != nil)
        backgroundGradientLayer?.setBackgroundGradientColor(newGradient.gradientColor)

      case (.color, .gradient(let newGradient)):
        // solid -> gradient
        backgroundColor = nil
        isOpaque = false

        let gradientLayer = BaseCAGradientLayer()
        gradientLayer.setBackgroundGradientColor(newGradient.gradientColor)
        addFullSizeSublayer(gradientLayer, at: 0)
        backgroundGradientLayer = gradientLayer

      case (.gradient, .color(let newColor)):
        // gradient -> solid
        backgroundColor = newColor.cgColor
        isOpaque = newColor.isOpaque

        // remove gradient
        ChouTi.assert(backgroundGradientLayer != nil)
        backgroundGradientLayer.map { self.removeFullSizeSublayer($0) }
        backgroundGradientLayer = nil

      case (.color, .color(let newColor)):
        // solid -> solid
        backgroundColor = newColor.cgColor
        isOpaque = newColor.isOpaque

        ChouTi.assert(backgroundGradientLayer == nil)
      }
    }
  }
}

public extension CALayer {

  /// Set layer's background color.
  /// - Parameter color: The color or nil (to clear the background color).
  @inlinable
  @inline(__always)
  func setBackgroundColor(_ color: Color?) {
    background = color?.unifiedColor
  }

  /// Set layer's background color to linear gradient color.
  /// - Parameter color: The linear gradient color.
  @inlinable
  @inline(__always)
  func setBackgroundColor(_ color: LinearGradientColor) {
    background = .linearGradient(color)
  }

  /// Set layer's background color to radial gradient color.
  /// - Parameter color: The radial gradient color.
  @inlinable
  @inline(__always)
  func setBackgroundColor(_ color: RadialGradientColor) {
    background = .radialGradient(color)
  }

  /// Set layer's background color to angular gradient color.
  /// - Parameter color: The angular gradient color.
  @inlinable
  @inline(__always)
  func setBackgroundColor(_ color: AngularGradientColor) {
    background = .angularGradient(color)
  }

  /// Remove layer's background color.
  func removeBackgroundColor() {
    background = nil
  }
}

// MARK: - Animations

public extension CALayer {

  /// The gradient layer used for the background color animation.
  private var animationGradientLayer: AnimatedGradientLayer? {
    get {
      getAssociatedObject(for: &AssociateKey.animationGradientLayer) as? AnimatedGradientLayer
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.animationGradientLayer)
    }
  }

  /// The solid color animation of the layer.
  private var solidColorAnimation: CABasicAnimation? {
    get {
      getAssociatedObject(for: &AssociateKey.solidColorAnimation) as? CABasicAnimation
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.solidColorAnimation)
    }
  }

  /// Animate the background color of the layer.
  ///
  /// The layer's `background` property will be updated to the new color.
  ///
  /// - Note: Animating from one gradient to another requires both gradients to have the same type (e.g. linear -> linear).
  ///   For mismatched types (e.g. linear -> radial), the background is updated to the new value without animation.
  ///
  /// - Parameters:
  ///   - fromColor: The from color. If `nil`, the current background color will be used. Default is `nil`.
  ///   - toColor: The to color. If `nil`, the background color will be cleared.
  ///   - timing: The timing of the animation.
  func animateBackground(from fromColor: UnifiedColor? = nil, to toColor: UnifiedColor?, timing: AnimationTiming) {
    let fromColor: UnifiedColor = fromColor ?? {
      if let animationGradientLayer {
        // has animation gradient layer, there's a in-progress animation, use the current background color
        let presentation = animationGradientLayer.presentation() ?? animationGradientLayer
        let colors = presentation.getColors()
        let locations = presentation.getLocations()
        let startPoint = presentation.getStartPoint()
        let endPoint = presentation.getEndPoint()

        switch animationGradientLayer.type {
        case .axial:
          // linear
          return .linearGradient(LinearGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint))
        case .radial:
          // radial
          return .radialGradient(RadialGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint))
        case .conic:
          // angular
          return .angularGradient(AngularGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint))
        default:
          ChouTi.assertFailure("unsupported gradient type: \(animationGradientLayer.type)")
          return .linearGradient(LinearGradientColor(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint))
        }
      } else if solidColorAnimation != nil {
        // has solid color animation, there's a in-progress animation, use the current background color
        #if canImport(AppKit)
        return UnifiedColor.color(Color(cgColor: presentation().assertNotNil("missing presentation layer")?.backgroundColor ?? backgroundColor ?? CGColor.clear) ?? .clear)
        #endif
        #if canImport(UIKit)
        return UnifiedColor.color(Color(cgColor: presentation().assertNotNil("missing presentation layer")?.backgroundColor ?? backgroundColor ?? .clear))
        #endif
      } else {
        // no animation, just use the model value
        #if canImport(AppKit)
        return background ?? UnifiedColor.color(Color(cgColor: backgroundColor ?? .clear).assertNotNil("failed to convert CGColor to Color") ?? .clear)
        #endif
        #if canImport(UIKit)
        return background ?? UnifiedColor.color(Color(cgColor: backgroundColor ?? .clear))
        #endif
      }
    }()

    let toColor: UnifiedColor = toColor ?? UnifiedColor.color(.clear)

    switch (fromColor, toColor) {
    case (.color(let fromSolidColor), .color(let toSolidColor)):
      // solid -> solid
      ChouTi.assert(animationGradientLayer == nil, "animationGradientLayer should be nil")
      animate(
        keyPath: "backgroundColor",
        timing: timing,
        from: { _ in fromSolidColor.cgColor },
        to: { _ in toSolidColor.cgColor },
        updateAnimation: { [weak self] animation in
          self?.solidColorAnimation = animation

          animation.delegate = AnimationDelegate(
            animationDidStop: { [weak self, weak animation] _, finished in
              if self?.solidColorAnimation === animation {
                self?.solidColorAnimation = nil
              }
            }
          )
        }
      )
    case (.color(let fromSolidColor), .gradient(let toGradientColor)):
      // solid -> gradient
      let (gradientLayer, animationId) = prepareAnimationGradientLayer(with: toGradientColor)
      let teardownDelegate = makeTearDownAnimationDelegate(animationId: animationId)

      gradientLayer.animate(
        keyPath: "colors",
        timing: timing,
        from: { layer in
          guard let colors = layer.colors else {
            ChouTi.assertFailure("unexpected missing gradient colors")
            return nil
          }
          return Array(repeating: fromSolidColor.cgColor, count: colors.count)
        },
        to: { layer in layer.colors },
        updateAnimation: { $0.delegate = teardownDelegate }
      )
    case (.gradient(let fromGradientColor), .color(let toSolidColor)):
      // gradient -> solid
      let (gradientLayer, animationId) = prepareAnimationGradientLayer(with: fromGradientColor)
      let teardownDelegate = makeTearDownAnimationDelegate(animationId: animationId)

      gradientLayer.animate(
        keyPath: "colors",
        timing: timing,
        from: { layer in layer.colors },
        to: { layer in
          guard let colors = layer.colors else {
            ChouTi.assertFailure("unexpected missing gradient colors")
            return nil
          }
          return Array(repeating: toSolidColor.cgColor, count: colors.count)
        },
        updateAnimation: { $0.delegate = teardownDelegate }
      )
    case (.gradient(let fromGradientColor), .gradient(let toGradientColor)):
      // gradient -> gradient
      ChouTi.assert(fromGradientColor.gradientLayerType == toGradientColor.gradientLayerType, "mismatch gradient layer type")
      guard fromGradientColor.gradientLayerType == toGradientColor.gradientLayerType else {
        // can't animate between different gradient layer types, skip the animation and let the background update below
        // apply the new background directly.
        break
      }

      let (gradientLayer, animationId) = prepareAnimationGradientLayer(with: toGradientColor)
      let teardownDelegate = makeTearDownAnimationDelegate(animationId: animationId)

      // Core Animation can't interpolate arrays of different lengths (the animation jumps discretely), so pad the
      // shorter colors/locations to the same length. Repeating the last color/location adds zero-width gradient stops,
      // which render identically to the original gradient.
      let colorCount = max(fromGradientColor.colors.count, toGradientColor.colors.count)
      let fromColors = fromGradientColor.colors.map(\.cgColor).padded(to: colorCount)
      let toColors = toGradientColor.colors.map(\.cgColor).padded(to: colorCount)
      let fromLocations = fromGradientColor.locationNSNumbers.padded(to: colorCount)
      let toLocations = toGradientColor.locationNSNumbers.padded(to: colorCount)

      gradientLayer.animate(
        keyPath: "colors",
        timing: timing,
        from: { _ in fromColors },
        to: { _ in toColors },
        updateAnimation: { $0.delegate = teardownDelegate }
      )
      gradientLayer.animate(
        keyPath: "locations",
        timing: timing,
        from: { _ in fromLocations },
        to: { _ in toLocations }
      )
      gradientLayer.animate(
        keyPath: "startPoint",
        timing: timing,
        from: { _ in fromGradientColor.startPoint.cgPoint },
        to: { _ in toGradientColor.startPoint.cgPoint }
      )
      gradientLayer.animate(
        keyPath: "endPoint",
        timing: timing,
        from: { _ in fromGradientColor.endPoint.cgPoint },
        to: { _ in toGradientColor.endPoint.cgPoint }
      )
    }

    CATransaction.disableAnimations { // disable the implicit animation
      background = toColor
    }
  }

  /// Prepare the animation gradient layer for a background animation.
  ///
  /// - Parameter gradientColor: The gradient color to set on the animation gradient layer, without an implicit animation.
  /// - Returns: The animation gradient layer, tagged with a new animation id.
  private func prepareAnimationGradientLayer(with gradientColor: GradientColorType) -> (gradientLayer: AnimatedGradientLayer, animationId: MachTimeId) {
    let gradientLayer = CATransaction.disableAnimations {
      let gradientLayer = prepareAnimationGradientLayer()
      gradientLayer.setBackgroundGradientColor(gradientColor)
      return gradientLayer
    }

    let animationId = MachTimeId.id()
    gradientLayer.animationId = animationId
    return (gradientLayer, animationId)
  }

  /// Make an animation delegate that tears down the animation gradient layer when the animation stops.
  ///
  /// - Parameter animationId: The id of the animation that the delegate is attached to. The teardown only happens if the
  ///   animation gradient layer's current animation id still matches this id, so that a stale animation's completion
  ///   doesn't tear down the animation gradient layer reused by a newer animation.
  /// - Returns: The animation delegate.
  private func makeTearDownAnimationDelegate(animationId: MachTimeId) -> AnimationDelegate {
    AnimationDelegate(
      animationDidStop: { [weak self] _, _ in
        if self?.animationGradientLayer?.animationId == animationId {
          self?.tearDownAnimationGradientLayer()
        }
      }
    )
  }

  private func prepareAnimationGradientLayer() -> AnimatedGradientLayer {
    if let animationGradientLayer {
      return animationGradientLayer
    }

    let gradientLayer = AnimatedGradientLayer()

    // insert the animation gradient layer below the layer's content sublayers so that the animating background doesn't
    // cover the layer's content:
    // - if there's a background gradient layer, insert just above it.
    // - otherwise, insert at the bottom. if the background is updated to a gradient at the end of `animateBackground`,
    //   the new background gradient layer is inserted at index 0, which places it right below this animation gradient layer.
    let index: UInt32
    if let backgroundGradientLayer,
       let backgroundGradientLayerIndex = sublayers?.firstIndex(where: { $0 === backgroundGradientLayer })
    {
      index = UInt32(backgroundGradientLayerIndex) + 1
    } else {
      index = 0
    }
    addFullSizeSublayer(gradientLayer, at: index)

    self.animationGradientLayer = gradientLayer
    return gradientLayer
  }

  private func tearDownAnimationGradientLayer() {
    animationGradientLayer.map { self.removeFullSizeSublayer($0) }
    animationGradientLayer = nil
  }
}

private final class AnimatedGradientLayer: BaseCAGradientLayer {

  /// The id for the animation running on this layer.
  var animationId: MachTimeId?
}

private extension CAGradientLayer {

  /// Get the colors of the gradient layer.
  func getColors() -> [Color] {
    (colors ?? []).map { value -> Color in
      #if canImport(AppKit)
      return Color(cgColor: value as! CGColor) ?? .clear // swiftlint:disable:this force_cast
      #endif
      #if canImport(UIKit)
      return Color(cgColor: value as! CGColor) // swiftlint:disable:this force_cast
      #endif
    }
  }

  func getLocations() -> [CGFloat] {
    (locations ?? []).map { CGFloat($0.doubleValue) }
  }

  func getStartPoint() -> UnitPoint {
    UnitPoint(x: startPoint.x, y: startPoint.y)
  }

  func getEndPoint() -> UnitPoint {
    UnitPoint(x: endPoint.x, y: endPoint.y)
  }
}

private extension CGColor {

  static let clear = Color.clear.cgColor
}

private extension Array {

  /// Pad the array to the given count by repeating the last element.
  ///
  /// - Parameter count: The target element count.
  /// - Returns: The padded array, or the original array if it's empty or already has at least `count` elements.
  func padded(to count: Int) -> [Element] {
    guard self.count < count, let last else {
      return self
    }
    return self + Array(repeating: last, count: count - self.count)
  }
}

// MARK: - Testing

#if DEBUG

extension CALayer.Test {

  var animationGradientLayer: BaseCAGradientLayer? {
    host.animationGradientLayer
  }

  var solidColorAnimation: CABasicAnimation? {
    host.solidColorAnimation
  }
}

#endif
