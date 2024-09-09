//
//  NSColor+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 12/23/22.
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

public extension NSColor {

  /// Check if the color space is RGB (red-green-blue) color-space model.
  @inlinable
  @inline(__always)
  var isRGB: Bool {
    /// ⚠️ accessing `colorSpace` for other types like `catalog` and `pattern` will raise exception
    guard type == .componentBased else {
      return false
    }
    return colorSpace.colorSpaceModel == .rgb
  }

  /// Check if the color space is grayscale (black-white) color-space model.
  @inlinable
  @inline(__always)
  var isGray: Bool {
    guard type == .componentBased else {
      return false
    }
    return colorSpace.colorSpaceModel == .gray
  }
}

public extension NSColorSpace.Model {

  /// Check if the color space model is RGB (red-green-blue) color-space model.
  @inlinable
  @inline(__always)
  var isRGB: Bool {
    self == .rgb
  }

  /// Check if the color space model is grayscale (black-white) color-space model.
  @inlinable
  @inline(__always)
  var isGray: Bool {
    self == .gray
  }

  /// Check if the color space model is a pattern color space, which is a repeated image that creates a tiled pattern.
  @inlinable
  @inline(__always)
  var isPatterned: Bool {
    self == .patterned
  }
}

#endif
