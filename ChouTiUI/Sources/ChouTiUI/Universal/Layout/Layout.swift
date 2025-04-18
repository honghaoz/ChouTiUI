//
//  Layout.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 2/10/22.
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

import ChouTi

/// Frame layout helper.
public extension Layout {

  /// Get the centered frame of a child rectangle within a container rectangle.
  ///
  /// - Parameters:
  ///   - childSize: The size of the child rectangle.
  ///   - containerSize: The size of the container rectangle.
  /// - Returns: The centered frame of the child rectangle.
  @inlinable
  @inline(__always)
  static func center(rect childSize: CGSize, in containerSize: CGSize) -> CGRect {
    position(rect: childSize, in: containerSize, alignment: .center)
  }

  /// Get the frame of a child rectangle anchored to the edge of a parent frame.
  ///
  /// The child frame is anchored to the edge of the parent frame, outside of the parent frame.
  ///
  /// - Parameters:
  ///   - size: The child frame size.
  ///   - frame: The parent frame.
  ///   - edge: The edge of parent frame.
  ///   - anchorPoint: The anchor point of the parent frame.
  ///   - gap: The gap between child and parent frame.
  /// - Returns: The frame for child frame.
  static func anchor(rect size: CGSize, relativeTo frame: CGRect, edge: Edge, anchorPoint: UnitPoint = .center, gap: CGFloat = 0) -> CGRect {
    switch edge {
    case .top:
      return CGRect(x: frame.origin.x + frame.width * anchorPoint.x - size.width / CGFloat(2), y: frame.origin.y - size.height - gap, width: size.width, height: size.height)
    case .left:
      return CGRect(x: frame.origin.x - size.width - gap, y: frame.origin.y + frame.height * anchorPoint.y - size.height / CGFloat(2), width: size.width, height: size.height)
    case .bottom:
      return CGRect(x: frame.origin.x + frame.width * anchorPoint.x - size.width / CGFloat(2), y: frame.maxY + gap, width: size.width, height: size.height)
    case .right:
      return CGRect(x: frame.maxX + gap, y: frame.origin.y + frame.height * anchorPoint.y - size.height / CGFloat(2), width: size.width, height: size.height)
    }
  }

  /// Get the max rectangle with the given aspect ratio that can fit within the container rectangle.
  ///
  /// - Parameters:
  ///   - boundingSize: The bounding container rectangle size.
  ///   - aspectRatio: The aspect ratio for the final rectangle.
  /// - Returns: The max rectangle with the given aspect ratio that can fit within the container rectangle.
  static func maxSize(in boundingSize: CGSize, aspectRatio: Double) -> CGSize {
    let aspectSize = CGSize(width: aspectRatio, height: 1)

    let scaleFactor: CGFloat = {
      if aspectRatio > boundingSize.aspectRatio {
        // container is horizontal
        return boundingSize.width / aspectSize.width
      } else {
        // container is vertical
        return boundingSize.height / aspectSize.height
      }
    }()

    return aspectSize * scaleFactor
  }
}
