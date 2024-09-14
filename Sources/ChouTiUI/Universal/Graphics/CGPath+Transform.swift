//
//  CGPath+Transform.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/17/21.
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
import ChouTi

public extension CGPath {

  // MARK: - Resize

  /// Defines the mode for resizing a path.
  enum ResizeMode {

    /// Fit the path within the new size, preserving aspect ratio and potentially leaving empty space.
    case aspectFit

    /// Fill the new size with the path, preserving aspect ratio and potentially cropping the path.
    case aspectFill

    /// Stretch the path to fill the new size, potentially altering its aspect ratio.
    case fill
  }

  /// Resize the path to a new canvas size.
  ///
  /// This method uses the bounding box containing all points of the path as its canvas size to resize the path.
  ///
  /// - Parameter size: The new canvas size to resize the path to.
  /// - Returns: A new `CGPath` instance resized.
  func resizing(to boundingSize: CGSize, mode: ResizeMode) -> CGPath {
    let oldBoundingRect = self.boundingBoxOfPath
    let normalizedPath = self.translate(dx: -oldBoundingRect.origin.x, dy: -oldBoundingRect.origin.y)
    return normalizedPath.resized(from: oldBoundingRect.size, to: boundingSize, mode: mode)
  }

  /// Resizes the path using a from canvas size and a to canvas size.
  ///
  /// - Parameters:
  ///   - fromCanvasSize: The canvas size containing the path.
  ///   - toCanvasSize: The new canvas size to resize the path to.
  ///   - mode: The resize mode to apply. See `ResizeMode` for available options.
  /// - Returns: A new `CGPath` instance resized according to the specified parameters.
  ///
  /// - Note: The original path remains unchanged. This method creates and returns a new path.
  func resized(from fromCanvasSize: CGSize, to toCanvasSize: CGSize, mode: ResizeMode) -> CGPath {
    switch mode {
    case .aspectFit:
      return resizedAspect(from: fromCanvasSize, to: toCanvasSize, isFit: true)
    case .aspectFill:
      return resizedAspect(from: fromCanvasSize, to: toCanvasSize, isFit: false)
    case .fill:
      return resizedScaleToFill(from: fromCanvasSize, to: toCanvasSize)
    }
  }

  /// Resize the path to a new size while preserving its aspect ratio.
  ///
  /// The new path is scaled to fit entirely within the new canvas size, maintaining its aspect ratio.
  /// It will be centered in the new canvas, potentially leaving empty space on two sides.
  ///
  /// If you want to resize the path's shape only (no padding), you can use following code to get a normalized
  /// path and use its `boundingBox` size as the from canvas size.
  ///
  /// ```swift
  /// let originalPath = cgPath
  /// let originalPathBoundingBox = originalPath.boundingBox
  /// let normalizedPath = cgPath.translate(dx: -originalPathBoundingBox.x, dy: -originalPathBoundingBox.y)
  /// let normalizedPathSize = normalizedPath.boundingBox.size
  /// let resizedPath = normalizedPath.resizedFit(from: normalizedPathSize, to: rect.size)
  /// ```
  ///
  /// - Parameters:
  ///   - fromCanvasSize: The path's original canvas size.
  ///   - toCanvasSize: The new canvas size to fit the path within.
  /// - Returns: A resized path that fits within the new canvas size while preserving its aspect ratio.
  private func resizedAspect(from fromCanvasSize: CGSize, to toCanvasSize: CGSize, isFit: Bool) -> CGPath {
    // https://stackoverflow.com/questions/15643626/scale-cgpath-to-fit-uiview
    let fromAspectRatio = fromCanvasSize.width / fromCanvasSize.height
    let toAspectRatio = toCanvasSize.width / toCanvasSize.height

    // let scaleFactor: CGFloat = {
    //   if isFit {
    //     if fromAspectRatio > toAspectRatio {
    //       return toCanvasSize.width / fromCanvasSize.width
    //     } else {
    //       return toCanvasSize.height / fromCanvasSize.height
    //     }
    //   } else {
    //     if fromAspectRatio > toAspectRatio {
    //       return toCanvasSize.height / fromCanvasSize.height
    //     } else {
    //       return toCanvasSize.width / fromCanvasSize.width
    //     }
    //   }
    // }()
    let scaleFactor = (isFit == (fromAspectRatio > toAspectRatio)) ?
      (toCanvasSize.width / fromCanvasSize.width) : (toCanvasSize.height / fromCanvasSize.height)

    let scaledWidth = fromCanvasSize.width * scaleFactor
    let scaledHeight = fromCanvasSize.height * scaleFactor
    let centerOffsetX = (toCanvasSize.width - scaledWidth) / (2 * scaleFactor)
    let centerOffsetY = (toCanvasSize.height - scaledHeight) / (2 * scaleFactor)

    var transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
      .translatedBy(x: centerOffsetX, y: centerOffsetY)

    guard let resizedPath = copy(using: &transform) else {
      ChouTi.assertFailure("Failed to resize the path", metadata: ["path": "\(self)", "from": "\(fromCanvasSize)", "to": "\(toCanvasSize)"])
      return self
    }
    return resizedPath
  }

  /// Scale the path to fill a new size.
  ///
  /// - Parameters:
  ///   - fromCanvasSize: The path's canvas size.
  ///   - toCanvasSize: The new canvas size.
  /// - Returns: A resized path.
  private func resizedScaleToFill(from fromCanvasSize: CGSize, to toCanvasSize: CGSize) -> CGPath {
    var transform = CGAffineTransform(
      scaleX: toCanvasSize.width / fromCanvasSize.width,
      y: toCanvasSize.height / fromCanvasSize.height
    )
    guard let resizedPath = copy(using: &transform) else {
      ChouTi.assertFailure("Failed to resize the path", metadata: ["path": "\(self)", "from": "\(fromCanvasSize)", "to": "\(toCanvasSize)"])
      return self
    }
    return resizedPath
  }

  // MARK: - Translate

  /// Translate the path.
  ///
  /// - Parameters:
  ///   - point: The point represents the offset to translate the path by.
  /// - Returns: A translated path.
  @inlinable
  @inline(__always)
  func translate(_ point: CGPoint) -> CGPath {
    translate(dx: point.x, dy: point.y)
  }

  /// Translate the path by a certain offset.
  ///
  /// - Parameters:
  ///   - dx: The x-coordinate offset.
  ///   - dy: The y-coordinate offset.
  /// - Returns: A translated path.
  func translate(dx: CGFloat = 0, dy: CGFloat = 0) -> CGPath {
    var transform = CGAffineTransform.translation(x: dx, y: dy)
    guard let translatedPath = copy(using: &transform) else {
      ChouTi.assertFailure("Fail to translate the path", metadata: ["path": "\(self)", "dx": "\(dx)", "dy": "\(dy)"])
      return self
    }
    return translatedPath
  }
}
