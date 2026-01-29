//
//  NSApplication+ThemingTests.swift
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

class NSApplication_ThemingTests: XCTestCase {

  func test_theme() {
    let application = NSApplication.shared
    let currentTheme = application.theme

    expect(NSView().theme) == currentTheme

    application.overrideTheme = .dark
    expect(application.theme) == .dark
    expect(application.overrideTheme) == .dark
    expect(NSView().theme) == .dark
    expect(NSView().overrideTheme) == nil
    expect(NSWindow().theme) == .dark
    expect(NSWindow().overrideTheme) == nil
    expect(NSPopover().theme) == .dark
    expect(NSPopover().overrideTheme) == nil
    expect(NSMenu().theme) == .dark
    expect(NSMenu().overrideTheme) == nil

    application.overrideTheme = nil
    expect(application.theme) == currentTheme
    expect(application.overrideTheme) == nil
    expect(NSView().theme) == currentTheme
    expect(NSView().overrideTheme) == nil
    expect(NSWindow().theme) == currentTheme
    expect(NSWindow().overrideTheme) == nil
    expect(NSPopover().theme) == currentTheme
    expect(NSPopover().overrideTheme) == nil
    expect(NSMenu().theme) == currentTheme
    expect(NSMenu().overrideTheme) == nil

    application.overrideTheme = .light
    expect(application.theme) == .light
    expect(application.overrideTheme) == .light
    expect(NSView().theme) == .light
    expect(NSView().overrideTheme) == nil
    expect(NSWindow().theme) == .light
    expect(NSWindow().overrideTheme) == nil
    expect(NSPopover().theme) == .light
    expect(NSPopover().overrideTheme) == nil
    expect(NSMenu().theme) == .light
    expect(NSMenu().overrideTheme) == nil

    application.overrideTheme = nil
    expect(application.theme) == currentTheme
    expect(application.overrideTheme) == nil
    expect(NSView().theme) == currentTheme
    expect(NSView().overrideTheme) == nil
    expect(NSWindow().theme) == currentTheme
    expect(NSWindow().overrideTheme) == nil
    expect(NSPopover().theme) == currentTheme
    expect(NSPopover().overrideTheme) == nil
    expect(NSMenu().theme) == currentTheme
    expect(NSMenu().overrideTheme) == nil
  }

  func test_theme_onBackgroundThread() {
    let expectation = XCTestExpectation(description: "theme")

    DispatchQueue.global().async {
      let application = NSApplication.shared
      application.overrideTheme = .dark
      expect(application.theme) == .dark
      expect(application.overrideTheme) == .dark
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }
}

#endif
