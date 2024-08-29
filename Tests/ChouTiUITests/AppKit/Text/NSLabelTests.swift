//
//  NSLabelTests.swift
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit

import ChouTiTest
import ChouTiUI
import ChouTi

class NSLabelTests: XCTestCase {

  func testCellClass() {

    expect("\(String(describing: NSLabel.cellClass))") == "Optional(ChouTiUI.BaseNSTextFieldCell)"

    // set cell class has no effect
    NSLabel.cellClass = NSTextFieldCell.self
    expect("\(String(describing: NSLabel.cellClass))") == "Optional(ChouTiUI.BaseNSTextFieldCell)"
  }

  func testVerticalAlignment() {
    let label = NSLabel()
    expect(label.verticalAlignment) == .center

    label.verticalAlignment = .top
    expect(label.verticalAlignment) == .top
  }

  func testText() {
    let label = NSLabel()
    expect(label.text) == ""
    expect(label.stringValue) == ""

    label.text = "Hello, world!"
    expect(label.text) == "Hello, world!"
    expect(label.stringValue) == "Hello, world!"

    label.text = nil
    expect(label.text) == ""
    expect(label.stringValue) == ""
  }

  func testMultilineTruncatesLastVisibleLine() {
    let label = NSLabel()
    expect(label.multilineTruncatesLastVisibleLine) == true

    label.multilineTruncatesLastVisibleLine = false
    expect(label.multilineTruncatesLastVisibleLine) == false
  }

  func testCommonInit() {
    let label = NSLabel()
    expect(label.layerContentsRedrawPolicy) == .onSetNeedsDisplay
    expect(label.maximumNumberOfLines) == 1
    expect(label.cell?.truncatesLastVisibleLine) == true

    expect(label.wantsLayer) == true
    expect(label.layer()?.cornerCurve) == .continuous
    expect(label.layer()?.contentsScale) == Screen.mainScreenScale
    expect(label.layer()?.masksToBounds) == false

    expect(label.refusesFirstResponder) == true

    expect(label.isEditable) == false
    expect(label.isSelectable) == false
    expect(label.allowsEditingTextAttributes) == false

    expect(label.drawsBackground) == false
    expect(label.isBezeled) == false
    expect(label.isBordered) == false

    expect(label.backgroundColor) == .clear
    expect(label.ignoreHitTest) == true
  }

  func testSetToSingleLineMode() {
    let label = NSLabel()

    label.setToSingleLineMode(truncationMode: .none)
    expect(label.lineBreakMode) == .byClipping
    expect(label.multilineTruncatesLastVisibleLine) == false

    label.setToSingleLineMode(truncationMode: .head)
    expect(label.lineBreakMode) == .byTruncatingHead
    expect(label.multilineTruncatesLastVisibleLine) == false

    label.setToSingleLineMode(truncationMode: .tail)
    expect(label.lineBreakMode) == .byTruncatingTail
    expect(label.multilineTruncatesLastVisibleLine) == false

    label.setToSingleLineMode(truncationMode: .middle)
    expect(label.lineBreakMode) == .byTruncatingMiddle
    expect(label.multilineTruncatesLastVisibleLine) == false
  }

  func testSetToMultilineMode() {
    let label = NSLabel()

    label.setToMultilineMode(numberOfLines: 0, lineWrapMode: .byWord, truncatesLastVisibleLine: true)
    expect(label.maximumNumberOfLines) == 0
    expect(label.cell?.lineBreakMode) == .byWordWrapping
    expect(label.multilineTruncatesLastVisibleLine) == true

    label.setToMultilineMode(numberOfLines: 1, lineWrapMode: .byChar, truncatesLastVisibleLine: false)
    expect(label.maximumNumberOfLines) == 1
    expect(label.cell?.lineBreakMode) == .byCharWrapping
    expect(label.multilineTruncatesLastVisibleLine) == false
  }

  func testSetToSelectable() {
    let label = NSLabel()
    label.setIsSelectable(true)
    expect(label.isSelectable) == true
    expect(label.allowsEditingTextAttributes) == true

    label.setIsSelectable(false)
    expect(label.isSelectable) == false
    expect(label.allowsEditingTextAttributes) == false
  }
}

#endif