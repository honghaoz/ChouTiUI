//
//  CombinedShape.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/20/24.
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

/// A shape with another shape combined.
public struct CombinedShape<MainShape: Shape, SubShape: Shape>: Shape {

  /// The mode of the combined shape.
  public enum Mode {
    case add
    case difference
  }

  public let mainShape: MainShape
  public let subShape: SubShape
  public let mode: Mode

  /// Create a new combined shape.
  /// - Parameters:
  ///   - mainShape: The main shape. The shape path must be clockwise.
  ///   - subShape: The sub shape. The shape path must be clockwise.
  ///   - mode: The mode of the combined shape.
  public init(mainShape: MainShape, subShape: SubShape, mode: Mode) {
    self.mainShape = mainShape
    self.subShape = subShape
    self.mode = mode
  }

  // MARK: - Shape

  public func path(in rect: CGRect) -> CGPath {
    let mainPath = mainShape.path(in: rect)
    let subPath = subShape.path(in: rect)

    let combinedPath = CGMutablePath()

    switch mode {
    case .add:
      combinedPath.addPath(mainPath)
      combinedPath.addPath(subPath)
    case .difference:
      combinedPath.addPath(mainPath)
      combinedPath.addPath(subPath.reversing())
    }

    return combinedPath
  }
}
