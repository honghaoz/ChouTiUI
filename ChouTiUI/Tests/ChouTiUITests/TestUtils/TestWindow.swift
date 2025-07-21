//
//  TestWindow.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 4/8/25.
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
#endif

#if canImport(UIKit)
import UIKit
#endif

import QuartzCore

import ComposeUI

final class TestWindow: Window {

  #if canImport(AppKit)
  override var canBecomeMain: Bool { true }
  override var canBecomeKey: Bool { true }
  #endif

  #if canImport(AppKit)
  private(set) var layer: CALayer!
  #endif

  #if canImport(AppKit)
  init() {
    super.init(
      contentRect: CGRect(x: 0, y: 0, width: 500, height: 500),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )
    contentView?.wantsLayer = true
    layer = contentView!.layer! // swiftlint:disable:this force_unwrapping
  }
  #endif

  #if canImport(UIKit)
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
  }
  #endif

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  #if canImport(AppKit)

  private var _isKey: Bool = false

  override var isKeyWindow: Bool {
    get {
      _isKey
    }
    set {
      _isKey = newValue
    }
  }

  override func makeKey() {
    super.makeKey()

    // somehow no `didBecomeKeyNotification` is triggered, so we need to post it manually
    NotificationCenter.default.post(name: NSWindow.didBecomeKeyNotification, object: self)

    _isKey = true
  }

  override func resignKey() {
    super.resignKey()

    _isKey = false
  }
  #endif
}
