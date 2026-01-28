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
    if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
      expect(view.themeBinding.value) == .light
    }

    // test observing
    let expectation = XCTestExpectation(description: "themeBinding")
    var receivedThemes: [Theme] = []

    var observation: (any BindingObservation)!
    if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
      observation = view.themeBinding.observe { theme in
        receivedThemes.append(theme)
        if receivedThemes.count == 1 {
          expectation.fulfill()
        }
      }
    }
    _ = observation

    view.overrideTheme = .dark
    expect(view.theme) == .dark

    view.overrideTheme = .light
    expect(view.theme) == .light

    view.overrideTheme = .dark
    expect(view.theme) == .dark

    wait(for: [expectation], timeout: 1)

    // only [.dark] because of trailing debounce
    expect(receivedThemes) == [.dark]
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
      if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
        expect(view.themeBinding.value) == window.theme
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
}
