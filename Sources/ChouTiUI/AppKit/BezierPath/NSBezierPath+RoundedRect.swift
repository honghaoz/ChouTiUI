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
     This implementation can generate a path that matches UIKit's rounded rect.

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
      // TODO: shape 2a doesn't match UIKit exactly, need to write the code gen for shape 2 and update the test case
    } else if rect.size.height > breakRatio * radius {
      // radius < 1/3 height, radius > 1/3 width
      // vertical rect
      path.addRoundedRect2b(rect, cornerRadius: radius, roundingCorners: corners)
      // TODO: shape 2b doesn't match UIKit exactly, need to write the code gen for shape 2 and update the test case
    } else if rect.size.height > rect.size.width {
      // vertical rect
      path.addRoundedRect3a(rect, cornerRadius: radius, roundingCorners: corners)
      // TODO: shape 3a doesn't match UIKit exactly, need to write the code gen for shape 3 and update the test case
    } else {
      // horizontal rect
      path.addRoundedRect3b(rect, cornerRadius: radius, roundingCorners: corners)
      // TODO: shape 3b doesn't match UIKit exactly, need to write the code gen for shape 3 and update the test case
    }

    /**
     Note:
     - shape1 is the expected rounded rect.
     - shape2 is weird, it doesn't match either the layer.cornerRadius nor the capsule shape, don't think it's should be used.
     - shape3 is a capsule shape.
     */
  }

  /*
   private func addRoundedRect1(_ rect: CGRect, cornerRadius: CGFloat) {
     // CGFloat limitedCornerRadius = MIN(cornerRadius, MIN(rect.size.width, rect.size.height) / 2 / 1.52866483);
     let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
     // ChouTi.assert(cornerRadius <= limit, "caller should make sure radius is within shape 1 limit")
     let limitedRadius: CGFloat = min(cornerRadius, limit)

     //    [self moveToPoint: TOP_LEFT(1.52866483, 0.00000000)];
     move(to: topLeft(rect, 1.52866483, 0, limitedRadius))

     // top right
     //    [self addLineToPoint: TOP_RIGHT(1.52866471, 0.00000000)];
     addLine(to: topRight(rect, 1.52866471, 0, limitedRadius))
     //    [self addCurveToPoint: TOP_RIGHT(0.66993427, 0.06549600) controlPoint1: TOP_RIGHT(1.08849323, 0.00000000) controlPoint2: TOP_RIGHT(0.86840689, 0.00000000)];
     addCurve(to: topRight(rect, 0.66993427, 0.06549600, limitedRadius), controlPoint1: topRight(rect, 1.08849323, 0, limitedRadius), controlPoint2: topRight(rect, 0.86840689, 0, limitedRadius))
     //    [self addLineToPoint: TOP_RIGHT(0.63149399, 0.07491100)];
     addLine(to: topRight(rect, 0.63149399, 0.07491100, limitedRadius))
     //    [self addCurveToPoint: TOP_RIGHT(0.07491176, 0.63149399) controlPoint1: TOP_RIGHT(0.37282392, 0.16905899) controlPoint2: TOP_RIGHT(0.16906013, 0.37282401)];
     addCurve(to: topRight(rect, 0.07491176, 0.63149399, limitedRadius), controlPoint1: topRight(rect, 0.37282392, 0.16905899, limitedRadius), controlPoint2: topRight(rect, 0.16906013, 0.37282401, limitedRadius))
     //    [self addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483) controlPoint1: TOP_RIGHT(0.00000000, 0.86840701) controlPoint2: TOP_RIGHT(0.00000000, 1.08849299)];
     addCurve(to: topRight(rect, 0, 1.52866483, limitedRadius), controlPoint1: topRight(rect, 0, 0.86840701, limitedRadius), controlPoint2: topRight(rect, 0, 1.08849299, limitedRadius))

     // bottom right
     //    [self addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471)];
     addLine(to: bottomRight(rect, 0, 1.52866471, limitedRadius))
     //    [self addCurveToPoint: BOTTOM_RIGHT(0.06549569, 0.66993493) controlPoint1: BOTTOM_RIGHT(0.00000000, 1.08849323) controlPoint2: BOTTOM_RIGHT(0.00000000, 0.86840689)];
     addCurve(to: bottomRight(rect, 0.06549569, 0.66993493, limitedRadius), controlPoint1: bottomRight(rect, 0, 1.08849323, limitedRadius), controlPoint2: bottomRight(rect, 0, 0.86840689, limitedRadius))
     //    [self addLineToPoint: BOTTOM_RIGHT(0.07491111, 0.63149399)];
     addLine(to: bottomRight(rect, 0.07491111, 0.63149399, limitedRadius))
     //    [self addCurveToPoint: BOTTOM_RIGHT(0.63149399, 0.07491111) controlPoint1: BOTTOM_RIGHT(0.16905883, 0.37282392) controlPoint2: BOTTOM_RIGHT(0.37282392, 0.16905883)];
     addCurve(to: bottomRight(rect, 0.63149399, 0.07491111, limitedRadius), controlPoint1: bottomRight(rect, 0.16905883, 0.37282392, limitedRadius), controlPoint2: bottomRight(rect, 0.37282392, 0.16905883, limitedRadius))
     //    [self addCurveToPoint: BOTTOM_RIGHT(1.52866471, 0.00000000) controlPoint1: BOTTOM_RIGHT(0.86840689, 0.00000000) controlPoint2: BOTTOM_RIGHT(1.08849323, 0.00000000)];
     addCurve(to: bottomRight(rect, 1.52866471, 0, limitedRadius), controlPoint1: bottomRight(rect, 0.86840689, 0, limitedRadius), controlPoint2: bottomRight(rect, 1.08849323, 0, limitedRadius))

     // bottom left
     //    [self addLineToPoint: BOTTOM_LEFT(1.52866483, 0.00000000)];
     addLine(to: bottomLeft(rect, 1.52866483, 0, limitedRadius))
     //    [self addCurveToPoint: BOTTOM_LEFT(0.66993397, 0.06549569) controlPoint1: BOTTOM_LEFT(1.08849299, 0.00000000) controlPoint2: BOTTOM_LEFT(0.86840701, 0.00000000)];
     addCurve(to: bottomLeft(rect, 0.66993397, 0.06549569, limitedRadius), controlPoint1: bottomLeft(rect, 1.08849299, 0, limitedRadius), controlPoint2: bottomLeft(rect, 0.86840701, 0, limitedRadius))
     //    [self addLineToPoint: BOTTOM_LEFT(0.63149399, 0.07491111)];
     addLine(to: bottomLeft(rect, 0.63149399, 0.07491111, limitedRadius))
     //    [self addCurveToPoint: BOTTOM_LEFT(0.07491100, 0.63149399) controlPoint1: BOTTOM_LEFT(0.37282401, 0.16905883) controlPoint2: BOTTOM_LEFT(0.16906001, 0.37282392)];
     addCurve(to: bottomLeft(rect, 0.07491100, 0.63149399, limitedRadius), controlPoint1: bottomLeft(rect, 0.37282401, 0.16905883, limitedRadius), controlPoint2: bottomLeft(rect, 0.16906001, 0.37282392, limitedRadius))
     //    [self addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471) controlPoint1: BOTTOM_LEFT(0.00000000, 0.86840689) controlPoint2: BOTTOM_LEFT(0.00000000, 1.08849323)];
     addCurve(to: bottomLeft(rect, 0, 1.52866471, limitedRadius), controlPoint1: bottomLeft(rect, 0, 0.86840689, limitedRadius), controlPoint2: bottomLeft(rect, 0, 1.08849323, limitedRadius))

     // top left
     //    [self addLineToPoint: TOP_LEFT(0.00000000, 1.52866483)];
     addLine(to: topLeft(rect, 0, 1.52866483, limitedRadius))
     //    [self addCurveToPoint: TOP_LEFT(0.06549600, 0.66993397) controlPoint1: TOP_LEFT(0.00000000, 1.08849299) controlPoint2: TOP_LEFT(0.00000000, 0.86840701)];
     addCurve(to: topLeft(rect, 0.06549600, 0.66993397, limitedRadius), controlPoint1: topLeft(rect, 0, 1.08849299, limitedRadius), controlPoint2: topLeft(rect, 0, 0.86840701, limitedRadius))
     //    [self addLineToPoint: TOP_LEFT(0.07491100, 0.63149399)];
     addLine(to: topLeft(rect, 0.07491100, 0.63149399, limitedRadius))
     //    [self addCurveToPoint: TOP_LEFT(0.63149399, 0.07491100) controlPoint1: TOP_LEFT(0.16906001, 0.37282401) controlPoint2: TOP_LEFT(0.37282401, 0.16906001)];
     addCurve(to: topLeft(rect, 0.63149399, 0.07491100, limitedRadius), controlPoint1: topLeft(rect, 0.16906001, 0.37282401, limitedRadius), controlPoint2: topLeft(rect, 0.37282401, 0.16906001, limitedRadius))
     //    [self addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000) controlPoint1: TOP_LEFT(0.86840701, 0.00000000) controlPoint2: TOP_LEFT(1.08849299, 0.00000000)];
     addCurve(to: topLeft(rect, 1.52866483, 0, limitedRadius), controlPoint1: topLeft(rect, 0.86840701, 0, limitedRadius), controlPoint2: topLeft(rect, 1.08849299, 0, limitedRadius))

     //    [self closePath];
     close()
   }
    */

  /// Generated by `NSBezierPathRoundedRectGenerator.generateShape1Code()` on iOS 14.2 and iOS 15 (iPhone 11 Pro)
  private func addRoundedRect1(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    // ChouTi.assert(cornerRadius <= limit, "caller should make sure radius is within shape 1 limit")
    let limitedRadius: CGFloat = min(cornerRadius, limit)

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

  private func addRoundedRect2a(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    // ChouTi.assertFailure("using shape 2 is not recommended, rounding corner is not supported")
    // CGFloat limitedCornerRadius = MIN(cornerRadius, MIN(rect.size.width, rect.size.height) / 2 / 1.52866483);
    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let radius: CGFloat = min(cornerRadius, limit)

    //    [self moveToPoint: TOP_LEFT(2.00593972, 0.00000000)];
    move(to: topLeft(rect, 2.00593972, 0, radius))
    //    [self addLineToPoint: CGPointMake(rect.origin.x + rect.size.width - 1.52866483 * cornerRadius, rect.origin.y + 0 * cornerRadius)];
    addLine(to: CGPoint(rect.origin.x + rect.size.width - 1.52866483 * cornerRadius, rect.origin.y + 0 * cornerRadius))

    //    [self addCurveToPoint: TOP_RIGHT(0.99544263, 0.10012127) controlPoint1: TOP_RIGHT(1.63527834, 0.00000000) controlPoint2: TOP_RIGHT(1.29884040, 0.00000000)];
    addCurve(to: topRight(rect, 0.99544263, 0.10012127, radius), controlPoint1: topRight(rect, 1.63527834, 0, radius), controlPoint2: topRight(rect, 1.29884040, 0, radius))
    //    [self addLineToPoint: TOP_RIGHT(0.93667978, 0.11451437)];
    addLine(to: topRight(rect, 0.93667978, 0.11451437, radius))
    //    [self addCurveToPoint: TOP_RIGHT(0.00000051, 1.45223188) controlPoint1: TOP_RIGHT(0.37430558, 0.31920183) controlPoint2: TOP_RIGHT(0.00000051, 0.85376567)];
    addCurve(to: topRight(rect, 0.00000051, 1.45223188, radius), controlPoint1: topRight(rect, 0.37430558, 0.31920183, radius), controlPoint2: topRight(rect, 0.00000051, 0.85376567, radius))
    //    [self addCurveToPoint: RIGHT(0.00000000) controlPoint1: RIGHT(0.00000000) controlPoint2: RIGHT(0.00000000)];
    addCurve(to: right(rect, 0, radius), controlPoint1: right(rect, 0, radius), controlPoint2: right(rect, 0, radius))
    //    [self addLineToPoint: RIGHT(0.00000000)];
    addLine(to: right(rect, 0, radius))
    //    [self addCurveToPoint: RIGHT(0.00000000) controlPoint1: RIGHT(0.00000000) controlPoint2: RIGHT(0.00000000)];
    addCurve(to: right(rect, 0, radius), controlPoint1: right(rect, 0, radius), controlPoint2: right(rect, 0, radius))

    //    [self addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.45223165)];
    addLine(to: bottomRight(rect, 0, 1.45223165, radius))
    //    [self addCurveToPoint: BOTTOM_RIGHT(0.93667978, 0.11451438) controlPoint1: BOTTOM_RIGHT(0.00000000, 0.85376561) controlPoint2: BOTTOM_RIGHT(0.37430558, 0.31920174)];
    addCurve(to: bottomRight(rect, 0.93667978, 0.11451438, radius), controlPoint1: bottomRight(rect, 0, 0.85376561, radius), controlPoint2: bottomRight(rect, 0.37430558, 0.31920174, radius))
    //    [self addCurveToPoint: BOTTOM_RIGHT(2.30815363, 0.00000000) controlPoint1: BOTTOM_RIGHT(1.29884040, 0.00000000) controlPoint2: BOTTOM_RIGHT(1.63527834, 0.00000000)];
    addCurve(to: bottomRight(rect, 2.30815363, 0, radius), controlPoint1: bottomRight(rect, 1.29884040, 0, radius), controlPoint2: bottomRight(rect, 1.63527834, 0, radius))

    //    [self addLineToPoint: CGPointMake(rect.origin.x + 1.52866483 * cornerRadius, rect.origin.y + rect.size.height - 0 * limitedCornerRadius)];
    addLine(to: CGPoint(rect.origin.x + 1.52866483 * cornerRadius, rect.origin.y + rect.size.height - 0 * radius))

    //    [self addCurveToPoint: BOTTOM_LEFT(0.99544257, 0.10012124) controlPoint1: BOTTOM_LEFT(1.63527822, 0.00000000) controlPoint2: BOTTOM_LEFT(1.29884040, 0.00000000)];
    addCurve(to: bottomLeft(rect, 0.99544257, 0.10012124, radius), controlPoint1: bottomLeft(rect, 1.63527822, 0, radius), controlPoint2: bottomLeft(rect, 1.29884040, 0, radius))
    //    [self addLineToPoint: BOTTOM_LEFT(0.93667972, 0.11451438)];
    addLine(to: bottomLeft(rect, 0.93667972, 0.11451438, radius))
    //    [self addCurveToPoint: BOTTOM_LEFT(-0.00000001, 1.45223176) controlPoint1: BOTTOM_LEFT(0.37430549, 0.31920174) controlPoint2: BOTTOM_LEFT(-0.00000007, 0.85376561)];
    addCurve(to: bottomLeft(rect, -0.00000001, 1.45223176, radius), controlPoint1: bottomLeft(rect, 0.37430549, 0.31920174, radius), controlPoint2: bottomLeft(rect, -0.00000007, 0.85376561, radius))
    //    [self addCurveToPoint: LEFT(0.00000000) controlPoint1: LEFT(0.00000000) controlPoint2: LEFT(0.00000000)];
    addCurve(to: left(rect, 0, radius), controlPoint1: left(rect, 0, radius), controlPoint2: left(rect, 0, radius))
    //    [self addLineToPoint: LEFT(0.00000000)];
    addLine(to: left(rect, 0, radius))
    //    [self addCurveToPoint: LEFT(0.00000000) controlPoint1: LEFT(0.00000000) controlPoint2: LEFT(0.00000000)];
    addCurve(to: left(rect, 0, radius), controlPoint1: left(rect, 0, radius), controlPoint2: left(rect, 0, radius))

    //    [self addLineToPoint: TOP_LEFT(-0.00000001, 1.45223153)];
    addLine(to: topLeft(rect, -0.00000001, 1.45223153, radius))
    //    [self addCurveToPoint: TOP_LEFT(0.93667978, 0.11451436) controlPoint1: TOP_LEFT(0.00000004, 0.85376537) controlPoint2: TOP_LEFT(0.37430561, 0.31920177)];
    addCurve(to: topLeft(rect, 0.93667978, 0.11451436, radius), controlPoint1: topLeft(rect, 0.00000004, 0.85376537, radius), controlPoint2: topLeft(rect, 0.37430561, 0.31920177, radius))
    //    [self addCurveToPoint: TOP_LEFT(2.30815363, 0.00000000) controlPoint1: TOP_LEFT(1.29884040, 0.00000000) controlPoint2: TOP_LEFT(1.63527822, 0.00000000)];
    addCurve(to: topLeft(rect, 2.30815363, 0, radius), controlPoint1: topLeft(rect, 1.29884040, 0, radius), controlPoint2: topLeft(rect, 1.63527822, 0, radius))
    //    [self addLineToPoint: CGPointMake(rect.origin.x + 1.52866483 * cornerRadius, rect.origin.y + 0 * cornerRadius)];
    addLine(to: CGPoint(rect.origin.x + 1.52866483 * cornerRadius, rect.origin.y + 0 * cornerRadius))
    //    [self addLineToPoint: TOP_LEFT(2.00593972, 0.00000000)];
    addLine(to: topLeft(rect, 2.00593972, 0, radius))
    //    [self closePath];
    close()
  }

  private func addRoundedRect2b(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    // ChouTi.assertFailure("using shape 2 is not recommended, rounding corner is not supported")
    // CGFloat limitedCornerRadius = MIN(cornerRadius, MIN(rect.size.width, rect.size.height) / 2 / 1.52866483);
    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let radius: CGFloat = min(cornerRadius, limit)

    //    [self moveToPoint: TOP(0.00000000)];
    move(to: top(rect, 0, radius))

    //    [self addLineToPoint: TOP(0.00000000)];
    addLine(to: top(rect, 0, radius))
    //    [self addCurveToPoint: TOP(0.00000000) controlPoint1: TOP(0.00000000) controlPoint2: TOP(0.00000000)];
    addCurve(to: top(rect, 0, radius), controlPoint1: top(rect, 0, radius), controlPoint2: top(rect, 0, radius))
    //    [self addLineToPoint: TOP_RIGHT(1.45223153, 0.00000000)];
    addLine(to: topRight(rect, 1.45223153, 0, radius))
    //    [self addCurveToPoint: TOP_RIGHT(0.11451442, 0.93667936) controlPoint1: TOP_RIGHT(0.85376573, 0.00000001) controlPoint2: TOP_RIGHT(0.31920189, 0.37430537)];
    addCurve(to: topRight(rect, 0.11451442, 0.93667936, radius), controlPoint1: topRight(rect, 0.85376573, 0.00000001, radius), controlPoint2: topRight(rect, 0.31920189, 0.37430537, radius))
    //    [self addCurveToPoint: TOP_RIGHT(0.00000000, 2.30815387) controlPoint1: TOP_RIGHT(0.00000000, 1.29884040) controlPoint2: TOP_RIGHT(0.00000000, 1.63527822)];
    addCurve(to: topRight(rect, 0, 2.30815387, radius), controlPoint1: topRight(rect, 0, 1.29884040, radius), controlPoint2: topRight(rect, 0, 1.63527822, radius))

    //    [self addLineToPoint: CGPointMake(rect.origin.x + rect.size.width - 0 * cornerRadius, rect.origin.y + rect.size.height - 1.52866483 * cornerRadius)];
    addLine(to: CGPoint(rect.origin.x + rect.width - 0 * cornerRadius, rect.origin.y + rect.height - 1.52866483 * cornerRadius))

    //    [self addCurveToPoint: BOTTOM_RIGHT(0.10012137, 0.99544269) controlPoint1: BOTTOM_RIGHT(0.00000000, 1.63527822) controlPoint2: BOTTOM_RIGHT(0.00000000, 1.29884028)];
    addCurve(to: bottomRight(rect, 0.10012137, 0.99544269, radius), controlPoint1: bottomRight(rect, 0, 1.63527822, radius), controlPoint2: bottomRight(rect, 0, 1.29884028, radius))
    //    [self addLineToPoint: BOTTOM_RIGHT(0.11451442, 0.93667972)];
    addLine(to: bottomRight(rect, 0.11451442, 0.93667972, radius))
    //    [self addCurveToPoint: BOTTOM_RIGHT(1.45223165, 0.00000000) controlPoint1: BOTTOM_RIGHT(0.31920189, 0.37430552) controlPoint2: BOTTOM_RIGHT(0.85376549, 0.00000000)];
    addCurve(to: bottomRight(rect, 1.45223165, 0, radius), controlPoint1: bottomRight(rect, 0.31920189, 0.37430552, radius), controlPoint2: bottomRight(rect, 0.85376549, 0, radius))
    //    [self addCurveToPoint: BOTTOM(0.00000000) controlPoint1: BOTTOM(0.00000000) controlPoint2: BOTTOM(0.00000000)];
    addCurve(to: bottom(rect, 0, radius), controlPoint1: bottom(rect, 0, radius), controlPoint2: bottom(rect, 0, radius))
    //    [self addLineToPoint: BOTTOM(0.00000000)];
    addLine(to: bottom(rect, 0, radius))
    //    [self addCurveToPoint: BOTTOM(0.00000000) controlPoint1: BOTTOM(0.00000000) controlPoint2: BOTTOM(0.00000000)];
    addCurve(to: bottom(rect, 0, radius), controlPoint1: bottom(rect, 0, radius), controlPoint2: bottom(rect, 0, radius))

    //    [self addLineToPoint: BOTTOM_LEFT(1.45223141, 0.00000000)];
    addLine(to: bottomLeft(rect, 1.45223141, 0, radius))
    //    [self addCurveToPoint: BOTTOM_LEFT(0.11451446, 0.93667972) controlPoint1: BOTTOM_LEFT(0.85376543, 0.00000000) controlPoint2: BOTTOM_LEFT(0.31920192, 0.37430552)];
    addCurve(to: bottomLeft(rect, 0.11451446, 0.93667972, radius), controlPoint1: bottomLeft(rect, 0.85376543, 0, radius), controlPoint2: bottomLeft(rect, 0.31920192, 0.37430552, radius))
    //    [self addCurveToPoint: BOTTOM_LEFT(0.00000000, 2.30815387) controlPoint1: BOTTOM_LEFT(0.00000000, 1.29884028) controlPoint2: BOTTOM_LEFT(0.00000000, 1.63527822)];
    addCurve(to: bottomLeft(rect, 0, 2.30815387, radius), controlPoint1: bottomLeft(rect, 0, 1.29884028, radius), controlPoint2: bottomLeft(rect, 0, 1.63527822, radius))

    //    [self addLineToPoint: CGPointMake(rect.origin.x + 0 * cornerRadius, rect.origin.y + 1.52866483 * cornerRadius)];
    addLine(to: CGPoint(rect.origin.x + 0 * cornerRadius, rect.origin.y + 1.52866483 * cornerRadius))

    //    [self addCurveToPoint: TOP_LEFT(0.10012126, 0.99544257) controlPoint1: TOP_LEFT(0.00000000, 1.63527822) controlPoint2: TOP_LEFT(0.00000000, 1.29884040)];
    addCurve(to: topLeft(rect, 0.10012126, 0.99544257, radius), controlPoint1: topLeft(rect, 0, 1.63527822, radius), controlPoint2: topLeft(rect, 0, 1.29884040, radius))
    //    [self addLineToPoint: TOP_LEFT(0.11451443, 0.93667966)];
    addLine(to: topLeft(rect, 0.11451443, 0.93667966, radius))
    //    [self addCurveToPoint: TOP_LEFT(1.45223153, 0.00000000) controlPoint1: TOP_LEFT(0.31920189, 0.37430552) controlPoint2: TOP_LEFT(0.85376549, 0.00000000)];
    addCurve(to: topLeft(rect, 1.45223153, 0, radius), controlPoint1: topLeft(rect, 0.31920189, 0.37430552, radius), controlPoint2: topLeft(rect, 0.85376549, 0, radius))
    //    [self addCurveToPoint: TOP(0.00000000) controlPoint1: TOP(0.00000000) controlPoint2: TOP(0.00000000)];
    addCurve(to: top(rect, 0, radius), controlPoint1: top(rect, 0, radius), controlPoint2: top(rect, 0, radius))
    //    [self addLineToPoint: TOP(0.00000000)];
    addLine(to: top(rect, 0, radius))
    //    [self closePath];
    close()
  }

  private func addRoundedRect3a(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    // ChouTi.assertFailure("using shape 3 is not recommended, consider using Capsule shape")
    // CGFloat limitedCornerRadius = MIN(cornerRadius, MIN(rect.size.width, rect.size.height) / 2 / 1.52866483);
    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let radius: CGFloat = min(cornerRadius, limit)

    if roundingCorners.contains(.topLeft) {
      //    [self moveToPoint: TOP(0.00000000)];
      move(to: top(rect, 0, radius))
    } else {
      move(to: rect.topLeft)
    }

    // top right
    if roundingCorners.contains(.topRight) {
      //    [self addLineToPoint: TOP(0.00000000)];
      addLine(to: top(rect, 0, radius))
      //    [self addCurveToPoint: TOP(0.00000000) controlPoint1: TOP(0.00000000) controlPoint2: TOP(0.00000000)];
      addCurve(to: top(rect, 0, radius), controlPoint1: top(rect, 0, radius), controlPoint2: top(rect, 0, radius))
      //    [self addLineToPoint: TOP(0.00000000)];
      addLine(to: top(rect, 0, radius))
      //    [self addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483) controlPoint1: TOP_RIGHT(0.68440646, 0.00000001) controlPoint2: TOP_RIGHT(0.00000000, 0.68440658)];
      addCurve(to: topRight(rect, 0, 1.52866483, radius), controlPoint1: topRight(rect, 0.68440646, 0.00000001, radius), controlPoint2: topRight(rect, 0, 0.68440658, radius))
      //    [self addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866507) controlPoint1: TOP_RIGHT(0.00000000, 1.52866495) controlPoint2: TOP_RIGHT(0.00000000, 1.52866495)];
      addCurve(to: topRight(rect, 0, 1.52866507, radius), controlPoint1: topRight(rect, 0, 1.52866495, radius), controlPoint2: topRight(rect, 0, 1.52866495, radius))
      //    [self addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483) controlPoint1: TOP_RIGHT(0.00000000, 1.52866483) controlPoint2: TOP_RIGHT(0.00000000, 1.52866483)];
      addCurve(to: topRight(rect, 0, 1.52866483, radius), controlPoint1: topRight(rect, 0, 1.52866483, radius), controlPoint2: topRight(rect, 0, 1.52866483, radius))
    } else {
      addLine(to: rect.topRight)
    }

    // bottom right
    if roundingCorners.contains(.bottomRight) {
      //    [self addLineToPoint: RIGHT(0.00000000)];
      addLine(to: right(rect, 0, radius))
      //    [self addCurveToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471) controlPoint1: BOTTOM_RIGHT(0.00000000, 1.52866471) controlPoint2: BOTTOM_RIGHT(0.00000000, 1.52866471)];
      addCurve(to: bottomRight(rect, 0, 1.52866471, radius), controlPoint1: bottomRight(rect, 0, 1.52866471, radius), controlPoint2: bottomRight(rect, 0, 1.52866471, radius))
      //    [self addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471)];
      addLine(to: bottomRight(rect, 0, 1.52866471, radius))
      //    [self addCurveToPoint: BOTTOM(0.00000000) controlPoint1: BOTTOM_RIGHT(0.00000000, 0.68440646) controlPoint2: BOTTOM_RIGHT(0.68440646, 0.00000000)];
      addCurve(to: bottom(rect, 0, radius), controlPoint1: bottomRight(rect, 0, 0.68440646, radius), controlPoint2: bottomRight(rect, 0.68440646, 0, radius))
      //    [self addCurveToPoint: BOTTOM(0.00000000) controlPoint1: BOTTOM(0.00000000) controlPoint2: BOTTOM(0.00000000)];
      addCurve(to: bottom(rect, 0, radius), controlPoint1: bottom(rect, 0, radius), controlPoint2: bottom(rect, 0, radius))
      //    [self addCurveToPoint: BOTTOM(0.00000000) controlPoint1: BOTTOM(0.00000000) controlPoint2: BOTTOM(0.00000000)];
      addCurve(to: bottom(rect, 0, radius), controlPoint1: bottom(rect, 0, radius), controlPoint2: bottom(rect, 0, radius))
      //    [self addLineToPoint: BOTTOM(0.00000000)];
      addLine(to: bottom(rect, 0, radius))
      //    [self addCurveToPoint: BOTTOM(0.00000000) controlPoint1: BOTTOM(0.00000000) controlPoint2: BOTTOM(0.00000000)];
      addCurve(to: bottom(rect, 0, radius), controlPoint1: bottom(rect, 0, radius), controlPoint2: bottom(rect, 0, radius))
    } else {
      addLine(to: rect.bottomRight)
    }

    // bottom left
    if roundingCorners.contains(.bottomLeft) {
      //    [self addLineToPoint: BOTTOM(0.00000000)];
      addLine(to: bottom(rect, 0, radius))
      //    [self addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471) controlPoint1: BOTTOM_LEFT(0.68440646, 0.00000000) controlPoint2: BOTTOM_LEFT(-0.00000004, 0.68440646)];
      addCurve(to: bottomLeft(rect, 0, 1.52866471, radius), controlPoint1: bottomLeft(rect, 0.68440646, 0, radius), controlPoint2: bottomLeft(rect, -0.00000004, 0.68440646, radius))
      //    [self addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866495) controlPoint1: BOTTOM_LEFT(0.00000000, 1.52866471) controlPoint2: BOTTOM_LEFT(0.00000000, 1.52866495)];
      addCurve(to: bottomLeft(rect, 0, 1.52866495, radius), controlPoint1: bottomLeft(rect, 0, 1.52866471, radius), controlPoint2: bottomLeft(rect, 0, 1.52866495, radius))
      //    [self addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471) controlPoint1: BOTTOM_LEFT(0.00000000, 1.52866471) controlPoint2: BOTTOM_LEFT(0.00000000, 1.52866471)];
      addCurve(to: bottomLeft(rect, 0, 1.52866471, radius), controlPoint1: bottomLeft(rect, 0, 1.52866471, radius), controlPoint2: bottomLeft(rect, 0, 1.52866471, radius))
    } else {
      addLine(to: rect.bottomLeft)
    }

    // top left
    if roundingCorners.contains(.topLeft) {
      //    [self addLineToPoint: LEFT(0.00000000)];
      addLine(to: left(rect, 0, radius))
      //    [self addCurveToPoint: TOP_LEFT(0.00000000, 1.52866483) controlPoint1: TOP_LEFT(0.00000000, 1.52866483) controlPoint2: TOP_LEFT(0.00000000, 1.52866483)];
      addCurve(to: topLeft(rect, 0, 1.52866483, radius), controlPoint1: topLeft(rect, 0, 1.52866483, radius), controlPoint2: topLeft(rect, 0, 1.52866483, radius))
      //    [self addLineToPoint: TOP_LEFT(0.00000000, 1.52866471)];
      addLine(to: topLeft(rect, 0, 1.52866471, radius))
      //    [self addCurveToPoint: TOP(0.00000000) controlPoint1: TOP_LEFT(0.00000007, 0.68440652) controlPoint2: TOP_LEFT(0.68440658, -0.00000001)];
      addCurve(to: top(rect, 0, radius), controlPoint1: topLeft(rect, 0.00000007, 0.68440652, radius), controlPoint2: topLeft(rect, 0.68440658, -0.00000001, radius))
      //    [self addCurveToPoint: TOP(0.00000000) controlPoint1: TOP(0.00000000) controlPoint2: TOP(0.00000000)];
      addCurve(to: top(rect, 0, radius), controlPoint1: top(rect, 0, radius), controlPoint2: top(rect, 0, radius))
      //    [self addLineToPoint: TOP(0.00000000)];
      addLine(to: top(rect, 0, radius))
    } else {
      addLine(to: rect.topLeft)
    }

    //    [self closePath];
    close()
  }

  private func addRoundedRect3b(_ rect: CGRect, cornerRadius: CGFloat, roundingCorners: RectCorner) {
    // ChouTi.assertFailure("using shape 3 is not recommended, consider using Capsule shape")
    // CGFloat limitedCornerRadius = MIN(cornerRadius, MIN(rect.size.width, rect.size.height) / 2 / 1.52866483);
    let limit: CGFloat = min(rect.width, rect.height) / 2 / 1.52866483
    let radius: CGFloat = min(cornerRadius, limit)

    if roundingCorners.contains(.topLeft) {
      //    [self moveToPoint: TOP(0.00000000)];
      move(to: top(rect, 0, radius))
    } else {
      move(to: rect.topLeft)
    }

    // top right
    if roundingCorners.contains(.topRight) {
      //    [self addLineToPoint: TOP(0.00000000)];
      addLine(to: top(rect, 0, radius))
      //    [self addCurveToPoint: TOP_RIGHT(1.52866495, 0.00000000) controlPoint1: TOP_RIGHT(1.52866495, 0.00000000) controlPoint2: TOP_RIGHT(1.52866495, 0.00000000)];
      addCurve(to: topRight(rect, 1.52866495, 0, radius), controlPoint1: topRight(rect, 1.52866495, 0, radius), controlPoint2: topRight(rect, 1.52866495, 0, radius))
      //    [self addLineToPoint: TOP_RIGHT(1.52866495, 0.00000000)];
      addLine(to: topRight(rect, 1.52866495, 0, radius))
      //    [self addCurveToPoint: RIGHT(0.00000000) controlPoint1: TOP_RIGHT(0.68440676, 0.00000001) controlPoint2: TOP_RIGHT(0.00000000, 0.68440658)];
      addCurve(to: right(rect, 0, radius), controlPoint1: topRight(rect, 0.68440676, 0.00000001, radius), controlPoint2: topRight(rect, 0, 0.68440658, radius))
      //    [self addCurveToPoint: RIGHT(0.00000000) controlPoint1: RIGHT(0.00000000) controlPoint2: RIGHT(0.00000000)];
      addCurve(to: right(rect, 0, radius), controlPoint1: right(rect, 0, radius), controlPoint2: right(rect, 0, radius))
      //    [self addCurveToPoint: RIGHT(0.00000000) controlPoint1: RIGHT(0.00000000) controlPoint2: RIGHT(0.00000000)];
      addCurve(to: right(rect, 0, radius), controlPoint1: right(rect, 0, radius), controlPoint2: right(rect, 0, radius))
    } else {
      addLine(to: rect.topRight)
    }

    // bottom right
    if roundingCorners.contains(.bottomRight) {
      //    [self addLineToPoint: RIGHT(0.00000000)];
      addLine(to: right(rect, 0, radius))
      //    [self addCurveToPoint: RIGHT(0.00000000) controlPoint1: RIGHT(0.00000000) controlPoint2: RIGHT(0.00000000)];
      addCurve(to: right(rect, 0, radius), controlPoint1: right(rect, 0, radius), controlPoint2: right(rect, 0, radius))
      //    [self addLineToPoint: RIGHT(0.00000000)];
      addLine(to: right(rect, 0, radius))
      //    [self addCurveToPoint: BOTTOM_RIGHT(1.52866495, 0.00000000) controlPoint1: BOTTOM_RIGHT(0.00000000, 0.68440652) controlPoint2: BOTTOM_RIGHT(0.68440676, 0.00000000)];
      addCurve(to: bottomRight(rect, 1.52866495, 0, radius), controlPoint1: bottomRight(rect, 0, 0.68440652, radius), controlPoint2: bottomRight(rect, 0.68440676, 0, radius))
      //    [self addCurveToPoint: BOTTOM_RIGHT(1.52866495, 0.00000000) controlPoint1: BOTTOM_RIGHT(1.52866495, 0.00000000) controlPoint2: BOTTOM_RIGHT(1.52866495, 0.00000000)];
      addCurve(to: bottomRight(rect, 1.52866495, 0, radius), controlPoint1: bottomRight(rect, 1.52866495, 0, radius), controlPoint2: bottomRight(rect, 1.52866495, 0, radius))
      //    [self addCurveToPoint: BOTTOM_RIGHT(1.52866495, 0.00000000) controlPoint1: BOTTOM_RIGHT(1.52866495, 0.00000000) controlPoint2: BOTTOM_RIGHT(1.52866495, 0.00000000)];
      addCurve(to: bottomRight(rect, 1.52866495, 0, radius), controlPoint1: bottomRight(rect, 1.52866495, 0, radius), controlPoint2: bottomRight(rect, 1.52866495, 0, radius))
    } else {
      addLine(to: rect.bottomRight)
    }

    // bottom left
    if roundingCorners.contains(.bottomLeft) {
      //    [self addLineToPoint: BOTTOM(0.00000000)];
      addLine(to: bottom(rect, 0, radius))
      //    [self addCurveToPoint: BOTTOM_LEFT(1.52866483, 0.00000000) controlPoint1: BOTTOM_LEFT(1.52866483, 0.00000000) controlPoint2: BOTTOM_LEFT(1.52866483, 0.00000000)];
      addCurve(to: bottomLeft(rect, 1.52866483, 0, radius), controlPoint1: bottomLeft(rect, 1.52866483, 0, radius), controlPoint2: bottomLeft(rect, 1.52866483, 0, radius))
      //    [self addLineToPoint: BOTTOM_LEFT(1.52866471, 0.00000000)];
      addLine(to: bottomLeft(rect, 1.52866471, 0, radius))
      //    [self addCurveToPoint: LEFT(0.00000000) controlPoint1: BOTTOM_LEFT(0.68440646, 0.00000000) controlPoint2: BOTTOM_LEFT(-0.00000004, 0.68440676)];
      addCurve(to: left(rect, 0, radius), controlPoint1: bottomLeft(rect, 0.68440646, 0, radius), controlPoint2: bottomLeft(rect, -0.00000004, 0.68440676, radius))
      //    [self addCurveToPoint: LEFT(0.00000000) controlPoint1: LEFT(0.00000000) controlPoint2: LEFT(0.00000000)];
      addCurve(to: left(rect, 0, radius), controlPoint1: left(rect, 0, radius), controlPoint2: left(rect, 0, radius))
      //    [self addCurveToPoint: LEFT(0.00000000) controlPoint1: LEFT(0.00000000) controlPoint2: LEFT(0.00000000)];
      addCurve(to: left(rect, 0, radius), controlPoint1: left(rect, 0, radius), controlPoint2: left(rect, 0, radius))
      //    [self addLineToPoint: LEFT(0.00000000)];
      addLine(to: left(rect, 0, radius))
      //    [self addCurveToPoint: LEFT(0.00000000) controlPoint1: LEFT(0.00000000) controlPoint2: LEFT(0.00000000)];
      addCurve(to: left(rect, 0, radius), controlPoint1: left(rect, 0, radius), controlPoint2: left(rect, 0, radius))
    } else {
      addLine(to: rect.bottomLeft)
    }

    // top left
    if roundingCorners.contains(.topLeft) {
      //    [self addLineToPoint: LEFT(0.00000000)];
      addLine(to: left(rect, 0, radius))
      //    [self addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000) controlPoint1: TOP_LEFT(0.00000007, 0.68440652) controlPoint2: TOP_LEFT(0.68440664, -0.00000001)];
      addCurve(to: topLeft(rect, 1.52866483, 0, radius), controlPoint1: topLeft(rect, 0.00000007, 0.68440652, radius), controlPoint2: topLeft(rect, 0.68440664, -0.00000001, radius))
      //    [self addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000) controlPoint1: TOP_LEFT(1.52866483, 0.00000000) controlPoint2: TOP_LEFT(1.52866483, 0.00000000)];
      addCurve(to: topLeft(rect, 1.52866483, 0, radius), controlPoint1: topLeft(rect, 1.52866483, 0, radius), controlPoint2: topLeft(rect, 1.52866483, 0, radius))
      //    [self addLineToPoint: TOP(0.00000000)];
      addLine(to: top(rect, 0, radius))
    } else {
      addLine(to: rect.topLeft)
    }

    //    [self closePath];
    close()
  }
}

// #define TOP_LEFT(X, Y) CGPointMake(rect.origin.x + X * limitedCornerRadius, rect.origin.y + Y * limitedCornerRadius)
private func topLeft(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.origin.x + x * radius, y: rect.origin.y + y * radius)
}

// #define TOP_RIGHT(X, Y) CGPointMake(rect.origin.x + rect.size.width - X * limitedCornerRadius, rect.origin.y + Y * limitedCornerRadius)
private func topRight(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.origin.x + rect.width - x * radius, y: rect.origin.y + y * radius)
}

// #define BOTTOM_RIGHT(X, Y) CGPointMake(rect.origin.x + rect.size.width - X * limitedCornerRadius, rect.origin.y + rect.size.height - Y * limitedCornerRadius)
private func bottomRight(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.origin.x + rect.width - x * radius, y: rect.origin.y + rect.height - y * radius)
}

// #define BOTTOM_LEFT(X, Y) CGPointMake(rect.origin.x + X * limitedCornerRadius, rect.origin.y + rect.size.height - Y * limitedCornerRadius)
private func bottomLeft(_ rect: CGRect, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.origin.x + x * radius, y: rect.origin.y + rect.height - y * radius)
}

// #define TOP(Y) CGPointMake(CGRectGetMidX(rect), rect.origin.y + Y * rect.size.width)
private func top(_ rect: CGRect, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.midX, y: rect.origin.y + y * rect.width)
}

// #define BOTTOM(Y) CGPointMake(CGRectGetMidX(rect), rect.origin.y + rect.size.height - Y * limitedCornerRadius)
private func bottom(_ rect: CGRect, _ y: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.midX, y: rect.origin.y + rect.height - y * radius)
}

// #define LEFT(X) CGPointMake(rect.origin.x + X * rect.size.height, CGRectGetMidY(rect))
private func left(_ rect: CGRect, _ x: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.origin.x + x * rect.height, y: rect.midY)
}

// #define RIGHT(X) CGPointMake(rect.origin.x + rect.size.width - X * limitedCornerRadius, CGRectGetMidY(rect))
private func right(_ rect: CGRect, _ x: CGFloat, _ radius: CGFloat) -> CGPoint {
  CGPoint(x: rect.right - x * radius, y: rect.midY)
}

/// https://www.paintcodeapp.com/news/code-for-ios-7-rounded-rectangles
/// https://gist.github.com/cemolcay/28cb15001cd4786e78830369e074aa5c
/// [UIBezierPath+Superellipsoid](https://gist.github.com/nicolas-miari/46f05ab939c3778a665510bebdc7fd54)
/// https://stackoverflow.com/questions/18389114/draw-ios-7-style-squircle-programmatically

#endif
