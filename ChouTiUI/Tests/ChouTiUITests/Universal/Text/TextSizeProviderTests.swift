//
//  TextSizeProviderTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/6/24.
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

import CoreGraphics
import CoreText

import ChouTiTest

import ChouTi
import ChouTiUI

class TextSizeProviderTests: XCTestCase {

  func test_singleLine() throws {
    // one line attributed string
    do {
      // when attribute string is empty
      do {
        let attributedString = NSAttributedString(string: "")
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString)
        expect(size) == .zero
      }

      let attributedString = try NSAttributedString(
        string: "01234 abgh ABGH",
        attributes: [
          .font: Font(name: "HelveticaNeue", size: 10).unwrap(),
          .foregroundColor: Color.black,
          .paragraphStyle: {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineBreakMode = .byTruncatingTail
            return style
          }(),
        ]
      )

      // when layout width is unlimited
      do {
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString)
        expect(size.width).to(beApproximatelyEqual(to: 84.1, within: 1e-9))
        expect(size.height).to(beApproximatelyEqual(to: 12.409999999999998, within: 1e-4))
      }

      // when layout width is big
      do {
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString, layoutWidth: 100)
        expect(size.width).to(beApproximatelyEqual(to: 84.1, within: 1e-9))
        expect(size.height).to(beApproximatelyEqual(to: 12.409999999999998, within: 1e-4))
      }

      // when layout width is small
      do {
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString, layoutWidth: 42.3)
        expect(size.width).to(beApproximatelyEqual(to: 42.3, within: 1e-9))
        expect(size.height).to(beApproximatelyEqual(to: 12.409999999999998, within: 1e-4))
      }
    }

    // multiline attributed string
    do {
      let attributedString = try NSAttributedString(
        string: "01234 abgh ABGH\nthis is next line\nand more",
        attributes: [
          .font: Font(name: "HelveticaNeue", size: 10).unwrap(),
          .foregroundColor: Color.black,
          .paragraphStyle: {
            let style = NSMutableParagraphStyle()
            style.alignment = .natural
            style.lineBreakMode = .byTruncatingTail
            return style
          }(),
        ]
      )

      // when layout width is unlimited
      do {
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString)
        expect(size.width).to(beApproximatelyEqual(to: 84.1, within: 1e-9))
        expect(size.height).to(beApproximatelyEqual(to: 12.409999999999998, within: 1e-4))
      }

      // when layout width is big
      do {
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString, layoutWidth: 100)
        expect(size.width).to(beApproximatelyEqual(to: 84.1, within: 1e-9))
        expect(size.height).to(beApproximatelyEqual(to: 12.409999999999998, within: 1e-4))
      }

      // when layout width is small
      do {
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString, layoutWidth: 42.3)
        expect(size.width).to(beApproximatelyEqual(to: 42.3, within: 1e-9))
        expect(size.height).to(beApproximatelyEqual(to: 12.409999999999998, within: 1e-4))
      }
    }
  }

  func test_multiline() throws {
    // empty string
    do {
      expect(TextSizeProvider.shared.boundingRectSize(for: NSAttributedString(string: ""), numberOfLines: 2)) == .zero
    }

    let attributedString = try NSAttributedString(
      string: "Think different. Your time is limited, so don’t waste it living someone else’s life. Stay hungry. Stay foolish. 0123456789 abcedfghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ",
      attributes: [
        .font: Font(name: "HelveticaNeue", size: 20).unwrap(),
        .foregroundColor: Color.black,
        .paragraphStyle: {
          let style = NSMutableParagraphStyle()
          style.alignment = .natural
          style.lineBreakMode = .byTruncatingTail
          return style
        }(),
      ]
    )

    // default layout mode
    do {
      // 1 line, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: .greatestFiniteMagnitude)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
      }

      // 1 line, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 2000)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
      }

      // 1 line, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 300)
        expect(size.width) == 297.1
        expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
      }

      // 2 lines, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: .greatestFiniteMagnitude)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
      }

      // 2 lines, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 2000)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
      }

      // 2 lines, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 300)
        expect(size.width) == 297.1
        expect(size.height).to(beApproximatelyEqual(to: 47.8199462890625, within: 1e-4))
      }

      // 3 lines, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: .greatestFiniteMagnitude)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
      }

      // 3 lines, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 2000)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
      }

      // 3 lines, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 300)
        expect(size.width) == 297.1
        expect(size.height).to(beApproximatelyEqual(to: 71.8199462890625, within: 1e-4))
      }
    }

    //  // layout mode: label
    //  do {
    //    // empty string
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: NSAttributedString(), numberOfLines: 1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .label)
    //      expect(size.width) == 0
    //      expect(size.height) == 0
    //    }
    //
    //    // 1 line, unlimited
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 1 line, big
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 2000, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 1 line, small
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 300, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 2 lines, unlimited
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: .greatestFiniteMagnitude, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 2 lines, big
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 2000, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 2 lines, small
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 300, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 273.68
    //      expect(size.height).to(beApproximatelyEqual(to: 46, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 270
    //      expect(size.height).to(beApproximatelyEqual(to: 47, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 270.0
    //      expect(size.height).to(beApproximatelyEqual(to: 47, within: 1e-4))
    //      #else
    //      expect(size.width) == 270.0
    //      expect(size.height).to(beApproximatelyEqual(to: 46.666666666666664, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 3 lines, unlimited
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: .greatestFiniteMagnitude, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 3 lines, big
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 2000, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 3 lines, small
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 300, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 295.54
    //      expect(size.height).to(beApproximatelyEqual(to: 69, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 292
    //      expect(size.height).to(beApproximatelyEqual(to: 70, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 292
    //      expect(size.height).to(beApproximatelyEqual(to: 70, within: 1e-4))
    //      #else
    //      expect(size.width) == 291.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 70, within: 1e-4))
    //      #endif
    //    }
    //
    //    // 0 number of lines
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 0, layoutWidth: .greatestFiniteMagnitude, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //
    //    // negative number of lines
    //    do {
    //      let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: -1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .label)
    //      #if os(macOS)
    //      expect(size.width) == 1667.3399999999997
    //      expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
    //      #elseif os(tvOS)
    //      expect(size.width) == 1664.0
    //      expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
    //      #elseif os(visionOS)
    //      expect(size.width) == 1663.5
    //      expect(size.height).to(beApproximatelyEqual(to: 23.5, within: 1e-4))
    //      #else
    //      expect(size.width) == 1663.6666666666667
    //      expect(size.height).to(beApproximatelyEqual(to: 23.333333333333332, within: 1e-4))
    //      #endif
    //    }
    //  }

    // layout mode: attributedString
    do {
      // empty string
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: NSAttributedString(), numberOfLines: 1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .attributedString)
        expect(size.width) == 0
        expect(size.height) == 0
      }

      // 1 line, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // 1 line, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 2000, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // 1 line, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 300, layoutMode: .attributedString)
        expect(size.width) == 300
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // 2 lines, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: .greatestFiniteMagnitude, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // 2 lines, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 2000, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // 2 lines, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 300, layoutMode: .attributedString)
        expect(size.width) == 269.68
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 46, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 46.599999999999994, within: 1e-4))
        #endif
      }

      // 3 lines, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: .greatestFiniteMagnitude, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // 3 lines, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 2000, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // 3 lines, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 300, layoutMode: .attributedString)
        expect(size.width) == 291.54
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 69, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 69.89999999999999, within: 1e-4))
        #endif
      }

      // 0 number of lines
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 0, layoutWidth: .greatestFiniteMagnitude, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }

      // negative number of lines
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: -1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .attributedString)
        expect(size.width) == 1663.3399999999997
        #if os(macOS)
        expect(size.height).to(beApproximatelyEqual(to: 23, within: 1e-4))
        #else
        expect(size.height).to(beApproximatelyEqual(to: 23.299999999999997, within: 1e-4))
        #endif
      }
    }

    // layout mode: coreTextSuggestFrameSizeWithConstraints
    do {
      // empty string
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: NSAttributedString(), numberOfLines: 1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 0
        expect(size.height) == 0
      }

      // 1 line, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // 1 line, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 2000, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // 1 line, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 1, layoutWidth: 300, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 242.36
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // 2 lines, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: .greatestFiniteMagnitude, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // 2 lines, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 2000, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // 2 lines, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 2, layoutWidth: 300, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 269.68
        expect(size.height).to(beApproximatelyEqual(to: 48, within: 1e-4))
      }

      // 3 lines, unlimited
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: .greatestFiniteMagnitude, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // 3 lines, big
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 2000, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // 3 lines, small
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 3, layoutWidth: 300, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 291.54
        expect(size.height).to(beApproximatelyEqual(to: 72, within: 1e-4))
      }

      // 0 number of lines
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 0, layoutWidth: .greatestFiniteMagnitude, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }

      // negative number of lines
      do {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: -1, layoutWidth: .greatestFiniteMagnitude, layoutMode: .coreTextSuggestFrameSizeWithConstraints)
        expect(size.width) == 1663.3399999999997
        expect(size.height).to(beApproximatelyEqual(to: 24, within: 1e-4))
      }
    }
  }

  func test_cache() throws {
    let attributedString = try NSMutableAttributedString(
      string: "01234 abgh ABGH test",
      attributes: [
        .font: Font(name: "HelveticaNeue", size: 10).unwrap(),
        .foregroundColor: Color.black,
        .paragraphStyle: {
          let style = NSMutableParagraphStyle()
          style.alignment = .center
          style.lineBreakMode = .byTruncatingTail
          return style
        }(),
      ]
    )

    var size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 0, layoutWidth: 300)
    expect(size.width) == 103.55000000000003
    expect(size.height).to(beApproximatelyEqual(to: 12.409999999999998, within: 1e-4))

    try attributedString.addAttributes([.font: Font(name: "HelveticaNeue", size: 20).unwrap()], range: attributedString.fullRange)
    size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 0, layoutWidth: 300)
    expect(size.width) == 207.10000000000005
    expect(size.height).to(beApproximatelyEqual(to: 23.819999999999997, within: 1e-4))
  }

  func test_performance() throws {
    // single line performance test
    do {
      let attributedString = try NSAttributedString(
        string: "01234 abgh ABGH test",
        attributes: [
          .font: Font(name: "HelveticaNeue", size: 10).unwrap(),
          .foregroundColor: Color.black,
          .paragraphStyle: {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineBreakMode = .byTruncatingTail
            return style
          }(),
        ]
      )

      // [size-with-cache] elapsed time: 0.006561083340784535
      // [size-no-cache  ] elapsed time: 0.04475166666088626
      PerformanceMeasurer.measure(tag: "one", tagLength: 11, repeatCount: 10000) {
        let size = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString, layoutWidth: 42.3)
        _ = size
      }
    }

    // multi-line performance test
    do {
      let attributedString = try NSAttributedString(
        string: "01234 abgh ABGH test\nmany new line texts",
        attributes: [
          .font: Font(name: "HelveticaNeue", size: 10).unwrap(),
          .foregroundColor: Color.black,
          .paragraphStyle: {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineBreakMode = .byTruncatingTail
            return style
          }(),
        ]
      )

      // [size-with-cache] elapsed time: 0.00486924999859184
      // [size-no-cache  ] elapsed time: 0.20449366664979607
      PerformanceMeasurer.measure(tag: "multi", tagLength: 11, repeatCount: 10000) {
        let size = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 0, layoutWidth: 23, layoutMode: .coreTextLines)
        _ = size
      }
    }
  }
}
