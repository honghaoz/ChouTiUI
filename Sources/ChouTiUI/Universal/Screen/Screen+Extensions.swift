//
//  Screen+Extensions.swift
//
//  Created by Honghao Zhang on 1/30/22.
//  Copyright © 2024 ChouTi. All rights reserved.
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
