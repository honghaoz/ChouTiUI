//
//  NSView+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/28/24.
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

public extension NSView {

  /// Some NSView common settings in ChouTi projects.
  func updateCommonSettings() {
    // seems like using auto layout can avoid certain ambiguous layout issues
    //
    // don't use auto layout
    // translatesAutoresizingMaskIntoConstraints = false

    wantsLayer = true
    layer()?.cornerCurve = .continuous
    layer()?.contentsScale = Screen.mainScreenScale

    // turns off clipping
    // https://stackoverflow.com/a/53176282/3164091
    layer()?.masksToBounds = false
  }
}

// MARK: - Ignore Hit Test

public extension NSView {

  private static let _key = Obfuscation.deobfuscate(#"}{y\}hy"#, key: 20) // "ignoreHitTest"

  var ignoreHitTest: Bool {
    /// https://avaidyam.github.io/2018/03/22/Exercise-Modern-Cocoa-Views.html
    /// https://stackoverflow.com/a/2906605/3164091
    /// https://stackoverflow.com/questions/11923597/using-valueforkey-to-access-view-in-uibarbuttonitem-private-api-violation

    get {
      (value(forKey: Self._key) as? Bool).assert("missing ignoreHitTest key") ?? false
    }
    set {
      setValue(newValue, forKey: Self._key)
    }
  }
}

#endif
