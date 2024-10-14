//
//  NSWindow+ThemeUpdatingTests.swift
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

import ChouTiUI

class NSWindow_ThemeUpdatingTests: XCTestCase {

  func test_themeBinding_debounce() {
    let window = NSWindow()
    let view = NSView()
    window.contentView = view

    // ensure initial theme is light
    window.overrideTheme = .light
    wait(timeout: 0.05)
    expect(window.theme) == .light
    expect(window.themeBinding.value) == .light
    expect(view.theme) == .light
    expect(view.themeBinding.value) == .light

    // test observing
    let windowThemeExpectation = XCTestExpectation(description: "window theme binding")
    var receivedWindowThemes: [Theme] = []
    let windowThemeObservation = window.themeBinding.observe { theme in
      receivedWindowThemes.append(theme)
      if receivedWindowThemes.count == 1 {
        windowThemeExpectation.fulfill()
      }
    }
    _ = windowThemeObservation

    let viewThemeExpectation = XCTestExpectation(description: "view theme binding")
    var receivedViewThemes: [Theme] = []
    let viewThemeObservation = view.themeBinding.observe { theme in
      receivedViewThemes.append(theme)
      if receivedViewThemes.count == 1 {
        viewThemeExpectation.fulfill()
      }
    }
    _ = viewThemeObservation

    window.overrideTheme = .dark
    expect(window.theme) == .dark
    expect(view.theme) == .dark

    window.overrideTheme = .light
    expect(window.theme) == .light
    expect(view.theme) == .light

    window.overrideTheme = .dark
    expect(window.theme) == .dark
    expect(view.theme) == .dark

    wait(for: [windowThemeExpectation, viewThemeExpectation], timeout: 1)

    // only [.dark] because of trailing debounce
    expect(receivedWindowThemes) == [.dark]
    expect(receivedViewThemes) == [.dark]
  }
}

#endif
