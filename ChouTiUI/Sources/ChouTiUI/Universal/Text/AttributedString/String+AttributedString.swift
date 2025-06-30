//
//  String+AttributedString.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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

import ChouTi

public extension String {

  /// Returns a mutable attributed string with the font set.
  ///
  /// - Parameter font: The font to set.
  /// - Returns: A mutable attributed string with the font set.
  func font(_ font: Font) -> NSMutableAttributedString {
    mutableAttributed().font(font)
  }

  /// Returns a mutable attributed string with the foreground color set.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: A mutable attributed string with the foreground color set.
  func foregroundColor(_ color: Color) -> NSMutableAttributedString {
    mutableAttributed().foregroundColor(color)
  }

  /// Returns a mutable attributed string with the background color set.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: A mutable attributed string with the background color set.
  func backgroundColor(_ color: Color) -> NSMutableAttributedString {
    mutableAttributed().backgroundColor(color)
  }

  /// Returns a mutable attributed string with the shadow set.
  ///
  /// - Parameter shadow: The shadow to set.
  /// - Returns: A mutable attributed string with the shadow set.
  func shadow(_ shadow: NSShadow) -> NSMutableAttributedString {
    mutableAttributed().shadow(shadow)
  }

  /// Returns a mutable attributed string with the shadow set.
  ///
  /// - Parameter color: The color to set.
  /// - Parameter blurRadius: The blur radius to set.
  /// - Parameter offset: The offset to set.
  /// - Returns: A mutable attributed string with the shadow set.
  func shadow(color: Color, blurRadius: CGFloat, offset: CGSize) -> NSMutableAttributedString {
    mutableAttributed().shadow(color: color, blurRadius: blurRadius, offset: offset)
  }

  /// Returns a mutable attributed string with the themed foreground color set.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: A mutable attributed string with the themed foreground color set.
  func themedForegroundColor(_ color: ThemedColor) -> NSMutableAttributedString {
    mutableAttributed().themedForegroundColor(color)
  }

  /// Returns a mutable attributed string with the themed background color set.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: A mutable attributed string with the themed background color set.
  func themedBackgroundColor(_ color: ThemedColor) -> NSMutableAttributedString {
    mutableAttributed().themedBackgroundColor(color)
  }

  /// Returns a mutable attributed string with the themed shadow set.
  ///
  /// - Parameter shadow: The shadow to set.
  /// - Returns: A mutable attributed string with the themed shadow set.
  func themedShadow(_ shadow: Themed<NSShadow>) -> NSMutableAttributedString {
    mutableAttributed().themedShadow(shadow)
  }

  /// Returns a mutable attributed string with the paragraph style set.
  ///
  /// - Parameter style: The paragraph style to set.
  /// - Returns: A mutable attributed string with the paragraph style set.
  func paragraphStyle(_ style: NSParagraphStyle) -> NSMutableAttributedString {
    mutableAttributed().paragraphStyle(style)
  }

  /// Returns a mutable attributed string with the underline set.
  ///
  /// - Parameter color: The color of the underline.
  /// - Parameter style: The style of the underline.
  /// - Returns: A mutable attributed string with the underline set.
  func underline(color: Color, style: NSUnderlineStyle) -> NSMutableAttributedString {
    mutableAttributed().underline(color: color, style: style)
  }

  /// Returns a mutable attributed string with the text effect set.
  ///
  /// - Parameter style: The text effect style to set.
  /// - Returns: A mutable attributed string with the text effect set.
  func textEffect(_ style: NSAttributedString.TextEffectStyle) -> NSMutableAttributedString {
    mutableAttributed().textEffect(style)
  }

  /// Returns a mutable attributed string with the link set.
  ///
  /// - Parameter link: The link to set.
  /// - Returns: A mutable attributed string with the link set.
  func link(_ link: String) -> NSMutableAttributedString {
    mutableAttributed().link(link)
  }
}
