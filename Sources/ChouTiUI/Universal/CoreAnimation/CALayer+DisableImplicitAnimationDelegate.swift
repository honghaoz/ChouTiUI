//
//  CALayer+DisableImplicitAnimationDelegate.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/22/21.
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

public extension CALayer {

  /// A `CALayerDelegate` that disables CALayer's implicit animations.
  ///
  /// Example:
  /// ```swift
  /// layer.delegate = CALayer.DisableImplicitAnimationDelegate.shared
  /// ```
  final class DisableImplicitAnimationDelegate: NSObject, CALayerDelegate {

    public static let shared = DisableImplicitAnimationDelegate()

    private let null = NSNull()

    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
      null
    }
  }
}

/// https://stackoverflow.com/a/58518282/3164091
