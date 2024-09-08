//
//  LayoutTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 6/16/22.
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

class LayoutTests: XCTestCase {

  func testCenter_whenChildSizeIsSmallerThanContainer() {
    let smallSize = CGSize(100, 200)
    let containerSize = CGSize(300, 500)

    let frame = Layout.center(rect: smallSize, in: containerSize)
    expect(frame) == CGRect(x: 100, y: 150, width: 100, height: 200)
  }

  func testCenter_whenChildSizeIsBiggerThanContainer() {
    let smallSize = CGSize(500, 1000)
    let containerSize = CGSize(300, 500)

    let frame = Layout.center(rect: smallSize, in: containerSize)
    expect(frame) == CGRect(x: -100, y: -250, width: 500, height: 1000)
  }

  func testPosition_whenChildSizeIsSmallerThanContainer() {
    let smallSize = CGSize(100, 200)
    let containerSize = CGSize(300, 500)

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .center)
      expect(frame) == CGRect(x: 100, y: 150, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .left)
      expect(frame) == CGRect(x: 0, y: 150, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .right)
      expect(frame) == CGRect(x: 200, y: 150, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .top)
      expect(frame) == CGRect(x: 100, y: 0, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .bottom)
      expect(frame) == CGRect(x: 100, y: 300, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .topLeft)
      expect(frame) == CGRect(x: 0, y: 0, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .topRight)
      expect(frame) == CGRect(x: 200, y: 0, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .bottomLeft)
      expect(frame) == CGRect(x: 0, y: 300, width: 100, height: 200)
    }

    do {
      let frame = Layout.position(rect: smallSize, in: containerSize, alignment: .bottomRight)
      expect(frame) == CGRect(x: 200, y: 300, width: 100, height: 200)
    }
  }

  func testPosition_whenChildSizeIsBiggerThanContainer() {
    let childSize = CGSize(500, 800)
    let containerSize = CGSize(300, 500)

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .center)
      expect(frame) == CGRect(x: -100, y: -150, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .left)
      expect(frame) == CGRect(x: 0, y: -150, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .right)
      expect(frame) == CGRect(x: -200, y: -150, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .top)
      expect(frame) == CGRect(x: -100, y: 0, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .bottom)
      expect(frame) == CGRect(x: -100, y: -300, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .topLeft)
      expect(frame) == CGRect(x: 0, y: 0, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .topRight)
      expect(frame) == CGRect(x: -200, y: 0, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .bottomLeft)
      expect(frame) == CGRect(x: 0, y: -300, width: 500, height: 800)
    }

    do {
      let frame = Layout.position(rect: childSize, in: containerSize, alignment: .bottomRight)
      expect(frame) == CGRect(x: -200, y: -300, width: 500, height: 800)
    }
  }

  func testAnchor() {
    let childSize = CGSize(100, 200)
    let containerSize = CGSize(300, 500)

    // when anchor is center
    do {
      var frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: 100, y: -213, width: 100, height: 200)

      frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: CGPoint(x: 10, y: 20), size: containerSize), edge: .top, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: 110, y: -193, width: 100, height: 200)
    }

    do {
      var frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: -113, y: 150, width: 100, height: 200)

      frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: CGPoint(x: 10, y: 20), size: containerSize), edge: .left, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: -103, y: 170, width: 100, height: 200)
    }

    do {
      var frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: 100, y: 513, width: 100, height: 200)

      frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: CGPoint(x: 10, y: 20), size: containerSize), edge: .bottom, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: 110, y: 533, width: 100, height: 200)
    }

    do {
      var frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: 313, y: 150, width: 100, height: 200)

      frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: CGPoint(x: 10, y: 20), size: containerSize), edge: .right, anchorPoint: .center, gap: 13)
      expect(frame) == CGRect(x: 323, y: 170, width: 100, height: 200)
    }

    // when anchor is left
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .left, gap: 13)
      expect(frame) == CGRect(x: -50, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .left, gap: 13)
      expect(frame) == CGRect(x: -113, y: 150, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .left, gap: 13)
      expect(frame) == CGRect(x: -50, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .left, gap: 13)
      expect(frame) == CGRect(x: 313, y: 150, width: 100, height: 200)
    }

    // when anchor is right
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .right, gap: 13)
      expect(frame) == CGRect(x: 250, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .right, gap: 13)
      expect(frame) == CGRect(x: -113, y: 150, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .right, gap: 13)
      expect(frame) == CGRect(x: 250, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .right, gap: 13)
      expect(frame) == CGRect(x: 313, y: 150, width: 100, height: 200)
    }

    // when anchor is top
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .top, gap: 13)
      expect(frame) == CGRect(x: 100, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .top, gap: 13)
      expect(frame) == CGRect(x: -113, y: -100, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .top, gap: 13)
      expect(frame) == CGRect(x: 100, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .top, gap: 13)
      expect(frame) == CGRect(x: 313, y: -100, width: 100, height: 200)
    }

    // when anchor is bottom
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .bottom, gap: 13)
      expect(frame) == CGRect(x: 100, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .bottom, gap: 13)
      expect(frame) == CGRect(x: -113, y: 400, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .bottom, gap: 13)
      expect(frame) == CGRect(x: 100, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .bottom, gap: 13)
      expect(frame) == CGRect(x: 313, y: 400, width: 100, height: 200)
    }

    // when anchor is topLeft
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .topLeft, gap: 13)
      expect(frame) == CGRect(x: -50, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .topLeft, gap: 13)
      expect(frame) == CGRect(x: -113, y: -100, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .topLeft, gap: 13)
      expect(frame) == CGRect(x: -50, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .topLeft, gap: 13)
      expect(frame) == CGRect(x: 313, y: -100, width: 100, height: 200)
    }

    // when anchor is topRight
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .topRight, gap: 13)
      expect(frame) == CGRect(x: 250, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .topRight, gap: 13)
      expect(frame) == CGRect(x: -113, y: -100, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .topRight, gap: 13)
      expect(frame) == CGRect(x: 250, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .topRight, gap: 13)
      expect(frame) == CGRect(x: 313, y: -100, width: 100, height: 200)
    }

    // when anchor is bottomLeft
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: .bottomLeft, gap: 13)
      expect(frame) == CGRect(x: -50, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: .bottomLeft, gap: 13)
      expect(frame) == CGRect(x: -113, y: 400, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: .bottomLeft, gap: 13)
      expect(frame) == CGRect(x: -50, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: .bottomLeft, gap: 13)
      expect(frame) == CGRect(x: 313, y: 400, width: 100, height: 200)
    }

    // when anchor is customized
    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .top, anchorPoint: UnitPoint(x: 0.1, y: 0.2), gap: 13)
      expect(frame) == CGRect(x: -20, y: -213, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .left, anchorPoint: UnitPoint(x: 0.1, y: 0.2), gap: 13)
      expect(frame) == CGRect(x: -113, y: 0, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .bottom, anchorPoint: UnitPoint(x: 0.1, y: 0.2), gap: 13)
      expect(frame) == CGRect(x: -20, y: 513, width: 100, height: 200)
    }

    do {
      let frame = Layout.anchor(rect: childSize, relativeTo: CGRect(origin: .zero, size: containerSize), edge: .right, anchorPoint: UnitPoint(x: 0.1, y: 0.2), gap: 13)
      expect(frame) == CGRect(x: 313, y: 0, width: 100, height: 200)
    }
  }

  func testMaxSize() {
    // when aspect ratio is > 1
    do {
      let aspectRatio: Double = 2

      // when bounding size is > aspect ratio
      do {
        let boundingSize = CGSize(100, 25)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(50, 25)
      }

      // when bounding size is == aspect ratio
      do {
        let boundingSize = CGSize(50, 25)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(50, 25)
      }

      // when bounding size is < aspect ratio
      do {
        let boundingSize = CGSize(40, 25)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(40, 20)
      }
    }

    // when aspect ratio is == 1
    do {
      let aspectRatio: Double = 1

      // when bounding size is > aspect ratio
      do {
        let boundingSize = CGSize(100, 25)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(25, 25)
      }

      // when bounding size is == aspect ratio
      do {
        let boundingSize = CGSize(50, 50)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(50, 50)
      }

      // when bounding size is < aspect ratio
      do {
        let boundingSize = CGSize(10, 20)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(10, 10)
      }
    }

    // when aspect ratio is < 1
    do {
      let aspectRatio: Double = 0.6

      // when bounding size is > aspect ratio
      do {
        let boundingSize = CGSize(100, 25)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(15, 25)
      }

      // when bounding size is == aspect ratio
      do {
        let boundingSize = CGSize(60, 100)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(60, 100)
      }

      // when bounding size is < aspect ratio
      do {
        let boundingSize = CGSize(10, 20)
        let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
        expect(size) == CGSize(10, 16.666666666666667)
      }
    }
  }
}

// class LayoutTests: QuickSpec {

//   override func spec() {

//     describe("static maxSize(in:aspectRatio:)") {

//       context("when aspect ratio is < 1") {
//         let aspectRatio: Double = 0.6
//         context("when bounding size is > aspect ratio") {
//           let boundingSize = CGSize(100, 25)
//           it("should return correct size") {
//             let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
//             expect(size) == CGSize(15, 25)
//           }
//         }

//         context("when bounding size is == aspect ratio") {
//           let boundingSize = CGSize(60, 100)
//           it("should return correct size") {
//             let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
//             expect(size) == CGSize(60, 100)
//           }
//         }

//         context("when bounding size is < aspect ratio") {
//           let boundingSize = CGSize(10, 20)
//           it("should return correct size") {
//             let size = Layout.maxSize(in: boundingSize, aspectRatio: aspectRatio)
//             expect(size) == CGSize(10, 16.666666666666667)
//           }
//         }
//       }
//     }
//   }
// }
