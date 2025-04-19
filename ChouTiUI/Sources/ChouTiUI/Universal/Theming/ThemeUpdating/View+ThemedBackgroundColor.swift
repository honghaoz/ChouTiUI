//
//  View+ThemedBackgroundColor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/28/22.
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

public extension ThemeUpdating where Self: View {

  /// Set themed background color.
  ///
  /// - Parameters:
  ///   - color: The color to set.
  @inlinable
  @inline(__always)
  func setBackgroundColor(_ color: ThemedColor) {
    setBackgroundColor(color.themedUnifiedColor)
  }

  /// Set themed background color.
  ///
  /// - Parameters:
  ///   - color: The color to set.
  func setBackgroundColor(_ color: ThemedUnifiedColor) {
    themeBinding.emitCurrentValue().observe { [weak self] theme in
      switch theme {
      case .light:
        self?.layer()?.background = color.light
      case .dark:
        self?.layer()?.background = color.dark
      }
    }.store(in: bindingObservationStorage, for: "io.chouti.ChouTiUI.ThemeUpdating.themed-background-color") // set explicit key to override the old one
  }
}
