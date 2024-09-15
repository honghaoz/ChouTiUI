//
//  CGPath+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/3/21.
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

public extension CGPath {

  // MARK: - Factory

  /// Create an immutable path of a rectangle.
  ///
  /// - Parameters:
  ///   - rect: The rectangle to create the path from.
  ///   - transform: An optional transform to apply to the path.
  /// - Returns: An immutable rect path.
  static func path(rect: CGRect, transform: CGAffineTransform? = nil) -> CGPath {
    if let transform = transform {
      withUnsafePointer(to: transform) { pointer in
        CGPath(rect: rect, transform: pointer)
      }
    } else {
      CGPath(rect: rect, transform: nil)
    }
  }

  /// Create an immutable path of an ellipse.
  ///
  /// - Parameters:
  ///   - rect: The rectangle to create the path from.
  ///   - transform: An optional transform to apply to the path.
  /// - Returns: An immutable ellipse path.
  static func path(ellipseIn rect: CGRect, transform: CGAffineTransform? = nil) -> CGPath {
    if let transform = transform {
      withUnsafePointer(to: transform) { pointer in
        CGPath(ellipseIn: rect, transform: pointer)
      }
    } else {
      CGPath(ellipseIn: rect, transform: nil)
    }
  }

  /// Create an immutable path of a rounded rectangle.
  ///
  /// Each corner of the rounded rectangle is one-quarter of an ellipse with axes equal to the cornerWidth and cornerHeight parameters.
  /// The rounded rectangle forms a complete subpath and is oriented in the clockwise direction.
  ///
  /// - Parameters:
  ///   - rect: The rectangle to create the path from.
  ///   - cornerWidth: The width of the rounded corner.
  ///   - cornerHeight: The height of the rounded corner.
  ///   - transform: An optional transform to apply to the path.
  /// - Returns: An immutable rounded rectangle path.
  static func path(roundedRect rect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat, transform: CGAffineTransform? = nil) -> CGPath {
    if let transform = transform {
      withUnsafePointer(to: transform) { pointer in
        CGPath(roundedRect: rect, cornerWidth: cornerWidth, cornerHeight: cornerWidth, transform: pointer)
      }
    } else {
      CGPath(roundedRect: rect, cornerWidth: cornerWidth, cornerHeight: cornerWidth, transform: nil)
    }
  }

  // MARK: - Path Elements

  /// Get path elements.
  ///
  /// - Returns: An array of path elements.
  func pathElements() -> [CGPathElement.Element] {
    // https://gist.github.com/juliensagot/32c990ba69beaa754008d787e8299fa5
    var elements: [CGPathElement.Element] = []
    applyWithBlock { element in
      elements.append(element.pointee.element)
    }
    return elements
  }

  /// Get the subpaths of the path.
  ///
  /// The subpaths are the individual disconnected paths that make up the original path.
  ///
  /// - Returns: The subpaths.
  func subpaths() -> [CGPath] {
    guard isEmpty == false else {
      return []
    }

    var subpaths: [CGPath] = []
    var currentPath: CGMutablePath?

    applyWithBlock { elementPointer in
      let element = elementPointer.pointee

      switch element.type {
      case .moveToPoint:
        if let currentPath {
          subpaths.append(currentPath)
        }
        currentPath = CGMutablePath()
        currentPath?.move(to: element.points[0])

      case .addLineToPoint:
        currentPath?.addLine(to: element.points[0])

      case .addQuadCurveToPoint:
        currentPath?.addQuadCurve(to: element.points[1], control: element.points[0])

      case .addCurveToPoint:
        currentPath?.addCurve(to: element.points[2], control1: element.points[0], control2: element.points[1])

      case .closeSubpath:
        currentPath?.closeSubpath()
        if let currentPath {
          subpaths.append(currentPath)
        }
        currentPath = nil

      @unknown default:
        fatalError("Unknown path element type encountered.") // swiftlint:disable:this fatal_error
      }
    }

    if let currentPath {
      subpaths.append(currentPath)
    }

    return subpaths
  }

  // MARK: - Miscellaneous

  /// Create a `BezierPath` from the `CGPath`.
  ///
  /// - Returns: A `BezierPath` instance.
  func asBezierPath() -> BezierPath {
    BezierPath(cgPath: self)
  }

  /// Make a reversed path.
  ///
  /// - Returns: A reversed `CGPath`.
  func reversing() -> CGPath {
    BezierPath(cgPath: self).reversing().cgPath
  }
}
