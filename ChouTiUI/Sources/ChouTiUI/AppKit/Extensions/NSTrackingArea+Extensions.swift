//
//  NSTrackingArea+Extensions.swift
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

import Foundation

public extension NSTrackingArea {

  /// The type of event message sent.
  struct EventTypes: OptionSet, Hashable {

    public let rawValue: UInt8

    public init(rawValue: UInt8) {
      self.rawValue = rawValue
    }

    /// For `mouseEnteredAndExited`.
    public static let mouseEnteredAndExited = EventTypes(rawValue: 1 << 0)

    /// For `mouseMoved`.
    public static let mouseMoved = EventTypes(rawValue: 1 << 1)

    /// For `cursorUpdate`.
    public static let cursorUpdate = EventTypes(rawValue: 1 << 2)

    /// [.mouseEnteredAndExited, .mouseMoved, .cursorUpdate]
    public static let all: EventTypes = [.mouseEnteredAndExited, .mouseMoved, .cursorUpdate]

    /// Make a new NSTrackingArea.Options based on the event types.
    public func trackingAreaOptions() -> NSTrackingArea.Options {
      var options: NSTrackingArea.Options = []
      if contains(.mouseEnteredAndExited) {
        options.insert(.mouseEnteredAndExited)
      }
      if contains(.mouseMoved) {
        options.insert(.mouseMoved)
      }
      if contains(.cursorUpdate) {
        options.insert(.cursorUpdate)
      }
      return options
    }
  }

  /// The scope of the tracking area.
  enum ActiveScope {

    case activeWhenFirstResponder
    case activeInKeyWindow
    case activeInActiveApp
    case activeAlways

    /// Make a new NSTrackingArea.Options based on the active scope.
    public func trackingAreaOptions() -> NSTrackingArea.Options {
      switch self {
      case .activeWhenFirstResponder:
        return .activeWhenFirstResponder
      case .activeInKeyWindow:
        return .activeInKeyWindow
      case .activeInActiveApp:
        return .activeInActiveApp
      case .activeAlways:
        return .activeAlways
      }
    }
  }

  /// The refinements of the tracking area.
  struct Refinements: OptionSet {

    public let rawValue: UInt8

    public init(rawValue: UInt8) {
      self.rawValue = rawValue
    }

    /// The tracking area is assumed to be inside the bounds of the owner view.
    ///
    /// If this option is not specified, the first event is generated 1) when the cursor leaves the tracking area if the cursor is initially inside the area,
    /// or 2) when the cursor enters the area if the cursor is initially outside it.
    ///
    /// If this option is specified, the first event is generated when the cursor leaves the tracking area, regardless of the initial cursor location.
    ///
    /// Generally, you do not want to request this behavior.
    public static let assumeInside = Refinements(rawValue: 1 << 0)

    public static let inVisibleRect = Refinements(rawValue: 1 << 1)

    /// The tracking area is enabled during a mouse drag.
    public static let enabledDuringMouseDrag = Refinements(rawValue: 1 << 2)

    /// [.assumeInside, .inVisibleRect, .enabledDuringMouseDrag]
    public static let all: Refinements = [.assumeInside, .inVisibleRect, .enabledDuringMouseDrag]

    /// Make a new NSTrackingArea.Options based on the refinements.
    public func trackingAreaOptions() -> NSTrackingArea.Options {
      var options: NSTrackingArea.Options = []
      if contains(.assumeInside) {
        options.insert(.assumeInside)
      }
      if contains(.inVisibleRect) {
        options.insert(.inVisibleRect)
      }
      if contains(.enabledDuringMouseDrag) {
        options.insert(.enabledDuringMouseDrag)
      }
      return options
    }
  }

  /// Make a new NSTrackingArea.
  convenience init(rect: NSRect, eventTypes: EventTypes, activeScope: ActiveScope, refinements: Refinements, owner: Any?, userInfo: [AnyHashable: Any]? = nil) {
    self.init(rect: rect, options: Options(eventTypes: eventTypes, activeScope: activeScope, refinements: refinements), owner: owner, userInfo: userInfo)
  }
}

public extension NSTrackingArea.Options {

  /// Make a new NSTrackingArea.Options based on the event types, active scope, and refinements.
  ///
  /// - Parameters:
  ///   - eventTypes: The event types.
  ///   - activeScope: The active scope.
  ///   - refinements: The refinements.
  init(eventTypes: NSTrackingArea.EventTypes, activeScope: NSTrackingArea.ActiveScope, refinements: NSTrackingArea.Refinements) {
    self = eventTypes.trackingAreaOptions().union(activeScope.trackingAreaOptions()).union(refinements.trackingAreaOptions())
  }
}

// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/TrackingAreaObjects/TrackingAreaObjects.html

#endif
