//
//  ThemedBorder.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/29/22.
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

import Foundation

/// A type describes a layer's border info for both light and dark theme.
public struct ThemedBorder: Hashable {

  /// The border for light theme.
  public let lightBorder: Border

  /// The border for dark theme.
  public let darkBorder: Border

  /// Creates a themed border with the given light and dark borders.
  /// - Parameters:
  ///   - lightBorder: The border for light theme.
  ///   - darkBorder: The border for dark theme.
  public init(lightBorder: Border, darkBorder: Border) {
    self.lightBorder = lightBorder
    self.darkBorder = darkBorder
  }

  /// Creates a themed border with the given border for both light and dark theme.
  /// - Parameters:
  ///   - border: The border for both light and dark theme.
  public init(_ border: Border) {
    self.lightBorder = border
    self.darkBorder = border
  }

  /// Returns the border for the given theme.
  /// - Parameter theme: The theme to get the border for.
  /// - Returns: The border for the given theme.
  public func border(for theme: Theme) -> Border {
    switch theme {
    case .light:
      return lightBorder
    case .dark:
      return darkBorder
    }
  }
}

public extension Border {

  /// Returns a new themed border with the same border for both light and dark theme.
  @inlinable
  @inline(__always)
  var themedBorder: ThemedBorder { ThemedBorder(self) }
}
