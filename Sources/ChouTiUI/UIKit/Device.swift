//
//  Device.swift
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(UIKit) && !os(visionOS)

import UIKit

public enum Device {

  /// Whether the current device is an iPad.
  public static var isIpad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

  /// Whether the current device is a simulator.
  public static let isSimulator: Bool = {
    #if targetEnvironment(simulator)
    return true
    #else
    return false
    #endif

    // Alternative approach:
    // https://stackoverflow.com/questions/24869481/how-to-detect-if-app-is-being-built-for-device-or-simulator-in-swift
    // static var isSimulator: Bool { TARGET_OS_SIMULATOR != 0 }

    // Ref: http://stackoverflow.com/a/30284266/3164091
  }()
}

#endif
