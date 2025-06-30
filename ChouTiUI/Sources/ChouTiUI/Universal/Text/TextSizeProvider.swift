//
//  TextSizeProvider.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/30/22.
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

import ChouTi

// TODO: To use https://github.com/honghaoz/ComposeUI/blob/15e65c3476b22303f5cad51ad92b428390832d92/ComposeUI/Sources/ComposeUI/Extensions/NSAttributedString%2BSizing.swift="{{{{{

/// A utility class for calculating text sizes.
public final class TextSizeProvider {

  public static let shared = TextSizeProvider()

  // private static let helperLabel = Label()

  public enum LayoutMode: Hashable {

    // /// Use a helper Label with `sizeThatFits`.
    // case label

    /// Use `NSAttributedString.boundingRect(with:options:context:)`.
    case attributedString

    /// Use `CTFramesetterSuggestFrameSizeWithConstraints(_:_:_:_:_:)`
    ///
    /// For multiline text, the width is the most accurate. It returns the intrinsic size within the layout width.
    case coreTextSuggestFrameSizeWithConstraints

    /// Use `CTLine` with manual computation.
    case coreTextLines
  }

  /// Returns text bounding rect size.
  ///
  /// - Parameters:
  ///   - attributedString: The attributed string.
  ///   - numberOfLines: The max number of lines. The bounding rectangle height is bounded by this number.
  ///   - layoutWidth: The proposing layout width.
  ///   - lineWrap: The line wrap mode to use.
  ///   - layoutMode: The layout mode to use.
  /// - Returns: The bounding rect size, is integral size.
  public func boundingRectSize(for attributedString: NSAttributedString,
                               numberOfLines: Int,
                               layoutWidth: CGFloat = .greatestFiniteMagnitude,
                               lineWrap: LineWrapMode = .byWord,
                               layoutMode: LayoutMode = .coreTextLines) -> CGSize
  {
    let attributedString = attributedString.updateLineWrap(lineWrap)

    let size: CGSize
    switch layoutMode {
    // case .label:
    //   size = self.boundingRectSizeWithLabel(for: attributedString, numberOfLines: numberOfLines, layoutWidth: layoutWidth)
    case .attributedString:
      size = self.boundingRectSizeWithAttributedString(for: attributedString, numberOfLines: numberOfLines, layoutWidth: layoutWidth)
    case .coreTextSuggestFrameSizeWithConstraints:
      size = self.boundingRectSizeWithCoreTextSuggestFrameSizeWithConstraints(for: attributedString, numberOfLines: numberOfLines, layoutWidth: layoutWidth)
    case .coreTextLines:
      size = self.boundingRectSizeWithCoreTextLines(for: attributedString, numberOfLines: numberOfLines, layoutWidth: layoutWidth)
    }

    return size
  }

  // /// Returns text bounding rect size.
  // ///
  // /// Uses `Label` under the hood.
  // /// - one line text returns the intrinsic size.
  // /// - multiline text returns size constrained by `numberOfLines` and `multilineLayoutWidth`.
  // ///
  // /// The line break mode in attributed string doesn't affect the bounding rect size.
  // ///
  // /// - Parameters:
  // ///   - attributedString: The attributed string.
  // ///   - numberOfLines: The max number of lines.
  // ///   - layoutWidth: The proposing layout width. If `numberOfLines != 1`, this value has no effects.
  // /// - Returns: The bounding rect size, is integral size.
  // private func boundingRectSizeWithLabel(for attributedString: NSAttributedString,
  //                                        numberOfLines: Int,
  //                                        layoutWidth: CGFloat) -> CGSize
  // {
  //   guard attributedString.length > 0 else {
  //     return .zero
  //   }
  //
  //   let label = TextSizeProvider.helperLabel
  //   label.attributedText = attributedString
  //
  //   #if canImport(AppKit)
  //   if numberOfLines == 1 {
  //     label.setToSingleLineMode()
  //   } else {
  //     label.setToMultilineMode(numberOfLines: numberOfLines)
  //   }
  //   #endif
  //   #if canImport(UIKit)
  //   label.numberOfLines = numberOfLines
  //   #endif
  //
  //   let boundingRectSize = label.sizeThatFits(CGSize(layoutWidth, .greatestFiniteMagnitude))
  //   return boundingRectSize
  // }

  private func boundingRectSizeWithAttributedString(for attributedString: NSAttributedString,
                                                    numberOfLines: Int,
                                                    layoutWidth: CGFloat) -> CGSize
  {
    guard attributedString.length > 0 else {
      return .zero
    }

    let layoutHeight: CGFloat
    if numberOfLines <= 0 {
      layoutHeight = .greatestFiniteMagnitude
    } else {
      let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
      let frameHeight: CGFloat = 1000000000
      let path = CGPath(rect: CGRect(x: 0, y: 0, width: layoutWidth, height: frameHeight), transform: nil)

      let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

      guard let lines = CTFrameGetLines(frame) as? [CTLine], lines.count > 0 else {
        ChouTi.assertFailure("failed to get non-empty lines")
        return .zero
      }

      let linesCount = lines.count

      if numberOfLines >= linesCount {
        layoutHeight = .greatestFiniteMagnitude
      } else {
        let endLineIndex: Int = numberOfLines - 1

        var lineOrigins = [CGPoint](repeating: .zero, count: linesCount)
        CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &lineOrigins)
        let lineOriginYs = lineOrigins.map { frameHeight - $0.y }

        /// the origin is relative to the bottom left corner of the path bounding box.
        let endLineOrigin = lineOriginYs[endLineIndex]

        let endLine = lines[endLineIndex]
        var endLineDescent: CGFloat = 0
        var endLineLeading: CGFloat = 0
        _ = CTLineGetTypographicBounds(endLine, nil, &endLineDescent, &endLineLeading)
        let endLineBottom = endLineOrigin + endLineDescent + endLineLeading
        layoutHeight = endLineBottom
      }
    }

    #if os(macOS)
    var options: NSString.DrawingOptions = []
    if numberOfLines != 1 {
      options = [
        .usesLineFragmentOrigin, // for multiline
        // .usesDeviceMetrics // measures the text image height, aka the exact height (no top/bottom padding)
        // .usesFontLeading // for .byClipping/.byTruncatingMiddle, etc, the height is slightly taller (23 vs 23.55)
      ]
    }
    #else
    var options: NSStringDrawingOptions = []
    if numberOfLines != 1 {
      options = [
        .usesLineFragmentOrigin, // for multiline
        // .usesDeviceMetrics // measures the text image height, aka the exact height (no top/bottom padding)
        // .usesFontLeading // for .byClipping/.byTruncatingMiddle, etc, the height is slightly taller (23 vs 23.55)
      ]
    }
    #endif

    return attributedString.boundingRect(
      with: CGSize(layoutWidth, layoutHeight),
      options: options,
      context: nil
    ).size
  }

  private func boundingRectSizeWithCoreTextSuggestFrameSizeWithConstraints(for attributedString: NSAttributedString,
                                                                           numberOfLines: Int,
                                                                           layoutWidth: CGFloat) -> CGSize
  {
    guard attributedString.length > 0 else {
      return .zero
    }

    let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)

    let layoutHeight: CGFloat
    if numberOfLines <= 0 {
      layoutHeight = .greatestFiniteMagnitude
    } else {
      let frameHeight: CGFloat = 1000000000
      let path = CGPath(rect: CGRect(x: 0, y: 0, width: layoutWidth, height: frameHeight), transform: nil)

      let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

      guard let lines = CTFrameGetLines(frame) as? [CTLine], lines.count > 0 else {
        ChouTi.assertFailure("failed to get non-empty lines")
        return .zero
      }

      let linesCount = lines.count

      if numberOfLines >= linesCount {
        layoutHeight = .greatestFiniteMagnitude
      } else {
        let endLineIndex: Int = numberOfLines - 1

        var lineOrigins = [CGPoint](repeating: .zero, count: linesCount)
        CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &lineOrigins)
        let lineOriginYs = lineOrigins.map { frameHeight - $0.y }

        /// the origin is relative to the bottom left corner of the path bounding box.
        let endLineOrigin = lineOriginYs[endLineIndex]

        let endLine = lines[endLineIndex]
        var endLineDescent: CGFloat = 0
        var endLineLeading: CGFloat = 0
        _ = CTLineGetTypographicBounds(endLine, nil, &endLineDescent, &endLineLeading)
        let endLineBottom = endLineOrigin + endLineDescent + endLineLeading
        layoutHeight = endLineBottom
      }
    }

    return CTFramesetterSuggestFrameSizeWithConstraints(
      framesetter,
      CFRange(location: 0, length: 0),
      nil,
      CGSize(layoutWidth, layoutHeight),
      nil
    )
  }

  private func boundingRectSizeWithCoreTextLines(for attributedString: NSAttributedString,
                                                 numberOfLines: Int,
                                                 layoutWidth: CGFloat) -> CGSize
  {
    guard attributedString.length > 0 else {
      return .zero
    }

    let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
    let frameHeight: CGFloat = 1000000000
    let path = CGPath(rect: CGRect(x: 0, y: 0, width: layoutWidth, height: frameHeight), transform: nil)

    let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

    guard let lines = CTFrameGetLines(frame) as? [CTLine], lines.count > 0 else {
      ChouTi.assertFailure("failed to get non-empty lines")
      return .zero
    }

    let linesCount = lines.count

    let endLineIndex: Int
    if numberOfLines <= 0 || numberOfLines >= linesCount {
      endLineIndex = linesCount - 1
    } else {
      endLineIndex = numberOfLines - 1
    }

    var lineOrigins = [CGPoint](repeating: .zero, count: linesCount)
    CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &lineOrigins)
    let lineOriginYs = lineOrigins.map { frameHeight - $0.y }

    /// the origin is relative to the bottom left corner of the path bounding box.
    let endLineOrigin = lineOriginYs[endLineIndex]

    let endLine = lines[endLineIndex]
    var endLineDescent: CGFloat = 0
    var endLineLeading: CGFloat = 0
    _ = CTLineGetTypographicBounds(endLine, nil, &endLineDescent, &endLineLeading)
    let endLineBottom = endLineOrigin + endLineDescent + endLineLeading

    // swiftlint:disable:next force_unwrapping
    let maxWidth = lines.map { CTLineGetBoundsWithOptions($0, []).width }.max()!
    return CGSize(width: maxWidth, height: endLineBottom)
  }

  /// Returns single line text bounding box size in fractional size.
  ///
  /// For multiline text, only the first line size is returned.
  ///
  /// - Parameters:
  ///   - attributedString: The attributed string.
  ///   - layoutWidth: The proposing layout width. This width determines the final size's width if it is smaller than the text's intrinsic size.
  /// - Returns: The bounding box for the text.
  public func singleLineTextBoundingRectSize(for attributedString: NSAttributedString,
                                             layoutWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize
  {
    /// For this text:
    /// ```
    /// NSAttributedString(
    ///   string: "01234 abgh ABGH",
    ///   attributes: [
    ///     .font: Font.HelveticaNeue.regular(size: 10) as Font,
    ///     .foregroundColor: Color.black,
    ///   ]
    /// )
    /// ```
    ///
    /// Using Method 1 returns a frame that height is a little bit small that `g`'s bottom is cut off

    // Method 1
    //
    // attributedString.boundingRect(
    //   with: CGSize(layoutWidth, .greatestFiniteMagnitude),
    //   options: [
    //     // .usesLineFragmentOrigin, // for multiline
    //     // .usesDeviceMetrics // measures the text image height, aka the exact height (no top/bottom padding)
    //     // .usesFontLeading // for .byClipping/.byTruncatingMiddle, etc, the height is slightly taller (23 vs 23.55)
    //   ],
    //   context: nil
    // ).size

    // Method 2
    guard attributedString.length > 0 else {
      return .zero
    }

    let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
    let frameWidth: CGFloat = 1e9
    let frameHeight: CGFloat = 1e9
    let path = CGPath(rect: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight), transform: nil)

    let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

    guard let lines = CTFrameGetLines(frame) as? [CTLine], lines.count > 0 else {
      ChouTi.assertFailure("failed to get non-empty lines")
      return .zero
    }

    let linesCount = lines.count
    var lineOrigins = [CGPoint](repeating: .zero, count: linesCount)
    CTFrameGetLineOrigins(frame, CFRange(location: 0, length: 0), &lineOrigins)
    let lineOriginY = frameHeight - lineOrigins[0].y

    let line = lines[0] // only take the first line size
    var descent: CGFloat = 0
    var leading: CGFloat = 0
    let width = CTLineGetTypographicBounds(line, nil, &descent, &leading)
    let lineBottom = lineOriginY + descent + leading

    return CGSize(width: min(width, layoutWidth), height: lineBottom)
  }
}

private extension NSAttributedString {

  /// Update attributedString to have correct line wrap mode.
  ///
  /// The CoreText returns decreased number of lines (CTLine) if paragraph style have the `lineBreakMode` set to truncating mode such as `.byTruncatingTail`.
  /// In this case, each line can have two `CTRun`s.
  /// While with `byWord` or `byChar` line break mode, CoreText can return correct lines with each line have one `CTRun`.
  func updateLineWrap(_ lineWrap: LineWrapMode) -> NSAttributedString {
    let attributedString = self.mutable(alwaysCopy: false)
    let lineBreakModeToSet = lineWrap.lineBreakMode
    attributedString.enumerateAttribute(.paragraphStyle, in: attributedString.fullRange, options: []) { value, range, stop in
      if let paragraphStyle = value as? NSParagraphStyle {
        // update paragraphStyle to use .byWordWrapping if not
        if paragraphStyle.lineBreakMode != lineBreakModeToSet {
          guard let newParagraphStyle = paragraphStyle.mutableCopy() as? NSMutableParagraphStyle else {
            return
          }
          newParagraphStyle.lineBreakMode = lineBreakModeToSet
          attributedString.addAttribute(.paragraphStyle, value: newParagraphStyle, range: range)
        }
      }
    }
    return attributedString
  }
}

/**
 Performance Tests:
 ```
 // 1) with same string, random widths
 // [label                                  ] elapsed time: 0.08288395832641982
 // [attributedString                       ] elapsed time: 0.3300661666726228
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.18834166665328667
 // [coreTextLines                          ] elapsed time: 0.17581358333700337

 // [label                                  ] elapsed time: 0.08228508333559148
 // [attributedString                       ] elapsed time: 0.32624587501049973
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.19185412500519305
 // [coreTextLines                          ] elapsed time: 0.17434537498047575

 // [label                                  ] elapsed time: 0.09228941664332524
 // [attributedString                       ] elapsed time: 0.37269487499725074
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.2313246249977965
 // [coreTextLines                          ] elapsed time: 0.206279166683089

 // [label                                  ] elapsed time: 0.09166295832255855
 // [attributedString                       ] elapsed time: 0.3738432083046064
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.22853862500051036
 // [coreTextLines                          ] elapsed time: 0.21010420835227706

 // 2) with different string, random width
 // [label                                  ] elapsed time: 0.5815834999957588
 // [attributedString                       ] elapsed time: 0.5925072083482519
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.3672845416585915
 // [coreTextLines                          ] elapsed time: 0.3252504999982193

 // [label                                  ] elapsed time: 0.5767819999891799
 // [attributedString                       ] elapsed time: 0.5925822500139475
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.3684547083103098
 // [coreTextLines                          ] elapsed time: 0.32496308331610635

 // [label                                  ] elapsed time: 0.5705404166656081
 // [attributedString                       ] elapsed time: 0.5895631249877624
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.37095433330978267
 // [coreTextLines                          ] elapsed time: 0.3302912916697096

 // [label                                  ] elapsed time: 0.5994176666426938
 // [attributedString                       ] elapsed time: 0.59134045834071
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.36235675000352785
 // [coreTextLines                          ] elapsed time: 0.33033858332782984

 // [label                                  ] elapsed time: 0.5775550416728947
 // [attributedString                       ] elapsed time: 0.5854262083303183
 // [coreTextSuggestFrameSizeWithConstraints] elapsed time: 0.3587589999951888
 // [coreTextLines                          ] elapsed time: 0.3278580416808836

 let string = NSMutableAttributedString(string: "This is a beautiful text doc with some random text, long enough to spread to multi lines", attributes: [:])
 let fullRange = NSRange(location: 0, length: string.length)
 string.addAttributes([.font: UIFont(name: "HelveticaNeue", size: 20)!], range: fullRange)
 string.setAttributes([.font: UIFont(name: "HelveticaNeue", size: 40)!], range: NSRange(25, 8))
 string.addAttributes([.foregroundColor: UIColor.black], range: fullRange)

 let style = NSMutableParagraphStyle()
 style.lineBreakMode = NSLineBreakMode.byWordWrapping
 style.lineBreakStrategy = []
 style.lineSpacing = 10
 string.addAttributes([.paragraphStyle: style], range: fullRange)

 let string2 = NSMutableAttributedString(string: "with some random text, long enough to spread to multi lines", attributes: [:])
 let fullRange2 = NSRange(location: 0, length: string2.length)
 string2.addAttributes([.font: UIFont(name: "HelveticaNeue", size: 20)!], range: fullRange2)
 string2.setAttributes([.font: UIFont(name: "HelveticaNeue", size: 40)!], range: NSRange(25, 8))
 string2.addAttributes([.foregroundColor: UIColor.black], range: fullRange2)

 let style2 = NSMutableParagraphStyle()
 style2.lineBreakMode = NSLineBreakMode.byWordWrapping
 style2.lineBreakStrategy = []
 style2.lineSpacing = 10
 string2.addAttributes([.paragraphStyle: style2], range: fullRange2)

 PerformanceMeasurer.measure(tag: "label", tagLength: 39, repeatCount: 10000) {
   _ = TextSizeProvider.shared.boundingRectSize(for: string, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .label)
   _ = TextSizeProvider.shared.boundingRectSize(for: string2, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .label)
 }
 PerformanceMeasurer.measure(tag: "attributedString", tagLength: 39, repeatCount: 10000) {
   _ = TextSizeProvider.shared.boundingRectSize(for: string, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .attributedString)
   _ = TextSizeProvider.shared.boundingRectSize(for: string2, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .attributedString)
 }
 PerformanceMeasurer.measure(tag: "coreTextSuggestFrameSizeWithConstraints", tagLength: 39, repeatCount: 10000) {
   _ = TextSizeProvider.shared.boundingRectSize(for: string, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .coreTextSuggestFrameSizeWithConstraints)
   _ = TextSizeProvider.shared.boundingRectSize(for: string2, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .coreTextSuggestFrameSizeWithConstraints)
 }
 PerformanceMeasurer.measure(tag: "coreTextLines", tagLength: 39, repeatCount: 10000) {
   _ = TextSizeProvider.shared.boundingRectSize(for: string, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .coreTextLines)
   _ = TextSizeProvider.shared.boundingRectSize(for: string2, numberOfLines: 3, layoutWidth: CGFloat.random(in: 10 ... 1000), layoutMode: .coreTextLines)
 }
 ```
 */

/**
 UIFont learnings
 https://www.cocoanetics.com/2010/02/understanding-uifont/
 */

// MARK: - Deprecated

/**
 Learnings:
 - Use `NSAttributedString` as key in cache is slow.
 - Converting `NSAttributedString` to `AttributedString` is extremely slow.
 */

/// Commented out as the cache key is not reliable because NSAttributedString is a reference type.
//
//  private struct CacheKey: Hashable {
//    let attributedString: NSAttributedString
//    let numberOfLines: Int
//    let layoutWidth: CGFloat
//    let layoutMode: LayoutMode
//  }
//
//  private lazy var textSizeCache = Cache<CacheKey, CGSize>()
//
//  private struct SingleLineCacheKey: Hashable {
//
//    let attributedString: NSAttributedString
//    let layoutWidth: CGFloat
//
//    func hash(into hasher: inout Hasher) {
//      hasher.combine(attributedString.string)
//
//      attributedString.enumerateAttributes(in: attributedString.fullRange, options: []) { attributes, range, _ in
//        for (key, value) in attributes {
//          switch key {
//          case .font,
//              .foregroundColor,
//              .paragraphStyle,
//              .shadow,
//              .backgroundColor,
//              .strokeColor,
//              .strokeWidth,
//              .underlineStyle,
//              .strikethroughStyle:
//            hasher.combine(key)
//            if let value = value as? (any Hashable) {
//              hasher.combine(value)
//            } else {
//              hasher.combine("\(value)")
//            }
//            hasher.combine(range)
//          default:
//            break
//          }
//        }
//      }
//
//      hasher.combine(layoutWidth)
//    }
//  }
//
//  private lazy var singleLineTextSizeCache = Cache<SingleLineCacheKey, CGSize>()

/// Using `AttributedString` as the key is extremely slow.
//
//  @available(iOS 15, *)
//  private class TextSizeCache {
//
//    static let shared = TextSizeCache()
//
//    struct MultilineKey: Hashable {
//
//      let attributedString: AttributedString
//      let numberOfLines: Int
//      let layoutWidth: CGFloat
//      let lineWrap: LineWrapMode
//      let layoutMode: TextSizeProvider.LayoutMode
//
//      init(attributedString: NSAttributedString,
//           numberOfLines: Int,
//           layoutWidth: CGFloat,
//           lineWrap: LineWrapMode,
//           layoutMode: TextSizeProvider.LayoutMode) {
//        self.attributedString = AttributedString(attributedString) // This is very slow, making the cache pointless
//        self.numberOfLines = numberOfLines
//        self.layoutWidth = layoutWidth
//        self.lineWrap = lineWrap
//        self.layoutMode = layoutMode
//      }
//    }
//
//    private(set) lazy var multilineCache = Cache<MultilineKey, CGSize>()
//  }
//
//  if #available(iOS 15, *) {
//    let key = TextSizeCache.MultilineKey(
//      attributedString: attributedString,
//      numberOfLines: numberOfLines,
//      layoutWidth: layoutWidth,
//      lineWrap: lineWrap,
//      layoutMode: layoutMode
//    )
//    if let cachedSize = TextSizeCache.shared.multilineCache[key] {
//      return cachedSize
//    }
//
//    let size = calculateSize()
//
//    TextSizeCache.shared.multilineCache[key] = size
//    return size
//  } else {
//    return calculateSize()
//  }
