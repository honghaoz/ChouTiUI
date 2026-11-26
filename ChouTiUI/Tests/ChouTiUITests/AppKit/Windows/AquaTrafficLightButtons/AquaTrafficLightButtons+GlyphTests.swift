//
//  AquaTrafficLightButtons+GlyphTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/25/26.
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

import ChouTiTest

@testable import ChouTiUI

class AquaTrafficLightButtons_GlyphTests: XCTestCase {

  private let allGlyphs: [AquaTrafficLightGlyph] = [.close, .documentEdited, .miniaturize, .zoom, .enterFullScreen, .exitFullScreen]

  /// The button circle rect on macOS 26 and later: the 14 x 16 system button frame, inset by -1 and then by the 1pt
  /// button inset.
  private let tallRect = CGRect(x: 0, y: 0, width: 14, height: 16)

  /// The button circle rect on macOS 15: the 14 x 14 system button frame, inset by the 1pt button inset.
  private let squareRect = CGRect(x: 0, y: 0, width: 12, height: 12)

  func test_bounds_tallRect() {
    // given the glyphs in a rect taller than wide, they're drawn in the centered square (0, 1, 14, 14)
    // when making the paths, then the bounds match the legacy glyph shapes
    expect(AquaTrafficLightGlyph.close.path(in: tallRect, isTahoe: true).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(x: 3.8787, y: 4.8787, width: 6.2426, height: 6.2426), absoluteTolerance: 1e-3)) == true
    expect(AquaTrafficLightGlyph.documentEdited.path(in: tallRect, isTahoe: true).boundingBoxOfPath) == CGRect(x: 4, y: 5, width: 6, height: 6)
    expect(AquaTrafficLightGlyph.miniaturize.path(in: tallRect, isTahoe: true).boundingBoxOfPath) == CGRect(x: 3, y: 7, width: 8, height: 2)
    expect(AquaTrafficLightGlyph.zoom.path(in: tallRect, isTahoe: true).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(x: 3, y: 4, width: 8, height: 8), absoluteTolerance: 1e-9)) == true
    expect(AquaTrafficLightGlyph.enterFullScreen.path(in: tallRect, isTahoe: true).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(x: 4, y: 5, width: 6, height: 6), absoluteTolerance: 1e-9)) == true
    expect(AquaTrafficLightGlyph.exitFullScreen.path(in: tallRect, isTahoe: true).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(x: 3, y: 4, width: 8, height: 8), absoluteTolerance: 1e-9)) == true
  }

  func test_bounds_fullScreenGlyphs_beforeTahoe() {
    // given the pre-Tahoe geometry, the full screen glyphs are inset by 3 instead of 4
    // when making the paths
    let enterBounds = AquaTrafficLightGlyph.enterFullScreen.path(in: squareRect, isTahoe: false).boundingBoxOfPath
    let exitBounds = AquaTrafficLightGlyph.exitFullScreen.path(in: squareRect, isTahoe: false).boundingBoxOfPath

    // then the enter glyph fills the inset square, and the exit glyph's triangles point at the center from 1pt outside
    expect(enterBounds.isApproximatelyEqual(to: CGRect(x: 3, y: 3, width: 6, height: 6), absoluteTolerance: 1e-9)) == true
    expect(exitBounds.isApproximatelyEqual(to: CGRect(x: 2, y: 2, width: 8, height: 8), absoluteTolerance: 1e-9)) == true
  }

  func test_paths_areInsideTheRect() {
    for isTahoe in [true, false] {
      for rect in [tallRect, squareRect] {
        for glyph in allGlyphs {
          // given a glyph in a rect
          // when making the path
          let path = glyph.path(in: rect, isTahoe: isTahoe)

          // then the path isn't empty and stays inside the rect
          expect(path.isEmpty) == false
          expect(rect.contains(path.boundingBoxOfPath)) == true
        }
      }
    }
  }

  func test_paths_areDeterministic() {
    for glyph in allGlyphs {
      // given a glyph, when making the path twice, then the paths are the same
      expect(glyph.path(in: tallRect, isTahoe: true)) == glyph.path(in: tallRect, isTahoe: true)
    }
  }

  func test_paths_arePointSymmetric() {
    for glyph in allGlyphs {
      // given a glyph path
      let path = glyph.path(in: tallRect, isTahoe: true)
      let center = CGPoint(x: tallRect.midX, y: tallRect.midY)

      // when sampling the points of the rect, then each point and its reflection around the center are both
      // inside or both outside, so the glyph looks the same in flipped and non-flipped coordinates
      for x in stride(from: CGFloat(0.25), to: tallRect.width, by: 0.5) {
        for y in stride(from: CGFloat(0.25), to: tallRect.height, by: 0.5) {
          let point = CGPoint(x: x, y: y)
          let reflected = CGPoint(x: 2 * center.x - x, y: 2 * center.y - y)
          expect(path.contains(point), "\(glyph) at \(point)") == path.contains(reflected)
        }
      }
    }
  }

  func test_paths_center() {
    let center = CGPoint(x: tallRect.midX, y: tallRect.midY)

    // the glyphs that cross the center
    expect(AquaTrafficLightGlyph.close.path(in: tallRect, isTahoe: true).contains(center)) == true
    expect(AquaTrafficLightGlyph.documentEdited.path(in: tallRect, isTahoe: true).contains(center)) == true
    expect(AquaTrafficLightGlyph.miniaturize.path(in: tallRect, isTahoe: true).contains(center)) == true
    expect(AquaTrafficLightGlyph.zoom.path(in: tallRect, isTahoe: true).contains(center)) == true

    // the full screen triangles leave the center empty
    expect(AquaTrafficLightGlyph.enterFullScreen.path(in: tallRect, isTahoe: true).contains(center)) == false
    expect(AquaTrafficLightGlyph.exitFullScreen.path(in: tallRect, isTahoe: true).contains(center)) == false
  }

  func test_close_isRotatedZoom() {
    // given the "×" and "+" glyphs
    let close = AquaTrafficLightGlyph.close.path(in: tallRect, isTahoe: true)
    let zoom = AquaTrafficLightGlyph.zoom.path(in: tallRect, isTahoe: true)

    // then "+" covers the horizontal axis, "×" covers the diagonal
    expect(zoom.contains(CGPoint(x: 3.5, y: 8))) == true
    expect(close.contains(CGPoint(x: 3.5, y: 8))) == false
    expect(close.contains(CGPoint(x: 5, y: 6))) == true
    expect(zoom.contains(CGPoint(x: 5, y: 6))) == false
  }
}

#endif
