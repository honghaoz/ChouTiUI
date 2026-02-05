//
//  CALayer+ThemingTests.swift
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

import QuartzCore

import ChouTiTest

import ChouTiUI

class CALayer_ThemingTests: XCTestCase {

  func test_theme_standaloneLayer() {
    let layer = CALayer()
    expect(layer.theme) == .light // initial theme is light
    expect(layer.overrideTheme) == nil

    let sublayer1 = CALayer()
    layer.addSublayer(sublayer1)
    expect(sublayer1.theme) == .light // sublayer1 should inherit layer's theme
    expect(sublayer1.overrideTheme) == nil

    layer.overrideTheme = .dark // set layer's override theme to dark
    expect(layer.theme) == .dark
    expect(layer.overrideTheme) == .dark
    expect(sublayer1.theme) == .dark // sublayer1 should inherit layer's override theme
    expect(sublayer1.overrideTheme) == nil

    // when add new sublayer, it should inherit current layer's theme
    let sublayer2 = CALayer()
    layer.addSublayer(sublayer2)
    expect(sublayer2.theme) == .dark // sublayer2 should inherit layer's theme
    expect(sublayer2.overrideTheme) == nil

    let sublayer3 = CALayer()
    sublayer3.overrideTheme = .light
    sublayer2.addSublayer(sublayer3)
    expect(sublayer3.theme) == .light // sublayer3 should NOT inherit sublayer2's theme as it has an explicit override theme
    expect(sublayer3.overrideTheme) == .light

    // clear root layer's override theme, sublayers should revert to light theme
    layer.overrideTheme = nil
    expect(layer.theme) == .light
    expect(layer.overrideTheme) == nil
    expect(sublayer1.theme) == .light
    expect(sublayer1.overrideTheme) == nil
    expect(sublayer2.theme) == .light
    expect(sublayer2.overrideTheme) == nil
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light

    // set root layer's override theme to light, sublayers should inherit it
    layer.overrideTheme = .light
    expect(layer.theme) == .light
    expect(layer.overrideTheme) == .light
    expect(sublayer1.theme) == .light
    expect(sublayer1.overrideTheme) == nil
    expect(sublayer2.theme) == .light
    expect(sublayer2.overrideTheme) == nil
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light

    // clear root layer's override theme from light, sublayers should revert to light theme
    layer.overrideTheme = nil
    expect(layer.theme) == .light
    expect(layer.overrideTheme) == nil
    expect(sublayer1.theme) == .light
    expect(sublayer1.overrideTheme) == nil
    expect(sublayer2.theme) == .light
    expect(sublayer2.overrideTheme) == nil
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light

    // set root layer's override theme to dark, sublayers should inherit it
    layer.overrideTheme = .dark
    expect(layer.theme) == .dark
    expect(layer.overrideTheme) == .dark
    expect(sublayer1.theme) == .dark
    expect(sublayer1.overrideTheme) == nil
    expect(sublayer2.theme) == .dark
    expect(sublayer2.overrideTheme) == nil
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light

    // clear root layer's override theme from dark, sublayers should revert to light theme
    layer.overrideTheme = nil
    expect(layer.theme) == .light
    expect(layer.overrideTheme) == nil
    expect(sublayer1.theme) == .light
    expect(sublayer1.overrideTheme) == nil
    expect(sublayer2.theme) == .light
    expect(sublayer2.overrideTheme) == nil
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light
  }

  func test_theme_layerBackedView() {
    let currentTheme = ThemingTest.currentTheme

    // given a view in a window hierarchy
    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif

    let window = TestWindow()
    window.contentView().addSubview(view)

    // then view's theme should be the same as the current system theme
    expect(view.theme) == currentTheme
    expect(view.unsafeLayer.theme) == currentTheme
    expect(view.unsafeLayer.overrideTheme) == nil

    // when set the layer's override theme to dark, the view's theme should be dark
    view.unsafeLayer.overrideTheme = .dark
    expect(view.theme) == .dark
    expect(view.unsafeLayer.theme) == .dark
    expect(view.unsafeLayer.overrideTheme) == .dark

    // when clear the layer's override theme from dark, the view's theme should revert to the current system theme
    view.unsafeLayer.overrideTheme = nil
    expect(view.theme) == currentTheme
    expect(view.unsafeLayer.theme) == currentTheme
    expect(view.unsafeLayer.overrideTheme) == nil

    // when set the layer's override theme to light, the view's theme should be light
    view.unsafeLayer.overrideTheme = .light
    expect(view.theme) == .light
    expect(view.unsafeLayer.theme) == .light
    expect(view.unsafeLayer.overrideTheme) == .light

    // when clear the layer's override theme from light, the view's theme should revert to the current system theme
    view.unsafeLayer.overrideTheme = nil
    expect(view.theme) == currentTheme
    expect(view.unsafeLayer.theme) == currentTheme
    expect(view.unsafeLayer.overrideTheme) == nil
  }
}
