//
//  AquaTrafficLightButtons+Glyph.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/3/21.
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

import CoreGraphics

/// The glyph drawn on top of an Aqua traffic light button.
///
/// The paths reproduce the Big Sur era system glyphs. They are drawn in the button circle's square and are point
/// symmetric about its center, so the same path works in flipped and non-flipped coordinates.
enum AquaTrafficLightGlyph: Equatable {

  /// "×", the close glyph.
  case close

  /// "●", the close glyph when the window has unsaved changes.
  case documentEdited

  /// "−", the miniaturize glyph.
  case miniaturize

  /// "+", the zoom glyph.
  case zoom

  /// "◤◢", the enter full screen glyph.
  case enterFullScreen

  /// "◢ ◤", the exit full screen glyph.
  case exitFullScreen

  /// Makes the glyph path.
  ///
  /// - Parameters:
  ///   - rect: The rect of the button circle. The glyph is drawn in the centered square of the rect.
  ///   - isTahoe: Whether to use the macOS 26 (Tahoe) geometry, which draws the full screen glyphs with a larger inset
  ///     because the Tahoe buttons are larger.
  /// - Returns: The glyph path.
  func path(in rect: CGRect, isTahoe: Bool) -> CGPath {
    let square = rect.squareRect()
    switch self {
    case .close:
      return Self.crossPath(in: square, rotation: .pi / 4)
    case .documentEdited:
      return CGPath(ellipseIn: square.insetBy(dx: Constants.documentEditedDotInset, dy: Constants.documentEditedDotInset), transform: nil)
    case .miniaturize:
      return Self.barPath(in: square)
    case .zoom:
      return Self.crossPath(in: square, rotation: 0)
    case .enterFullScreen:
      return Self.enterFullScreenPath(in: square.insetBy(dx: fullScreenInset(isTahoe), dy: fullScreenInset(isTahoe)))
    case .exitFullScreen:
      return Self.exitFullScreenPath(in: square.insetBy(dx: fullScreenInset(isTahoe), dy: fullScreenInset(isTahoe)))
    }
  }

  /// Returns the inset of the full screen glyphs from the button circle's square.
  ///
  /// - Parameter isTahoe: Whether to use the macOS 26 (Tahoe) geometry.
  /// - Returns: The inset.
  private func fullScreenInset(_ isTahoe: Bool) -> CGFloat {
    isTahoe ? Constants.tahoeFullScreenGlyphInset : Constants.fullScreenGlyphInset
  }

  // MARK: - Paths

  /// Makes a "+" path: two bars with round caps crossing at the center of the square.
  ///
  /// The outline is one closed path, so the bars don't overlap and the path fills evenly with either fill rule.
  ///
  /// - Parameters:
  ///   - square: The square to draw in.
  ///   - rotation: The rotation around the square's center, in radians. `.pi / 4` makes a "×".
  /// - Returns: The cross path.
  private static func crossPath(in square: CGRect, rotation: CGFloat) -> CGPath {
    let center = CGPoint(x: square.midX, y: square.midY)
    let halfLength = Constants.barLength / 2
    let halfWidth = Constants.barWidth / 2
    let capRadius = halfWidth
    let armEnd = halfLength - capRadius // the distance from the center to the center of a cap

    // angles go clockwise on screen (y down) as they increase
    let path = CGMutablePath()
    path.move(to: CGPoint(x: center.x - armEnd, y: center.y - halfWidth))
    path.addLine(to: CGPoint(x: center.x - halfWidth, y: center.y - halfWidth))
    path.addLine(to: CGPoint(x: center.x - halfWidth, y: center.y - armEnd))
    path.addArc(center: CGPoint(x: center.x, y: center.y - armEnd), radius: capRadius, startAngle: .pi, endAngle: 2 * .pi, clockwise: false) // top cap
    path.addLine(to: CGPoint(x: center.x + halfWidth, y: center.y - halfWidth))
    path.addLine(to: CGPoint(x: center.x + armEnd, y: center.y - halfWidth))
    path.addArc(center: CGPoint(x: center.x + armEnd, y: center.y), radius: capRadius, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: false) // right cap
    path.addLine(to: CGPoint(x: center.x + halfWidth, y: center.y + halfWidth))
    path.addLine(to: CGPoint(x: center.x + halfWidth, y: center.y + armEnd))
    path.addArc(center: CGPoint(x: center.x, y: center.y + armEnd), radius: capRadius, startAngle: 0, endAngle: .pi, clockwise: false) // bottom cap
    path.addLine(to: CGPoint(x: center.x - halfWidth, y: center.y + halfWidth))
    path.addLine(to: CGPoint(x: center.x - armEnd, y: center.y + halfWidth))
    path.addArc(center: CGPoint(x: center.x - armEnd, y: center.y), radius: capRadius, startAngle: .pi / 2, endAngle: 3 * .pi / 2, clockwise: false) // left cap
    path.closeSubpath()

    guard rotation != 0 else {
      return path
    }
    return path.transform(CGAffineTransform.rotation(rotation, around: center))
  }

  /// Makes a "−" path: a horizontal capsule at the center of the square.
  ///
  /// - Parameter square: The square to draw in.
  /// - Returns: The bar path.
  private static func barPath(in square: CGRect) -> CGPath {
    let barRect = CGRect(
      x: square.minX + (square.width - Constants.barLength) / 2,
      y: square.minY + (square.height - Constants.barWidth) / 2,
      width: Constants.barLength,
      height: Constants.barWidth
    )
    return Capsule().path(in: barRect)
  }

  /// Makes a "◤◢" path: two right triangles in the opposite corners of the square, pointing outward.
  ///
  /// - Parameter square: The square to draw in, already inset from the button circle's square.
  /// - Returns: The enter full screen path.
  private static func enterFullScreenPath(in square: CGRect) -> CGPath {
    let topLeft = cornerTrianglePath(corner: square.origin)
    return pointSymmetricPair(topLeft, center: CGPoint(x: square.midX, y: square.midY))
  }

  /// Makes a "◢ ◤" path: two right triangles near the center of the square, pointing inward.
  ///
  /// - Parameter square: The square to draw in, already inset from the button circle's square.
  /// - Returns: The exit full screen path.
  private static func exitFullScreenPath(in square: CGRect) -> CGPath {
    let legLength = Constants.barLength / 2

    // the "◤" triangle at the top left corner, rotated 180° around its own center to make a "◢", then moved toward
    // the top left by a quarter of its leg, which puts its corner close to the square's center
    let triangle = cornerTrianglePath(corner: square.origin)
    let triangleCenter = CGPoint(x: square.minX + legLength / 2, y: square.minY + legLength / 2)
    let topLeft = triangle.transform(
      CGAffineTransform.rotation(.pi, around: triangleCenter)
        .concatenating(CGAffineTransform(translationX: -legLength / 4, y: -legLength / 4))
    )
    return pointSymmetricPair(topLeft, center: CGPoint(x: square.midX, y: square.midY))
  }

  /// Makes a "◤" path: a right triangle with its legs along the top and left edges from the corner, and its right
  /// angle rounded.
  ///
  /// - Parameter corner: The point of the right angle.
  /// - Returns: The triangle path.
  private static func cornerTrianglePath(corner: CGPoint) -> CGPath {
    let legLength = Constants.barLength / 2
    let cornerRadius = Constants.barWidth / 2

    let path = CGMutablePath()
    path.move(to: CGPoint(x: corner.x + legLength, y: corner.y))
    path.addLine(to: CGPoint(x: corner.x + cornerRadius, y: corner.y))
    path.addArc(
      center: CGPoint(x: corner.x + cornerRadius, y: corner.y + cornerRadius),
      radius: cornerRadius,
      startAngle: -.pi / 2,
      endAngle: -.pi,
      clockwise: true
    )
    path.addLine(to: CGPoint(x: corner.x, y: corner.y + legLength))
    path.closeSubpath()
    return path
  }

  /// Makes a path of a subpath and its copy rotated by 180° around a center.
  ///
  /// - Parameters:
  ///   - path: The subpath.
  ///   - center: The center to rotate the copy around.
  /// - Returns: The path with both subpaths.
  private static func pointSymmetricPair(_ path: CGPath, center: CGPoint) -> CGPath {
    let pair = CGMutablePath()
    pair.addPath(path)
    pair.addPath(path, transform: CGAffineTransform.rotation(.pi, around: center))
    return pair
  }

  // MARK: - Constants

  private enum Constants {

    /// The width of a glyph bar, also the thickness of the full screen triangles' legs' rounded corner.
    static let barWidth: CGFloat = 2

    /// The length of a glyph bar. Half of it is the leg length of a full screen triangle.
    static let barLength: CGFloat = 8

    /// The inset of the document edited dot from the button circle's square.
    static let documentEditedDotInset: CGFloat = 4

    /// The inset of the full screen glyphs from the button circle's square.
    static let fullScreenGlyphInset: CGFloat = 3

    /// The inset of the full screen glyphs from the button circle's square on macOS 26 (Tahoe).
    static let tahoeFullScreenGlyphInset: CGFloat = 4
  }
}

private extension CGAffineTransform {

  /// Makes a transform that rotates around a point.
  ///
  /// - Parameters:
  ///   - angle: The rotation angle, in radians.
  ///   - center: The point to rotate around.
  /// - Returns: The transform.
  static func rotation(_ angle: CGFloat, around center: CGPoint) -> CGAffineTransform {
    CGAffineTransform(translationX: -center.x, y: -center.y)
      .concatenating(CGAffineTransform(rotationAngle: angle))
      .concatenating(CGAffineTransform(translationX: center.x, y: center.y))
  }
}

#endif
