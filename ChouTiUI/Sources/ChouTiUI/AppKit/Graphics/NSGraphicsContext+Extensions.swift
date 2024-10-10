//
//  NSGraphicsContext+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/22/21.
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

public extension NSGraphicsContext {

  /// Renders an image of the specified size using the provided drawing block.
  ///
  /// This function creates an off-screen bitmap context, executes the drawing block,
  /// and returns the result as an `NSImage`.
  ///
  /// - Parameters:
  ///   - size: The size of the image to be rendered.
  ///   - drawBlock: A closure that takes a `CGContext` and performs the drawing operations.
  /// - Returns: An `NSImage` containing the rendered content.
  static func renderImage(size: CGSize, drawBlock: (CGContext) -> Void) -> NSImage {
    /// References:
    ///   - https://gist.github.com/randomsequence/b9f4462b005d0ced9a6c
    ///   - https://newbedev.com/mac-os-x-drawing-into-an-offscreen-nsgraphicscontext-using-cgcontextref-c-functions-has-no-effect-why
    ///   - https://docs.huihoo.com/apple/wwdc/2012/session_245__advanced_tips_and_tricks_for_high_resolution_on_os_x.pdf

    /// TODO: this code needs to investigate.
    /// Note: Should block-based API? or this explicit, especially considering the scale.

    let rep = NSBitmapImageRep(
      bitmapDataPlanes: nil,
      pixelsWide: Int(size.width),
      pixelsHigh: Int(size.height),
      bitsPerSample: 8,
      samplesPerPixel: 4,
      hasAlpha: true,
      isPlanar: false,
      colorSpaceName: NSColorSpaceName.calibratedRGB,
      bytesPerRow: 0,
      bitsPerPixel: 0
    )

    // swiftlint:disable:next force_unwrapping
    let context = NSGraphicsContext(bitmapImageRep: rep!)!

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context

    drawBlock(context.cgContext)

    NSGraphicsContext.restoreGraphicsState()

    let image = NSImage(size: size)
    // swiftlint:disable:next force_unwrapping
    image.addRepresentation(rep!)

    return image
  }
}

#endif
