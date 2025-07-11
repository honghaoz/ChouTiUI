//
//  NSMutableAttributedString+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 6/29/25.
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

class NSMutableAttributedString_ExtensionsTests: XCTestCase {

  // MARK: - Add Attributes

  func test_font() {
    let string = "0123"
    let attributedString = string.mutableAttributed().font(.systemFont(ofSize: 16))
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 16)
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 16)
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 16)
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 16)
  }

  func test_foregroundColor() {
    let string = "0123"
    let attributedString = string.mutableAttributed().foregroundColor(.red)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.foregroundColor] as? Color) == .red
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.foregroundColor] as? Color) == .red
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as? Color) == .red
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.foregroundColor] as? Color) == .red
  }

  func test_backgroundColor() {
    let string = "0123"
    let attributedString = string.mutableAttributed().backgroundColor(.red)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.backgroundColor] as? Color) == .red
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.backgroundColor] as? Color) == .red
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.backgroundColor] as? Color) == .red
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.backgroundColor] as? Color) == .red
  }

  func test_shadow() {
    let string = "0123"
    let shadow = NSShadow()
    shadow.shadowColor = Color.red
    shadow.shadowBlurRadius = 1
    shadow.shadowOffset = CGSize(width: 1, height: 1)
    let attributedString = string.mutableAttributed().shadow(shadow)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
  }

  func test_shadow_color_blurRadius_offset() {
    let string = "0123"
    let attributedString = string.mutableAttributed().shadow(color: .red, blurRadius: 1, offset: CGSize(width: 1, height: 1))
    let shadow = NSShadow()
    shadow.shadowColor = Color.red
    shadow.shadowBlurRadius = 1
    shadow.shadowOffset = CGSize(width: 1, height: 1)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
  }

  func test_themedForegroundColor() {
    let string = "0123"
    let color = ThemedColor(light: .red, dark: .blue)
    let attributedString = string.mutableAttributed().themedForegroundColor(color)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
  }

  func test_themedBackgroundColor() {
    let string = "0123"
    let color = ThemedColor(light: .red, dark: .blue)
    let attributedString = string.mutableAttributed().themedBackgroundColor(color)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.themedBackgroundColor] as? ThemedColor) == color
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.themedBackgroundColor] as? ThemedColor) == color
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.themedBackgroundColor] as? ThemedColor) == color
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.themedBackgroundColor] as? ThemedColor) == color
  }

  func test_themedShadow() {
    let string = "0123"
    let shadow = Themed<NSShadow>(light: NSShadow(), dark: NSShadow())
    let attributedString = string.mutableAttributed().themedShadow(shadow)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow
  }

  func test_paragraphStyle() {
    let string = "0123"
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    paragraphStyle.lineHeightMultiple = 1.5
    let attributedString = string.mutableAttributed().paragraphStyle(paragraphStyle)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle
  }

  func test_baselineOffset() {
    let string = "0123"
    let attributedString = string.mutableAttributed().baselineOffset(10)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 10
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 10
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 10
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 10
  }

  func test_underline() {
    let string = "0123"
    let attributedString = string.mutableAttributed().underline(color: .red, style: .single)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.underlineColor] as? Color) == .red
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.underlineColor] as? Color) == .red
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.underlineColor] as? Color) == .red
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.underlineColor] as? Color) == .red
  }

  func test_textEffect() {
    let string = "0123"
    let attributedString = string.mutableAttributed().textEffect(.letterpressStyle)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
  }

  func test_link() {
    // valid url
    do {
      let string = "0123"
      let attributedString = string.mutableAttributed().link("https://www.ibluebox.com")
      expect(attributedString.attributes(at: 0, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
      expect(attributedString.attributes(at: 1, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
      expect(attributedString.attributes(at: 2, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
      expect(attributedString.attributes(at: 3, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
    }

    // invalid url
    do {
      let string = "0123"

      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "link is not url: \"\""
      }
      let attributedString = string.mutableAttributed().link("")
      Assert.resetTestAssertionFailureHandler()

      expect(attributedString.attributes(at: 0, effectiveRange: nil)[.link] as? URL) == nil
      expect(attributedString.attributes(at: 1, effectiveRange: nil)[.link] as? URL) == nil
      expect(attributedString.attributes(at: 2, effectiveRange: nil)[.link] as? URL) == nil
      expect(attributedString.attributes(at: 3, effectiveRange: nil)[.link] as? URL) == nil
    }
  }

  // MARK: - Add Default Attributes

  func test_addDefaultFont() {
    let string = "0123".mutableAttributed()
    string.addAttribute(.font, value: Font.systemFont(ofSize: 12), range: NSRange(location: 0, length: 1))
    let attributedString = string.addDefaultFont(.systemFont(ofSize: 20))
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 12)
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 20)
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 20)
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 20)
  }

  func test_addDefaultForegroundColor() {
    let string = "0123".mutableAttributed()
    string.addAttribute(.foregroundColor, value: Color.red, range: NSRange(location: 0, length: 1))
    let attributedString = string.addDefaultForegroundColor(.blue)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.foregroundColor] as? Color) == .red
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.foregroundColor] as? Color) == .blue
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as? Color) == .blue
  }

  func test_addDefaultThemedForegroundColor() {
    let string = "0123".mutableAttributed()
    let color1 = ThemedColor(light: .red, dark: .blue)
    let color2 = ThemedColor(light: .green, dark: .yellow)
    string.addAttribute(.themedForegroundColor, value: color1, range: NSRange(location: 0, length: 1))
    let attributedString = string.addDefaultThemedForegroundColor(color2)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color1
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color2
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color2
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color2
  }

  func test_addDefaultShadow() {
    let string = "0123".mutableAttributed()
    let shadow1 = NSShadow()
    shadow1.shadowColor = Color.red
    shadow1.shadowBlurRadius = 1
    shadow1.shadowOffset = CGSize(width: 1, height: 1)
    let shadow2 = NSShadow()
    string.addAttribute(.shadow, value: shadow1, range: NSRange(location: 0, length: 1))
    let attributedString = string.addDefaultShadow(shadow2)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.shadow] as? NSShadow) == shadow1
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.shadow] as? NSShadow) == shadow2
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.shadow] as? NSShadow) == shadow2
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.shadow] as? NSShadow) == shadow2
  }

  func test_addDefaultThemedShadow() {
    let string = "0123".mutableAttributed()
    let shadow1 = Themed<NSShadow>(light: NSShadow(), dark: NSShadow())
    let shadow2 = Themed<NSShadow>(light: NSShadow(), dark: NSShadow())
    string.addAttribute(.themedShadow, value: shadow1, range: NSRange(location: 0, length: 1))
    let attributedString = string.addDefaultThemedShadow(shadow2)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow1
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow2
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow2
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow2
  }

  func test_addDefaultParagraphStyle() {
    let string = "0123".mutableAttributed()
    let paragraphStyle1 = NSMutableParagraphStyle()
    paragraphStyle1.alignment = .center
    paragraphStyle1.lineHeightMultiple = 1.5
    let paragraphStyle2 = NSMutableParagraphStyle()
    paragraphStyle2.alignment = .right
    paragraphStyle2.lineHeightMultiple = 2
    string.addAttribute(.paragraphStyle, value: paragraphStyle1, range: NSRange(location: 0, length: 1))
    let attributedString = string.addDefaultParagraphStyle(paragraphStyle2)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle1
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle2
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle2
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == paragraphStyle2
  }

  func test_addDefaultAttribute() {
    let string = "0123".mutableAttributed()
    string.addAttribute(.baselineOffset, value: 1, range: NSRange(location: 0, length: 1))
    let attributedString = string.addDefaultAttribute(.baselineOffset, value: 10)
    expect(attributedString.attributes(at: 0, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 1
    expect(attributedString.attributes(at: 1, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 10
    expect(attributedString.attributes(at: 2, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 10
    expect(attributedString.attributes(at: 3, effectiveRange: nil)[.baselineOffset] as? CGFloat) == 10
  }
}
