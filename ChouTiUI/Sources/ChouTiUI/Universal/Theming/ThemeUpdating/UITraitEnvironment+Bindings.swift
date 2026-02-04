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
  static var themeBindingImplementation: UInt8 = 0
  static var traitChangeRegistration: UInt8 = 0
  static var traitCollectionDidChangeInterceptToken: UInt8 = 0
  static var themeUpdatingDebouncer: UInt8 = 0
}

public extension ThemeUpdating where Self: UITraitEnvironment {

  var themeBinding: AnyBinding<Theme> {
    if let binding = objc_getAssociatedObject(self, &AssociateKey.themeBinding) as? AnyBinding<Theme> {
      return binding
    }

    let currentTheme = DispatchQueue.onMainSync { self.theme }
    let themeBinding = Binding<Theme>(currentTheme)
    let anyThemeBinding = themeBinding.eraseToAnyBinding()
    objc_setAssociatedObject(self, &AssociateKey.themeBinding, anyThemeBinding, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    objc_setAssociatedObject(self, &AssociateKey.themeBindingImplementation, themeBinding, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
      useRegisterForTraitChanges()
    } else {
      hookTraitCollectionDidChangeIfNeeded()
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

// MARK: - iOS 17 and above

@available(iOS 17.0, tvOS 17.0, visionOS 1.0, *)
private extension ThemeUpdating where Self: UITraitEnvironment {

  func useRegisterForTraitChanges() {
    DispatchQueue.onMainSync {
      MainActor.assumeIsolated {
        guard let observable = self as? UITraitChangeObservable else {
          return
        }
        let registration = observable.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (_: any UITraitEnvironment, _: UITraitCollection) in
          self?.updateThemeBindingIfNeeded()
        }
        objc_setAssociatedObject(self, &AssociateKey.traitChangeRegistration, registration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
    }
  }
}

// MARK: - iOS 16 and below

private extension ThemeUpdating where Self: UITraitEnvironment {

  var traitCollectionDidChangeInterceptToken: CancellableToken? {
    get {
      objc_getAssociatedObject(self, &AssociateKey.traitCollectionDidChangeInterceptToken) as? CancellableToken
    }
    set {
      if let newValue {
        objc_setAssociatedObject(self, &AssociateKey.traitCollectionDidChangeInterceptToken, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      } else {
        objc_setAssociatedObject(self, &AssociateKey.traitCollectionDidChangeInterceptToken, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
    }
  }
}

private extension ThemeUpdating where Self: UITraitEnvironment {

  func hookTraitCollectionDidChangeIfNeeded() {
    guard traitCollectionDidChangeInterceptToken == nil else {
      return
    }

    guard let object = self as? NSObject else {
      return
    }

    let token = object.intercept(selector: #selector(UIView.traitCollectionDidChange(_:))) { (object, _, previousTraitCollection: UITraitCollection?, callOriginal) in
      callOriginal(previousTraitCollection)

      guard let object = object as? (any ThemeUpdating & UITraitEnvironment) else {
        return
      }
      object.updateThemeBindingIfNeeded()
    }

    traitCollectionDidChangeInterceptToken = token
  }
}

// MARK: - Helpers

private extension ThemeUpdating where Self: UITraitEnvironment {

  func updateThemeBindingIfNeeded() {
    guard let themeBinding = objc_getAssociatedObject(self, &AssociateKey.themeBindingImplementation) as? Binding<Theme> else {
      return
    }

    // use debouncer to avoid excessive theme updates
    // this can happen when app goes into background, the trait collection change can emit unnecessarily fast.
    // for example, if the app's theme is light, make the app goes into background, the trait collection change will emit "dark" then "light" in a short time.
    self.themeUpdatingDebouncer.debounce { [weak self] in
      guard let self = self else {
        return // it's possible that self is deallocated before the debounce is called
      }
      let newTheme = self.theme
      if newTheme != themeBinding.value {
        themeBinding.value = newTheme
      }
    }
  }
}

#endif
