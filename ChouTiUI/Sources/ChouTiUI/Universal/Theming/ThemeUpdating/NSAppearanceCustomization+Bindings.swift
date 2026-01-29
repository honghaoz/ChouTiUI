//
//  NSAppearanceCustomization+Bindings.swift
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

import ChouTi

private enum AssociateKey {

  static var effectiveAppearanceBinding: UInt8 = 0
  static var effectiveAppearanceKVOToken: UInt8 = 0

  static var themeBinding: UInt8 = 0
  static var bindingObservationStorageKey: UInt8 = 0
}

public extension NSAppearanceCustomization {

  /// A binding of `effectiveAppearance`.
  var effectiveAppearanceBinding: some BindingType<NSAppearance> {
    if let binding = objc_getAssociatedObject(self, &AssociateKey.effectiveAppearanceBinding) as? Binding<NSAppearance> {
      return binding
    }

    let newBinding = DispatchQueue.onMainSync { Binding<NSAppearance>(effectiveAppearance) }
    objc_setAssociatedObject(self, &AssociateKey.effectiveAppearanceBinding, newBinding, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    let observationToken: KVOObserver<Self, NSAppearance> = observe("effectiveAppearance") { [weak newBinding] object, _, newValue in
      DispatchQueue.onMainSync {
        ChouTi.assert(object.effectiveAppearance == newValue)
      }
      newBinding?.value = newValue
    }
    objc_setAssociatedObject(self, &AssociateKey.effectiveAppearanceKVOToken, observationToken, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    return newBinding
  }
}

/// Make all objects conforming to `ThemeUpdating` and `NSAppearanceCustomization` have `themeBinding`.
public extension ThemeUpdating where Self: NSAppearanceCustomization {

  var themeBinding: AnyBinding<Theme> {
    if let binding = objc_getAssociatedObject(self, &AssociateKey.themeBinding) as? AnyBinding<Theme> {
      return binding
    }

    let themeBinding = Binding<Theme>(DispatchQueue.onMainSync { effectiveAppearance.theme })
    let anyThemeBinding = themeBinding.eraseToAnyBinding()
    objc_setAssociatedObject(self, &AssociateKey.themeBinding, anyThemeBinding, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

    // self -> effectiveAppearanceBinding <- observation <- bindingObservationStorage
    // self -> bindingObservationStorage
    effectiveAppearanceBinding
      .trailingDebounce(for: ThemeUpdatingConstants.themeUpdatingDebounceInterval, queue: .makeMain()) // add debounce because `effectiveAppearance` may emit too fast unnecessarily
      .observe { [weak themeBinding] appearance, stop in
        guard let themeBinding else {
          ChouTi.assertFailure("no themeBinding")
          return
        }
        let newTheme = appearance.theme
        if newTheme != themeBinding.value {
          themeBinding.value = newTheme
        }
      }
      .store(in: bindingObservationStorage)

    return anyThemeBinding
  }

  fileprivate var bindingObservationStorage: BindingObservationStorage {
    if let storage = objc_getAssociatedObject(self, &AssociateKey.bindingObservationStorageKey) as? BindingObservationStorage {
      return storage
    }

    let storage = BindingObservationStorage()
    objc_setAssociatedObject(self, &AssociateKey.bindingObservationStorageKey, storage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    return storage
  }
}

#endif
