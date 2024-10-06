//
//  CGContext+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/14/22.
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

import CoreGraphics

public extension CGContext {

  /// Returns the current drawing context.
  @inlinable
  @inline(__always)
  static var current: CGContext? {
    #if os(macOS)
    return NSGraphicsContext.current?.cgContext
    #else
    return UIGraphicsGetCurrentContext()
    #endif

    /// https://github.com/shaps80/GraphicsRenderer/blob/master/GraphicsRenderer/Classes/Platforms.swift
  }

  /// Flips the context's coordinate system vertically.
  ///
  /// - Parameter height: The height of the context to flip.
  func flipCoordinatesVertically(height: CGFloat) {
    translateBy(x: 0.0, y: height)
    scaleBy(x: 1.0, y: -1.0)

    /// https://stackoverflow.com/questions/506622/cgcontextdrawimage-draws-image-upside-down-when-passed-uiimage-cgimage
    ///
    /// Useful when drawing CGImage on context.
  }

  // Deprecated: The below implementation is not reliable.
  //
  /// Get the height of the context.
  // private func getContextHeight() -> CGFloat {
  //   let contextHeight = self.height
  //   if contextHeight > 0 {
  //     return CGFloat(contextHeight)
  //   } else {
  //     // got zero height, the context is not a bitmap context
  //     // fallback to use the clip path to get the height
  //     saveGState()
  //
  //     resetClip()
  //     let height = boundingBoxOfClipPath.size.height
  //
  //     restoreGState()
  //
  //     return height
  //   }
  // }

  /// Executes drawing operations within a saved graphics state.
  ///
  /// Example:
  /// ```swift
  /// context.onPushedGraphicsState { context in
  ///   context.setFillColor(UIColor.red.cgColor)
  ///   context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
  /// }
  /// ```
  ///
  /// - Parameter draw: A closure that performs drawing operations on the context.
  @inlinable
  @inline(__always)
  func onPushedGraphicsState(_ draw: (_ context: CGContext) throws -> Void) rethrows {
    saveGState()
    try draw(self)
    restoreGState()
  }
}

/// NSView Drawing Issue on macOS Big Sur.md
/// https://gist.github.com/lukaskubanek/9a61ac71dc0db8bb04db2028f2635779

/// Cocoa Drawing Guide
/// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40003290-CH201-SW1
