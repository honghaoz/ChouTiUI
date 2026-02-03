//
//  View+ThemeUpdatingTests.swift
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
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest

import ChouTi
import ChouTiUI

class View_ThemeUpdatingTests: XCTestCase {

  func test_themeBinding_debounce() {
    let window = TestWindow()

    let view = View()
    window.contentView().addSubview(view)

    // ensure initial theme is light
    view.overrideTheme = .light
    wait(timeout: 0.05)
    expect(view.theme) == .light
    expect(view.themeBinding.value) == .light

    var receivedThemes: [Theme] = []
    let observation = view.themeBinding.observe { theme in
      receivedThemes.append(theme)
    }
    _ = observation

    view.overrideTheme = .dark
    expect(view.theme) == .dark
    expect(receivedThemes) == []

    view.overrideTheme = .light
    expect(view.theme) == .light
    expect(receivedThemes) == []

    view.overrideTheme = .dark
    expect(view.theme) == .dark
    expect(receivedThemes) == []

    // only [.dark] because of trailing debounce
    expect(receivedThemes).toEventually(beEqual(to: [.dark]))
  }

  /// Test that when view's override theme is set, the theme binding should emit the override theme.
  func test_themeBinding_overrideTheme() {
    let currentTheme = ThemingTest.currentTheme
    let initialTheme = currentTheme.opposite

    // given a view with an initial override theme
    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif
    view.overrideTheme = initialTheme

    // the view's theme and theme binding value should be the initial override theme
    expect(view.theme) == initialTheme
    expect(view.themeBinding.value) == initialTheme
  }

  func test_themeBinding_accessFromBackgroundThread() {
    let window = TestWindow()

    let view = View()
    window.contentView().addSubview(view)

    // test accessing from background thread
    let expectation = XCTestExpectation(description: "themeBinding")
    let backgroundQueue = DispatchQueue(label: "backgroundQueue")
    backgroundQueue.async {
      expect(view.theme) == window.theme
      expect(view.overrideTheme) == nil
      expect(view.themeBinding.value) == window.theme
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
}
