//
//  NSMutableAttributedString+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/10/22.
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
import ComposeUI

public extension NSMutableAttributedString {

  // MARK: - Basic Styles

  /// Set font for the entire string.
  ///
  /// - Parameter font: The font to set.
  /// - Returns: The attributed string self with the font set.
  @discardableResult
  @inlinable
  @inline(__always)
  func font(_ font: Font) -> NSMutableAttributedString {
    addAttribute(.font, value: font, range: fullRange)
    return self
  }

  /// Set foreground color for the entire string.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: The attributed string self with the foreground color set.
  @discardableResult
  @inlinable
  @inline(__always)
  func foregroundColor(_ color: Color) -> NSMutableAttributedString {
    addAttribute(.foregroundColor, value: color, range: fullRange)
    return self
  }

  /// Set background color for the entire string.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: The attributed string self with the background color set.
  @discardableResult
  @inlinable
  @inline(__always)
  func backgroundColor(_ color: Color) -> NSMutableAttributedString {
    addAttribute(.backgroundColor, value: color, range: fullRange)
    return self
  }

  /// Set shadow for the entire string.
  ///
  /// - Parameter shadow: The shadow to set.
  /// - Returns: The attributed string self with the shadow set.
  @discardableResult
  @inlinable
  @inline(__always)
  func shadow(_ shadow: NSShadow) -> NSMutableAttributedString {
    addAttribute(.shadow, value: shadow, range: fullRange)
    return self
  }

  /// Set shadow for the entire string.
  ///
  /// - Parameter color: The color to set.
  /// - Parameter blurRadius: The blur radius to set.
  /// - Parameter offset: The offset to set.
  /// - Returns: The attributed string self with the shadow set.
  @discardableResult
  func shadow(color: Color, blurRadius: CGFloat, offset: CGSize) -> NSMutableAttributedString {
    let shadow = NSShadow()
    shadow.shadowColor = color
    shadow.shadowBlurRadius = blurRadius
    shadow.shadowOffset = offset
    addAttribute(.shadow, value: shadow, range: fullRange)
    return self
  }

  /// Set themed foreground color for the entire string.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: The attributed string self with the themed foreground color set.
  @discardableResult
  @inlinable
  @inline(__always)
  func themedForegroundColor(_ color: ThemedColor) -> NSMutableAttributedString {
    addAttribute(.themedForegroundColor, value: color, range: fullRange)
    return self
  }

  /// Set themed background color for the entire string.
  ///
  /// - Parameter color: The color to set.
  /// - Returns: The attributed string self with the themed background color set.
  @discardableResult
  @inlinable
  @inline(__always)
  func themedBackgroundColor(_ color: ThemedColor) -> NSMutableAttributedString {
    addAttribute(.themedBackgroundColor, value: color, range: fullRange)
    return self
  }

  /// Set themed shadow for the entire string.
  ///
  /// - Parameter shadow: The shadow to set.
  /// - Returns: The attributed string self with the themed shadow set.
  @discardableResult
  @inlinable
  @inline(__always)
  func themedShadow(_ shadow: Themed<NSShadow>) -> NSMutableAttributedString {
    addAttribute(.themedShadow, value: shadow, range: fullRange)
    return self
  }

  /// Set paragraph style for the entire string.
  ///
  /// - Parameter style: The paragraph style to set.
  /// - Returns: The attributed string self with the paragraph style set.
  @discardableResult
  @inlinable
  @inline(__always)
  func paragraphStyle(_ style: NSParagraphStyle) -> NSMutableAttributedString {
    addAttribute(.paragraphStyle, value: style, range: fullRange)
    return self
  }

  // MARK: - Advanced Styles

  /// Set baseline offset for the entire string.
  ///
  /// - Parameter offset: The offset from the baseline of the text. Positive values are above the baseline and negative values are below.
  /// - Returns: The attributed string self with the baseline offset set.
  @discardableResult
  @inlinable
  @inline(__always)
  func baselineOffset(_ offset: CGFloat) -> NSMutableAttributedString {
    addAttribute(.baselineOffset, value: offset, range: fullRange)
    return self
  }

  /// Set underline for the entire string.
  ///
  /// Example:
  /// ```swift
  /// text.underline(color: .red, style: [.single, .byWord])
  /// ```
  ///
  /// - Parameters:
  ///   - color: The color of the underline.
  ///   - style: The style of the underline.
  /// - Returns: The attributed string self with the underline set.
  @discardableResult
  @inlinable
  @inline(__always)
  func underline(color: Color, style: NSUnderlineStyle = .single) -> NSMutableAttributedString {
    addAttributes([.underlineColor: color, .underlineStyle: style.rawValue], range: fullRange)
    return self
  }

  /// Set text effect for the entire string.
  ///
  /// - Parameter style: The text effect style to set.
  /// - Returns: The attributed string self with the text effect set.
  @discardableResult
  @inlinable
  @inline(__always)
  func textEffect(_ style: NSAttributedString.TextEffectStyle) -> NSMutableAttributedString {
    addAttribute(.textEffect, value: style, range: fullRange)
    return self
  }

  /// Set link for the entire string.
  ///
  /// - Parameter link: The link to set.
  /// - Returns: The attributed string self with the link set.
  @discardableResult
  func link(_ link: String) -> NSMutableAttributedString {
    guard let url = URL(string: link) else {
      ChouTi.assertFailure("link is not url: \"\(link)\"")
      return self
    }
    addAttribute(.link, value: url, range: fullRange)

    #if os(macOS)
    // TODO: text field doesn't work well for cursor, use TextView
    /// resetCursorRects
    /**
     class LinkCursorTextView: NSTextView {
         override func resetCursorRects() {
             super.resetCursorRects()

             guard let layoutManager = layoutManager, let textContainer = textContainer else { return }

             let fullRange = NSRange(location: 0, length: (textStorage?.length) ?? 0)
             textStorage?.enumerateAttribute(.link, in: fullRange, options: []) { (value, range, stop) in
                 guard value != nil else { return }
                 let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                 let rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                 addCursorRect(rect, cursor: .pointingHand)
             }
         }
     }
     */
    addAttribute(.cursor, value: NSCursor.pointingHand, range: fullRange)
    #endif

    return self
  }
}

// MARK: - Default Attributes

public extension NSMutableAttributedString {

  /// Add default font to ranges without font attribute.
  ///
  /// - Parameter font: The font to add.
  /// - Returns: The attributed string self with the default font set.
  @discardableResult
  @inlinable
  @inline(__always)
  func addDefaultFont(_ font: Font) -> NSMutableAttributedString {
    addDefaultAttribute(.font, value: font)
  }

  /// Add default foreground color to ranges without foreground color attribute.
  ///
  /// - Parameter color: The color to add.
  /// - Returns: The attributed string self with the default foreground color set.
  @discardableResult
  @inlinable
  @inline(__always)
  func addDefaultForegroundColor(_ color: Color) -> NSMutableAttributedString {
    addDefaultAttribute(.foregroundColor, value: color)
  }

  /// Add default themed foreground color to ranges without themed foreground color attribute.
  ///
  /// - Parameter color: The color to add.
  /// - Returns: The attributed string self with the default themed foreground color set.
  @discardableResult
  @inlinable
  @inline(__always)
  func addDefaultThemedForegroundColor(_ color: ThemedColor) -> NSMutableAttributedString {
    addDefaultAttribute(.themedForegroundColor, value: color)
  }

  /// Add default shadow to ranges without shadow attribute.
  ///
  /// - Parameter shadow: The shadow to add.
  /// - Returns: The attributed string self with the default shadow set.
  @discardableResult
  @inlinable
  @inline(__always)
  func addDefaultShadow(_ shadow: NSShadow) -> NSMutableAttributedString {
    addDefaultAttribute(.shadow, value: shadow)
  }

  /// Add default themed shadow to ranges without themed shadow attribute.
  ///
  /// - Parameter shadow: The shadow to add.
  /// - Returns: The attributed string self with the default themed shadow set.
  @discardableResult
  @inlinable
  @inline(__always)
  func addDefaultThemedShadow(_ shadow: Themed<NSShadow>) -> NSMutableAttributedString {
    addDefaultAttribute(.themedShadow, value: shadow)
  }

  /// Add default paragraph style to ranges without paragraph style attribute.
  ///
  /// - Parameter style: The paragraph style to add.
  /// - Returns: The attributed string self with the default paragraph style set.
  @discardableResult
  @inlinable
  @inline(__always)
  func addDefaultParagraphStyle(_ style: NSParagraphStyle) -> NSMutableAttributedString {
    addDefaultAttribute(.paragraphStyle, value: style)
  }

  /// Add default attribute to ranges without the attribute.
  ///
  /// Example:
  /// ```swift
  /// // add black foreground color to all text that doesn't have a foreground color attribute
  /// attributedString.addDefaultAttribute(.foregroundColor, value: .black)
  ///
  /// // add default font to all text that doesn't have a font attribute
  /// attributedString.addDefaultAttribute(.font, value: .systemFont(ofSize: 16))
  ///
  /// // add default stroke width to all text that doesn't have a stroke width attribute
  /// attributedString.addDefaultAttribute(.strokeWidth, value: 1)
  /// ```
  ///
  /// - Note: This method is useful when you want to add a default attribute to a range of text that doesn't have that attribute.
  /// For example, if you want to add a default foreground color to a range of text that doesn't have a foreground color attribute, you can use this method.
  ///
  /// - Parameters:
  ///   - attribute: The attribute to add.
  ///   - value: The value to add.
  /// - Returns: Self.
  @discardableResult
  func addDefaultAttribute(_ attribute: NSAttributedString.Key, value: Any) -> NSMutableAttributedString {
    enumerateAttribute(attribute, in: fullRange) { existingValue, range, stop in
      if existingValue == nil {
        self.addAttribute(attribute, value: value, range: range)
      }
    }
    return self
  }
}
