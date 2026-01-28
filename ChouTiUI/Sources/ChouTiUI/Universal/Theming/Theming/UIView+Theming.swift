//
//  UIView+Theming.swift
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

#if canImport(UIKit)

import UIKit

import ChouTi

extension UIView: Theming {

  public var theme: Theme {
    let getThemeFromTraitCollection: () -> Theme = {
      let traitCollection = Thread.isMainThread ? self.traitCollection : DispatchQueue.main.sync { self.traitCollection }
      switch traitCollection.userInterfaceStyle {
      case .unspecified:
        #if !os(tvOS)
        ChouTi.assertFailure("unspecified traitCollection.userInterfaceStyle")
        #endif
        return self.window?.theme ?? .light
      case .light:
        return .light
      case .dark:
        return .dark
      @unknown default:
        ChouTi.assertFailure("unknown UIUserInterfaceStyle: \(self.traitCollection.userInterfaceStyle)")
        return self.window?.theme ?? .light
      }
    }

    let overrideUserInterfaceStyle = Thread.isMainThread ? self.overrideUserInterfaceStyle : DispatchQueue.main.sync { self.overrideUserInterfaceStyle }
    switch overrideUserInterfaceStyle {
    case .unspecified:
      return getThemeFromTraitCollection()
    case .light:
      return .light
    case .dark:
      return .dark
    @unknown default:
      ChouTi.assertFailure("unknown overrideUserInterfaceStyle: \(overrideUserInterfaceStyle)")
      return getThemeFromTraitCollection()
    }
  }

  public var overrideTheme: Theme? {
    get {
      switch overrideUserInterfaceStyle {
      case .unspecified:
        return nil
      case .light:
        return .light
      case .dark:
        return .dark
      @unknown default:
        assertionFailure("unknown UIUserInterfaceStyle: \(self)")
        return nil
      }
    }
    set {
      if let newValue {
        overrideUserInterfaceStyle = newValue.isLight ? .light : .dark
      } else {
        overrideUserInterfaceStyle = .unspecified
      }
    }
  }
}

#endif
