//
//  ThemeMonitorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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

import Combine

import ChouTiTest

import ChouTi
@testable import ChouTiUI

class ThemeMonitorTests: XCTestCase {

  func test_theme() {
    #if os(macOS)
    // ensure initial theme
    let application = NSApplication.shared
    application.overrideTheme = .dark
    wait(timeout: 0.05)

    let themeMonitor = ThemeMonitor.shared
    expect(themeMonitor.theme) == .dark
    expect(themeMonitor.themeBinding.value) == .dark

    application.overrideTheme = .light
    wait(timeout: 0.05)
    expect(themeMonitor.theme) == .light
    expect(themeMonitor.themeBinding.value) == .light

    expect(themeMonitor.accentColorBinding.value) == Color.controlAccentColor
    #endif
  }

  func test_accentColorBinding() {
    #if os(macOS)
    let themeMonitor = ThemeMonitor()
    expect(themeMonitor.accentColorBinding.value) == Color.controlAccentColor

    var bindingEmissionCount = 0
    var lastValue: Color?
    let observation = themeMonitor.accentColorBinding.observe { value in
      bindingEmissionCount += 1
      lastValue = value
    }
    _ = observation

    Foundation.DistributedNotificationCenter.default().postNotificationName(.accentColorDidChange, object: nil)
    wait(timeout: 0.05)
    expect(lastValue) == Color.controlAccentColor
    expect(bindingEmissionCount) == 1
    #endif
  }
}
