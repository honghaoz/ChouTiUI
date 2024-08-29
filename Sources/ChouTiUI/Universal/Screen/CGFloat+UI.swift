//
//  CGFloat+UI.swift
//
//  Created by Honghao Zhang on 10/18/21.
//  Copyright © 2024 ChouTi. All rights reserved.
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
