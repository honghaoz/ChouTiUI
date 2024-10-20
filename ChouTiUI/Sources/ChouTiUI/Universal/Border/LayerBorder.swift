//
//  LayerBorder.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 6/23/23.
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

import CoreGraphics
import QuartzCore

import ChouTi

/// A type represents `CALayer`'s border info.
public struct LayerBorder: Equatable, CustomStringConvertible {

  /// No border.
  public static let none = LayerBorder(
    borderColor: nil,
    borderWidth: 0
  )

  /// The color of the border.
  public let borderColor: CGColor?

  /// The width of the border.
  public let borderWidth: CGFloat

  /// Creates a layer border with the given color and width.
  /// - Parameters:
  ///   - borderColor: The color of the border.
  ///   - borderWidth: The width of the border.
  public init(borderColor: CGColor?, borderWidth: CGFloat) {
    self.borderColor = borderColor
    self.borderWidth = borderWidth
  }

  /// Creates a layer border with the given border.
  /// - Parameter border: The border to create the layer border with.
  public init(border: Border) {
    self.borderColor = border.color.solidColor.assert("LayerBorder only supports solid color", metadata: ["borderColor": "\(border.color)"])?.cgColor
    self.borderWidth = border.width
  }

  /// Returns a new layer border with the given color.
  /// - Parameter value: The color of the border.
  /// - Returns: A new layer border with the given color.
  @inlinable
  @inline(__always)
  public func borderColor(_ value: CGColor?) -> LayerBorder {
    LayerBorder(borderColor: value, borderWidth: borderWidth)
  }

  /// Returns a new layer border with the given width.
  /// - Parameter value: The width of the border.
  /// - Returns: A new layer border with the given width.
  @inlinable
  @inline(__always)
  public func borderWidth(_ value: CGFloat) -> LayerBorder {
    LayerBorder(borderColor: borderColor, borderWidth: value)
  }

  // MARK: - CustomStringConvertible

  public var description: String {
    "LayerBorder(borderColor: \(borderColor, default: "nil"), borderWidth: \(borderWidth))"
  }
}

// MARK: - View + LayerBorder

public extension View {

  /// Returns the layer border of the view.
  var layerBorder: LayerBorder {
    get {
      guard let layer = layer() else {
        ChouTi.assertFailure("view must have a layer", metadata: ["view": "\(self)"])
        return LayerBorder.none
      }
      return layer.layerBorder
    }
    set {
      guard let layer = layer() else {
        ChouTi.assertFailure("view must have a layer", metadata: ["view": "\(self)"])
        return
      }
      layer.layerBorder = newValue
    }
  }

  /// Updates the layer's border with the given layer border.
  /// - Parameter layerBorder: The layer border to update the layer with.
  func updateBorder(with layerBorder: LayerBorder) {
    guard let layer = layer() else {
      ChouTi.assertFailure("view must have a layer", metadata: ["view": "\(self)"])
      return
    }
    layer.updateBorder(with: layerBorder)
  }
}

// MARK: - CALayer + LayerBorder

public extension CALayer {

  /// Returns the layer border of the layer.
  var layerBorder: LayerBorder {
    get {
      LayerBorder(
        borderColor: borderColor,
        borderWidth: borderWidth
      )
    }
    set {
      updateBorder(with: newValue)
    }
  }

  /// Updates the layer's border with the given layer border.
  /// - Parameter layerBorder: The layer border to update the layer with.
  func updateBorder(with layerBorder: LayerBorder) {
    borderColor = layerBorder.borderColor
    borderWidth = layerBorder.borderWidth
  }
}
