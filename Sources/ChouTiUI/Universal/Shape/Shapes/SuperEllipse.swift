//
//  SuperEllipse.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/28/22.
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

public extension Shape where Self == SuperEllipse {

  /// Creates a super ellipse with the given corner radius.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius of the super ellipse.
  ///   - roundingCorners: The corners to round.
  static func superEllipse(cornerRadius: CGFloat, roundingCorners: RectCorner = .all) -> SuperEllipse {
    SuperEllipse(cornerRadius: cornerRadius, roundingCorners: roundingCorners)
  }

  /// Creates a super ellipse with the given corner radius.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius of the super ellipse.
  ///   - roundingCorners: The corners to round.
  static func superEllipse(_ cornerRadius: CGFloat, _ roundingCorners: RectCorner = .all) -> SuperEllipse {
    SuperEllipse(cornerRadius: cornerRadius, roundingCorners: roundingCorners)
  }

  /// Creates a super ellipse with the given corner radius.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius of the super ellipse.
  static func superEllipse(cornerRadius: SuperEllipse.CornerRadius) -> SuperEllipse {
    SuperEllipse(cornerRadius: cornerRadius)
  }
}

public extension SuperEllipse {

  /// The corner radius of the super ellipse.
  struct CornerRadius: Hashable {

    /// The top left corner radius.
    public let topLeft: CGFloat

    /// The top right corner radius.
    public let topRight: CGFloat

    /// The bottom left corner radius.
    public let bottomLeft: CGFloat

    /// The bottom right corner radius.
    public let bottomRight: CGFloat

    /// Creates a corner radius with the given corner radii.
    ///
    /// - Parameters:
    ///   - topLeft: The top left corner radius.
    ///   - topRight: The top right corner radius.
    ///   - bottomRight: The bottom right corner radius.
    ///   - bottomLeft: The bottom left corner radius.
    public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomRight: CGFloat = 0, bottomLeft: CGFloat = 0) {
      self.topLeft = topLeft.clamped(to: 0...)
      self.topRight = topRight.clamped(to: 0...)
      self.bottomRight = bottomRight.clamped(to: 0...)
      self.bottomLeft = bottomLeft.clamped(to: 0...)
    }

    /// Creates a corner radius with the given corner radius.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius of the super ellipse.
    ///   - roundingCorners: The corners to round.
    public init(cornerRadius: CGFloat, roundingCorners: RectCorner = .all) {
      let cornerRadius = cornerRadius.clamped(to: 0...)
      self.topLeft = roundingCorners.contains(.topLeft) ? cornerRadius : 0
      self.topRight = roundingCorners.contains(.topRight) ? cornerRadius : 0
      self.bottomRight = roundingCorners.contains(.bottomRight) ? cornerRadius : 0
      self.bottomLeft = roundingCorners.contains(.bottomLeft) ? cornerRadius : 0
    }

    /// Creates a corner radius with the given corner radius.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius of the super ellipse.
    ///   - roundingCorners: The corners to round.
    public init(_ cornerRadius: CGFloat, _ roundingCorners: RectCorner = .all) {
      self.init(cornerRadius: cornerRadius, roundingCorners: roundingCorners)
    }
  }
}

/// A continuous rounded rect.
///
/// `Rectangle` is a `Shape` that can be also used to create a rectangle with continuous rounded corners.
/// The main difference between `SuperEllipse` and `Rectangle` is that `SuperEllipse` supports different corner radii for each corner.
/// And `SuperEllipse` uses a custom algorithm to draw the rounded corners, while `Rectangle` uses `BezierPath` to draw the rounded corners.
public struct SuperEllipse: Shape, OffsetableShape {

  /// The corner radius of the super ellipse.
  public let cornerRadius: CornerRadius

  /// Creates a super ellipse with the given corner radius.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius of the super ellipse.
  ///   - roundingCorners: The corners to round.
  public init(cornerRadius: CGFloat, roundingCorners: RectCorner = .all) {
    self.cornerRadius = CornerRadius(cornerRadius: cornerRadius, roundingCorners: roundingCorners)
  }

  /// Creates a super ellipse with the given corner radius.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius of the super ellipse.
  public init(cornerRadius: CornerRadius) {
    self.cornerRadius = cornerRadius
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    let ellipseCoefficient: CGFloat = 1.28195
    let coefficients: [CGFloat] = [0.04641, 0.08715, 0.13357, 0.16296, 0.21505, 0.290086, 0.32461, 0.37801, 0.44576, 0.6074, 0.77037]

    let cornerRadius = limitedCornerRadius(cornerRadius, within: rect, ellipseCoefficient: ellipseCoefficient)

    let left = rect.minX
    let right = rect.maxX
    let top = rect.minY
    let bottom = rect.maxY

    let topRightP1 = CGPoint(x: right - cornerRadius.topRight * ellipseCoefficient, y: top)
    let topRightP1CP1 = CGPoint(x: topRightP1.x + cornerRadius.topRight * coefficients[8], y: topRightP1.y)
    let topRightP1CP2 = CGPoint(x: topRightP1.x + cornerRadius.topRight * coefficients[9], y: topRightP1.y + cornerRadius.topRight * coefficients[0])

    let topRightP2 = CGPoint(x: topRightP1.x + cornerRadius.topRight * coefficients[10], y: topRightP1.y + cornerRadius.topRight * coefficients[2])
    let topRightP2CP1 = CGPoint(x: topRightP2.x + cornerRadius.topRight * coefficients[3], y: topRightP2.y + cornerRadius.topRight * coefficients[1])
    let topRightP2CP2 = CGPoint(x: topRightP2.x + cornerRadius.topRight * coefficients[5], y: topRightP2.y + cornerRadius.topRight * coefficients[4])

    let topRightP3 = CGPoint(x: topRightP2.x + cornerRadius.topRight * coefficients[7], y: topRightP2.y + cornerRadius.topRight * coefficients[7])
    let topRightP3CP1 = CGPoint(x: topRightP3.x + cornerRadius.topRight * coefficients[1], y: topRightP3.y + cornerRadius.topRight * coefficients[3])
    let topRightP3CP2 = CGPoint(x: topRightP3.x + cornerRadius.topRight * coefficients[2], y: topRightP3.y + cornerRadius.topRight * coefficients[6])

    let topRightP4 = CGPoint(x: topRightP3.x + cornerRadius.topRight * coefficients[2], y: topRightP3.y + cornerRadius.topRight * coefficients[10])

    let bottomRightP1 = CGPoint(x: right, y: bottom - cornerRadius.bottomRight * ellipseCoefficient)
    let bottomRightP1CP1 = CGPoint(x: bottomRightP1.x, y: bottomRightP1.y + cornerRadius.bottomRight * coefficients[8])
    let bottomRightP1CP2 = CGPoint(x: bottomRightP1.x - cornerRadius.bottomRight * coefficients[0], y: bottomRightP1.y + cornerRadius.bottomRight * coefficients[9])

    let bottomRightP2 = CGPoint(x: bottomRightP1.x - cornerRadius.bottomRight * coefficients[2], y: bottomRightP1.y + cornerRadius.bottomRight * coefficients[10])
    let bottomRightP2CP1 = CGPoint(x: bottomRightP2.x - cornerRadius.bottomRight * coefficients[1], y: bottomRightP2.y + cornerRadius.bottomRight * coefficients[3])
    let bottomRightP2CP2 = CGPoint(x: bottomRightP2.x - cornerRadius.bottomRight * coefficients[4], y: bottomRightP2.y + cornerRadius.bottomRight * coefficients[5])

    let bottomRightP3 = CGPoint(x: bottomRightP2.x - cornerRadius.bottomRight * coefficients[7], y: bottomRightP2.y + cornerRadius.bottomRight * coefficients[7])
    let bottomRightP3CP1 = CGPoint(x: bottomRightP3.x - cornerRadius.bottomRight * coefficients[3], y: bottomRightP3.y + cornerRadius.bottomRight * coefficients[1])
    let bottomRightP3CP2 = CGPoint(x: bottomRightP3.x - cornerRadius.bottomRight * coefficients[6], y: bottomRightP3.y + cornerRadius.bottomRight * coefficients[2])

    let bottomRightP4 = CGPoint(x: bottomRightP3.x - cornerRadius.bottomRight * coefficients[10], y: bottomRightP3.y + cornerRadius.bottomRight * coefficients[2])

    let bottomLeftP1 = CGPoint(x: left + cornerRadius.bottomLeft * ellipseCoefficient, y: bottom)
    let bottomLeftP1CP1 = CGPoint(x: bottomLeftP1.x - cornerRadius.bottomLeft * coefficients[8], y: bottomLeftP1.y)
    let bottomLeftP1CP2 = CGPoint(x: bottomLeftP1.x - cornerRadius.bottomLeft * coefficients[9], y: bottomLeftP1.y - cornerRadius.bottomLeft * coefficients[0])

    let bottomLeftP2 = CGPoint(x: bottomLeftP1.x - cornerRadius.bottomLeft * coefficients[10], y: bottomLeftP1.y - cornerRadius.bottomLeft * coefficients[2])
    let bottomLeftP2CP1 = CGPoint(x: bottomLeftP2.x - cornerRadius.bottomLeft * coefficients[3], y: bottomLeftP2.y - cornerRadius.bottomLeft * coefficients[1])
    let bottomLeftP2CP2 = CGPoint(x: bottomLeftP2.x - cornerRadius.bottomLeft * coefficients[5], y: bottomLeftP2.y - cornerRadius.bottomLeft * coefficients[4])

    let bottomLeftP3 = CGPoint(x: bottomLeftP2.x - cornerRadius.bottomLeft * coefficients[7], y: bottomLeftP2.y - cornerRadius.bottomLeft * coefficients[7])
    let bottomLeftP3CP1 = CGPoint(x: bottomLeftP3.x - cornerRadius.bottomLeft * coefficients[1], y: bottomLeftP3.y - cornerRadius.bottomLeft * coefficients[3])
    let bottomLeftP3CP2 = CGPoint(x: bottomLeftP3.x - cornerRadius.bottomLeft * coefficients[2], y: bottomLeftP3.y - cornerRadius.bottomLeft * coefficients[6])

    let bottomLeftP4 = CGPoint(x: bottomLeftP3.x - cornerRadius.bottomLeft * coefficients[2], y: bottomLeftP3.y - cornerRadius.bottomLeft * coefficients[10])

    let topLeftP1 = CGPoint(x: left, y: top + cornerRadius.topLeft * ellipseCoefficient)
    let topLeftP1CP1 = CGPoint(x: topLeftP1.x, y: topLeftP1.y - cornerRadius.topLeft * coefficients[8])
    let topLeftP1CP2 = CGPoint(x: topLeftP1.x + cornerRadius.topLeft * coefficients[0], y: topLeftP1.y - cornerRadius.topLeft * coefficients[9])

    let topLeftP2 = CGPoint(x: topLeftP1.x + cornerRadius.topLeft * coefficients[2], y: topLeftP1.y - cornerRadius.topLeft * coefficients[10])
    let topLeftP2CP1 = CGPoint(x: topLeftP2.x + cornerRadius.topLeft * coefficients[1], y: topLeftP2.y - cornerRadius.topLeft * coefficients[3])
    let topLeftP2CP2 = CGPoint(x: topLeftP2.x + cornerRadius.topLeft * coefficients[4], y: topLeftP2.y - cornerRadius.topLeft * coefficients[5])

    let topLeftP3 = CGPoint(x: topLeftP2.x + cornerRadius.topLeft * coefficients[7], y: topLeftP2.y - cornerRadius.topLeft * coefficients[7])
    let topLeftP3CP1 = CGPoint(x: topLeftP3.x + cornerRadius.topLeft * coefficients[3], y: topLeftP3.y - cornerRadius.topLeft * coefficients[1])
    let topLeftP3CP2 = CGPoint(x: topLeftP3.x + cornerRadius.topLeft * coefficients[6], y: topLeftP3.y - cornerRadius.topLeft * coefficients[2])

    // let topLeftP4 = CGPoint(x: topLeftP3.x + cornerRadius.topLeft * coefficients[10], y: topLeftP3.y - cornerRadius.topLeft * coefficients[2])
    let topLeftP4 = CGPoint(x: left + cornerRadius.topLeft * ellipseCoefficient, y: top)

    let path = BezierPath()

    // top left
    path.move(to: topLeftP4)

    // top right
    path.addLine(to: topRightP1)
    path.addCurve(to: topRightP2, controlPoint1: topRightP1CP1, controlPoint2: topRightP1CP2)
    path.addCurve(to: topRightP3, controlPoint1: topRightP2CP1, controlPoint2: topRightP2CP2)
    path.addCurve(to: topRightP4, controlPoint1: topRightP3CP1, controlPoint2: topRightP3CP2)

    // bottom right
    path.addLine(to: bottomRightP1)
    path.addCurve(to: bottomRightP2, controlPoint1: bottomRightP1CP1, controlPoint2: bottomRightP1CP2)
    path.addCurve(to: bottomRightP3, controlPoint1: bottomRightP2CP1, controlPoint2: bottomRightP2CP2)
    path.addCurve(to: bottomRightP4, controlPoint1: bottomRightP3CP1, controlPoint2: bottomRightP3CP2)

    // bottom left
    path.addLine(to: bottomLeftP1)
    path.addCurve(to: bottomLeftP2, controlPoint1: bottomLeftP1CP1, controlPoint2: bottomLeftP1CP2)
    path.addCurve(to: bottomLeftP3, controlPoint1: bottomLeftP2CP1, controlPoint2: bottomLeftP2CP2)
    path.addCurve(to: bottomLeftP4, controlPoint1: bottomLeftP3CP1, controlPoint2: bottomLeftP3CP2)

    // top Left
    path.addLine(to: topLeftP1)
    path.addCurve(to: topLeftP2, controlPoint1: topLeftP1CP1, controlPoint2: topLeftP1CP2)
    path.addCurve(to: topLeftP3, controlPoint1: topLeftP2CP1, controlPoint2: topLeftP2CP2)
    path.addCurve(to: topLeftP4, controlPoint1: topLeftP3CP1, controlPoint2: topLeftP3CP2)

    return path.cgPath
  }

  /// Limits the corner radius to the given rect.
  ///
  /// This method is used to ensure that the corner radius is not too large.
  ///
  /// - Parameters:
  ///   - cornerRadius: The corner radius to limit.
  ///   - rect: The rect to limit the corner radius within.
  ///   - ellipseCoefficient: The ellipse coefficient.
  /// - Returns: The limited corner radius.
  private func limitedCornerRadius(_ cornerRadius: CornerRadius, within rect: CGRect, ellipseCoefficient: CGFloat) -> CornerRadius {
    let width = rect.width
    let height = rect.height

    let epsilon: CGFloat = .leastNormalMagnitude // to avoid division by zero

    let cornerRadiusTopWidth = (cornerRadius.topLeft + cornerRadius.topRight) + epsilon
    let cornerRadiusRightHeight = (cornerRadius.topRight + cornerRadius.bottomRight) + epsilon
    let cornerRadiusBottomWidth = (cornerRadius.bottomRight + cornerRadius.bottomLeft) + epsilon
    let cornerRadiusLeftHeight = (cornerRadius.bottomLeft + cornerRadius.topLeft) + epsilon

    /// Limits the radius to the given width and height.
    ///
    /// - Parameters:
    ///   - width: The maximum width allowed for the corner.
    ///   - height: The maximum height allowed for the corner.
    ///   - radius: The radius to limit.
    /// - Returns: The limited radius.
    func limitedRadius(width: CGFloat, height: CGFloat, radius: CGFloat) -> CGFloat {
      let shortSide = min(width, height)
      let limitedRadius = min(radius * ellipseCoefficient, shortSide)
      return limitedRadius / ellipseCoefficient
    }

    let limitedTopLeft = limitedRadius(
      width: width / cornerRadiusTopWidth * cornerRadius.topLeft,
      height: height / cornerRadiusLeftHeight * cornerRadius.topLeft,
      radius: cornerRadius.topLeft
    )
    let limitedTopRight = limitedRadius(
      width: width / cornerRadiusTopWidth * cornerRadius.topRight,
      height: height / cornerRadiusRightHeight * cornerRadius.topRight,
      radius: cornerRadius.topRight
    )
    let limitedBottomRight = limitedRadius(
      width: width / cornerRadiusBottomWidth * cornerRadius.bottomRight,
      height: height / cornerRadiusRightHeight * cornerRadius.bottomRight,
      radius: cornerRadius.bottomRight
    )
    let limitedBottomLeft = limitedRadius(
      width: width / cornerRadiusBottomWidth * cornerRadius.bottomLeft,
      height: height / cornerRadiusLeftHeight * cornerRadius.bottomLeft,
      radius: cornerRadius.bottomLeft
    )

    return CornerRadius(
      topLeft: limitedTopLeft,
      topRight: limitedTopRight,
      bottomRight: limitedBottomRight,
      bottomLeft: limitedBottomLeft
    )
  }

  // MARK: - OffsetableShape

  public func path(in rect: CGRect, offset: CGFloat) -> CGPath {
    let newCornerRadius = CornerRadius(
      topLeft: cornerRadius.topLeft == 0 ? 0 : (cornerRadius.topLeft + offset).clamped(to: 0...),
      topRight: cornerRadius.topRight == 0 ? 0 : (cornerRadius.topRight + offset).clamped(to: 0...),
      bottomRight: cornerRadius.bottomRight == 0 ? 0 : (cornerRadius.bottomRight + offset).clamped(to: 0...),
      bottomLeft: cornerRadius.bottomLeft == 0 ? 0 : (cornerRadius.bottomLeft + offset).clamped(to: 0...)
    )
    return SuperEllipse(cornerRadius: newCornerRadius).path(in: rect.expanded(by: offset))
  }
}

// - https://github.com/everdrone/react-native-super-ellipse-mask
// - https://github.com/regexident/EnhancedRoundedRectangle
// - https://github.com/MeltedNYC/ContinuousCorners/blob/master/UIBezierPath%2BContinuousCorners.swift
// - https://github.com/sugarmo/SGMSuperEllipsePath/
// - https://99percentinvisible.org/article/circling-square-designing-squircles-instead-rounded-rectangles/
