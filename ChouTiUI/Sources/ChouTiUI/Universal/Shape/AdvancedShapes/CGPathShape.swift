//
//  CGPathShape.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/21/22.
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

/// A shape backed by `CGPath`.
public struct CGPathShape: Shape {

  /// The content mode of the shape.
  public enum ContentMode: Hashable {

    /// The shape is resized to fill the entire rect, with aspect ratio preserved.
    case aspectFill

    /// The shape is resized to fit the entire rect, with aspect ratio preserved.
    case aspectFit

    /// The shape is resized to fill the entire rect, without preserving aspect ratio.
    case stretch
  }

  /// The raw CGPath.
  public let cgPath: CGPath

  /// The size of the canvas that the raw CGPath is defined in.
  public let canvasSize: CGSize

  /// The content mode of the shape.
  public let contentMode: ContentMode

  /// Make a shape from the path with its canvas size.
  ///
  /// The path won't be normalized with zero origin.
  ///
  /// - Parameters:
  ///   - cgPath: The raw CGPath.
  ///   - canvasSize: The size of the canvas that the raw CGPath is defined in.
  ///   - contentMode: The content mode of the shape.
  public init(cgPath: CGPath, canvasSize: CGSize, contentMode: ContentMode) {
    self.cgPath = cgPath
    self.canvasSize = canvasSize
    self.contentMode = contentMode
  }

  /// Make a Shape from the path's shape only.
  ///
  /// The canvas size will be the bounding box of the path, not including control points.
  /// The path will be normalized with zero origin.
  ///
  /// - Parameters:
  ///   - cgPath: The raw CGPath.
  ///   - contentMode: The content mode of the shape.
  public init(cgPath: CGPath, contentMode: ContentMode) {
    let boundingBox = cgPath.boundingBoxOfPath
    let normalizedPath = cgPath.translate(dx: -boundingBox.x, dy: -boundingBox.y)
    self.cgPath = normalizedPath
    self.canvasSize = boundingBox.size
    self.contentMode = contentMode
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    let mode: CGPath.ResizeMode
    switch contentMode {
    case .aspectFill:
      mode = .aspectFill
    case .aspectFit:
      mode = .aspectFit
    case .stretch:
      mode = .fill
    }

    return cgPath.resized(from: canvasSize, to: rect.size, mode: mode).translate(rect.origin)
  }
}
