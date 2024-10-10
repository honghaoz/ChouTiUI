//
//  UIScreen+Extensions.swift
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

#if canImport(UIKit) && !os(visionOS)

import UIKit

import ChouTi

// MARK: - Display Corner Radius

public extension UIScreen {

  private static let _displayCornerRadius = Obfuscation.deobfuscate("afkurnc{EqtpgtTcfkwu", key: 2) // "_displayCornerRadius"

  var displayCornerRadius: CGFloat {
    guard let value = value(forKey: Self._displayCornerRadius) else {
      ChouTi.assertFailure("Failed to get display corner radius.")
      return 0
    }
    return (value as? CGFloat).assert("Got invalid display corner radius.", metadata: ["value": "\(value)"]) ?? 0
  }

  // https://kylebashour.com/posts/finding-the-real-iphone-x-corner-radius
}

#endif
