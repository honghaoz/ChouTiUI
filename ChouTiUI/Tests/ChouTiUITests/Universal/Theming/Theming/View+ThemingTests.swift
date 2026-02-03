//
//  View+ThemingTests.swift
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest

import ChouTiUI

class View_ThemingTests: XCTestCase {

  func test_theme_standaloneView() {
    let view = View()

    expect(view.theme) == currentTheme
    expect(view.overrideTheme) == nil

    view.overrideTheme = .dark
    expect(view.theme) == .dark
    expect(view.overrideTheme) == .dark

    view.overrideTheme = nil
    #if os(macOS)
    expect(view.theme) == .dark // expected to be currentTheme, but it returns the last override theme
    #else
    expect(view.theme) == currentTheme
    #endif
    expect(view.overrideTheme) == nil

    view.overrideTheme = .light
    expect(view.theme) == .light
    expect(view.overrideTheme) == .light

    view.overrideTheme = nil
    #if os(macOS)
    expect(view.theme) == .light // expected to be currentTheme, but it returns the last override theme
    #else
    expect(view.theme) == currentTheme
    #endif
    expect(view.overrideTheme) == nil
  }

  func test_theme_viewInWindow() {
    let window = TestWindow()
    let view = View()
    window.contentView().addSubview(view)

    expect(view.theme) == currentTheme
    expect(view.overrideTheme) == nil

    view.overrideTheme = .dark
    expect(view.theme) == .dark
    expect(view.overrideTheme) == .dark

    view.overrideTheme = nil
    expect(view.theme) == currentTheme
    expect(view.overrideTheme) == nil

    view.overrideTheme = .light
    expect(view.theme) == .light
    expect(view.overrideTheme) == .light

    view.overrideTheme = nil
    expect(view.theme) == currentTheme
    expect(view.overrideTheme) == nil
  }

  /// Test that view in view hierarchy should follow the parent view's theme.
  func test_theme_viewInViewHierarchy() {
    let currentTheme = currentTheme

    // given a container view in a window
    let window = TestWindow()
    let containerView = View()
    window.contentView().addSubview(containerView)
    expect(containerView.theme) == currentTheme
    expect(containerView.overrideTheme) == nil

    // given a child view in the container view
    let childView1 = View()
    containerView.addSubview(childView1)

    // then the child view's theme should be the same as the container view's theme
    expect(childView1.theme) == currentTheme
    expect(childView1.overrideTheme) == nil

    containerView.overrideTheme = .dark
    expectTheme(of: childView1, toBe: .dark)
    expect(childView1.overrideTheme) == nil

    containerView.overrideTheme = nil
    expectTheme(of: childView1, toBe: currentTheme)
    expect(childView1.theme) == currentTheme
    expect(childView1.overrideTheme) == nil

    containerView.overrideTheme = .light
    expectTheme(of: childView1, toBe: .light)
    expect(childView1.overrideTheme) == nil

    containerView.overrideTheme = nil
    expectTheme(of: childView1, toBe: currentTheme)
    expect(childView1.theme) == currentTheme
    expect(childView1.overrideTheme) == nil

    // when set the container view's override theme to the opposite of the current theme
    containerView.overrideTheme = currentTheme.opposite
    expect(containerView.theme) == currentTheme.opposite
    expect(containerView.overrideTheme) == currentTheme.opposite

    // given a new child view
    let childView2 = View()

    // when it is a standalone view, it should follow the current theme
    expect(childView2.theme) == currentTheme
    expect(childView2.overrideTheme) == nil

    // when it is added to the container view, it should follow the container view's theme
    containerView.addSubview(childView2)
    expectTheme(of: childView2, toBe: currentTheme.opposite)
    expect(childView2.overrideTheme) == nil

    // when the child view is removed from the container view, it should keep the same theme as before
    childView2.removeFromSuperview()
    expectTheme(of: childView2, toBe: currentTheme.opposite)
    expect(childView2.overrideTheme) == nil

    // given a new nested child view
    let childView3 = View()
    let childView4 = View()
    childView3.addSubview(childView4)

    // when it is a standalone view, it should follow the current theme
    expect(childView3.theme) == currentTheme
    expect(childView3.overrideTheme) == nil
    expect(childView4.theme) == currentTheme
    expect(childView4.overrideTheme) == nil

    // when they are added to the container view, they should follow the container view's theme
    containerView.addSubview(childView3)
    expectTheme(of: childView3, toBe: currentTheme.opposite)
    expect(childView3.overrideTheme) == nil
    expectTheme(of: childView4, toBe: currentTheme.opposite)
    expect(childView4.overrideTheme) == nil
  }

  // MARK: - Edge Cases

  func test_theme_onBackgroundThread() {
    let currentTheme = currentTheme

    let expectation = XCTestExpectation(description: "theme")

    let view = View()

    DispatchQueue.global().async {
      expect(view.theme) == currentTheme
      expect(view.overrideTheme) == nil

      view.overrideTheme = .dark
      expect(view.theme) == .dark
      expect(view.overrideTheme) == .dark

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
  }

  // MARK: - Helper

  /// Get the current theme, this is based on the current system theme.
  private var currentTheme: Theme {
    #if os(macOS)
    return NSApplication.shared.theme // current macOS system theme
    #else
    return UITraitCollection.current.userInterfaceStyle.theme // current iOS/tvOS/visionOS system theme
    #endif
  }

  /// Expect the theme of a view to be the given theme.
  private func expectTheme(of view: View, toBe expectedTheme: Theme, line: UInt = #line) {
    #if os(macOS)
    expect(view.theme, line: line) == expectedTheme // macOS theme update happens immediately
    #else
    expect(view.theme, line: line).toEventually(beEqual(to: expectedTheme)) // UIKit theme update happens on next runloop
    #endif
  }
}
