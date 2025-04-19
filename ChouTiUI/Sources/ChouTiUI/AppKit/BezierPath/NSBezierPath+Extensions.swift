//
//  NSBezierPath+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/4/21.
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

import ChouTi

// MARK: - UIBezierPath (UIKit) Compatibility

public extension NSBezierPath {

  /// Creates and returns a new Bézier path object with an arc of a circle.
  ///
  /// - Parameters:
  ///   - center: Specifies the center point of the circle (in the current coordinate system) used to define the arc.
  ///   - radius: Specifies the radius of the circle used to define the arc.
  ///   - startAngle: Specifies the starting angle of the arc (measured in radians).
  ///   - endAngle: Specifies the end angle of the arc (measured in radians).
  ///   - clockwise: The direction in which to draw the arc.
  convenience init(arcCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
    self.init()

    // iOS uses radians for angles
    // macOS uses degrees for angles
    // NSBezierPath has a revered clockwise flag 🤨. iOS and macOS uses different directions.
    //
    // reference:
    //   - https://stackoverflow.com/a/31219154/3164091
    //   - https://gist.github.com/seivan/d360aaec9780692e3520
    appendArc(withCenter: center, radius: radius, startAngle: startAngle.toDegrees, endAngle: endAngle.toDegrees, clockwise: !clockwise)
  }

  /// Transforms all points in the path using the specified affine transform matrix.
  ///
  /// This method applies the specified transform to the path’s points immediately.
  ///
  /// - Parameter transform: The transform matrix to apply to the path.
  @inlinable
  @inline(__always)
  func apply(_ transform: CGAffineTransform) {
    self.transform(using: transform.affineTransform)
  }

  /// Appends an arc of a circle to the path.
  ///
  /// This method adds the specified arc beginning at the current point. The created arc lies on the perimeter of the specified circle.
  ///
  /// - Parameters:
  ///   - center: Specifies the center point of the circle used to define the arc.
  ///   - radius: Specifies the radius of the circle used to define the arc.
  ///   - startAngle: Specifies the starting angle of the arc (measured in radians).
  ///   - endAngle: Specifies the end angle of the arc (measured in radians).
  ///   - clockwise: The direction in which to draw the arc.
  func addArc(withCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
    // NSBezierPath has a revered clockwise flag 🤨. iOS and macOS uses different directions.
    appendArc(withCenter: center, radius: radius, startAngle: startAngle.toDegrees, endAngle: endAngle.toDegrees, clockwise: !clockwise)
  }

  /// A Boolean value that indicates whether the even-odd winding rule is in use for drawing paths.
  ///
  /// If true, the path is filled using the even-odd rule. If false, it is filled using the non-zero rule.
  /// Both rules are algorithms to determine which areas of a path to fill with the current fill color.
  /// A ray is drawn from a point inside a given region to a point anywhere outside the path’s bounds.
  ///
  /// The total number of crossed path lines (including implicit path lines) and the direction of each path line are then interpreted as follows:
  ///
  /// - For the even-odd rule, if the total number of path crossings is odd, the point is considered to be inside the path and the corresponding region is filled.
  ///   If the number of crossings is even, the point is considered to be outside the path and the region is not filled.
  ///
  /// - For the non-zero rule, the crossing of a left-to-right path counts as +1 and the crossing of a right-to-left path counts as -1.
  ///   If the sum of the crossings is nonzero, the point is considered to be inside the path and the corresponding region is filled.
  ///   If the sum is 0, the point is outside the path and the region is not filled.
  ///
  /// The default value of this property is false. For more information about winding rules and how they are applied to subpaths,
  /// see [Quartz 2D Programming Guide](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html#//apple_ref/doc/uid/TP30001066).
  var usesEvenOddFillRule: Bool {
    /**
     https://www.sitepoint.com/understanding-svg-fill-rule-property/
     - non zero: drawing a line from the point in question through the shape in any direction.
       1. start with a count of 0.
       2. add 1 each time a path segment crosses the line from left to right (clockwise)
       3. subtract 1 each time a path segment crosses from right to left (counterclockwise).
       4. zero is outside, non-zero is inside

     - even odd (winding): drawing a line from the area in question through the entire shape in any direction.
       1. The path segments that cross this line are then counted.
       2. If the final number is even, the point is outside;
       3. if it’s odd, the point is inside.
     */
    get {
      windingRule == .evenOdd
    }
    set {
      windingRule = newValue ? .evenOdd : .nonZero
    }
  }
}

/**
 Readings:
 - https://gist.github.com/erica/ec3e2a4a8526e3fc3ba1fc95a0d53083
 - [NSBezierPath port](https://gist.github.com/cemolcay/28cb15001cd4786e78830369e074aa5c)
 */

#endif
