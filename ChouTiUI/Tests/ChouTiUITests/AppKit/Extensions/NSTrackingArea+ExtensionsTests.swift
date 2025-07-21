//
//  NSTrackingArea+ExtensionsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 1/21/23.
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

import ChouTiUI

class NSTrackingArea_ExtensionsTests: XCTestCase {

  // MARK: - EventTypes

  func test_EventTypes_rawValue() {
    expect(NSTrackingArea.EventTypes.mouseEnteredAndExited.rawValue) == 1
    expect(NSTrackingArea.EventTypes.mouseMoved.rawValue) == 2
    expect(NSTrackingArea.EventTypes.cursorUpdate.rawValue) == 4
  }

  func test_EventTypes_all() {
    let all = NSTrackingArea.EventTypes.all
    expect(all.contains(.mouseEnteredAndExited)) == true
    expect(all.contains(.mouseMoved)) == true
    expect(all.contains(.cursorUpdate)) == true
  }

  func test_EventTypes_trackingAreaOptions_single() {
    let mouseEnteredOptions = NSTrackingArea.EventTypes.mouseEnteredAndExited.trackingAreaOptions()
    expect(mouseEnteredOptions.contains(.mouseEnteredAndExited)) == true
    expect(mouseEnteredOptions.contains(.mouseMoved)) == false
    expect(mouseEnteredOptions.contains(.cursorUpdate)) == false

    let mouseMovedOptions = NSTrackingArea.EventTypes.mouseMoved.trackingAreaOptions()
    expect(mouseMovedOptions.contains(.mouseEnteredAndExited)) == false
    expect(mouseMovedOptions.contains(.mouseMoved)) == true
    expect(mouseMovedOptions.contains(.cursorUpdate)) == false

    let cursorUpdateOptions = NSTrackingArea.EventTypes.cursorUpdate.trackingAreaOptions()
    expect(cursorUpdateOptions.contains(.mouseEnteredAndExited)) == false
    expect(cursorUpdateOptions.contains(.mouseMoved)) == false
    expect(cursorUpdateOptions.contains(.cursorUpdate)) == true
  }

  func test_EventTypes_trackingAreaOptions_combined() {
    let combined: NSTrackingArea.EventTypes = [.mouseEnteredAndExited, .mouseMoved]
    let options = combined.trackingAreaOptions()
    expect(options.contains(.mouseEnteredAndExited)) == true
    expect(options.contains(.mouseMoved)) == true
    expect(options.contains(.cursorUpdate)) == false
  }

  func test_EventTypes_trackingAreaOptions_all() {
    let allOptions = NSTrackingArea.EventTypes.all.trackingAreaOptions()
    expect(allOptions.contains(.mouseEnteredAndExited)) == true
    expect(allOptions.contains(.mouseMoved)) == true
    expect(allOptions.contains(.cursorUpdate)) == true
  }

  // MARK: - ActiveScope

  func test_ActiveScope_trackingAreaOptions() {
    expect(NSTrackingArea.ActiveScope.activeWhenFirstResponder.trackingAreaOptions()) == .activeWhenFirstResponder
    expect(NSTrackingArea.ActiveScope.activeInKeyWindow.trackingAreaOptions()) == .activeInKeyWindow
    expect(NSTrackingArea.ActiveScope.activeInActiveApp.trackingAreaOptions()) == .activeInActiveApp
    expect(NSTrackingArea.ActiveScope.activeAlways.trackingAreaOptions()) == .activeAlways
  }

  // MARK: - Refinements

  func test_Refinements_rawValue() {
    expect(NSTrackingArea.Refinements.assumeInside.rawValue) == 1
    expect(NSTrackingArea.Refinements.inVisibleRect.rawValue) == 2
    expect(NSTrackingArea.Refinements.enabledDuringMouseDrag.rawValue) == 4
  }

  func test_Refinements_all() {
    let all = NSTrackingArea.Refinements.all
    expect(all.contains(.assumeInside)) == true
    expect(all.contains(.inVisibleRect)) == true
    expect(all.contains(.enabledDuringMouseDrag)) == true
  }

  func test_Refinements_trackingAreaOptions_single() {
    let assumeInsideOptions = NSTrackingArea.Refinements.assumeInside.trackingAreaOptions()
    expect(assumeInsideOptions.contains(.assumeInside)) == true
    expect(assumeInsideOptions.contains(.inVisibleRect)) == false
    expect(assumeInsideOptions.contains(.enabledDuringMouseDrag)) == false

    let inVisibleRectOptions = NSTrackingArea.Refinements.inVisibleRect.trackingAreaOptions()
    expect(inVisibleRectOptions.contains(.assumeInside)) == false
    expect(inVisibleRectOptions.contains(.inVisibleRect)) == true
    expect(inVisibleRectOptions.contains(.enabledDuringMouseDrag)) == false

    let enabledDuringMouseDragOptions = NSTrackingArea.Refinements.enabledDuringMouseDrag.trackingAreaOptions()
    expect(enabledDuringMouseDragOptions.contains(.assumeInside)) == false
    expect(enabledDuringMouseDragOptions.contains(.inVisibleRect)) == false
    expect(enabledDuringMouseDragOptions.contains(.enabledDuringMouseDrag)) == true
  }

  func test_Refinements_trackingAreaOptions_combined() {
    let combined: NSTrackingArea.Refinements = [.assumeInside, .inVisibleRect]
    let options = combined.trackingAreaOptions()
    expect(options.contains(.assumeInside)) == true
    expect(options.contains(.inVisibleRect)) == true
    expect(options.contains(.enabledDuringMouseDrag)) == false
  }

  func test_Refinements_trackingAreaOptions_all() {
    let allOptions = NSTrackingArea.Refinements.all.trackingAreaOptions()
    expect(allOptions.contains(.assumeInside)) == true
    expect(allOptions.contains(.inVisibleRect)) == true
    expect(allOptions.contains(.enabledDuringMouseDrag)) == true
  }

  // MARK: - NSTrackingArea Init

  func test_convenienceInit() {
    let rect = NSRect(x: 0, y: 0, width: 100, height: 100)
    let eventTypes: NSTrackingArea.EventTypes = [.mouseEnteredAndExited, .mouseMoved]
    let activeScope = NSTrackingArea.ActiveScope.activeAlways
    let refinements: NSTrackingArea.Refinements = [.inVisibleRect]
    let owner = NSObject()
    let userInfo = ["key": "value"]

    let trackingArea = NSTrackingArea(
      rect: rect,
      eventTypes: eventTypes,
      activeScope: activeScope,
      refinements: refinements,
      owner: owner,
      userInfo: userInfo
    )

    expect(trackingArea.rect) == rect
    expect(trackingArea.owner === owner) == true
    expect(trackingArea.userInfo?["key"] as? String) == "value"

    let expectedOptions: NSTrackingArea.Options = [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect]
    expect(trackingArea.options) == expectedOptions
  }

  // MARK: - NSTrackingArea.Options Init

  func test_Options_init() {
    let eventTypes: NSTrackingArea.EventTypes = [.mouseEnteredAndExited, .cursorUpdate]
    let activeScope = NSTrackingArea.ActiveScope.activeInKeyWindow
    let refinements: NSTrackingArea.Refinements = [.assumeInside, .enabledDuringMouseDrag]

    let options = NSTrackingArea.Options(
      eventTypes: eventTypes,
      activeScope: activeScope,
      refinements: refinements
    )

    let expectedOptions: NSTrackingArea.Options = [
      .mouseEnteredAndExited,
      .cursorUpdate,
      .activeInKeyWindow,
      .assumeInside,
      .enabledDuringMouseDrag,
    ]

    expect(options) == expectedOptions
  }

  func test_Options_init_emptyRefinements() {
    let eventTypes = NSTrackingArea.EventTypes.mouseMoved
    let activeScope = NSTrackingArea.ActiveScope.activeWhenFirstResponder
    let refinements: NSTrackingArea.Refinements = []

    let options = NSTrackingArea.Options(
      eventTypes: eventTypes,
      activeScope: activeScope,
      refinements: refinements
    )

    let expectedOptions: NSTrackingArea.Options = [.mouseMoved, .activeWhenFirstResponder]
    expect(options) == expectedOptions
  }
}

#endif
