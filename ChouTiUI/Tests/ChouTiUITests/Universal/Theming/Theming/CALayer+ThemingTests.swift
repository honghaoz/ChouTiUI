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
    // get current theme, this is based on the current system theme
    #if os(macOS)
    let currentTheme: Theme = NSApplication.shared.theme // current macOS system theme
    #else
    let currentTheme: Theme = UITraitCollection.current.userInterfaceStyle.theme // current iOS/tvOS/visionOS system theme
    #endif

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
    // get current theme, this is based on the current system theme
    #if os(macOS)
    let currentTheme: Theme = NSApplication.shared.theme // current macOS system theme
    #else
    let currentTheme: Theme = UITraitCollection.current.userInterfaceStyle.theme // current iOS/tvOS/visionOS system theme
    #endif

    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif

    let window = TestWindow()
    window.contentView().addSubview(view)

    // verify the initial theme values are correct
    expect(view.theme) == currentTheme
    expect(view.themeBinding.value) == currentTheme

    let initialTheme = currentTheme.opposite

    // set initial override theme to initial theme (opposite of current theme)
    view.overrideTheme = initialTheme
    wait(timeout: 0.05)

    // then view's theme should be initial theme
    expect(view.theme) == initialTheme
    expect(view.themeBinding.value) == initialTheme

    let bindingObservationStorage = BindingObservationStorage()

    // observe view's theme updates
    var viewThemeBindingThemes: [Theme] = []
    view.themeBinding.observe { theme in
      viewThemeBindingThemes.append(theme)
    }.store(in: bindingObservationStorage)

    // when change the view's override theme
    view.overrideTheme = initialTheme.opposite
    wait(timeout: 0.05)
    expect(view.theme) == initialTheme.opposite
    expect(view.themeBinding.value) == initialTheme.opposite

    // then binding should emit value as theme is changed
    expect(viewThemeBindingThemes) == [initialTheme.opposite]

    // add a sublayer to the view
    let sublayer = CALayer()
    view.unsafeLayer.addSublayer(sublayer)
    expect(sublayer.theme) == initialTheme.opposite
    expect(sublayer.themeBinding.value) == initialTheme.opposite

    var sublayerThemeBindingThemes: [Theme] = []
    sublayer.themeBinding.observe { theme in
      sublayerThemeBindingThemes.append(theme)
    }.store(in: bindingObservationStorage)

    // when change the view's override theme again
    view.overrideTheme = initialTheme
    wait(timeout: 0.05)
    expect(view.theme) == initialTheme
    expect(view.themeBinding.value) == initialTheme
    expect(viewThemeBindingThemes) == [initialTheme.opposite, initialTheme]
    expect(sublayerThemeBindingThemes) == [initialTheme]

    // when clear the view's override theme, should revert to current system theme
    view.overrideTheme = nil
    wait(timeout: 0.05)
    expect(view.theme) == currentTheme
    expect(view.themeBinding.value) == currentTheme
    expect(viewThemeBindingThemes) == [initialTheme.opposite, initialTheme, currentTheme]
    expect(sublayerThemeBindingThemes) == [initialTheme, currentTheme]
  }
}

private extension Theme {

  /// Returns the opposite theme.
  var opposite: Theme {
    switch self {
    case .light:
      return .dark
    case .dark:
      return .light
    }
  }
}
