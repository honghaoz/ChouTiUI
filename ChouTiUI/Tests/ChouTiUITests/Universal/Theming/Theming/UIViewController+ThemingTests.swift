//
//  UIViewController+ThemingTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/12/24.
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

#if canImport(UIKit)

import UIKit

import ChouTiTest

import ChouTiUI

class UIViewController_ThemingTests: XCTestCase {

  func test_theme() {
    let currentTheme: Theme = UITraitCollection.current.userInterfaceStyle.theme ?? .light

    let viewController = UIViewController()
    expect(viewController.theme) == currentTheme
    expect(viewController.overrideTheme) == nil
    expect(viewController.view.theme) == currentTheme
    expect(viewController.view.overrideTheme) == nil

    viewController.overrideTheme = .dark
    expect(viewController.theme) == .dark
    expect(viewController.overrideTheme) == .dark
    expect(viewController.view.theme) == .dark
    expect(viewController.view.overrideTheme) == .dark

    viewController.overrideTheme = nil
    expect(viewController.theme) == currentTheme
    expect(viewController.overrideTheme) == nil
    expect(viewController.view.theme) == currentTheme
    expect(viewController.view.overrideTheme) == nil

    viewController.overrideTheme = .light
    expect(viewController.theme) == .light
    expect(viewController.overrideTheme) == .light
    expect(viewController.view.theme) == .light
    expect(viewController.view.overrideTheme) == .light

    viewController.overrideTheme = nil
    expect(viewController.theme) == currentTheme
    expect(viewController.overrideTheme) == nil
    expect(viewController.view.theme) == currentTheme
    expect(viewController.view.overrideTheme) == nil
  }

  func test_demoViewControllerIncorrectUserInterfaceStyle() {
    // This test is for demonstrating the `overrideUserInterfaceStyle` resetting doesn't reset the `traitCollection.userInterfaceStyle`

    let viewController = UIViewController()

    // on tvOS, it's .unspecified
    let currentUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
    expect(viewController.traitCollection.userInterfaceStyle) == currentUserInterfaceStyle

    viewController.overrideUserInterfaceStyle = .dark
    expect(viewController.traitCollection.userInterfaceStyle) == .dark
    expect(viewController.overrideUserInterfaceStyle) == .dark

    viewController.overrideUserInterfaceStyle = .unspecified
    expect(viewController.traitCollection.userInterfaceStyle) == .dark // still dark, which is incorrect
    expect(viewController.overrideUserInterfaceStyle) == .unspecified

    viewController.overrideUserInterfaceStyle = .light
    expect(viewController.traitCollection.userInterfaceStyle) == .light
    expect(viewController.overrideUserInterfaceStyle) == .light

    viewController.overrideUserInterfaceStyle = .unspecified
    expect(viewController.traitCollection.userInterfaceStyle) == .light // still light, which is incorrect
    expect(viewController.overrideUserInterfaceStyle) == .unspecified
  }
}
#endif
