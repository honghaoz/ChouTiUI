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

import ChouTi
import ChouTiUI

class CALayer_ThemingTests: XCTestCase {

  func test_theme_standaloneLayer() {
    let layer = CALayer()
    expect(layer.theme) == .light
    expect(layer.overrideTheme) == nil

    let sublayer1 = CALayer()
    layer.addSublayer(sublayer1)
    expect(sublayer1.theme) == .light
    expect(sublayer1.overrideTheme) == nil

    layer.overrideTheme = .dark
    expect(layer.theme) == .dark
    expect(layer.overrideTheme) == .dark
    expect(sublayer1.theme) == .dark
    expect(sublayer1.overrideTheme) == nil

    // when add new sublayer, it should inherit current layer's theme
    let sublayer2 = CALayer()
    layer.addSublayer(sublayer2)
    expect(sublayer2.theme) == .dark
    expect(sublayer2.overrideTheme) == nil

    let sublayer3 = CALayer()
    sublayer3.overrideTheme = .light
    sublayer2.addSublayer(sublayer3)
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light

    layer.overrideTheme = nil
    expect(layer.theme) == .light
    expect(layer.overrideTheme) == nil
    expect(sublayer1.theme) == .light
    expect(sublayer1.overrideTheme) == nil
    expect(sublayer2.theme) == .light
    expect(sublayer2.overrideTheme) == nil
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light

    layer.overrideTheme = .light
    expect(layer.theme) == .light
    expect(layer.overrideTheme) == .light
    expect(sublayer1.theme) == .light
    expect(sublayer1.overrideTheme) == nil
    expect(sublayer2.theme) == .light
    expect(sublayer2.overrideTheme) == nil
    expect(sublayer3.theme) == .light
    expect(sublayer3.overrideTheme) == .light

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
    #if os(macOS)
    let currentTheme: Theme = NSApplication.shared.theme

    let view = View()
    view.wantsLayer = true

    expect(view.unsafeLayer.theme) == currentTheme
    expect(view.unsafeLayer.overrideTheme) == nil

    view.unsafeLayer.overrideTheme = .dark
    expect(view.theme) == .dark
    expect(view.unsafeLayer.theme) == .dark
    expect(view.unsafeLayer.overrideTheme) == .dark

    view.unsafeLayer.overrideTheme = nil
    expect(view.theme) == .dark // expect to restore to current theme, but it keeps last theme
    expect(view.unsafeLayer.theme) == .dark // expect to restore to current theme, but it keeps last theme
    expect(view.unsafeLayer.overrideTheme) == nil

    view.unsafeLayer.overrideTheme = .light
    expect(view.theme) == .light // expect to restore to current theme, but it keeps last theme
    expect(view.unsafeLayer.theme) == .light // expect to restore to current theme, but it keeps last theme
    expect(view.unsafeLayer.overrideTheme) == .light

    view.unsafeLayer.overrideTheme = nil
    expect(view.theme) == .light // expect to restore to current theme, but it keeps last theme
    expect(view.unsafeLayer.theme) == .light // expect to restore to current theme, but it keeps last theme
    expect(view.unsafeLayer.overrideTheme) == nil

    #else
    // let currentTheme: Theme = UITraitCollection.current.userInterfaceStyle.theme ?? .light
    // TODO: test for iOS
    #endif
  }

  func test_themeBinding_standaloneLayer() {
    let layer = CALayer()
    let themeBinding = layer.themeBinding

    expect(themeBinding.value) == .light

    let sublayer = CALayer()
    let sublayerThemeBinding = sublayer.themeBinding
    layer.addSublayer(sublayer)
    expect(sublayerThemeBinding.value) == .light

    layer.overrideTheme = .dark
    expect(themeBinding.value) == .dark

    let sublayer2 = CALayer()
    let sublayer2ThemeBinding = sublayer2.themeBinding
    layer.addSublayer(sublayer2)
    expect(sublayer2ThemeBinding.value) == .light // binding's value is not updated
    expect(sublayer2.themeBinding.value) == .dark // binding's value is updated

    layer.overrideTheme = nil
    expect(themeBinding.value) == .light
    expect(sublayerThemeBinding.value) == .light
    expect(sublayer2ThemeBinding.value) == .light

    let bindingObservationStorage = BindingObservationStorage()

    var receivedThemes: [Theme] = []
    themeBinding.observe { theme in
      receivedThemes.append(theme)
    }.store(in: bindingObservationStorage)

    var receivedThemes1: [Theme] = []
    sublayerThemeBinding.observe { theme in
      receivedThemes1.append(theme)
    }.store(in: bindingObservationStorage)

    var receivedThemes2: [Theme] = []
    sublayer2ThemeBinding.observe { theme in
      receivedThemes2.append(theme)
    }.store(in: bindingObservationStorage)

    layer.overrideTheme = .dark
    expect(themeBinding.value) == .dark
    expect(sublayerThemeBinding.value) == .dark
    expect(sublayer2ThemeBinding.value) == .dark

    expect(receivedThemes) == [.dark]
    expect(receivedThemes1) == [.dark]
    expect(receivedThemes2) == [.dark]

    layer.overrideTheme = nil
    expect(themeBinding.value) == .light
    expect(sublayerThemeBinding.value) == .light
    expect(sublayer2ThemeBinding.value) == .light

    expect(receivedThemes) == [.dark, .light]
    expect(receivedThemes1) == [.dark, .light]
    expect(receivedThemes2) == [.dark, .light]

    sublayer.overrideTheme = .dark
    expect(themeBinding.value) == .light
    expect(sublayerThemeBinding.value) == .dark
    expect(sublayer2ThemeBinding.value) == .light

    expect(receivedThemes) == [.dark, .light]
    expect(receivedThemes1) == [.dark, .light, .dark]
    expect(receivedThemes2) == [.dark, .light]

    sublayer.overrideTheme = .light
    expect(themeBinding.value) == .light
    expect(sublayerThemeBinding.value) == .light
    expect(sublayer2ThemeBinding.value) == .light

    expect(receivedThemes) == [.dark, .light]
    expect(receivedThemes1) == [.dark, .light, .dark, .light]
    expect(receivedThemes2) == [.dark, .light]

    sublayer.overrideTheme = nil
    expect(themeBinding.value) == .light
    expect(sublayerThemeBinding.value) == .light
    expect(sublayer2ThemeBinding.value) == .light

    expect(receivedThemes) == [.dark, .light]
    expect(receivedThemes1) == [.dark, .light, .dark, .light] // no duplicate
    expect(receivedThemes2) == [.dark, .light]
  }

  func test_themeBinding_layerBackedView() {
    #if os(macOS)
    let view = View()
    view.wantsLayer = true

    // set initial theme
    view.overrideTheme = .light
    wait(timeout: 0.05)
    expect(view.theme) == .light
    expect(view.themeBinding.value) == .light

    let bindingObservationStorage = BindingObservationStorage()

    var receivedThemes: [Theme] = []
    view.themeBinding.observe { theme in
      receivedThemes.append(theme)
    }.store(in: bindingObservationStorage)

    view.overrideTheme = .dark
    wait(timeout: 0.05)
    expect(view.theme) == .dark
    expect(view.themeBinding.value) == .dark
    expect(receivedThemes) == [.dark]

    let sublayer = CALayer()
    view.unsafeLayer.addSublayer(sublayer)
    expect(sublayer.themeBinding.value) == .dark

    var receivedThemes1: [Theme] = []
    sublayer.themeBinding.observe { theme in
      receivedThemes1.append(theme)
    }.store(in: bindingObservationStorage)

    view.overrideTheme = .light
    wait(timeout: 0.05)
    expect(view.theme) == .light
    expect(view.themeBinding.value) == .light
    expect(receivedThemes) == [.dark, .light]
    expect(receivedThemes1) == [.light]

    view.overrideTheme = nil
    wait(timeout: 0.05)
    expect(view.theme) == .light
    expect(view.themeBinding.value) == .light
    expect(receivedThemes) == [.dark, .light]
    expect(receivedThemes1) == [.light]
    #else
    // TODO: test for iOS
    #endif
  }
}
