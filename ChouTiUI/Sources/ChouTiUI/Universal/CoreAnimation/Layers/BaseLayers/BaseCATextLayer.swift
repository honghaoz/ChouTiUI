//
//  BaseCATextLayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/3/23.
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

import CoreText
import QuartzCore

import ChouTi

/// A base `CATextLayer` class.
///
/// Features:
/// - Supports vertical text alignment.
/// - In multiline mode, supports line spacing customization when `usesCoreTextDrawingForMultiline` set to `true`.
/// - Doesn't support negative stroke width for both text stroke and fill color
///   https://developer.apple.com/library/archive/qa/qa1531/_index.html
///
/// Notes on text effect on iOS and macOS:
/// - The layer can render a consistent text on iOS devices and Macs.
///   - On iOS devices, the rendered text looks very close or the same compared to `UILabel`.
///   - On Macs, the text looks thinner compared to `NSLabel` (`NSTextField`). The size may affect the difference.
///     For example, 60 points font looks the same, but 10 points font looks different.
///     - TextEdit.app and `NSLabel` render the same text effects.
///     - It is recommended to use `NSLabel` for UI purposes.
///
/// Line wrap and last line truncation for multiline text:
/// |            | BaseCATextLayer (Default) | BaseCATextLayer (CoreText) | UILabel                                       | NSLabel (NSTextField) |
/// |------------|---------------------------|----------------------------|-----------------------------------------------|-----------------------|
/// | Line Wrap  | word                      | word, char                 | word, char                                    | word, char            |
/// | Truncation | none, head, tail, middle  | none                       | none, head, tail, middle (word wrapping only) | tail                  |
open class BaseCATextLayer: CATextLayer, BaseCALayerInternalType {

  /// The attributed string.
  public var attributedString: NSAttributedString? {
    if let attributedString = string as? NSAttributedString {
      return attributedString
    } else if let normalString = string as? String {
      return NSAttributedString(string: normalString, attributes: [
        .font: uiFont as Any,
        .foregroundColor: foregroundColor as Any,
        .paragraphStyle: {
          let style = NSMutableParagraphStyle()
          style.alignment = alignmentMode.nsTextAlignment
          style.lineBreakMode = .byWordWrapping
          return style
        }(),
      ])
    } else {
      return nil
    }
  }

  /// The vertical text alignment.
  ///
  /// Default value is `.top`.
  public var verticalAlignment: TextVerticalAlignment = .top

  /// If the text is multiline.
  ///
  /// Default value is `false`.
  public var isMultiline: Bool {
    get {
      isWrapped
    }
    set {
      isWrapped = newValue
    }
  }

  // TODO: compare line spacing effects among three CATextLayer, UILabel and NSLabel

  /// A flag indicates if should use Core Text to draw multiline text.
  ///
  /// Default value is `false`.
  ///
  /// - For single line text, this flag is ignored.
  /// - For multiline text, if this flag is `true`, the text can draw with correct line spacing.
  /// However, the last line truncation is not supported.
  public var usesCoreTextDrawingForMultiline: Bool = false

  /// The font of the text.
  ///
  /// Compared to `font` property, this property is more convenient to use.
  public var uiFont: Font? {
    get {
      guard let uiFont = font as? Font else {
        return nil
      }
      if uiFont.pointSize != fontSize {
        return uiFont.withSize(fontSize)
      } else {
        return uiFont
      }
    }
    set {
      font = newValue
      fontSize = newValue?.pointSize ?? 36.0
    }
  }

  // MARK: - Private

  #if DEBUG
  /// If `true`, the layer will draw bounding box with a dashed line.
  public var drawsBoundingBox: Bool = false
  #endif

  override public init() {
    super.init()

    commonInit()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    // swiftlint:disable:next fatal_error
    fatalError("init(coder:) is unavailable")
  }

  override public init(layer: Any) {
    if let layer = layer as? BaseCATextLayer {
      _debugDescription = layer._debugDescription
      verticalAlignment = layer.verticalAlignment
      usesCoreTextDrawingForMultiline = layer.usesCoreTextDrawingForMultiline
      #if DEBUG
      drawsBoundingBox = layer.drawsBoundingBox
      #endif
    }

    super.init(layer: layer)
  }

  /// Set the layer to single line mode.
  /// - Parameter truncationMode: The text truncation mode.
  public func setToSingleLineMode(truncationMode: TextTruncationMode) {
    isWrapped = false

    switch truncationMode {
    case .none:
      self.truncationMode = .none
    case .head:
      self.truncationMode = .start
    case .tail:
      self.truncationMode = .end
    case .middle:
      self.truncationMode = .middle
    }
  }

  /// Set the layer to multiline mode.
  ///
  /// Line wrapping is by word.
  ///
  /// - Parameter truncationMode: The text truncation mode.
  public func setToMultilineMode(truncationMode: TextTruncationMode) {
    isWrapped = true

    switch truncationMode {
    case .none:
      self.truncationMode = .none
    case .head:
      self.truncationMode = .start
    case .tail:
      self.truncationMode = .end
    case .middle:
      self.truncationMode = .middle
    }
  }

  /// Custom drawing to support multiline lineSpacing
  ///
  /// ⚠️ Note that the layer's bounds must be larger enough to draw the text. Otherwise, no text will draw.
  override open func draw(in context: CGContext) {
    guard let attributedString else {
      super.draw(in: context)
      return
    }

    switch verticalAlignment {
    case .top:
      super.draw(in: context)
    case .center,
         .bottom:
      context.saveGState()

      // 1) adjust y-offset
      let textSize: CGSize
      if isMultiline {
        textSize = TextSizeProvider.shared.boundingRectSize(for: attributedString, numberOfLines: 0, layoutWidth: bounds.width, layoutMode: .coreTextLines)
      } else {
        textSize = TextSizeProvider.shared.singleLineTextBoundingRectSize(for: attributedString)
      }

      let yOffset: CGFloat
      switch verticalAlignment {
      case .top:
        yOffset = 0
      case .center:
        yOffset = (bounds.height - textSize.height) / 2
      case .bottom:
        yOffset = (bounds.height - textSize.height)
      }

      let adjustedYOffset = max(yOffset, 0) // make sure text won't draw outside of bounds on top
      if adjustedYOffset != 0 {
        context.translateBy(x: 0, y: adjustedYOffset)
      }

      // 2) draw text
      if isMultiline {
        if usesCoreTextDrawingForMultiline {
          // Draw text
          // https://stackoverflow.com/questions/17779851/catextlayer-set-line-spacing
          // https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/LowerLevelText-HandlingTechnologies/LowerLevelText-HandlingTechnologies.html
          // https://github.com/cemolcay/CenterTextLayer/blob/master/Source/CenterTextLayer.swift
          context.onPushedGraphicsState { context in
            // let bounds = CGRect(0, 0, bounds.width, bounds.height + 100)
            // context.textMatrix = .identity
            context.flipCoordinatesVertically(height: bounds.height)

            #if DEBUG
            if drawsBoundingBox {
              context.setStrokeColor(Color.red.cgColor)
              context.setLineWidth(1)
              context.setLineDash(phase: 0, lengths: [2, 2])
              context.stroke(bounds)
            }
            #endif

            let framesetter = CTFramesetterCreateWithAttributedString(attributedString as CFAttributedString)
            let path = CGPath(rect: bounds, transform: nil)
            let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
            CTFrameDraw(frame, context)
          }
        } else {
          super.draw(in: context)
        }
      } else {
        super.draw(in: context)
      }

      context.restoreGState()
    }
  }

  // MARK: - BaseCALayerInternalType

  private(set) lazy var bindingObservationStorage = BindingObservationStorage()

  var _debugDescription: String?

  // MARK: - Debug

  override open var debugDescription: String {
    _debugDescription ?? super.debugDescription
  }
}

// CATextLayer and NSTextField renders the text differently
// CATextLayer can render text lighter compared to NSTextField. Maybe related to sub-pixel antialiasing?

// Read: https://www.cocoawithlove.com/2010/11/back-to-mac-12-features-from-ios-i-like.html
