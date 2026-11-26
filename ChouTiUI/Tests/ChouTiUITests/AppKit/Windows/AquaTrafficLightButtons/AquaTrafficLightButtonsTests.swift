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
    expect(window.standardWindowButton(.closeButton)) == nil
    expect(window.standardWindowButton(.miniaturizeButton)) == nil
    expect(window.standardWindowButton(.zoomButton)) == nil
    let subviewsBefore = window.contentView?.superview?.subviews.map(\.className)

    // when installing
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // then the window is left untouched
    expect(window.contentView?.superview?.subviews.map(\.className)) == subviewsBefore
  }

  func test_install_unrecognizedTitlebar_leavesWindowUntouched() throws {
    // given a window whose titlebar backgrounds are already gone, which isn't a recognized hierarchy
    let window = makeWindow()
    let titlebarView = try window.standardWindowButton(.closeButton)?.superview.unwrap()
    let titlebarContainerView = try titlebarView?.superview.unwrap()
    for view in (titlebarContainerView?.subviews ?? []) + (titlebarView?.subviews ?? []) where ["_NSTitlebarDecorationView", "NSTitlebarBackgroundView", "NSVisualEffectView", "NSView"].contains(view.className) {
      view.removeFromSuperview()
    }
    let frameSubviewsBefore = window.contentView?.superview?.subviews.map(\.className)

    // when installing
    var assertionMessage: String?
    Assert.setTestAssertionFailureHandler { message, _, _, _, _ in
      assertionMessage = message
    }
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    Assert.resetTestAssertionFailureHandler()

    // then nothing is changed, including the window background that would be removed with the titlebar background
    expect(assertionMessage) == "the titlebar background views aren't found"
    expect(window.contentView?.superview?.subviews.map(\.className)) == frameSubviewsBefore
    expect(buttonViews(window).isEmpty) == true
    expect(window.standardWindowButton(.closeButton)?.alphaValue) == 1
  }

  func test_install_visualEffectContentView_isKept() {
    // given a window whose content view is a visual effect view, a sibling of the window background
    let window = makeWindow()
    let contentView = NSVisualEffectView()
    window.contentView = contentView

    // when installing
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // then the content view stays, and the window background is removed
    expect(window.contentView) === contentView
    expect(contentView.superview) != nil
    expect(contentView.superview?.subviews.filter { $0 is NSVisualEffectView }.count) == 1
    expect(buttonViews(window).count) == 3
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

    // when the window shows again
    window.orderFront(nil)
    trafficLights.refresh()

    // then the mouse isn't considered inside until it enters again
    expect(buttonView(window, .close)?.state) == .inactive(nil)

    // when the mouse enters the cluster, then the buttons follow it again
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .close)?.state) == .hovered(.close)

    window.close()
  }

  func test_willClose_inFullScreen_resetsFullScreenGlyph() throws {
    // given installed buttons on a window that entered full screen
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    NotificationCenter.default.post(name: NSWindow.didEnterFullScreenNotification, object: window)
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .zoom)?.state) == .hovered(.exitFullScreen)

    // when the window closes and shows again, then the zoom button shows the enter full screen glyph
    window.close()
    window.orderFront(nil)
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .zoom)?.state) == .hovered(.enterFullScreen)

    window.close()
  }

  func test_fullScreen_transition() {
    // given installed buttons with the mouse over the cluster
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .zoom)?.state) == .hovered(.enterFullScreen)

    // when the window enters full screen, then the zoom button shows the exit glyph
    NotificationCenter.default.post(name: NSWindow.willEnterFullScreenNotification, object: window)
    NotificationCenter.default.post(name: NSWindow.didEnterFullScreenNotification, object: window)
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .zoom)?.state) == .hovered(.exitFullScreen)

    // when the window starts exiting full screen, then the glyphs are hidden during the transition
    NotificationCenter.default.post(name: NSWindow.willExitFullScreenNotification, object: window)
    expect(buttonView(window, .close)?.state) == .inactive(nil)
    expect(buttonView(window, .zoom)?.state) == .inactive(nil)

    // when the transition ends, then the mouse is checked again (it's not over the window in tests)
    NotificationCenter.default.post(name: NSWindow.didExitFullScreenNotification, object: window)
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .zoom)?.state) == .hovered(.enterFullScreen)
  }

  func test_frameChange_rechecksCursor() {
    // given installed buttons with the mouse over the cluster
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    sendMouseEvent(window, inside: true)
    expect(buttonView(window, .close)?.state) == .hovered(.close)

    // when the window moves under a still cursor (the real cursor isn't over the test window)
    NotificationCenter.default.post(name: NSWindow.didMoveNotification, object: window)

    // then the glyphs are hidden, without a mouse event from the tracking area
    expect(buttonView(window, .close)?.state) == .inactive(nil)
  }

  func test_accentColorChange() {
    // given installed buttons
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when the control tint changes
    NotificationCenter.default.post(name: NSColor.currentControlTintDidChangeNotification, object: nil)

    // then the buttons follow the system's graphite setting
    for view in buttonViews(window) {
      expect(view.isGraphite) == AquaTrafficLightButtons.isGraphiteAccentColor()
    }
  }

  func test_install_titlebarInAnotherWindow() throws {
    // given a window whose titlebar is hosted by another window, as AppKit does in full screen
    let window = makeWindow()
    let titlebarContainerView = try window.standardWindowButton(.closeButton)?.superview?.superview.unwrap()
    let hostWindow = makeWindow(styleMask: [.borderless])
    try titlebarContainerView.unwrap().removeFromSuperview()
    try hostWindow.contentView?.addSubview(titlebarContainerView.unwrap())

    // when installing
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // then the buttons are installed in the titlebar
    expect(buttonViews(window).count) == 3
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

  func test_hiddenButton_staysInHoverRegion() throws {
    // given installed buttons with the zoom button hidden
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()
    trafficLights.setZoomButtonHidden(true)

    // when the mouse moves over where the zoom button was
    let zoomButton = try window.standardWindowButton(.zoomButton).unwrap()
    let titlebarView = try zoomButton.superview.unwrap()
    let owner = try (titlebarView.trackingAreas.first { !($0.owner is NSView) }?.owner as? NSResponder).unwrap()
    let event = try NSEvent.mouseEvent(
      with: .mouseMoved,
      location: titlebarView.convert(CGPoint(x: zoomButton.frame.midX, y: zoomButton.frame.midY), to: nil),
      modifierFlags: [],
      timestamp: ProcessInfo.processInfo.systemUptime,
      windowNumber: window.windowNumber,
      context: nil,
      eventNumber: 0,
      clickCount: 0,
      pressure: 0
    ).unwrap()
    owner.mouseMoved(with: event)

    // then the visible buttons show their glyphs, like the system buttons, whose hover region keeps the hidden
    // button's spot
    expect(buttonView(window, .close)?.state) == .hovered(.close)
    expect(buttonView(window, .miniaturize)?.state) == .hovered(.miniaturize)
  }

  // MARK: - Full Screen

  func test_canEnterFullScreen() {
    // given a resizable normal window, it can enter full screen
    let window = makeWindow()
    expect(AquaTrafficLightButtons.canEnterFullScreen(window)) == true

    // given it opts out of full screen, it can't
    window.collectionBehavior = [.fullScreenNone]
    expect(AquaTrafficLightButtons.canEnterFullScreen(window)) == false

    // given an auxiliary window, it can't
    window.collectionBehavior = [.fullScreenAuxiliary]
    expect(AquaTrafficLightButtons.canEnterFullScreen(window)) == false

    // given it opts in, it can, even without being resizable
    window.collectionBehavior = [.fullScreenPrimary]
    window.styleMask.remove(.resizable)
    expect(AquaTrafficLightButtons.canEnterFullScreen(window)) == true

    // given a floating window, it can't
    window.level = .floating
    expect(AquaTrafficLightButtons.canEnterFullScreen(window)) == false

    // given a non-resizable window without the opt-in, it can't
    let fixedWindow = makeWindow(styleMask: [.titled, .closable, .miniaturizable])
    expect(AquaTrafficLightButtons.canEnterFullScreen(fixedWindow)) == false
  }

  // MARK: - Uninstall

  func test_uninstall_restoresWindow() throws {
    // given a window and its hierarchy before the installation
    let window = makeWindow()
    let titlebarView = try window.standardWindowButton(.closeButton)?.superview.unwrap()
    let frameSubviewsBefore = window.contentView?.superview?.subviews.map(\.className)
    let containerSubviewsBefore = titlebarView?.superview?.subviews.map(\.className)
    let titlebarSubviewsBefore = titlebarView?.subviews.map(\.className)

    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when uninstalling
    trafficLights.uninstall()

    // then the window is restored
    expect(buttonViews(window).isEmpty) == true
    expect(window.contentView?.superview?.subviews.map(\.className)) == frameSubviewsBefore
    expect(titlebarView?.superview?.subviews.map(\.className)) == containerSubviewsBefore
    expect(titlebarView?.subviews.map(\.className)) == titlebarSubviewsBefore
    expect(titlebarView?.trackingAreas.filter { !($0.owner is NSView) }.count) == 0
    for kind in AquaTrafficLightButtonKind.allCases {
      expect(window.standardWindowButton(kind.buttonType)?.alphaValue) == 1
    }

    // when installing again, then the buttons are back
    trafficLights.install()
    expect(buttonViews(window).count) == 3
  }

  // MARK: - Accessibility

  func test_accessibility_excludesButtonViews() {
    // given installed buttons
    let window = makeWindow()
    let trafficLights = AquaTrafficLightButtons(window: window)
    trafficLights.install()

    // when reading the window's accessibility tree
    func elements(_ element: NSAccessibilityProtocol, depth: Int) -> [Any] {
      guard depth > 0 else {
        return []
      }
      let children = element.accessibilityChildren() ?? []
      return children + children.compactMap { $0 as? NSAccessibilityProtocol }.flatMap { elements($0, depth: depth - 1) }
    }
    let allElements = elements(window, depth: 6)

    // then the custom buttons aren't in it, and the system close button is
    expect(allElements.contains { $0 is AquaTrafficLightButtonView }) == false
    expect(allElements.contains { ($0 as? NSAccessibilityProtocol)?.accessibilitySubrole() == .closeButton }) == true
  }

  // MARK: - Frames

  func test_buttonFrame() {
    let systemFrame = CGRect(x: 9, y: 6, width: 14, height: 16)
    expect(AquaTrafficLightButtons.buttonFrame(systemButtonFrame: systemFrame, isTahoe: true)) == CGRect(x: 8, y: 5, width: 16, height: 18)
    expect(AquaTrafficLightButtons.buttonFrame(systemButtonFrame: systemFrame, isTahoe: false)) == systemFrame
  }

  // MARK: - Deallocation

  func test_deinit_uninstalls() throws {
    // given installed buttons
    let window = makeWindow()
    let titlebarView = try window.standardWindowButton(.closeButton)?.superview.unwrap()
    var trafficLights: AquaTrafficLightButtons? = AquaTrafficLightButtons(window: window)
    trafficLights?.install()
    expect(titlebarView?.trackingAreas.filter { !($0.owner is NSView) }.count) == 1

    // when the instance is deallocated
    trafficLights = nil

    // then the buttons are uninstalled, and another instance can install
    expect(titlebarView?.trackingAreas.filter { !($0.owner is NSView) }.count) == 0
    expect(buttonViews(window).isEmpty) == true
    expect(window.standardWindowButton(.closeButton)?.alphaValue) == 1

    let anotherTrafficLights = AquaTrafficLightButtons(window: window)
    anotherTrafficLights.install()
    expect(buttonViews(window).count) == 3
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
