//
//  NSApplication+ThemeUpdatingTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/13/24.
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

import ChouTiTest

import ChouTi
import ChouTiUI

class NSApplication_ThemeUpdatingTests: XCTestCase {

  func test_effectiveAppearanceBinding() {
    let application = NSApplication.shared

    expect(application.effectiveAppearanceBinding.value) == application.effectiveAppearance
    expect(application.effectiveAppearanceBinding) === application.effectiveAppearanceBinding
  }

  func test_themeBinding_debounce() {
    let application = NSApplication.shared
    let currentTheme = application.theme

    expect(application.theme) == currentTheme
    expect(application.themeBinding.value) == currentTheme

    // test observing
    let expectation = XCTestExpectation(description: "themeBinding")
    var receivedThemes: [Theme] = []
    let observation = application.themeBinding.observe { theme in
      receivedThemes.append(theme)
      if receivedThemes.count == 1 {
        expectation.fulfill()
      }
    }
    _ = observation

    application.overrideTheme = .dark
    expect(application.theme) == .dark

    application.overrideTheme = .light
    expect(application.theme) == .light

    application.overrideTheme = .dark
    expect(application.theme) == .dark

    application.overrideTheme = .light
    expect(application.theme) == .light

    wait(for: [expectation], timeout: 1)

    // only [.light] because of trailing debounce
    expect(receivedThemes) == [.light]
  }

  func test_themeBinding_noDebounce() {
    let application = NSApplication.shared

    // test observing
    let expectation = XCTestExpectation(description: "themeBinding")
    var receivedThemes: [Theme] = []
    let observation = application.themeBinding.observe { theme in
      receivedThemes.append(theme)
      if receivedThemes.count == 3 {
        expectation.fulfill()
      }
    }
    _ = observation

    application.overrideTheme = .dark

    delay(0.05, leeway: .zero) {
      application.overrideTheme = .light
    }
    .then(delay: 0.05, leeway: .zero) {
      application.overrideTheme = .light // duplicated
    }
    .then(delay: 0.05, leeway: .zero) {
      application.overrideTheme = .dark
    }

    wait(for: [expectation], timeout: 1)

    expect(receivedThemes) == [.dark, .light, .dark]
  }
}

#endif
