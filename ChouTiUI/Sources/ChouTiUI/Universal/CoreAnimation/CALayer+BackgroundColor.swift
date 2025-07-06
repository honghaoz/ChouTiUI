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

import ChouTi
import QuartzCore

/**
 Extends `CALayer` to support unified background color.
 */

private enum AssociateKey {
  static var background: UInt8 = 0
  static var backgroundGradientLayer: UInt8 = 0
  static var boundsToken: UInt8 = 0
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

    if background?.gradientColor != nil {
      // if there's a gradient background, listen to bounds change to keep gradient layer's frame updated
      if boundsToken == nil {
        boundsToken = onBoundsChange { [weak self] _, _, _ in
          self?.boundsChanged()
        }
      }
    } else {
      boundsToken?.cancel()
      boundsToken = nil
    }
  }

  private func boundsChanged() {
    guard let backgroundGradientLayer, backgroundGradientLayer.superlayer === self else {
      ChouTi.assertFailure("bounds change call must have gradient background layer")
      return
    }

    backgroundGradientLayer.frame = bounds
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
