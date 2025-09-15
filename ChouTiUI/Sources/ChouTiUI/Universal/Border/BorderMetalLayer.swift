//
//  BorderMetalLayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/13/25.
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

import QuartzCore
import Metal

import ChouTi

/// A layer that can be used to render a border following a shape.
public final class BorderMetalLayer: CAMetalLayer {

  /// Creates a border metal layer.
  override public init() {
    super.init()
    configureCIImageRenderer()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    // swiftlint:disable:next fatal_error
    fatalError("init(coder:) is unavailable")
  }

  /// Updates the border of the layer.
  ///
  /// Example:
  /// ```swift
  /// let borderLayer = BorderMetalLayer()
  ///
  /// borderLayer.updateBorder(
  ///   width: 2,
  ///   content: .linearGradient(
  ///     startColor: .red,
  ///     endColor: .blue,
  ///     startPoint: .left,
  ///     endPoint: .right
  ///   ),
  ///   shape: Circle(),
  ///   bounds: metalLayer.bounds, // or live bounds while animating
  ///   scale: 3
  /// )
  /// ```
  ///
  /// - Parameters:
  ///   - width: The border width.
  ///   - content: The content of the border.
  ///   - shape: The shape of the border.
  ///   - bounds: The bounds of the border. If not provided, the layer's `bounds` will be used.
  ///   - scale: The scale of the border image. If not provided, the layer's `contentsScale` will be used.
  public func updateBorder(width: CGFloat,
                           content: CIImage.BorderContent,
                           shape: some Shape,
                           bounds: CGRect? = nil,
                           scale: CGFloat? = nil)
  {
    let bounds = bounds ?? self.bounds
    let scale = scale ?? contentsScale

    let borderImage = CIImage.makeBorderImage(width: width, content: content, shape: shape, size: bounds.size, scale: scale)
    render(borderImage, renderSize: bounds.size * contentsScale)
  }
}
