//
//  BaseCALayerType.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/21/22.
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

import ChouTi
import QuartzCore

/// A protocol for base CoreAnimation layer types.
public protocol BaseCALayerType: CALayer {

  /// Sets the debug description.
  ///
  /// - Parameter value: A new debug description.
  func setDebugDescription(_ value: String?)
}

// MARK: - Internal

protocol BaseCALayerInternalType: BaseCALayerType {

  /// Requires an explicit implementation for `BindingObservationStorageProviding`.
  var bindingObservationStorage: BindingObservationStorage { get }

  /// A custom debug description.
  var _debugDescription: String? { get set }
}

extension BaseCALayerInternalType {

  func commonInit() {
    #if !os(macOS)
    // don't set on macOS by default, see the issue:
    // https://twitter.com/ChouTiUI/status/1576765138316963841
    self.cornerCurve = .continuous
    #endif

    #if os(visionOS)
    self.wantsDynamicContentScaling = true
    #else
    // make sure drawing content scale is matching the screen.
    // this is important to show correct drawing.
    // https://stackoverflow.com/questions/9039892/why-is-my-calayer-shadow-blurry-on-retina-displays-when-using-shadowpath-with-sh
    // https://stackoverflow.com/questions/18459078/when-do-i-need-to-set-the-contentsscale-property-of-a-calayer
    // https://newbedev.com/how-to-get-text-in-a-catextlayer-to-be-clear
    self.contentsScale = Screen.mainScreenScale
    #endif

    // turn off implicit animations by default.
    self.strongDelegate = CALayer.DisableImplicitAnimationDelegate.shared
  }

  public func setDebugDescription(_ value: String?) {
    #if DEBUG
    _debugDescription = value
    self.name = value // set layer.name so that REVEAL app can show the debug info
    #endif
  }
}
