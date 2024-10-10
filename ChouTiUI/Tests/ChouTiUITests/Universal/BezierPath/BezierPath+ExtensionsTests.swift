//
//  BezierPath+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/17/21.
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

import CoreGraphics
#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest

import ChouTi
import ChouTiUI

class BezierPath_ExtensionsTests: XCTestCase {

  func test_apply() {
    let path = BezierPath()
    path.move(to: CGPoint(x: 10, y: 20))
    path.addLine(to: CGPoint(x: 30, y: 20))
    path.addLine(to: CGPoint(x: 30, y: 40))
    path.close()

    path.apply {
      CGAffineTransform.translation(-10, -20)
      CGAffineTransform.scale(2, 2)
      CGAffineTransform.translation(20, 40)
    }

    let memoryAddressString = memoryAddressString(path)
    #if canImport(AppKit)
    expect(String(describing: path)) ==
      """
      Path <\(memoryAddressString)>
        Bounds: {{20, 40}, {40, 40}}
        Control point bounds: {{20, 40}, {40, 40}}
          20.000000 40.000000 moveto
          60.000000 40.000000 lineto
          60.000000 80.000000 lineto
          closepath
          20.000000 40.000000 moveto
      """
    #endif

    #if canImport(UIKit)
    expect(String(describing: path)) ==
      """
      <UIBezierPath: \(memoryAddressString); <MoveTo {20, 40}>,
       <LineTo {60, 40}>,
       <LineTo {60, 80}>,
       <Close>
      """
    #endif
  }
}
