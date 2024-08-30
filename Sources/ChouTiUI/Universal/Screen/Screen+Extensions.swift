//
//  Screen+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/30/22.
//  Copyright © 2020 Honghao Zhang (github.com/honghaoz).
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang
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

public extension Screen {

  /// The main screen's scale factor.
  ///
  /// - on macOS and iOS, this uses `Screens.mainScreen`'s scale. You can set `Screens.mainScreen` explicitly to change this value.
  /// - on visionOS, this uses a constant: `Sizing.visionOS.scaleFactor`.
  static var mainScreenScale: CGFloat {
    #if os(visionOS)
    return Sizing.visionOS.scaleFactor
    #else
    Screens.mainScreen.assert("missing main screen")?.scale ?? 2.0
    #endif
  }

  #if !os(visionOS)
  /// The main screen.
  static func mainScreen() -> Screen? {
    #if os(macOS)
    return NSScreen.main
    #else
    return UIScreen.main
    #endif
  }

  /// The size of 1 pixel for the screen.
  @inlinable
  @inline(__always)
  var pixelSize: CGFloat {
    1 / scale
  }

  /// The size of half point for the screen.
  ///
  /// - on 2x devices -> The size of half point is 0.5
  /// - on 3x devices -> The size of half point is 0.66666
  var halfPoint: CGFloat {
    switch scale {
    case 3:
      return pixelSize * 2
    case 2:
      return pixelSize
    default:
      return pixelSize
    }
  }

  /// Check if the screen is 3x scale.
  @inlinable
  @inline(__always)
  var is3x: Bool {
    scale == 3
  }

  /// Check if the screen is 2x scale.
  @inlinable
  @inline(__always)
  var is2x: Bool {
    scale == 2
  }

  #if canImport(UIKit)
  /// The minimum refresh interval for the screen.
  @available(iOS 10.3, *)
  @inlinable
  @inline(__always)
  var minimumRefreshInterval: TimeInterval {
    1 / Double(maximumFramesPerSecond)
  }
  #endif

  #endif
}
