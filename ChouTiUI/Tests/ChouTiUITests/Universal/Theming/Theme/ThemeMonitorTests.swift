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
    let currentTheme = ThemingTest.currentTheme

    #if canImport(AppKit)
    let themeMonitor = ThemeMonitor.shared
    expect(themeMonitor.theme) == currentTheme
    expect(themeMonitor.themeBinding.value) == currentTheme

    // ensure initial theme
    let application = NSApplication.shared
    application.overrideTheme = .dark
    expect(themeMonitor.theme) == .dark
    expect(themeMonitor.themeBinding.value).toEventually(beEqual(to: .dark))

    application.overrideTheme = .light
    expect(themeMonitor.theme) == .light
    expect(themeMonitor.themeBinding.value).toEventually(beEqual(to: .light))

    // reset
    application.overrideTheme = nil

    #elseif canImport(UIKit)

    let themeMonitor = ThemeMonitor.shared
    expect(themeMonitor.theme) == currentTheme
    expect(themeMonitor.themeBinding.value) == currentTheme

    themeMonitor.overrideTheme = .dark
    expect(themeMonitor.theme) == .dark
    expect(themeMonitor.themeBinding.value).toEventually(beEqual(to: .dark))

    themeMonitor.overrideTheme = .light
    expect(themeMonitor.theme) == .light
    expect(themeMonitor.themeBinding.value).toEventually(beEqual(to: .light))

    // reset
    themeMonitor.overrideTheme = nil
    #endif
  }

  /// Test the debounce behavior of the theme binding.
  func test_themeBinding_debounce() {
    let themeMonitor = ThemeMonitor()

    let overrideTheme: (Theme?) -> Void = { theme in
      #if canImport(AppKit)
      NSApplication.shared.overrideTheme = theme
      #elseif canImport(UIKit)
      themeMonitor.overrideTheme = theme
      #endif
    }

    overrideTheme(.dark)
    expect(themeMonitor.theme) == .dark
    expect(themeMonitor.themeBinding.value).toEventually(beEqual(to: .dark))

    var receivedThemes: [Theme] = []
    let observation = themeMonitor.themeBinding.observe { theme in
      receivedThemes.append(theme)
    }
    _ = observation

    overrideTheme(.light)
    expect(receivedThemes) == [] // no emission yet

    overrideTheme(.dark)
    expect(receivedThemes) == [] // no emission yet

    overrideTheme(.light)
    expect(receivedThemes) == [] // no emission yet

    expect(receivedThemes).toEventually(beEqual(to: [.light])) // should emit after debounce

    // reset
    overrideTheme(nil)
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
