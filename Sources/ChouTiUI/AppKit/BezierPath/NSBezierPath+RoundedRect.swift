//
//  NSBezierPath+RoundedRect.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/27/22.
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

public extension BezierPath {

  /// The BezierPath can generate different shapes when `(width or height / corner radius)` ratio exceeds a magic number.
  ///
  /// Specifically, 1) when the corner radius is smaller than both the width and height divided by the magic number,
  /// the generated shape is a good rounded rectangle, i.e. matching the `CALayer.cornerRadius`. 2) when the corner radius
  /// is larger than both the width and height divided by the magic number, the shape is a capsule. 3) when the corner radius
  /// is larger than width or height divided by the magic number but smaller than the other dimension, the shape is a weird
  /// shape that doesn't match either the layer.cornerRadius nor the capsule shape.
  static let shapeBreakRatio: CGFloat = 3.0573299 // 1.52866495 * 2
}

#if canImport(AppKit)

import AppKit

public extension NSBezierPath {

  /// Creates and returns a new Bézier path object with a rounded rectangular path.
  ///
  /// The BezierPath can generate different shapes depending on the `cornerRadius` value relative to the width and height of the rect.
  /// It's recommended to ensure the `cornerRadius` is smaller than the width and height divided by `BezierPath.shapeBreakRatio`. For other cases,
  /// use `SuperEllipse` or `Capsule` shape instead.
  ///
  /// See `BezierPath.shapeBreakRatio` for more details.
  ///
  /// - Parameters:
  ///   - rect: The rectangle that defines the basic shape of the path.
  ///   - cornerRadius: The radius of each corner oval. A value of 0 results in a rectangle without rounded corners.
  ///                   Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
  convenience init(roundedRect rect: CGRect, cornerRadius: CGFloat) {
    /**
     `NSBezierPath.init(roundedRect rect: NSRect, xRadius: CGFloat, yRadius: CGFloat)` generates a path that doesn't match UIKit's one.
     This implementation can generate a path that matches UIKit's rounded rect exactly.

     For example, for rect {60, 30} with corner radius 8, the generated path is different:
     UIKit (`UIBezierPath.init(roundedRect rect: CGRect, cornerRadius: CGFloat)`):
     ```
     <MoveTo {12.22932, 0}>,
     <LineTo {47.770679999999999, 0}>,
     <CurveTo {54.948049657352058, 0.59929110277612807} {51.292056339051769, 0} {53.052744447495982, 0}>,
     <LineTo {54.948049657352058, 0.59929110277612807}>,

     <CurveTo {59.400708897223872, 5.0519503426479417} {57.017409386994025, 1.3524764483549596} {58.647523551645044, 2.9825906130059776}>,
     <CurveTo {60, 12.229319877836661} {60, 6.9472555525040187} {60, 8.7079436609482332}>,
     <LineTo {60, 17.770679999999999}>,
     <CurveTo {59.400708897223872, 24.948049657352058} {60, 21.292056339051769} {60, 23.052744447495982}>,
     <LineTo {59.400708897223872, 24.948049657352058}>,
     <CurveTo {54.948049657352058, 29.400708897223872} {58.647523551645044, 27.017409386994022} {57.017409386994025, 28.64752355164504}>,
     <CurveTo {47.770680122163341, 30} {53.052744447495982, 30} {51.292056339051769, 30}>,
     <LineTo {12.22932, 30}>,
     <CurveTo {5.05195034264794, 29.400708897223872} {8.7079436609482332, 30} {6.9472555525040187, 30}>,
     <LineTo {5.05195034264794, 29.400708897223872}>,
     <CurveTo {0.59929110277612807, 24.948049657352058} {2.9825906130059758, 28.64752355164504} {1.3524764483549592, 27.017409386994022}>,
     <CurveTo {0, 17.770680122163341} {0, 23.052744447495982} {0, 21.292056339051769}>,
     <LineTo {0, 12.22932}>,
     <CurveTo {0.59929110277612718, 5.05195034264794} {0, 8.7079436609482332} {0, 6.9472555525040187}>,
     <LineTo {0.59929110277612718, 5.05195034264794}>,
     <CurveTo {5.0519503426479417, 0.59929110277612718} {1.3524764483549583, 2.9825906130059745} {2.9825906130059763, 1.3524764483549581}>,
     <CurveTo {12.229319877836661, 0} {6.9472555525040187, 0} {8.7079436609482332, 0}>,
     <LineTo {12.22932, 0}>
     ```

     AppKit (`NSBezierPath.init(roundedRect rect: NSRect, xRadius: CGFloat, yRadius: CGFloat)`):
     ```
     Bounds: {{0, 0}, {60, 30}}
     Control point bounds: {{0, 0}, {60, 30}}
     8.000000 30.000000 moveto
     3.581760 30.000000 0.000000 26.418240 0.000000 22.000000 curveto
     0.000000 8.000000 lineto
     0.000000 3.581760 3.581760 0.000000 8.000000 0.000000 curveto
     52.000000 0.000000 lineto
     56.418240 0.000000 60.000000 3.581760 60.000000 8.000000 curveto
     60.000000 22.000000 lineto
     60.000000 26.418240 56.418240 30.000000 52.000000 30.000000 curveto
     closepath
     8.000000 30.000000 moveto
     ```

     My implementation:
     ```
     moveto (12.2293, 0)
     lineto (47.7707, 0)
     curveto (51.2921, 0) (53.0527, 0) (54.6405, 0.523968)
     lineto (54.948, 0.599288)
     curveto (57.0174, 1.35247) (58.6475, 2.98259) (59.4007, 5.05195)
     curveto (60, 6.94726) (60, 8.70794) (60, 12.2293)
     lineto (60, 17.7707)
     curveto (60, 21.2921) (60, 23.0527) (59.476, 24.6405)
     lineto (59.4007, 24.948)
     curveto (58.6475, 27.0174) (57.0174, 28.6475) (54.948, 29.4007)
     curveto (53.0527, 30) (51.2921, 30) (47.7707, 30)
     lineto (12.2293, 30)
     curveto (8.70794, 30) (6.94726, 30) (5.35947, 29.476)
     lineto (5.05195, 29.4007)
     curveto (2.98259, 28.6475) (1.35248, 27.0174) (0.599288, 24.948)
     curveto (0, 23.0527) (0, 21.2921) (0, 17.7707)
     lineto (0, 12.2293)
     curveto (0, 8.70794) (0, 6.94726) (0.523968, 5.35947)
     lineto (0.599288, 5.05195)
     curveto (1.35248, 2.98259) (2.98259, 1.35248) (5.05195, 0.599288)
     curveto (6.94726, 0) (8.70794, 0) (12.2293, 0)
     closepath
     moveto (12.2293, 0)
     ```
     */
    if cornerRadius == 0 {
      self.init(rect: rect)
    } else {
      self.init(roundedRect: rect, byRoundingCorners: .all, cornerRadii: CGSize(cornerRadius, cornerRadius))
    }
  }

  /// Creates and returns a new Bézier path object with a rectangular path rounded at the specified corners.
  ///
  /// - Note: `cornerRadii` only supports equal width and height. i.e. the corner should be a circle.
  /// - Note: Rounding corners only works when the radius is smaller than the width and height divided by `BezierPath.shapeBreakRatio`.
  ///
  /// The BezierPath can generate different shapes depending on the `cornerRadius` value relative to the width and height of the rect.
  /// It's recommended to ensure the `cornerRadius` is smaller than the width and height divided by `BezierPath.shapeBreakRatio`. For other cases,
  /// use `SuperEllipse` or `Capsule` shape instead.
  ///
  /// See `BezierPath.shapeBreakRatio` for more details.
  ///
  /// - Parameters:
  ///   - rect: The rectangle that defines the basic shape of the path.
  ///   - corners: A bitmask value that identifies the corners that you want rounded.
  ///              You can use this parameter to round only a subset of the corners of the rectangle.
  ///   - cornerRadii: The radius of each corner oval.
  ///                  Values larger than half the rectangle’s width or height are clamped appropriately to half the width or height.
  convenience init(roundedRect rect: CGRect, byRoundingCorners corners: RectCorner, cornerRadii: CGSize) {
    self.init()

    guard rect.size.area > 0 else {
      ChouTi.assertFailure("bounding rect area should be positive", metadata: ["rect": "\(rect)"])
      return
    }

    guard cornerRadii.width == cornerRadii.height else {
      ChouTi.assertFailure("cornerRadii only supports equal width and height", metadata: ["cornerRadii": "\(cornerRadii)"])
      return
    }
    let radius = cornerRadii.width

    let path = self

    let breakRatio = BezierPath.shapeBreakRatio
    if rect.width > breakRatio * radius, rect.height > breakRatio * radius {
      // radius < 1/3 of the shorter dimension
      path.addRoundedRect1(rect, cornerRadius: radius, roundingCorners: corners)
    } else if rect.size.width > breakRatio * radius {
      // radius < 1/3 width, radius > 1/3 height
      // horizontal rect
      path.addRoundedRect2a(rect, cornerRadius: radius, roundingCorners: corners)
    } else if rect.size.height > breakRatio * radius {
      // radius < 1/3 height, radius > 1/3 width
      // vertical rect
      path.addRoundedRect2b(rect, cornerRadius: radius, roundingCorners: corners)
    } else if rect.size.height > rect.size.width {
      // vertical rect
      path.addRoundedRect3a(rect, cornerRadius: radius, roundingCorners: corners)
      // TODO: shape 3a doesn't match UIKit exactly, need to write the code gen for shape 3 and update the test case
    } else {
      // horizontal rect
      path.addRoundedRect3b(rect, cornerRadius: radius, roundingCorners: corners)
    }

    /**
     Note:
     - shape1 is the expected rounded rect.
     - shape2 is weird, it doesn't match either the layer.cornerRadius nor the capsule shape, don't think it's should be used.
     - shape3 is a capsule shape.
     */
  }

  /// Generated by `NSBezierPathRoundedRectGenerator.generateShape1Code()` on iOS 14.2, iOS 15.
  /// Tested on iOS 16.0, 17.5
  private func addRoundedRect1(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    // ChouTi.assert(cornerRadius <= limit, "caller should make sure radius is within shape 1 limit")
    let limitedRadius: CGFloat = min(cornerRadius, limit)

    // top left
    if roundingCorners.contains(.topLeft) {
      move(to: topLeft(rect, 1.528665, 0, limitedRadius))
    } else {
      move(to: rect.topLeft)
    }

    // top right
    if roundingCorners.contains(.topRight) {
      addLine(to: topRight(rect, 1.5286649999999995, 0, limitedRadius))
      addCurve(to: topRight(rect, 0.6314937928309916, 0.07491138784701601, limitedRadius), controlPoint1: topRight(rect, 1.0884929576185285, 0, limitedRadius), controlPoint2: topRight(rect, 0.8684069440630026, 0, limitedRadius))
      addLine(to: topRight(rect, 0.6314937928309916, 0.07491138784701601, limitedRadius))
      addCurve(to: topRight(rect, 0.07491138784701548, 0.6314937928309927, limitedRadius), controlPoint1: topRight(rect, 0.3728238266257463, 0.16905955604436995, limitedRadius), controlPoint2: topRight(rect, 0.16905955604436967, 0.3728238266257472, limitedRadius))
      addCurve(to: topRight(rect, 0, 1.5286649847295823, limitedRadius), controlPoint1: topRight(rect, 0, 0.8684069440630022, limitedRadius), controlPoint2: topRight(rect, 0, 1.088492957618529, limitedRadius))
    } else {
      addLine(to: rect.topRight)
    }

    // bottom right
    if roundingCorners.contains(.bottomRight) {
      addLine(to: bottomRight(rect, 0, 1.5286649999999995, limitedRadius))
      addCurve(to: bottomRight(rect, 0.07491138784701548, 0.631493792830993, limitedRadius), controlPoint1: bottomRight(rect, 0, 1.0884929576185285, limitedRadius), controlPoint2: bottomRight(rect, 0, 0.8684069440630026, limitedRadius))
      addLine(to: bottomRight(rect, 0.07491138784701548, 0.631493792830993, limitedRadius))
      addCurve(to: bottomRight(rect, 0.631493792830993, 0.07491138784701548, limitedRadius), controlPoint1: bottomRight(rect, 0.16905955604436967, 0.37282382662574776, limitedRadius), controlPoint2: bottomRight(rect, 0.37282382662574776, 0.16905955604436967, limitedRadius))
      addCurve(to: bottomRight(rect, 1.528664984729582, 0, limitedRadius), controlPoint1: bottomRight(rect, 0.8684069440630026, 0, limitedRadius), controlPoint2: bottomRight(rect, 1.0884929576185285, 0, limitedRadius))
    } else {
      addLine(to: rect.bottomRight)
    }

    // bottom left
    if roundingCorners.contains(.bottomLeft) {
      addLine(to: bottomLeft(rect, 1.528665, 0, limitedRadius))
      addCurve(to: bottomLeft(rect, 0.6314937928309925, 0.07491138784701548, limitedRadius), controlPoint1: bottomLeft(rect, 1.088492957618529, 0, limitedRadius), controlPoint2: bottomLeft(rect, 0.8684069440630022, 0, limitedRadius))
      addLine(to: bottomLeft(rect, 0.6314937928309925, 0.07491138784701548, limitedRadius))
      addCurve(to: bottomLeft(rect, 0.07491138784701601, 0.6314937928309916, limitedRadius), controlPoint1: bottomLeft(rect, 0.37282382662574703, 0.16905955604436967, limitedRadius), controlPoint2: bottomLeft(rect, 0.1690595560443699, 0.3728238266257463, limitedRadius))
      addCurve(to: bottomLeft(rect, 0, 1.528664984729582, limitedRadius), controlPoint1: bottomLeft(rect, 0, 0.8684069440630026, limitedRadius), controlPoint2: bottomLeft(rect, 0, 1.0884929576185285, limitedRadius))
    } else {
      addLine(to: rect.bottomLeft)
    }

    // top left
    if roundingCorners.contains(.topLeft) {
      addLine(to: topLeft(rect, 0, 1.528665, limitedRadius))
      addCurve(to: topLeft(rect, 0.07491138784701583, 0.6314937928309925, limitedRadius), controlPoint1: topLeft(rect, 0, 1.088492957618529, limitedRadius), controlPoint2: topLeft(rect, 0, 0.8684069440630022, limitedRadius))
      addLine(to: topLeft(rect, 0.07491138784701583, 0.6314937928309925, limitedRadius))
      addCurve(to: topLeft(rect, 0.6314937928309927, 0.07491138784701583, limitedRadius), controlPoint1: topLeft(rect, 0.16905955604436976, 0.37282382662574676, limitedRadius), controlPoint2: topLeft(rect, 0.372823826625747, 0.1690595560443697, limitedRadius))
      addCurve(to: topLeft(rect, 1.5286649847295823, 0, limitedRadius), controlPoint1: topLeft(rect, 0.8684069440630022, 0, limitedRadius), controlPoint2: topLeft(rect, 1.088492957618529, 0, limitedRadius))
      addLine(to: topLeft(rect, 1.528665, 0, limitedRadius))
    } else {
      addLine(to: rect.topLeft)
    }

    close()
  }

  /// Generated by `NSBezierPathRoundedRectGenerator.generateShape2aCode()` on iOS 17.5.
  private func addRoundedRect2a(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    ChouTi.assert(roundingCorners == .all, "shape 2a only supports all rounding corners", metadata: [
      "rect": "\(rect)",
      "cornerRadius": "\(cornerRadius)",
      "roundingCorners": "\(roundingCorners)",
    ])

    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius: CGFloat = min(cornerRadius, limit)

    // top left
    move(to: topLeft(rect, 1.528665, 0, cornerRadius))

    // top right
    addLine(to: topRight(rect, 1.5286649999999997, 0, cornerRadius))
    addCurve(to: topRight(rect, 0.9366796566018196, 0.11451440396822271, limitedRadius), controlPoint1: topRight(rect, 1.6352782071519016, 0, limitedRadius), controlPoint2: topRight(rect, 1.2988404586546645, 0, limitedRadius))
    addLine(to: topRight(rect, 0.9366796566018196, 0.1145144039682227, limitedRadius))
    addCurve(to: topRight(rect, 0, 1.4522315885, limitedRadius), controlPoint1: topRight(rect, 0.3743055124078555, 0.31920185297575504, limitedRadius), controlPoint2: topRight(rect, 0, 0.8537655244336196, limitedRadius))

    // right center
    addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)
    addLine(to: rect.rightCenter)
    addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)

    // bottom right
    addLine(to: bottomRight(rect, 0, 1.4522315885000001, limitedRadius))
    addCurve(to: bottomRight(rect, 0.9366796566018196, 0.11451440396822246, limitedRadius), controlPoint1: bottomRight(rect, 0, 0.8537655244336196, limitedRadius), controlPoint2: bottomRight(rect, 0.3743055124078555, 0.3192018529757545, limitedRadius))
    addCurve(to: bottomRight(rect, 2.3081537041463758, 0, limitedRadius), controlPoint1: bottomRight(rect, 1.2988404586546645, 0, limitedRadius), controlPoint2: bottomRight(rect, 1.6352782071519016, 0, limitedRadius))

    // bottom left
    addLine(to: bottomLeft(rect, 1.528665, 0, cornerRadius))
    addCurve(to: bottomLeft(rect, 0.9366796566018198, 0.11451440396822246, limitedRadius), controlPoint1: bottomLeft(rect, 1.6352782071519016, 0, limitedRadius), controlPoint2: bottomLeft(rect, 1.2988404586546645, 0, limitedRadius))
    addLine(to: bottomLeft(rect, 0.93667965660182, 0.11451440396822246, limitedRadius))
    addCurve(to: bottomLeft(rect, -1.0182953347204205e-16, 1.4522315885, limitedRadius), controlPoint1: bottomLeft(rect, 0.37430551240785565, 0.3192018529757545, limitedRadius), controlPoint2: bottomLeft(rect, -3.0171713621345795e-17, 0.8537655244336196, limitedRadius))

    // left center
    addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)
    addLine(to: rect.leftCenter)
    addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)

    // top left
    addLine(to: topLeft(rect, -1.0182953347204205e-16, 1.4522315885000003, limitedRadius))
    addCurve(to: topLeft(rect, 0.9366796566018202, 0.11451440396822253, limitedRadius), controlPoint1: topLeft(rect, -1.734873533227383e-16, 0.85376552443362, limitedRadius), controlPoint2: topLeft(rect, 0.3743055124078558, 0.3192018529757547, limitedRadius))
    addCurve(to: topLeft(rect, 2.3081537041463758, 0, limitedRadius), controlPoint1: topLeft(rect, 1.2988404586546645, 0, limitedRadius), controlPoint2: topLeft(rect, 1.6352782071519016, 0, limitedRadius))
    addLine(to: topLeft(rect, 1.528665, 0, cornerRadius))

    close()
  }

  /// Generated by `NSBezierPathRoundedRectGenerator.generateShape2bCode()` on iOS 17.5.
  private func addRoundedRect2b(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    ChouTi.assert(roundingCorners == .all, "shape 2b only supports all rounding corners", metadata: [
      "rect": "\(rect)",
      "cornerRadius": "\(cornerRadius)",
      "roundingCorners": "\(roundingCorners)",
    ])

    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius: CGFloat = min(cornerRadius, limit)

    move(to: rect.topCenter)

    // top center
    addLine(to: rect.topCenter)
    addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)

    // top right
    addLine(to: topRight(rect, 1.4522315885000003, -1.0182953347204205e-16, limitedRadius))
    addCurve(to: topRight(rect, 0.11451440396822246, 0.9366796566018201, limitedRadius), controlPoint1: topRight(rect, 0.8537655244336196, -2.1120199534942054e-16, limitedRadius), controlPoint2: topRight(rect, 0.3192018529757545, 0.37430551240785565, limitedRadius))
    addCurve(to: topRight(rect, 0, 2.3081537041463758, limitedRadius), controlPoint1: topRight(rect, 0, 1.2988404586546645, limitedRadius), controlPoint2: topRight(rect, 0, 1.6352782071519016, limitedRadius))

    // bottom right
    addLine(to: bottomRight(rect, 0, 1.5286649999999997, cornerRadius))
    addCurve(to: bottomRight(rect, 0.11451440396822246, 0.9366796566018202, limitedRadius), controlPoint1: bottomRight(rect, 0, 1.6352782071519016, limitedRadius), controlPoint2: bottomRight(rect, 0, 1.2988404586546645, limitedRadius))
    addLine(to: bottomRight(rect, 0.11451440396822246, 0.9366796566018202, limitedRadius))
    addCurve(to: bottomRight(rect, 1.4522315885000001, 0, limitedRadius), controlPoint1: bottomRight(rect, 0.3192018529757545, 0.374305512407856, limitedRadius), controlPoint2: bottomRight(rect, 0.8537655244336196, 0, limitedRadius))

    // bottom center
    addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)
    addLine(to: rect.bottomCenter)
    addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)

    // bottom left
    addLine(to: bottomLeft(rect, 1.4522315885000001, 0, limitedRadius))
    addCurve(to: bottomLeft(rect, 0.1145144039682227, 0.9366796566018196, limitedRadius), controlPoint1: bottomLeft(rect, 0.8537655244336199, 0, limitedRadius), controlPoint2: bottomLeft(rect, 0.319201852975755, 0.3743055124078555, limitedRadius))
    addCurve(to: bottomLeft(rect, 0, 2.3081537041463758, limitedRadius), controlPoint1: bottomLeft(rect, 0, 1.2988404586546645, limitedRadius), controlPoint2: bottomLeft(rect, 0, 1.6352782071519016, limitedRadius))

    // top left
    addLine(to: topLeft(rect, 0, 1.528665, cornerRadius))
    addCurve(to: topLeft(rect, 0.11451440396822246, 0.9366796566018201, limitedRadius), controlPoint1: topLeft(rect, 0, 1.6352782071519016, limitedRadius), controlPoint2: topLeft(rect, 0, 1.2988404586546645, limitedRadius))
    addLine(to: topLeft(rect, 0.11451440396822253, 0.93667965660182, limitedRadius))
    addCurve(to: topLeft(rect, 1.4522315885, -1.0182953347204205e-16, limitedRadius), controlPoint1: topLeft(rect, 0.3192018529757547, 0.37430551240785565, limitedRadius), controlPoint2: topLeft(rect, 0.8537655244336195, 7.542928405336449e-18, limitedRadius))

    // top center
    addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)
    addLine(to: rect.topCenter)

    close()
  }

  private func addRoundedRect3a(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    ChouTi.assert(roundingCorners == .all, "shape 3a only supports all rounding corners", metadata: [
      "rect": "\(rect)",
      "cornerRadius": "\(cornerRadius)",
      "roundingCorners": "\(roundingCorners)",
    ])

    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius: CGFloat = min(cornerRadius, limit)

    move(to: rect.topCenter)

    // top center
    addLine(to: rect.topCenter)
    addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)
    addLine(to: rect.topCenter)

    // top right
    addCurve(to: topRight(rect, 0, 1.52866483, limitedRadius), controlPoint1: topRight(rect, 0.68440646, 0.00000001, limitedRadius), controlPoint2: topRight(rect, 0, 0.68440658, limitedRadius))
    addCurve(to: topRight(rect, 0, 1.52866483, limitedRadius), controlPoint1: topRight(rect, 0, 1.52866483, limitedRadius), controlPoint2: topRight(rect, 0, 1.52866483, limitedRadius))

    // right center
    addLine(to: rect.rightCenter)

    // bottom right
    addCurve(to: bottomRight(rect, 0, 1.52866471, limitedRadius), controlPoint1: bottomRight(rect, 0, 1.52866471, limitedRadius), controlPoint2: bottomRight(rect, 0, 1.52866471, limitedRadius))
    addLine(to: bottomRight(rect, 0, 1.52866471, limitedRadius))

    // bottom center
    addCurve(to: rect.bottomCenter, controlPoint1: bottomRight(rect, 0, 0.68440646, limitedRadius), controlPoint2: bottomRight(rect, 0.68440646, 0, limitedRadius))
    addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)
    addLine(to: rect.bottomCenter)
    addCurve(to: rect.bottomCenter, controlPoint1: rect.bottomCenter, controlPoint2: rect.bottomCenter)
    addLine(to: rect.bottomCenter)

    // bottom left
    addCurve(to: bottomLeft(rect, 0, 1.52866471, limitedRadius), controlPoint1: bottomLeft(rect, 0.68440646, 0, limitedRadius), controlPoint2: bottomLeft(rect, -0.00000004, 0.68440646, limitedRadius))
    addCurve(to: bottomLeft(rect, 0, 1.52866495, limitedRadius), controlPoint1: bottomLeft(rect, 0, 1.52866471, limitedRadius), controlPoint2: bottomLeft(rect, 0, 1.52866495, limitedRadius))

    // left center
    addLine(to: rect.leftCenter)

    // top left
    addCurve(to: topLeft(rect, 0, 1.52866483, limitedRadius), controlPoint1: topLeft(rect, 0, 1.52866483, limitedRadius), controlPoint2: topLeft(rect, 0, 1.52866483, limitedRadius))
    addLine(to: topLeft(rect, 0, 1.52866471, limitedRadius))

    // top center
    addCurve(to: rect.topCenter, controlPoint1: topLeft(rect, 0.00000007, 0.68440652, limitedRadius), controlPoint2: topLeft(rect, 0.68440658, -0.00000001, limitedRadius))
    addCurve(to: rect.topCenter, controlPoint1: rect.topCenter, controlPoint2: rect.topCenter)
    addLine(to: rect.topCenter)

    close()
  }

  private func addRoundedRect3b(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    ChouTi.assert(roundingCorners == .all, "shape 3b only supports all rounding corners", metadata: [
      "rect": "\(rect)",
      "cornerRadius": "\(cornerRadius)",
      "roundingCorners": "\(roundingCorners)",
    ])

    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let limitedRadius: CGFloat = min(cornerRadius, limit)

    move(to: rect.topCenter)

    // top center
    addLine(to: rect.topCenter)

    // top right
    addCurve(to: topRight(rect, 1.52866483, 0, limitedRadius), controlPoint1: topRight(rect, 1.52866483, 0, limitedRadius), controlPoint2: topRight(rect, 1.52866483, 0, limitedRadius))
    addLine(to: topRight(rect, 1.5286648300000005, 0, limitedRadius))

    // right center
    addCurve(to: rect.rightCenter, controlPoint1: topRight(rect, 0.6844065568353913, -1.550877287827066e-16, limitedRadius), controlPoint2: topRight(rect, 0, 0.6844065568353903, limitedRadius))
    addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)
    addLine(to: rect.rightCenter)
    addCurve(to: rect.rightCenter, controlPoint1: rect.rightCenter, controlPoint2: rect.rightCenter)
    addLine(to: rect.rightCenter)

    // bottom right
    addCurve(to: bottomRight(rect, 1.52866483, 0, limitedRadius), controlPoint1: bottomRight(rect, 0, 0.6844065568353903, limitedRadius), controlPoint2: bottomRight(rect, 0.6844065568353903, 0, limitedRadius))
    addCurve(to: bottomRight(rect, 1.52866483, 0, limitedRadius), controlPoint1: bottomRight(rect, 1.52866483, 0, limitedRadius), controlPoint2: bottomRight(rect, 1.52866483, 0, limitedRadius))

    // bottom center
    addLine(to: rect.bottomCenter)

    // bottom left
    addCurve(to: bottomLeft(rect, 1.52866483, 0, limitedRadius), controlPoint1: bottomLeft(rect, 1.52866483, 0, limitedRadius), controlPoint2: bottomLeft(rect, 1.52866483, 0, limitedRadius))
    addLine(to: bottomLeft(rect, 1.52866483, 0, limitedRadius))

    // left center
    addCurve(to: rect.leftCenter, controlPoint1: bottomLeft(rect, 0.6844065568353905, 0, limitedRadius), controlPoint2: bottomLeft(rect, 5.1695909594235537e-17, 0.6844065568353903, limitedRadius))
    addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)
    addLine(to: rect.leftCenter)
    addCurve(to: rect.leftCenter, controlPoint1: rect.leftCenter, controlPoint2: rect.leftCenter)
    addLine(to: rect.leftCenter)

    // top left
    addCurve(to: topLeft(rect, 1.5286648299999999, 0, limitedRadius), controlPoint1: topLeft(rect, -1.0339181918847107e-16, 0.6844065568353908, limitedRadius), controlPoint2: topLeft(rect, 0.6844065568353903, 1.0339181918847107e-16, limitedRadius))
    addCurve(to: topLeft(rect, 1.52866483, 0, limitedRadius), controlPoint1: topLeft(rect, 1.52866483, 0, limitedRadius), controlPoint2: topLeft(rect, 1.52866483, 0, limitedRadius))
    addLine(to: rect.topCenter)

    close()
  }
}

@inline(__always)
private func topLeft(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.minX + x * radius, y: rect.minY + y * radius)
}

@inline(__always)
private func topRight(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.maxX - x * radius, y: rect.minY + y * radius)
}

@inline(__always)
private func bottomRight(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.maxX - x * radius, y: rect.maxY - y * radius)
}

@inline(__always)
private func bottomLeft(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.minX + x * radius, y: rect.maxY - y * radius)
}

/// https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles
/// https://gist.github.com/cemolcay/28cb15001cd4786e78830369e074aa5c
/// [UIBezierPath+Superellipsoid](https://gist.github.com/nicolas-miari/46f05ab939c3778a665510bebdc7fd54)
/// https://stackoverflow.com/questions/18389114/draw-ios-7-style-squircle-programmatically

#endif
