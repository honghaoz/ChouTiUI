//
//  NSLabel.swift
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit

/// A macOS counter part of `UILabel`.
///
/// - The label renders the text vertically centered to match UILabel's default behavior.
/// - By default, the label is single-line.
/// - In single-line mode, `lineBreakMode` can be set to `.byTruncatingTail`, `.byTruncatingMiddle`, `.byTruncatingHead`, or `.byClipping`.
/// - To support multiline text, set `numberOfLines` to 0 (unlimited) or 2+ and `lineBreakMode` to `.byWordWrapping` or `.byCharWrapping`.
/// - In multiline mode, the label only supports `.byTruncatingTail` truncation mode, with `multilineTruncatesLastVisibleLine` set to `true`.
open class NSLabel: NSTextField {

  override public class var cellClass: AnyClass? {
    get {
      BaseNSTextFieldCell.self
    }
    set {}
  }

  private var theCell: BaseNSTextFieldCell? {
    (cell as? BaseNSTextFieldCell).assert("cell is not BaseNSTextFieldCell")
  }

  /// The vertical alignment of the text. Default to `.center`.
  public var verticalAlignment: TextVerticalAlignment {
    get {
      theCell?.verticalAlignment ?? .center
    }
    set {
      theCell?.verticalAlignment = newValue
    }
  }

  /// The text of the label. Default to `""`.
  ///
  /// Setting `text` to `nil` will set the `text` to `""`.
  public var text: String? {
    get {
      stringValue
    }
    set {
      stringValue = newValue ?? ""
    }
  }

  /// If the label is in multiline mode, this property controls whether the label truncates the text at the end of the last visible line.
  ///
  /// Default to `true`.
  public var multilineTruncatesLastVisibleLine: Bool {
    get {
      theCell?.truncatesLastVisibleLine ?? false
    }
    set {
      theCell?.truncatesLastVisibleLine = newValue
    }
  }

  override public init(frame: NSRect) {
    super.init(frame: frame)
    commonInit()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    // swiftlint:disable:next fatal_error
    fatalError("init(coder:) is unavailable")
  }

  private func commonInit() {
    layerContentsRedrawPolicy = .onSetNeedsDisplay

    // Add 2 points of horizontal padding on both sides to match UILabel's layout.
    // Note: This compensates for macOS's default inset, possibly caused by the default border.
    theCell?.horizontalPadding = 2

    // Default to single line mode
    maximumNumberOfLines = 1
    cell?.truncatesLastVisibleLine = true

    /// Don't set `usesSingleLineMode` as it can affect the text baseline.
    // usesSingleLineMode = true
    // cell?.usesSingleLineMode = true

    updateCommonSettings()

    refusesFirstResponder = true

    isEditable = false
    setIsSelectable(false)
    isContinuous = false

    drawsBackground = false
    isBezeled = false
    isBordered = false

    backgroundColor = .clear

    ignoreHitTest = true
  }

  /// Set label to single line mode.
  /// - Parameter truncationMode: The text truncation mode.
  public func setToSingleLineMode(truncationMode: TextTruncationMode) {
    maximumNumberOfLines = 1

    switch truncationMode {
    case .none:
      lineBreakMode = .byClipping
    case .head:
      lineBreakMode = .byTruncatingHead
    case .tail:
      lineBreakMode = .byTruncatingTail
    case .middle:
      lineBreakMode = .byTruncatingMiddle
    }

    multilineTruncatesLastVisibleLine = false
  }

  /// Set label to multiline mode.
  /// - Parameters:
  ///   - numberOfLines: Number of lines, 0 for unlimited.
  ///   - lineWrapMode: The line wrap mode.
  ///   - truncatesLastVisibleLine: If `true`, the label truncates the text at the end of the last visible line.
  public func setToMultilineMode(numberOfLines: Int, lineWrapMode: LineWrapMode, truncatesLastVisibleLine: Bool) {
    maximumNumberOfLines = numberOfLines

    switch lineWrapMode {
    case .byWord:
      cell?.lineBreakMode = .byWordWrapping
    case .byChar:
      cell?.lineBreakMode = .byCharWrapping
    }
    multilineTruncatesLastVisibleLine = truncatesLastVisibleLine
  }

  // MARK: - Public

  /// Set label's selectable state.
  ///
  /// - Note: Set to `true` for tappable links.
  ///
  /// - Parameter isSelectable: If `true`, the label is selectable.
  open func setIsSelectable(_ isSelectable: Bool) {
    if isSelectable {
      // avoid selecting text changes font
      // https://stackoverflow.com/a/38966031/3164091
      self.isSelectable = true
      allowsEditingTextAttributes = true
    } else {
      self.isSelectable = false
      allowsEditingTextAttributes = false
    }
  }
}

#endif
