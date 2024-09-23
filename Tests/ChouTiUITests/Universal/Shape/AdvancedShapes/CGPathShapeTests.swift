//
//  CGPathShapeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 2/28/23.
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

import ChouTiUI

class CGPathShapeTests: XCTestCase {

  func test_init() {
    // with canvas size
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
      expect(shape.cgPath) == cgPath
      expect(shape.canvasSize) == CGSize(40, 60)
      expect(shape.contentMode) == .scaleToFill
    }

    // without canvas size
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape = CGPathShape(cgPath: cgPath, contentMode: .resizeAspectFit)
      expect(shape.cgPath.pathElements()) == CGPath(rect: CGRect(0, 0, 30, 40), transform: nil).pathElements()
      expect(shape.canvasSize) == CGSize(30, 40)
      expect(shape.contentMode) == .resizeAspectFit
    }
  }

  func test_path() {
    // +-----------+
    // |           |
    // |           |
    // |  +-----+  |
    // |  |     |  |
    // |  |     |  |
    // |  +-----+  |
    // |           |
    // |           |
    // +-----------+

    // with canvasSize
    do {
      // scaleToFill
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 80), contentMode: .scaleToFill)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(10, 20, 30, 40)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(16.0, 20.0, 48.0, 40.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(10, 25, 30, 50)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(20, 40, 30, 40)
      }

      // resizeAspectFill
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 80), contentMode: .resizeAspectFill)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(10, 20, 30, 40)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(16.0, 8.0, 48.0, 64.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(6.25, 25.0, 37.5, 50.0)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(20, 40, 30, 40)
      }

      // resizeAspectFit
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 80), contentMode: .resizeAspectFit)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(10, 20, 30, 40)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(25.0, 20.0, 30.0, 40.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(10.0, 30.0, 30.0, 40.0)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(20, 40, 30, 40)
      }
    }

    // without canvas size
    do {
      // scaleToFill
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, contentMode: .scaleToFill)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(0, 0, 50, 80)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(0, 0, 80, 80)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(0, 0, 50, 100)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(10.0, 20.0, 50.0, 80.0)
      }

      // resizeAspectFill
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, contentMode: .resizeAspectFill)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath) == CGRect(-5.0, 0.0, 60.0, 80.0)

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(0.0, -13.333333333333329, 80.0, 106.66666666666666), absoluteTolerance: 1e-9)) == true
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath) == CGRect(-12.5, 0.0, 75.0, 100.0)

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath) == CGRect(5.0, 20.0, 60.0, 80.0)
      }

      // resizeAspectFit
      do {
        let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
        let shape = CGPathShape(cgPath: cgPath, contentMode: .resizeAspectFit)

        expect(shape.path(in: CGRect(0, 0, 50, 80)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(0.0, 6.666666666666664, 50.0, 66.66666666666669), absoluteTolerance: 1e-9)) == true

        expect(shape.path(in: CGRect(0, 0, 80, 80)).boundingBoxOfPath) == CGRect(10.0, 0.0, 60.0, 80.0)
        expect(shape.path(in: CGRect(0, 0, 50, 100)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(0.0, 16.666666666666664, 50.0, 66.66666666666669), absoluteTolerance: 1e-9)) == true

        expect(shape.path(in: CGRect(10, 20, 50, 80)).boundingBoxOfPath.isApproximatelyEqual(to: CGRect(10.0, 26.666666666666664, 50.0, 66.66666666666669), absoluteTolerance: 1e-9)) == true
      }
    }
  }

  func test_equal() {
    // same cgPath, canvasSize, contentMode
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
      let shape2 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
      expect(shape1) == shape2
    }

    // different cgPath
    do {
      let cgPath1 = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let cgPath2 = CGPath(rect: CGRect(11, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath1, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
      let shape2 = CGPathShape(cgPath: cgPath2, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
      expect(shape1) != shape2
    }

    // different canvasSize
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
      let shape2 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(50, 70), contentMode: .scaleToFill)
      expect(shape1) != shape2
    }

    // different contentMode
    do {
      let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
      let shape1 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
      let shape2 = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .resizeAspectFit)
      expect(shape1) != shape2
    }
  }
}

// class CGPathShapeTests: QuickSpec {

//   override func spec() {
//     context("for a shape with a rectangle CGPath") {
//       var cgPath: CGPath!
//       var shape: CGPathShape!

//       context("providing canvas size") {
//         context("fill") {
//           beforeEach {
//             cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//             shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .scaleToFill)
//           }

//           it("should return correct path") {
//             expect(shape.path(in: CGRect(0, 0, 40, 60))) == CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//             expect(shape.path(in: CGRect(10, 20, 40, 60))) == CGPath(rect: CGRect(20, 40, 30, 40), transform: nil)
//             expect(shape.path(in: CGRect(0, 0, 60, 60))) == CGPath(rect: CGRect(15, 20, 45, 40), transform: nil)
//             expect(shape.path(in: CGRect(20, 20, 60, 60))) == CGPath(rect: CGRect(35, 40, 45, 40), transform: nil)
//           }
//         }

//         context("fit") {
//           beforeEach {
//             cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//             shape = CGPathShape(cgPath: cgPath, canvasSize: CGSize(40, 60), contentMode: .resizeAspectFit)
//           }

//           it("should return correct path") {
//             expect(shape.path(in: CGRect(0, 0, 40, 60))) == CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//             expect(shape.path(in: CGRect(10, 20, 40, 60))) == CGPath(rect: CGRect(20, 40, 30, 40), transform: nil)
//             expect(shape.path(in: CGRect(0, 0, 60, 60))) == CGPath(rect: CGRect(20, 20, 30, 40), transform: nil)
//             expect(shape.path(in: CGRect(20, 20, 60, 60))) == CGPath(rect: CGRect(40, 40, 30, 40), transform: nil)
//           }
//         }
//       }

//       context("providing no canvas size") {
//         context("fill") {
//           beforeEach {
//             cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//             shape = CGPathShape(cgPath: cgPath, contentMode: .scaleToFill)
//           }

//           it("should return correct path") {
//             expect(shape.path(in: CGRect(0, 0, 40, 60))) == CGPath(rect: CGRect(0, 0, 40, 60), transform: nil)
//             expect(shape.path(in: CGRect(10, 20, 40, 60))) == CGPath(rect: CGRect(10, 20, 40, 60), transform: nil)
//             expect(shape.path(in: CGRect(0, 0, 60, 60))) == CGPath(rect: CGRect(0, 0, 60, 60), transform: nil)
//             expect(shape.path(in: CGRect(20, 20, 60, 60))) == CGPath(rect: CGRect(20, 20, 60, 60), transform: nil)
//           }
//         }

//         context("fit") {
//           beforeEach {
//             cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//             shape = CGPathShape(cgPath: cgPath, contentMode: .resizeAspectFit)
//           }

//           it("should return correct path") {
//             expect(shape.path(in: CGRect(0, 0, 60, 40))) == CGPath(rect: CGRect(15, 0, 30, 40), transform: nil)
//             expect(shape.path(in: CGRect(10, 20, 60, 40))) == CGPath(rect: CGRect(25, 20, 30, 40), transform: nil)
//             expect(shape.path(in: CGRect(0, 0, 60, 60))) == CGPath(rect: CGRect(7.5, 0, 45, 60), transform: nil)
//             expect(shape.path(in: CGRect(20, 20, 60, 60))) == CGPath(rect: CGRect(27.5, 20, 45, 60), transform: nil)
//           }
//         }
//       }
//     }

//     context("compare") {
//       var shape: CGPathShape!

//       context("when compare different shape") {
//         beforeEach {
//           let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//           shape = CGPathShape(cgPath: cgPath, contentMode: .resizeAspectFit)
//         }

//         it("should be not equal") {
//           expect(shape.isEqual(to: Rectangle())) == false
//         }
//       }

//       context("when compare same shape") {
//         beforeEach {
//           let cgPath = CGPath(rect: CGRect(10, 20, 30, 40), transform: nil)
//           shape = CGPathShape(cgPath: cgPath, contentMode: .resizeAspectFit)
//         }

//         context("when cgPath is same") {
//           it("should be equal") {
//             expect(shape.isEqual(to: CGPathShape(cgPath: CGPath(rect: CGRect(10, 20, 30, 40), transform: nil), contentMode: .resizeAspectFit))) == true
//             expect(shape == CGPathShape(cgPath: CGPath(rect: CGRect(10, 20, 30, 40), transform: nil), contentMode: .resizeAspectFit)) == true
//           }
//         }

//         context("when cgPath is different") {
//           it("should be not equal") {
//             expect(shape.isEqual(to: CGPathShape(cgPath: CGPath(ellipseIn: CGRect(10, 20, 30, 40), transform: nil), contentMode: .resizeAspectFit))) == false
//             expect(shape == CGPathShape(cgPath: CGPath(ellipseIn: CGRect(10, 20, 30, 40), transform: nil), contentMode: .resizeAspectFit)) == false
//           }
//         }

//         context("when canvasSize is different") {
//           it("should be not equal") {
//             expect(shape.isEqual(to: CGPathShape(cgPath: CGPath(ellipseIn: CGRect(10, 20, 30, 40), transform: nil), canvasSize: CGSize(100, 100), contentMode: .resizeAspectFit))) == false
//             expect(shape == CGPathShape(cgPath: CGPath(ellipseIn: CGRect(10, 20, 30, 40), transform: nil), canvasSize: CGSize(100, 100), contentMode: .resizeAspectFit)) == false
//           }
//         }

//         context("when contentMode is different") {
//           it("should be not equal") {
//             expect(shape.isEqual(to: CGPathShape(cgPath: CGPath(ellipseIn: CGRect(10, 20, 30, 40), transform: nil), contentMode: .resizeAspectFill))) == false
//             expect(shape == CGPathShape(cgPath: CGPath(ellipseIn: CGRect(10, 20, 30, 40), transform: nil), contentMode: .resizeAspectFill)) == false
//           }
//         }
//       }
//     }
//   }
// }
