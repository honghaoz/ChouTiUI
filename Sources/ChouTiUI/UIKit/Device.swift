//
//  Device.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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

  /// Whether the current device has rounded display corners. Like iPhone X and later.
  public static var hasRoundedDisplayCorners: Bool {
    UIScreen.main.displayCornerRadius > 0
  }
}

#endif
