//
//  BaseNSTextFieldCell.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/9/23.
//  Copyright © 2020 Honghao Zhang (github.com/honghaoz).
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang
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
import ChouTi

// TODO: make this class internal once `BaseNSTextField` is moved to ChouTiUI.

open class BaseNSTextFieldCell: NSTextFieldCell {

  /// The additional horizontal padding to add to the text frame.
  public var horizontalPadding: CGFloat = 0

  /// The vertical alignment of the text.
  public var verticalAlignment: TextVerticalAlignment = .center

  override open func drawingRect(forBounds rect: NSRect) -> NSRect {
    super.drawingRect(forBounds: adjustRect(rect))
  }

  override open func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
    super.draw(withFrame: adjustRect(cellFrame), in: controlView)
  }

  override open func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
    super.drawInterior(withFrame: adjustRect(cellFrame), in: controlView)
  }

  override open func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
    // the rect controls the text frame when editing
    super.edit(withFrame: adjustRect(rect), in: controlView, editor: textObj, delegate: delegate, event: event)
  }

  override open func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
    super.select(withFrame: adjustRect(rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
  }

  private func adjustRect(_ rect: CGRect) -> CGRect {
    let adjustRect = rect.inset(left: -horizontalPadding, right: -horizontalPadding)
    switch verticalAlignment {
    case .top:
      // by default, NSTextField uses top alignment
      return adjustRect
    case .center:
      return adjustedFrame(toVerticallyCenterText: adjustRect)
    case .bottom:
      ChouTi.assertFailure("unsupported bottom alignment")
      return adjustRect
    }
  }

  private func adjustedFrame(toVerticallyCenterText rect: NSRect) -> NSRect {
    // From: https://stackoverflow.com/questions/11775128/set-text-vertical-center-in-nstextfield

    // // super would normally draw text at the top of the cell
    // var titleRect = super.titleRect(forBounds: rect) // (-2.0, 0.0, 312.0, 130.0)
    //
    // let minimumHeight = self.cellSize(forBounds: rect).height // (294.84000000000003, 89.0)
    // titleRect.origin.y += (titleRect.height - minimumHeight) / 2
    // titleRect.size.height = minimumHeight

    let titleRect = titleRect(forBounds: rect) // (-2.0, 0.0, 312.0, 130.0)
    let cellHeight = cellSize(forBounds: rect).height // (294.84000000000003, 89.0)

    return CGRect(x: titleRect.origin.x, y: (titleRect.height - cellHeight) / 2, width: titleRect.width, height: cellHeight)
  }

  // https://stackoverflow.com/questions/10205088/nstextfield-vertical-alignment
}

#endif
