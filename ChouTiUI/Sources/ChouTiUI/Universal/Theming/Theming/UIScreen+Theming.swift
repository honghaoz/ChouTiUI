//
//  UIScreen+Theming.swift
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

#if canImport(UIKit) && !os(visionOS)

import UIKit

import ChouTi

extension UIScreen: Theming {

  public var theme: Theme {
    switch traitCollection.userInterfaceStyle {
    case .unspecified:
      #if !os(tvOS)
      ChouTi.assertFailure("unspecified traitCollection.userInterfaceStyle")
      #endif
      return .light
    case .light:
      return .light
    case .dark:
      return .dark
    @unknown default:
      ChouTi.assertFailure("unknown UIUserInterfaceStyle: \(traitCollection.userInterfaceStyle)")
      return .light
    }
  }

  public var overrideTheme: Theme? {
    get {
      // swiftlint:disable:next fatal_error
      fatalError("UIScreen doesn't support getting overrideTheme")
    }
    set {
      // swiftlint:disable:next fatal_error
      fatalError("UIScreen doesn't support setting overrideTheme")
      _ = newValue
    }
  }
}

#endif
