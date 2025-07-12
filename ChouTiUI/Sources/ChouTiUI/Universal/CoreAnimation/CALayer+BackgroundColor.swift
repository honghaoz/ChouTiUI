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
  static var boundsToken: UInt8 = 0
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

  private var boundsToken: CancellableToken? {
    get { getAssociatedObject(for: &AssociateKey.boundsToken) as? CancellableToken }
    set { setAssociatedObject(newValue, for: &AssociateKey.boundsToken) }
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
        gradientLayer.frame = bounds
        insertSublayer(gradientLayer, at: 0)
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
      backgroundGradientLayer?.removeFromSuperlayer()
      backgroundGradientLayer = nil

    case (.some(let oldBackgroundColor), .some(let newBackgroundColor)):
      switch (oldBackgroundColor.gradientColor, newBackgroundColor.gradientColor) {
      case (.some, .some(let newGradient)):
        // gradient -> gradient
        backgroundColor = nil
        isOpaque = false

        // reuse gradient
        ChouTi.assert(backgroundGradientLayer != nil)
        backgroundGradientLayer?.setBackgroundGradientColor(newGradient)
        backgroundGradientLayer?.frame = bounds

      case (nil, .some(let newGradient)):
        // solid -> gradient
        backgroundColor = nil
        isOpaque = false

        let gradientLayer = BaseCAGradientLayer()
        gradientLayer.setBackgroundGradientColor(newGradient)
        gradientLayer.frame = bounds
        insertSublayer(gradientLayer, at: 0)
        backgroundGradientLayer = gradientLayer

      case (.some, nil):
        // gradient -> solid
        backgroundColor = newBackgroundColor.solidColor!.cgColor // swiftlint:disable:this force_unwrapping
        isOpaque = newBackgroundColor.solidColor!.isOpaque // swiftlint:disable:this force_unwrapping

        // remove gradient
        ChouTi.assert(backgroundGradientLayer != nil)
        backgroundGradientLayer?.removeFromSuperlayer()
        backgroundGradientLayer = nil

      case (nil, nil):
        // solid -> solid
        backgroundColor = newBackgroundColor.solidColor!.cgColor // swiftlint:disable:this force_unwrapping
        isOpaque = newBackgroundColor.solidColor!.isOpaque // swiftlint:disable:this force_unwrapping

        ChouTi.assert(backgroundGradientLayer == nil)
      }
    }

    // listen to bounds change to keep gradient layer's frame updated
    if boundsToken == nil {
      boundsToken = onBoundsChange { [weak self] _, oldBounds, newBounds in
        self?.boundsChanged(oldBounds, newBounds)
      }
    }
  }

  private func boundsChanged(_ oldBounds: CGRect, _ newBounds: CGRect) {
    if let backgroundGradientLayer {
      backgroundGradientLayer.frame = bounds
      addSizeSynchronizationAnimation(to: backgroundGradientLayer, oldBounds: oldBounds, newBounds: newBounds)
    }

    if let animationGradientLayer {
      animationGradientLayer.frame = bounds
      addSizeSynchronizationAnimation(to: animationGradientLayer, oldBounds: oldBounds, newBounds: newBounds)
    }
  }

  /// Add size synchronization animation to the layer so that the layer can always follow the host layer's size.
  private func addSizeSynchronizationAnimation(to layer: CALayer, oldBounds: CGRect, newBounds: CGRect) {
    RunLoop.main.perform { // schedule to the next run loop to make sure the animation added after the bounds change can be found
      if let sizeAnimation = self.sizeAnimation() {

        if let positionAnimationCopy = sizeAnimation.copy() as? CABasicAnimation,
           let sizeAnimationCopy = sizeAnimation.copy() as? CABasicAnimation
        {

          positionAnimationCopy.keyPath = "position"
          let positionAnimationKey: String
          if positionAnimationCopy.isAdditive {
            let oldPosition = layer.position(from: oldBounds)
            let newPosition = layer.position(from: newBounds)
            positionAnimationCopy.fromValue = CGPoint(x: oldPosition.x - newPosition.x, y: oldPosition.y - newPosition.y)
            positionAnimationCopy.toValue = CGPoint.zero
            positionAnimationKey = layer.uniqueAnimationKey(key: "position")
          } else {
            positionAnimationCopy.fromValue = (self.presentation()?.bounds ?? oldBounds).center
            positionAnimationCopy.toValue = newBounds.center
            positionAnimationKey = "position"
          }

          sizeAnimationCopy.keyPath = "bounds.size"
          let sizeAnimationKey: String
          if sizeAnimationCopy.isAdditive {
            sizeAnimationCopy.fromValue = CGSize(width: oldBounds.size.width - newBounds.size.width, height: oldBounds.size.height - newBounds.size.height)
            sizeAnimationCopy.toValue = CGSize.zero
            sizeAnimationKey = layer.uniqueAnimationKey(key: "bounds.size")
          } else {
            sizeAnimationCopy.fromValue = (self.presentation()?.bounds ?? oldBounds).size
            sizeAnimationCopy.toValue = newBounds.size
            sizeAnimationKey = "bounds.size"
          }

          layer.add(positionAnimationCopy, forKey: positionAnimationKey)
          layer.add(sizeAnimationCopy, forKey: sizeAnimationKey)

        } else {
          ChouTi.assertFailure("failed to copy size animation", metadata: [
            "sizeAnimation": "\(sizeAnimation)",
          ])
        }
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
        return UnifiedColor.color(Color(cgColor: presentation().assert("missing presentation layer")?.backgroundColor ?? backgroundColor ?? CGColor.clear) ?? .clear)
        #endif
        #if canImport(UIKit)
        return UnifiedColor.color(Color(cgColor: presentation().assert("missing presentation layer")?.backgroundColor ?? backgroundColor ?? .clear))
        #endif
      } else {
        // no animation, just use the model value
        #if canImport(AppKit)
        return background ?? UnifiedColor.color(Color(cgColor: backgroundColor ?? .clear).assert("failed to convert CGColor to Color") ?? .clear)
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
      let gradientLayer = CATransaction.disableAnimations {
        let gradientLayer = prepareAnimationGradientLayer()
        gradientLayer.setBackgroundGradientColor(toGradientColor)
        return gradientLayer
      }

      let animationId = MachTimeId.id()
      gradientLayer.animationId = animationId

      gradientLayer.animate(
        keyPath: "colors",
        timing: timing,
        from: { layer in
          guard let colors = (layer as? CAGradientLayer)?.colors else {
            return nil
          }
          return Array(repeating: fromSolidColor.cgColor, count: colors.count)
        },
        to: { layer in (layer as? CAGradientLayer)?.colors },
        updateAnimation: { animation in
          animation.delegate = AnimationDelegate(
            animationDidStop: { [weak self] animation, finished in
              if self?.animationGradientLayer?.animationId == animationId {
                self?.tearDownAnimationGradientLayer()
              }
            }
          )
        }
      )
    case (.gradient(let fromGradientColor), .color(let toSolidColor)):
      // gradient -> solid
      let gradientLayer = CATransaction.disableAnimations {
        let gradientLayer = prepareAnimationGradientLayer()
        gradientLayer.setBackgroundGradientColor(fromGradientColor)
        return gradientLayer
      }

      let animationId = MachTimeId.id()
      gradientLayer.animationId = animationId

      gradientLayer.animate(
        keyPath: "colors",
        timing: timing,
        from: { layer in (layer as? CAGradientLayer)?.colors },
        to: { layer in
          guard let colors = (layer as? CAGradientLayer)?.colors else {
            return nil
          }
          return Array(repeating: toSolidColor.cgColor, count: colors.count)
        },
        updateAnimation: { animation in
          animation.delegate = AnimationDelegate(
            animationDidStop: { [weak self] animation, finished in
              if self?.animationGradientLayer?.animationId == animationId {
                self?.tearDownAnimationGradientLayer()
              }
            }
          )
        }
      )
    case (.gradient(let fromGradientColor), .gradient(let toGradientColor)):
      // gradient -> gradient
      ChouTi.assert(fromGradientColor.gradientLayerType == toGradientColor.gradientLayerType, "mismatch gradient layer type")

      let gradientLayer = CATransaction.disableAnimations {
        let gradientLayer = prepareAnimationGradientLayer()
        gradientLayer.setBackgroundGradientColor(toGradientColor)
        return gradientLayer
      }

      let animationId = MachTimeId.id()
      gradientLayer.animationId = animationId

      gradientLayer.animate(
        keyPath: "colors",
        timing: timing,
        from: { _ in fromGradientColor.colors.map(\.cgColor) },
        to: { _ in toGradientColor.colors.map(\.cgColor) },
        updateAnimation: { animation in
          animation.delegate = AnimationDelegate(
            animationDidStop: { [weak self] animation, finished in
              if self?.animationGradientLayer?.animationId == animationId {
                self?.tearDownAnimationGradientLayer()
              }
            }
          )
        }
      )
      gradientLayer.animate(
        keyPath: "locations",
        timing: timing,
        from: { _ in fromGradientColor.locationNSNumbers },
        to: { _ in toGradientColor.locationNSNumbers }
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

  private func prepareAnimationGradientLayer() -> AnimatedGradientLayer {
    if let animationGradientLayer {
      return animationGradientLayer
    }

    let gradientLayer = AnimatedGradientLayer()
    gradientLayer.frame = bounds
    addSublayer(gradientLayer)
    self.animationGradientLayer = gradientLayer
    return gradientLayer
  }

  private func tearDownAnimationGradientLayer() {
    animationGradientLayer?.removeFromSuperlayer()
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
