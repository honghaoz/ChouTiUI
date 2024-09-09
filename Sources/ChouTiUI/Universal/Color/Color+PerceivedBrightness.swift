//
//  Color+PerceivedBrightness.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/6/23.
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

import ChouTi
import CoreGraphics

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

public extension Color {

  /// Get the perceived brightness of the color.
  ///
  /// - Returns: A value between 0 (darkest) and 1 (brightest).
  func perceivedBrightness() -> CGFloat {
    /// https://gist.github.com/delputnam/2d80e7b4bd9363fd221d131e4cfdbd8f
    /// https://www.w3.org/WAI/ER/WD-AERT/#color-contrast

    guard let colorSpace = cgColor.colorSpace else {
      ChouTi.assertFailure("failed to get color space", metadata: ["color": "\(self)"])
      return 0
    }

    let calculateRGBColorBrightness: (CGColor) -> CGFloat = { cgColor in
      guard let components = cgColor.components, components.count >= 3 else {
        ChouTi.assertFailure("color components is less than 3", metadata: ["color": "\(self)"])
        return 0
      }
      if components.contains(where: \.isNaN) {
        ChouTi.assertFailure("color components contains NaN", metadata: [
          "color": "\(self)",
        ])
        return 0
      }
      return ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
    }

    switch colorSpace.model {
    case .rgb:
      return calculateRGBColorBrightness(cgColor)
    case .monochrome:
      var white: CGFloat = 0.0
      getWhite(&white, alpha: nil)
      return white
    default:
      if let rgbColor = cgColor.usingColorSpace(CGColorSpaceCreateDeviceRGB()) {
        return calculateRGBColorBrightness(rgbColor)
      } else {
        ChouTi.assertFailure("unsupported color space model", metadata: [
          "color": "\(self)",
          "colorSpace": "\(colorSpace)",
          "colorSpaceModel": "\(colorSpace.model)",
        ])
        return 0
      }
    }
  }

  /// Checks if a color is perceived as light.
  ///
  /// - Parameters:
  ///   - threshold: The threshold to determine if the color is light or dark. Default to nil, which uses a default threshold internally.
  /// - Returns: `true` if the color is perceived as light, `false` otherwise.
  func isLight(threshold: CGFloat? = nil) -> Bool {
    /// https://stackoverflow.com/a/47456938/3164091
    /// https://stackoverflow.com/a/29044899/3164091

    // 115 / 255
    // https://stackoverflow.com/a/51567564/3164091
    let threshold = threshold ?? 0.451
    return perceivedBrightness() > threshold
  }

  /// Checks if a color is perceived as dark.
  ///
  /// - Parameters:
  ///   - threshold: The threshold to determine if the color is light or dark. Default to nil, which uses a default threshold internally.
  /// - Returns: `true` if the color is perceived as dark, `false` otherwise.
  @inlinable
  @inline(__always)
  func isDark(threshold: CGFloat? = nil) -> Bool {
    !isLight(threshold: threshold)
  }
}
