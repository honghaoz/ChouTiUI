//
//  RadialGradientColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/21/21.
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

#if canImport(QuartzCore)
import QuartzCore
#endif

import ChouTiTest

import ChouTi
import ChouTiUI

class RadialGradientColorTests: XCTestCase {

  func test_clear() {
    let gradient = RadialGradientColor.clearGradientColor
    expect(gradient.colors) == [Color.clear, Color.clear]
    expect(gradient.locations) == [0, 1]
    expect(gradient.centerPoint) == UnitPoint.center
    expect(gradient.endPoint) == UnitPoint.top
  }

  #if canImport(QuartzCore)
  func test_gradientLayerType() {
    let gradient = RadialGradientColor(colors: [Color.red, Color.blue], centerPoint: .center, endPoint: .top)
    expect(gradient.gradientLayerType) == CAGradientLayerType.radial
  }
  #endif

  func test_init() {
    // default
    do {
      let gradient = RadialGradientColor(
        colors: [Color.red, Color.blue],
        startPoint: .top,
        endPoint: .bottom
      )
      expect(gradient.colors) == [Color.red, Color.blue]
      expect(gradient.locations) == [0, 1]
      expect(gradient.startPoint) == UnitPoint.top
      expect(gradient.endPoint) == UnitPoint.bottom
    }

    // colors and locations
    do {
      let gradient = RadialGradientColor(
        colors: [Color.red, Color.blue, Color.green],
        locations: [0, 0.5, 1],
        startPoint: .left,
        endPoint: .right
      )
      expect(gradient.colors) == [Color.red, Color.blue, Color.green]
      expect(gradient.locations) == [0, 0.5, 1]
      expect(gradient.startPoint) == UnitPoint.left
      expect(gradient.endPoint) == UnitPoint.right
    }

    // center point, end point
    do {
      let gradient = RadialGradientColor(
        colors: [Color.red, Color.blue, Color.green],
        locations: [0, 0.5, 1],
        centerPoint: .center,
        endPoint: .bottom
      )
      expect(gradient.colors) == [Color.red, Color.blue, Color.green]
      expect(gradient.locations) == [0, 0.5, 1]
      expect(gradient.startPoint) == UnitPoint.center
      expect(gradient.endPoint) == UnitPoint.bottom
    }
  }

  func test_init_invalid() {
    // empty colors
    do {
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "gradient color should have at least 2 colors."
        expect(metadata["colors"]) == "[]"
      }
      _ = RadialGradientColor(colors: [], startPoint: .left, endPoint: .right)
      Assert.resetTestAssertionFailureHandler()
    }

    // one color
    do {
      let color = Color.red
      var assertCount: Int = 0
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        switch assertCount {
        case 0:
          expect(message) == "gradient color should have at least 2 colors."
          expect(metadata["colors"]) == "[\(color)]"
        case 1:
          expect(message) == "locations should have the same count as colors."
          expect(metadata["colors"]) == "[\(color)]"
          expect(metadata["locations"]) == "[]"
        default:
          fail("unexpected assertion")
        }
        assertCount += 1
      }
      _ = RadialGradientColor(colors: [color], startPoint: .left, endPoint: .right)
      Assert.resetTestAssertionFailureHandler()
    }

    // locations count mismatch
    do {
      let colors = [Color.red, Color.blue]
      let locations: [CGFloat] = [0, 0.2, 1]
      Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
        expect(message) == "locations should have the same count as colors."
        expect(metadata["colors"]) == "\(colors)"
        expect(metadata["locations"]) == "\(locations)"
      }
      _ = RadialGradientColor(colors: colors, locations: locations, startPoint: .left, endPoint: .right)
      Assert.resetTestAssertionFailureHandler()
    }
  }

  func test_withComponents() {
    let gradient = RadialGradientColor(
      colors: [Color.red, Color.blue],
      startPoint: .top,
      endPoint: .bottom
    )
    let newGradient = gradient.withComponents(colors: [Color.blue, Color.red], locations: [0, 1], startPoint: .bottom, endPoint: .top)
    expect(newGradient.colors) == [Color.blue, Color.red]
    expect(newGradient.locations) == [0, 1]
    expect(newGradient.startPoint) == UnitPoint.bottom
    expect(newGradient.endPoint) == UnitPoint.top
  }

  // MARK: - Convenience Initializers

  func test_centerRadial_radius() {
    // aspect ratio = 1
    do {
      /// +---+---+---+
      /// |   |   |   |
      /// +---+---+---+
      /// |   |   |   |
      /// +---+---+---+
      /// |   |   |   |
      /// +---+---+---+
      let gradient = RadialGradientColor.centerRadial(
        colors: [Color.red, Color.green, Color.blue],
        locations: [0, 0.5, 1],
        radius: 0.25,
        aspectRatio: 1
      )

      expect(gradient.colors) == [Color.red, Color.green, Color.blue]
      expect(gradient.locations) == [0, 0.5, 1]
      expect(gradient.startPoint) == UnitPoint.center
      expect(gradient.endPoint) == UnitPoint(0.75, 0.75)
    }

    // aspect ratio < 1
    do {
      /// +---+---+
      /// |   |   |
      /// +---+---+
      /// |   |   |
      /// +---+---+
      /// |   |   |
      /// +---+---+
      /// |   |   |
      /// +---+---+
      let gradient = RadialGradientColor.centerRadial(
        colors: [Color.red, Color.green, Color.blue],
        locations: [0, 0.5, 1],
        radius: 0.25,
        aspectRatio: 0.5
      )

      expect(gradient.colors) == [Color.red, Color.green, Color.blue]
      expect(gradient.locations) == [0, 0.5, 1]
      expect(gradient.startPoint) == UnitPoint.center
      expect(gradient.endPoint) == UnitPoint(0.75, 0.625)
    }

    // aspect ratio > 1
    do {
      /// +---+---+---+---+
      /// |   |   |   |   |
      /// +---+---+---+---+
      /// |   |   |   |   |
      /// +---+---+---+---+
      let gradient = RadialGradientColor.centerRadial(
        colors: [Color.red, Color.green, Color.blue],
        locations: [0, 0.5, 1],
        radius: 0.25,
        aspectRatio: 2
      )

      expect(gradient.colors) == [Color.red, Color.green, Color.blue]
      expect(gradient.locations) == [0, 0.5, 1]
      expect(gradient.startPoint) == UnitPoint.center
      expect(gradient.endPoint) == UnitPoint(0.625, 0.75)
    }
  }

  func test_centerRadial_diameter() {
    // aspect ratio = 1
    do {
      /// +---+---+---+
      /// |   |   |   |
      /// +---+---+---+
      /// |   |   |   |
      /// +---+---+---+
      /// |   |   |   |
      /// +---+---+---+

      // width
      do {
        // scale factor: 1
        do {
          let gradient = RadialGradientColor.centerRadial(
            colors: [Color.red, Color.green, Color.blue],
            locations: [0, 0.5, 1],
            diameter: .width,
            aspectRatio: 1
          )

          expect(gradient.colors) == [Color.red, Color.green, Color.blue]
          expect(gradient.locations) == [0, 0.5, 1]
          expect(gradient.startPoint) == UnitPoint.center
          expect(gradient.endPoint) == UnitPoint.bottomRight
        }

        // scale factor: 2
        do {
          let gradient = RadialGradientColor.centerRadial(
            colors: [Color.red, Color.green, Color.blue],
            locations: [0, 0.5, 1],
            diameter: .width,
            radiusScaleFactor: 2,
            aspectRatio: 1
          )

          expect(gradient.colors) == [Color.red, Color.green, Color.blue]
          expect(gradient.locations) == [0, 0.5, 1]
          expect(gradient.startPoint) == UnitPoint.center
          expect(gradient.endPoint) == UnitPoint(x: 1.5, y: 1.5)
        }
      }

      // length
      do {
        // scale factor: 1
        do {
          let gradient = RadialGradientColor.centerRadial(
            colors: [Color.red, Color.green, Color.blue],
            locations: [0, 0.5, 1],
            diameter: .length,
            aspectRatio: 1
          )

          expect(gradient.colors) == [Color.red, Color.green, Color.blue]
          expect(gradient.locations) == [0, 0.5, 1]
          expect(gradient.startPoint) == UnitPoint.center
          expect(gradient.endPoint) == UnitPoint.bottomRight
        }

        // scale factor: 2
        do {
          let gradient = RadialGradientColor.centerRadial(
            colors: [Color.red, Color.green, Color.blue],
            locations: [0, 0.5, 1],
            diameter: .length,
            radiusScaleFactor: 2,
            aspectRatio: 1
          )

          expect(gradient.colors) == [Color.red, Color.green, Color.blue]
          expect(gradient.locations) == [0, 0.5, 1]
          expect(gradient.startPoint) == UnitPoint.center
          expect(gradient.endPoint) == UnitPoint(x: 1.5, y: 1.5)
        }
      }

      // diagonal
      do {
        // scale factor: 1
        do {
          let gradient = RadialGradientColor.centerRadial(
            colors: [Color.red, Color.green, Color.blue],
            locations: [0, 0.5, 1],
            diameter: .diagonal,
            aspectRatio: 1
          )

          expect(gradient.colors) == [Color.red, Color.green, Color.blue]
          expect(gradient.locations) == [0, 0.5, 1]
          expect(gradient.startPoint) == UnitPoint.center
          expect(gradient.endPoint) == UnitPoint(0.5 + 0.5 * sqrt(2), 0.5 + 0.5 * sqrt(2))
        }

        // scale factor: 2
        do {
          let gradient = RadialGradientColor.centerRadial(
            colors: [Color.red, Color.green, Color.blue],
            locations: [0, 0.5, 1],
            diameter: .diagonal,
            radiusScaleFactor: 2,
            aspectRatio: 1
          )

          expect(gradient.colors) == [Color.red, Color.green, Color.blue]
          expect(gradient.locations) == [0, 0.5, 1]
          expect(gradient.startPoint) == UnitPoint.center
          expect(gradient.endPoint) == UnitPoint(0.5 + sqrt(2), 0.5 + sqrt(2))
        }
      }
    }

    // aspect ratio < 1
    do {
      /// +---+---+
      /// |   |   |
      /// +---+---+
      /// |   |   |
      /// +---+---+
      /// |   |   |
      /// +---+---+

      // width
      do {
        let gradient = RadialGradientColor.centerRadial(
          colors: [Color.red, Color.green, Color.blue],
          locations: [0, 0.5, 1],
          diameter: .width,
          aspectRatio: 0.5
        )

        expect(gradient.colors) == [Color.red, Color.green, Color.blue]
        expect(gradient.locations) == [0, 0.5, 1]
        expect(gradient.startPoint) == UnitPoint.center
        expect(gradient.endPoint) == UnitPoint(1, 0.75)
      }

      // length
      do {
        let gradient = RadialGradientColor.centerRadial(
          colors: [Color.red, Color.green, Color.blue],
          locations: [0, 0.5, 1],
          diameter: .length,
          aspectRatio: 0.5
        )

        expect(gradient.colors) == [Color.red, Color.green, Color.blue]
        expect(gradient.locations) == [0, 0.5, 1]
        expect(gradient.startPoint) == UnitPoint.center
        expect(gradient.endPoint) == UnitPoint(1.5, 1)
      }

      // diagonal
      do {
        let gradient = RadialGradientColor.centerRadial(
          colors: [Color.red, Color.green, Color.blue],
          locations: [0, 0.5, 1],
          diameter: .diagonal,
          aspectRatio: 0.5
        )

        expect(gradient.colors) == [Color.red, Color.green, Color.blue]
        expect(gradient.locations) == [0, 0.5, 1]
        expect(gradient.startPoint) == UnitPoint.center
        expect(gradient.endPoint.x).to(beApproximatelyEqual(to: 1.6180339887, within: 1e-6)) // 0.5 + sqrt(0.5 * 0.5 + 1 * 1)
        expect(gradient.endPoint.y).to(beApproximatelyEqual(to: 1.05901699437, within: 1e-6)) // 0.5 + sqrt(0.5 * 0.5 + 0.25 * 0.25)
      }
    }

    // aspect ratio > 1
    do {
      /// +---+---+---+---+
      /// |   |   |   |   |
      /// +---+---+---+---+
      /// |   |   |   |   |
      /// +---+---+---+---+

      // width
      do {
        let gradient = RadialGradientColor.centerRadial(
          colors: [Color.red, Color.green, Color.blue],
          locations: [0, 0.5, 1],
          diameter: .width,
          aspectRatio: 2
        )

        expect(gradient.colors) == [Color.red, Color.green, Color.blue]
        expect(gradient.locations) == [0, 0.5, 1]
        expect(gradient.startPoint) == UnitPoint.center
        expect(gradient.endPoint) == UnitPoint(0.75, 1)
      }

      // length
      do {
        let gradient = RadialGradientColor.centerRadial(
          colors: [Color.red, Color.green, Color.blue],
          locations: [0, 0.5, 1],
          diameter: .length,
          aspectRatio: 2
        )

        expect(gradient.colors) == [Color.red, Color.green, Color.blue]
        expect(gradient.locations) == [0, 0.5, 1]
        expect(gradient.startPoint) == UnitPoint.center
        expect(gradient.endPoint) == UnitPoint(1, 1.5)
      }

      // diagonal
      do {
        let gradient = RadialGradientColor.centerRadial(
          colors: [Color.red, Color.green, Color.blue],
          locations: [0, 0.5, 1],
          diameter: .diagonal,
          aspectRatio: 2
        )

        expect(gradient.colors) == [Color.red, Color.green, Color.blue]
        expect(gradient.locations) == [0, 0.5, 1]
        expect(gradient.startPoint) == UnitPoint.center
        expect(gradient.endPoint.x).to(beApproximatelyEqual(to: 1.05901699437, within: 1e-6)) // 0.5 + sqrt(0.5 * 0.5 + 0.25 * 0.25)
        expect(gradient.endPoint.y).to(beApproximatelyEqual(to: 1.6180339887, within: 1e-6)) // 0.5 + sqrt(0.5 * 0.5 + 1 * 1)
      }
    }
  }
}
