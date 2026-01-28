//
//  UITraitEnvironment+Bindings.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/26/26.
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
import ComposeUI

private enum AssociateKey {

  static var themeBinding: UInt8 = 0
  static var traitChangeRegistration: UInt8 = 0
  static var themeUpdatingDebouncer: UInt8 = 0
}

@available(iOS 17.0, tvOS 17.0, visionOS 1.0, *)
public extension ThemeUpdating where Self: UITraitChangeObservable & UITraitEnvironment {

  var themeBinding: AnyBinding<Theme> {
    if let binding = objc_getAssociatedObject(self, &AssociateKey.themeBinding) as? AnyBinding<Theme> {
      return binding
    }

    let currentTheme = traitCollection.userInterfaceStyle.theme
    let themeBinding = Binding<Theme>(currentTheme)
    let anyThemeBinding = themeBinding.eraseToAnyBinding()
    objc_setAssociatedObject(self, &AssociateKey.themeBinding, anyThemeBinding, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    let registerTraitChanges: () -> Void = {
      MainActor.assumeIsolated {
        let registration = self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak themeBinding] (object: Self, _: UITraitCollection) in
          // use debouncer to avoid excessive theme updates
          // this can happen when app goes into background, the trait collection change can emit unnecessarily fast.
          // for example, if the app's theme is light, make the app goes into background, the trait collection change will emit "dark" then "light" in a short time.
          object.themeUpdatingDebouncer.debounce { [weak themeBinding] in
            guard let themeBinding else {
              ChouTi.assertFailure("no themeBinding")
              return
            }
            let newTheme = object.traitCollection.userInterfaceStyle.theme
            if newTheme != themeBinding.value {
              themeBinding.value = newTheme
            }
          }
        }
        objc_setAssociatedObject(self, &AssociateKey.traitChangeRegistration, registration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
    }

    if Thread.isMainThread {
      registerTraitChanges()
    } else {
      DispatchQueue.main.sync {
        registerTraitChanges()
      }
    }

    return anyThemeBinding
  }

  private var themeUpdatingDebouncer: TrailingDebouncer {
    if let debouncer = objc_getAssociatedObject(self, &AssociateKey.themeUpdatingDebouncer) as? TrailingDebouncer {
      return debouncer
    }
    let debouncer = TrailingDebouncer(interval: ThemeUpdatingConstants.themeUpdatingDebounceInterval)
    objc_setAssociatedObject(self, &AssociateKey.themeUpdatingDebouncer, debouncer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return debouncer
  }
}

#endif
