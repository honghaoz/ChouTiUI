//
//  UnifiedColorNode.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/13/25.
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

@_spi(Private) import ComposeUI

/// A node that renders unified color.
///
/// The node has a flexible size.
public struct UnifiedColorNode: ComposeNode {

  private let color: ThemedUnifiedColor

  /// Creates a new unified color node with a themed unified color.
  ///
  /// - Parameter color: The themed unified color.
  public init(_ color: ThemedUnifiedColor) {
    self.color = color
  }

  /// Creates a new unified color node with a unified color.
  ///
  /// - Parameter color: The unified color.
  public init(_ color: UnifiedColor) {
    self.color = ThemedUnifiedColor(color)
  }

  /// Creates a new unified color node with a color.
  ///
  /// - Parameter color: The color.
  public init(_ color: Color) {
    self.color = ThemedUnifiedColor(color)
  }

  /// Creates a new unified color node with a gradient color.
  ///
  /// - Parameter gradientColor: The gradient color.
  public init(_ gradientColor: GradientColorType) {
    self.color = gradientColor.themedUnifiedColor
  }

  /// Creates a new unified color node with a solid color for both light and dark theme.
  ///
  /// - Parameters:
  ///   - light: The solid color for light theme.
  ///   - dark: The solid color for dark theme.
  public init(light: Color, dark: Color) {
    self.color = ThemedUnifiedColor(light: light, dark: dark)
  }

  /// Creates a new unified color node with a linear gradient color for both light and dark theme.
  ///
  /// - Parameters:
  ///   - light: The linear gradient color for light theme.
  ///   - dark: The linear gradient color for dark theme.
  public init(light: LinearGradientColor, dark: LinearGradientColor) {
    self.color = ThemedUnifiedColor(light: light, dark: dark)
  }

  /// Creates a new unified color node with a radial gradient color for both light and dark theme.
  ///
  /// - Parameters:
  ///   - light: The radial gradient color for light theme.
  ///   - dark: The radial gradient color for dark theme.
  public init(light: RadialGradientColor, dark: RadialGradientColor) {
    self.color = ThemedUnifiedColor(light: light, dark: dark)
  }

  /// Creates a new unified color node with an angular gradient color for both light and dark theme.
  ///
  /// - Parameters:
  ///   - light: The angular gradient color for light theme.
  ///   - dark: The angular gradient color for dark theme.
  public init(light: AngularGradientColor, dark: AngularGradientColor) {
    self.color = ThemedUnifiedColor(light: light, dark: dark)
  }

  // MARK: - ComposeNode

  public var id: ComposeNodeId = .custom("io.chouti.ui.UnifiedColorNode")

  public var size: CGSize = .zero

  public mutating func layout(containerSize: CGSize, context: ComposeNodeLayoutContext) -> ComposeNodeSizing {
    size = containerSize
    return ComposeNodeSizing(width: .flexible, height: .flexible)
  }

  public func renderableItems(in visibleBounds: CGRect) -> [RenderableItem] {
    let frame = CGRect(origin: .zero, size: size)
    guard visibleBounds.intersects(frame) else {
      return []
    }

    let layerItem = LayerItem<CALayer>(
      id: id,
      frame: frame,
      make: { context in
        let layer = CALayer()
        if let initialFrame = context.initialFrame {
          layer.frame = initialFrame
        }
        return layer
      },
      update: { layer, context in
        let color = self.color.resolve(for: (context.contentView as View).theme)
        if let animationTiming = context.animationTiming {
          layer.animateBackground(to: color, timing: animationTiming)
        } else {
          CATransaction.disableAnimations {
            layer.background = color
          }
        }
      }
    )

    return [layerItem.eraseToRenderableItem()]
  }
}
