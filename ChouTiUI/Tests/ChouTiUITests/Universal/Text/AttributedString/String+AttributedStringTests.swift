//
//  String+AttributedStringTests.swift
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

class String_AttributedStringTests: XCTestCase {

  func test_font() {
    let string = "0123".font(.systemFont(ofSize: 12))
    expect(string.attributes(at: 0, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 12)
    expect(string.attributes(at: 1, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 12)
    expect(string.attributes(at: 2, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 12)
    expect(string.attributes(at: 3, effectiveRange: nil)[.font] as? Font) == .systemFont(ofSize: 12)
  }

  func test_foregroundColor() {
    let string = "0123".foregroundColor(.red)
    expect(string.attributes(at: 0, effectiveRange: nil)[.foregroundColor] as? Color) == .red
    expect(string.attributes(at: 1, effectiveRange: nil)[.foregroundColor] as? Color) == .red
    expect(string.attributes(at: 2, effectiveRange: nil)[.foregroundColor] as? Color) == .red
    expect(string.attributes(at: 3, effectiveRange: nil)[.foregroundColor] as? Color) == .red
  }

  func test_backgroundColor() {
    let string = "0123".backgroundColor(.red)
    expect(string.attributes(at: 0, effectiveRange: nil)[.backgroundColor] as? Color) == .red
    expect(string.attributes(at: 1, effectiveRange: nil)[.backgroundColor] as? Color) == .red
    expect(string.attributes(at: 2, effectiveRange: nil)[.backgroundColor] as? Color) == .red
    expect(string.attributes(at: 3, effectiveRange: nil)[.backgroundColor] as? Color) == .red
  }

  func test_shadow() {
    let shadow = NSShadow()
    shadow.shadowColor = Color.red
    shadow.shadowBlurRadius = 1
    shadow.shadowOffset = CGSize(width: 1, height: 1)
    let string = "0123".shadow(shadow)
    expect(string.attributes(at: 0, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(string.attributes(at: 1, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(string.attributes(at: 2, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(string.attributes(at: 3, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
  }

  func test_shadow_color_blurRadius_offset() {
    let string = "0123".shadow(color: .red, blurRadius: 1, offset: CGSize(width: 1, height: 1))
    let shadow = NSShadow()
    shadow.shadowColor = Color.red
    shadow.shadowBlurRadius = 1
    shadow.shadowOffset = CGSize(width: 1, height: 1)
    expect(string.attributes(at: 0, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(string.attributes(at: 1, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(string.attributes(at: 2, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
    expect(string.attributes(at: 3, effectiveRange: nil)[.shadow] as? NSShadow) == shadow
  }

  func test_themedForegroundColor() {
    let color = ThemedColor(light: .red, dark: .blue)
    let string = "0123".themedForegroundColor(color)
    expect(string.attributes(at: 0, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
    expect(string.attributes(at: 1, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
    expect(string.attributes(at: 2, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
    expect(string.attributes(at: 3, effectiveRange: nil)[.themedForegroundColor] as? ThemedColor) == color
  }

  func test_themedBackgroundColor() {
    let color = ThemedColor(light: .red, dark: .blue)
    let string = "0123".themedBackgroundColor(color)
    expect(string.attributes(at: 0, effectiveRange: nil)[.themedBackgroundColor] as? ThemedColor) == color
    expect(string.attributes(at: 1, effectiveRange: nil)[.themedBackgroundColor] as? ThemedColor) == color
    expect(string.attributes(at: 2, effectiveRange: nil)[.themedBackgroundColor] as? ThemedColor) == color
  }

  func test_themedShadow() {
    let shadow = Themed<NSShadow>(light: NSShadow(), dark: NSShadow())
    let string = "0123".themedShadow(shadow)
    expect(string.attributes(at: 0, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow
    expect(string.attributes(at: 1, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow
    expect(string.attributes(at: 2, effectiveRange: nil)[.themedShadow] as? Themed<NSShadow>) == shadow
  }

  func test_paragraphStyle() {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    let string = "0123".paragraphStyle(style)
    expect(string.attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == style
    expect(string.attributes(at: 1, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == style
    expect(string.attributes(at: 2, effectiveRange: nil)[.paragraphStyle] as? NSParagraphStyle) == style
  }

  func test_underline() {
    let string = "0123".underline(color: .red, style: .single)
    expect(string.attributes(at: 0, effectiveRange: nil)[.underlineColor] as? Color) == .red
    expect(string.attributes(at: 1, effectiveRange: nil)[.underlineColor] as? Color) == .red
    expect(string.attributes(at: 2, effectiveRange: nil)[.underlineColor] as? Color) == .red
    expect(string.attributes(at: 3, effectiveRange: nil)[.underlineColor] as? Color) == .red
  }

  func test_textEffect() {
    let string = "0123".textEffect(.letterpressStyle)
    expect(string.attributes(at: 0, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
    expect(string.attributes(at: 1, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
    expect(string.attributes(at: 2, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
    expect(string.attributes(at: 3, effectiveRange: nil)[.textEffect] as? NSAttributedString.TextEffectStyle) == .letterpressStyle
  }

  func test_link() {
    let string = "0123".link("https://www.ibluebox.com")
    expect(string.attributes(at: 0, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
    expect(string.attributes(at: 1, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
    expect(string.attributes(at: 2, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
    expect(string.attributes(at: 3, effectiveRange: nil)[.link] as? URL) == URL(string: "https://www.ibluebox.com")
  }
}
