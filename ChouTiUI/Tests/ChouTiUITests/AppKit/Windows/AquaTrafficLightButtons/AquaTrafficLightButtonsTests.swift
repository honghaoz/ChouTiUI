//
//  AquaTrafficLightButtonsTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/25/26.
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

import ChouTi

import ChouTiTest

@testable import ChouTiUI

@MainActor
class AquaTrafficLightButtonsTests: XCTestCase {

  private func makeWindow(styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]) -> NSWindow {
    let window = NSWindow(contentRect: CGRect(x: 0, y: 0, width: 320, height: 200), styleMask: styleMask, backing: .buffered, defer: false)
    window.isReleasedWhenClosed = false
    return window
  }

  private func buttonViews(_ window: NSWindow) -> [AquaTrafficLightButtonView] {
    window.standardWindowButton(.closeButton)?.superview?.subviews.compactMap { $0 as? AquaTrafficLightButtonView } ?? []
  }

  private func buttonView(_ window: NSWindow, _ kind: AquaTrafficLightButtonKind) -> AquaTrafficLightButtonView? {
    buttonViews(window).first { $0.kind == kind }
  }

  /// Sends a mouse event to the traffic light tracking area.
  private func sendMouseEvent(_ window: NSWindow, inside: Bool) {
    guard let titlebarView = window.standardWindowButton(.closeButton)?.superview,
          let trackingArea = titlebarView.trackingAreas.first(where: { $0.owner is NSResponder && !($0.owner is NSView) }),
          let owner = trackingArea.owner as? NSResponder
    else {
      fail("no traffic light tracking area")
      return
    }

    let pointInTitlebar = inside ? CGPoint(x: trackingArea.rect.midX, y: trackingArea.rect.midY) : CGPoint(x: trackingArea.rect.maxX + 50, y: trackingArea.rect.midY)
    guard let event = NSEvent.enterExitEvent(
      with: inside ? .mouseEntered : .mouseExited,
      location: titlebarView.convert(pointInTitlebar, to: nil),
      modifierFlags: [],
      timestamp: ProcessInfo.processInfo.systemUptime,
      windowNumber: window.windowNumber,
      context: nil,
      eventNumber: 0,
      trackingNumber: 0,
      userData: nil
    ) else {
      fail("failed to make the event")
      return
    }

    if inside {
      owner.mouseEntered(with: event)
    } else {
      owner.mouseExited(with: event)
    }
  }

  // MARK: - Install

  func test_install() throws {
    // given a titled window
    let window = makeWindow()
    let closeButton = try window.standardWindowButton(.closeButton).unwrap()
    let titlebarView = try closeButton.superview.unwrap()

    // when installing the buttons
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // then a button view is above each system button, following its frame
    let views = buttonViews(window)
    expect(views.count) == 3
    for kind in AquaTrafficLightButtonKind.allCases {
      let systemButton = try window.standardWindowButton(kind.buttonType).unwrap()
      let view = try buttonView(window, kind).unwrap()
      expect(view.frame) == AquaTrafficLightButtons.buttonFrame(systemButtonFrame: systemButton.frame, isTahoe: System.macOS_tahoe)
      let viewIndex = try titlebarView.subviews.firstIndex(of: view).unwrap()
      let systemButtonIndex = try titlebarView.subviews.firstIndex(of: systemButton).unwrap()
      expect(viewIndex) > systemButtonIndex

      // the system buttons are almost transparent but stay in the hierarchy to take clicks
      expect(systemButton.alphaValue) == 0.001
      expect(systemButton.isHidden) == false
    }

    // then the titlebar backgrounds are removed
    expect(window.contentView?.superview?.subviews.contains(where: { $0.className == "NSVisualEffectView" })) == false
    expect(titlebarView.superview?.subviews.contains(where: { $0.className == "_NSTitlebarDecorationView" })) == false

    // then the cluster is tracked
    expect(titlebarView.trackingAreas.filter { $0.owner is NSResponder && !($0.owner is NSView) }.count) == 1

    // then the window isn't key, so the buttons are gray
    expect(views.map(\.state)) == [.inactive(nil), .inactive(nil), .inactive(nil)]
  }

  func test_install_twice() {
    // given installed buttons
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when installing again
    trafficLights.install()

    // then nothing is duplicated
    expect(buttonViews(window).count) == 3
    expect(window.standardWindowButton(.closeButton)?.superview?.trackingAreas.filter { !($0.owner is NSView) }.count) == 1
  }

  func test_install_byAnotherInstance() {
    // given buttons installed on a window
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when another instance installs on the same window
    var assertionMessage: String?
    Assert.setTestAssertionFailureHandler { message, _, _, _, _ in
      assertionMessage = message
    }
    let anotherTrafficLights = AquaTrafficLightButtons(window: window)
    anotherTrafficLights.install()
    Assert.resetTestAssertionFailureHandler()

    // then the window is left untouched
    expect(assertionMessage) == "the window already has traffic light buttons installed by another instance"
    expect(buttonViews(window).count) == 3
  }

  func test_install_untitledWindow() {
    // given a borderless window
    let window = makeWindow(styleMask: [.borderless])

    // when installing
    var assertionMessage: String?
    Assert.setTestAssertionFailureHandler { message, _, _, _, _ in
      assertionMessage = message
    }
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    Assert.resetTestAssertionFailureHandler()

    // then nothing is installed
    expect(assertionMessage) == "only titled windows are supported"
    expect(buttonViews(window).isEmpty) == true
  }

  func test_install_windowWithoutButtons() {
    // given a titled window without the system buttons
    let window = makeWindow(styleMask: [.titled])
    window.standardWindowButton(.closeButton)?.removeFromSuperview()
    window.standardWindowButton(.miniaturizeButton)?.removeFromSuperview()
    window.standardWindowButton(.zoomButton)?.removeFromSuperview()
    let subviewsBefore = window.contentView?.superview?.subviews.map(\.className)

    // when installing
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // then the window is left untouched
    if window.standardWindowButton(.closeButton) == nil {
      expect(window.contentView?.superview?.subviews.map(\.className)) == subviewsBefore
    }
  }

  // MARK: - States

  func test_hover() {
    // given installed buttons on a non-key window
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when the mouse enters the cluster
    sendMouseEvent(window, inside: true)

    // then the buttons show their glyphs
    expect(buttonView(window, .close)?.state) == .hovered(.close)
    expect(buttonView(window, .miniaturize)?.state) == .hovered(.miniaturize)
    expect(buttonView(window, .zoom)?.state) == .hovered(.enterFullScreen)

    // when the mouse exits the cluster
    sendMouseEvent(window, inside: false)

    // then the glyphs are hidden
    expect(buttonView(window, .close)?.state) == .inactive(nil)
    expect(buttonView(window, .miniaturize)?.state) == .inactive(nil)
    expect(buttonView(window, .zoom)?.state) == .inactive(nil)
  }

  func test_documentEdited() {
    // given installed buttons
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when the window has unsaved changes
    window.isDocumentEdited = true

    // then the close button shows the dot
    expect(self.buttonView(window, .close)?.state).toEventually(beEqual(to: .inactive(.documentEdited)))

    // when the changes are saved
    window.isDocumentEdited = false

    // then the dot is hidden
    expect(self.buttonView(window, .close)?.state).toEventually(beEqual(to: .inactive(nil)))
  }

  func test_disabledButton() {
    // given installed buttons with the mouse over the cluster
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    sendMouseEvent(window, inside: true)

    // when the close button is disabled
    window.standardWindowButton(.closeButton)?.isEnabled = false
    trafficLights.refresh()

    // then the close button is inactive without its glyph, the others still show theirs
    expect(buttonView(window, .close)?.state) == .inactive(nil)
    expect(buttonView(window, .miniaturize)?.state) == .hovered(.miniaturize)
  }

  func test_willClose_resetsState() {
    // given installed buttons with the mouse over the cluster
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .close)?.state) == .hovered(.close)

    // when the window closes
    window.close()

    // then the buttons don't keep the hovered state
    for view in buttonViews(window) {
      expect(view.state) == .normal(nil)
    }

    // when the window shows again and refreshes, then the mouse isn't considered inside
    trafficLights.refresh()
    expect(buttonView(window, .close)?.state) == .inactive(nil)
  }

  // MARK: - Hidden

  func test_setButtonHidden() {
    // given installed buttons
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when hiding the buttons
    trafficLights.setCloseButtonHidden(true)
    trafficLights.setMiniaturizeButtonHidden(true)
    trafficLights.setZoomButtonHidden(true)

    // then both the system buttons and the custom buttons are hidden
    for kind in AquaTrafficLightButtonKind.allCases {
      expect(window.standardWindowButton(kind.buttonType)?.isHidden) == true
      expect(buttonView(window, kind)?.isHidden) == true
    }

    // when showing the close button
    trafficLights.setCloseButtonHidden(false)

    // then it shows again
    expect(window.standardWindowButton(.closeButton)?.isHidden) == false
    expect(buttonView(window, .close)?.isHidden) == false
  }

  func test_systemButtonHidden_isFollowed() {
    // given installed buttons
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when the system zoom button is hidden directly and the buttons refresh
    window.standardWindowButton(.zoomButton)?.isHidden = true
    trafficLights.refresh()

    // then the custom zoom button follows
    expect(buttonView(window, .zoom)?.isHidden) == true
  }

  // MARK: - Frames

  func test_buttonFrame() {
    let systemFrame = CGRect(x: 9, y: 6, width: 14, height: 16)
    expect(AquaTrafficLightButtons.buttonFrame(systemButtonFrame: systemFrame, isTahoe: true)) == CGRect(x: 8, y: 5, width: 16, height: 18)
    expect(AquaTrafficLightButtons.buttonFrame(systemButtonFrame: systemFrame, isTahoe: false)) == systemFrame
  }

  // MARK: - Deallocation

  func test_deinit_removesTrackingArea() throws {
    // given installed buttons
    let window = makeWindow()
    let titlebarView = try window.standardWindowButton(.closeButton)?.superview.unwrap()
    var trafficLights: AquaTrafficLightButtons? = AquaTrafficLightButtons(window: window)
    trafficLights?.install()
    expect(titlebarView?.trackingAreas.filter { !($0.owner is NSView) }.count) == 1

    // when the instance is deallocated
    trafficLights = nil

    // then the tracking area is removed
    expect(titlebarView?.trackingAreas.filter { !($0.owner is NSView) }.count) == 0
  }
}

private extension AquaTrafficLightButtonKind {

  var buttonType: NSWindow.ButtonType {
    switch self {
    case .close:
      return .closeButton
    case .miniaturize:
      return .miniaturizeButton
    case .zoom:
      return .zoomButton
    }
  }
}

#endif
