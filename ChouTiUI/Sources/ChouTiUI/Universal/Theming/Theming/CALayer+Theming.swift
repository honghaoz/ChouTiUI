//
//  CALayer+Theming.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 12/30/22.
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

import QuartzCore

import ChouTi

// MARK: - Theming

extension CALayer: Theming {

  /// The theme of the layer.
  ///
  /// If the layer is a backing layer of a view, this will return the view's theme.
  ///
  /// Otherwise, this will return the layer's own theme.
  ///
  /// The layer's own theme is determined by the following rules:
  /// 1. If the layer has an override theme, this will return the override theme.
  /// 2. If the layer has a parent layer, this will return the parent layer's theme.
  /// 3. Otherwise, this will return the light theme.
  public var theme: Theme {
    if let backedView {
      return backedView.theme
    } else {
      // self managing theme
      // should check self's override theme first
      // then follow the parent (container)'s theme
      // then use self's theme (self is a root layer)
      return _overrideTheme ?? superlayer?.theme ?? .light
    }
  }

  /// The override theme of the layer.
  ///
  /// If the layer is a backing layer of a view, this will return the view's override theme.
  /// Setting this will also set the view's override theme.
  ///
  /// Otherwise, this will return the layer's own override theme.
  ///
  /// The layer's own override theme is determined by the following rules:
  /// 1. If the layer has an override theme, this will return the override theme.
  /// 2. If the layer has a parent layer, this will return the parent layer's override theme.
  /// 3. Otherwise, this will return nil.
  public var overrideTheme: Theme? {
    get {
      if let backedView {
        return backedView.overrideTheme
      } else {
        return _overrideTheme
      }
    }
    set {
      if let backedView {
        backedView.overrideTheme = newValue
      } else {
        _overrideTheme = newValue
      }
    }
  }

  private var _overrideTheme: Theme? {
    get {
      getAssociatedObject(for: &AssociateKey.overrideTheme) as? Theme
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.overrideTheme)

      // update self's theme binding
      let newTheme = newValue ?? theme
      if _themeBinding.value != newTheme {
        _themeBinding.value = newTheme
      }

      // trigger sublayers' theme binding update
      for sublayer in sublayers ?? [] where sublayer.backedView == nil {
        let theme = sublayer.theme
        if sublayer._themeBinding.value != theme {
          sublayer._themeBinding.value = theme
        }
      }
    }
  }
}

// MARK: - ThemeUpdating

extension CALayer: ThemeUpdating {

  /// - Note: This binding's value maybe out of sync with the actual theme if the layer is added to a new layer.
  public var themeBinding: AnyBinding<Theme> {
    if let backedView {
      return backedView.themeBinding
    } else {
      return superlayer?.themeBinding ?? _themeBinding.eraseToAnyBinding()
    }
  }

  private var _themeBinding: Binding<Theme> {
    if let existing = getAssociatedObject(for: &AssociateKey.themeBinding) as? ChouTi.Binding<Theme> {
      return existing
    }
    let new = ChouTi.Binding<Theme>(theme)
    setAssociatedObject(new, for: &AssociateKey.themeBinding)
    return new
  }
}

// MARK: - Private

private extension CALayer {

  private enum AssociateKey {
    static var overrideTheme: UInt8 = 0
    static var themeBinding: UInt8 = 0
  }
}
