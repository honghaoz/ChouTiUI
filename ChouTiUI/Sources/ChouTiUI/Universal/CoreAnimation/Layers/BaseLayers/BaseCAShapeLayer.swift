//
//  BaseCAShapeLayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/22/22.
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

/// A base `CAShapeLayer` class.
open class BaseCAShapeLayer: CAShapeLayer, BaseCALayerInternalType {

  override public init() {
    super.init()

    commonInit()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    // swiftlint:disable:next fatal_error
    fatalError("init(coder:) is unavailable")
  }

  override public init(layer: Any) {
    if let layer = layer as? BaseCAShapeLayer {
      _debugDescription = layer._debugDescription
    }

    super.init(layer: layer)
  }

  // MARK: - BaseCALayerInternalType

  public private(set) lazy var bindingObservationStorage = BindingObservationStorage()

  var _debugDescription: String?

  // MARK: - Debug

  override open var debugDescription: String {
    _debugDescription ?? super.debugDescription
  }
}
