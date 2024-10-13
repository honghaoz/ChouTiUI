//
//  NSPopover+ThemingTests.swift
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

class NSPopover_ThemingTests: XCTestCase {

  func test_theme() {
    let popover = NSPopover()
    let currentTheme = NSApplication.shared.theme

    expect(popover.theme) == currentTheme
    expect(popover.overrideTheme) == nil

    popover.overrideTheme = .dark
    expect(popover.theme) == .dark
    expect(popover.overrideTheme) == .dark

    popover.overrideTheme = nil
    expect(popover.theme) == currentTheme
    expect(popover.overrideTheme) == nil

    popover.overrideTheme = .light
    expect(popover.theme) == .light
    expect(popover.overrideTheme) == .light

    popover.overrideTheme = nil
    expect(popover.theme) == currentTheme
    expect(popover.overrideTheme) == nil
  }

  func test_contentViewController() {
    let currentTheme = NSApplication.shared.theme

    let popover = NSPopover()
    let viewController = NSViewController()
    popover.contentViewController = viewController

    expect(popover.theme) == currentTheme
    expect(popover.overrideTheme) == nil
    expect(viewController.view.theme) == currentTheme
    expect(viewController.view.overrideTheme) == nil

    // override popover theme, should affect view controller theme
    do {
      popover.overrideTheme = .dark
      expect(popover.theme) == .dark
      expect(popover.overrideTheme) == .dark
      expect(viewController.view.theme) == .dark
      expect(viewController.view.overrideTheme) == .dark

      popover.overrideTheme = nil
      expect(popover.theme) == currentTheme
      expect(popover.overrideTheme) == nil
      expect(viewController.view.theme) == .dark // expected to be currentViewControllerTheme, but it returns the last override theme
      expect(viewController.view.overrideTheme) == nil

      popover.overrideTheme = .light
      expect(popover.theme) == .light
      expect(popover.overrideTheme) == .light
      expect(viewController.view.theme) == .light
      expect(viewController.view.overrideTheme) == .light

      popover.overrideTheme = nil
      expect(popover.theme) == currentTheme
      expect(popover.overrideTheme) == nil
      expect(viewController.view.theme) == .light // expected to be currentViewControllerTheme, but it returns the last override theme
      expect(viewController.view.overrideTheme) == nil
    }

    // override view controller theme, should not affect popover theme
    do {
      viewController.view.overrideTheme = .light
      expect(viewController.view.theme) == .light
      expect(viewController.view.overrideTheme) == .light
      expect(popover.theme) == currentTheme
      expect(popover.overrideTheme) == nil

      viewController.view.overrideTheme = nil
      expect(viewController.view.theme) == .light // follows the last override theme
      expect(viewController.view.overrideTheme) == nil
      expect(popover.theme) == currentTheme
      expect(popover.overrideTheme) == nil

      viewController.view.overrideTheme = .dark
      expect(viewController.view.theme) == .dark
      expect(viewController.view.overrideTheme) == .dark
      expect(popover.theme) == currentTheme
      expect(popover.overrideTheme) == nil

      viewController.view.overrideTheme = nil
      expect(viewController.view.theme) == .dark // follows the last override theme
      expect(viewController.view.overrideTheme) == nil
      expect(popover.theme) == currentTheme
      expect(popover.overrideTheme) == nil
    }
  }
}

#endif
