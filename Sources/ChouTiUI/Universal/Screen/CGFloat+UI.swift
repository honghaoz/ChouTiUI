//
//  CGFloat+UI.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/21.
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

import CoreGraphics

import ChouTi

public extension CGFloat {

  /// The pixel size based on the main screen scale.
  static var pixel: CGFloat {
    1 / Screen.mainScreenScale
  }

  /// The pixel size absolute tolerance for comparing point/size/rect.
  ///
  /// Example:
  /// ```
  /// frame.isApproximatelyEqual(to: hostView.frame, absoluteTolerance: .pixelTolerance)
  /// ```
  static var pixelTolerance: CGFloat {
    pixel + 1e-12
  }

  /// The point size.
  static let point: CGFloat = 1

  /// The half point size based on the main screen scale.
  static var halfPoint: CGFloat {
    #if os(visionOS)
    return 1 / Sizing.visionOS.scaleFactor
    #else
    return Screen.mainScreen().assert("Screen.mainScreen() is nil")?.halfPoint ?? 0.5
    #endif
  }
}
