//
//  NSWindow+ThemingTests.swift
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

class NSWindow_ThemingTests: XCTestCase {

  func test_theme() {
    let window = NSWindow()
    let currentTheme = window.theme

    window.overrideTheme = .dark
    expect(window.theme) == .dark
    expect(window.overrideTheme) == .dark

    window.overrideTheme = nil
    expect(window.theme) == currentTheme
    expect(window.overrideTheme) == nil

    window.overrideTheme = .light
    expect(window.theme) == .light
    expect(window.overrideTheme) == .light

    window.overrideTheme = nil
    expect(window.theme) == currentTheme
    expect(window.overrideTheme) == nil
  }

  func test_viewOnWindow() {
    let window = NSWindow()
    let view = NSView()
    window.contentView = view

    let currentWindowTheme = window.theme
    let currentViewTheme = view.theme

    // override window theme, should affect view theme
    do {
      window.overrideTheme = .dark
      expect(window.theme) == .dark
      expect(window.overrideTheme) == .dark
      expect(view.theme) == .dark
      expect(view.overrideTheme) == nil

      window.overrideTheme = nil
      expect(window.theme) == currentWindowTheme
      expect(window.overrideTheme) == nil
      expect(view.theme) == currentViewTheme
      expect(view.overrideTheme) == nil

      window.overrideTheme = .light
      expect(window.theme) == .light
      expect(window.overrideTheme) == .light
      expect(view.theme) == .light
      expect(view.overrideTheme) == nil

      window.overrideTheme = nil
      expect(window.theme) == currentWindowTheme
      expect(window.overrideTheme) == nil
      expect(view.theme) == currentViewTheme
      expect(view.overrideTheme) == nil
    }

    // override view theme, should not affect window theme
    do {
      view.overrideTheme = .light
      expect(view.theme) == .light
      expect(view.overrideTheme) == .light
      expect(window.theme) == currentWindowTheme
      expect(window.overrideTheme) == nil

      view.overrideTheme = nil
      expect(view.theme) == currentViewTheme
      expect(view.overrideTheme) == nil
      expect(window.theme) == currentWindowTheme
      expect(window.overrideTheme) == nil

      view.overrideTheme = .dark
      expect(view.theme) == .dark
      expect(view.overrideTheme) == .dark
      expect(window.theme) == currentWindowTheme
      expect(window.overrideTheme) == nil

      view.overrideTheme = nil
      expect(view.theme) == currentViewTheme
      expect(view.overrideTheme) == nil
      expect(window.theme) == currentWindowTheme
      expect(window.overrideTheme) == nil
    }
  }
}

#endif
