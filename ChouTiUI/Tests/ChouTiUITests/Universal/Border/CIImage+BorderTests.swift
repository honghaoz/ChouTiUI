//
//  CIImage+BorderTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/14/25.
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

import ChouTiTest

import ChouTi
import ChouTiUI

class CIImage_BorderTests: XCTestCase {

  func test_makeBorderImage_color() {
    let borderImage = CIImage.makeBorderImage(
      width: 2,
      content: .color(.red),
      shape: Circle(),
      size: CGSize(width: 100, height: 50),
      scale: 2
    )
    expect(borderImage.extent) == CGRect(origin: .zero, size: CGSize(width: 100, height: 50) * 2)
  }

  func test_makeBorderImage_linearGradient() {
    let borderImage = CIImage.makeBorderImage(
      width: 2,
      content: .linearGradient(startColor: .red, endColor: .green, startPoint: .left, endPoint: .right),
      shape: Circle(),
      size: CGSize(width: 100, height: 50),
      scale: 2
    )
    expect(borderImage.extent) == CGRect(origin: .zero, size: CGSize(width: 100, height: 50) * 2)
  }

  func test_makeBorderImage_image() {
    let borderImage = CIImage.makeBorderImage(
      width: 2,
      content: .image { extent in CIImage(color: .red).cropped(to: extent) },
      shape: Circle(),
      size: CGSize(width: 100, height: 50),
      scale: 2
    )
    expect(borderImage.extent) == CGRect(origin: .zero, size: CGSize(width: 100, height: 50) * 2)
  }
}
