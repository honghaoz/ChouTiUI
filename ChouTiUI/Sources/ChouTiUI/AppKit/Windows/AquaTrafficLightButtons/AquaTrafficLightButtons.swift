//
//  AquaTrafficLightButtons.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/3/21.
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

/// Installs Aqua-style traffic light buttons on a titled `NSWindow`.
///
/// The buttons are drawn over the system traffic light buttons (close, miniaturize, zoom), which stay in the window
/// to handle clicks, key equivalents and accessibility. The drawn buttons follow the system buttons' frames and
/// states: they show glyphs when the mouse is over the cluster, darken when pressed, turn gray when the window isn't
/// key, show the dirty dot when the window has unsaved changes, and turn gray with the graphite accent color.
///
/// Example:
/// ```swift
/// let window = NSWindow(
///   contentRect: CGRect(x: 0, y: 0, width: 480, height: 320),
///   styleMask: [.titled, .closable, .miniaturizable, .resizable],
///   backing: .buffered,
///   defer: false
/// )
///
/// let trafficLights = AquaTrafficLightButtons(window: window) // keep a strong reference
/// trafficLights.install()
/// ```
///
/// The buttons observe the window to stay in sync: key state, mouse hover, the Option key, document edited state,
/// resizing, full screen and the system button layout. Call `refresh()` after a change that the window doesn't
/// announce.
///
/// - Important: `install()` changes the window's titlebar view hierarchy permanently: it removes the titlebar
///   background views (`NSVisualEffectView`, `_NSTitlebarDecorationView`, `NSTitlebarBackgroundView`) so that the
///   window draws its own titlebar background, and makes the system buttons almost transparent. The hierarchy is
///   private to AppKit, so the installation checks it first and leaves the window untouched if it isn't recognized.
///
/// - Note: The buttons stop working when the instance is deallocated, keep a strong reference to it for the window's
///   lifetime.
@MainActor
public final class AquaTrafficLightButtons {

  /// The window that the buttons are installed on.
  private weak var window: NSWindow?

  /// Whether the buttons are installed.
  private var isInstalled = false

  /// The view that holds the system buttons and the custom buttons, `NSTitlebarView`.
  private weak var containerView: NSView?

  /// The system buttons, by kind.
  private var systemButtons: [AquaTrafficLightButtonKind: WeakBox<NSButton>] = [:]

  /// The custom buttons, by kind.
  private var buttonViews: [AquaTrafficLightButtonKind: AquaTrafficLightButtonView] = [:]

  /// The frame of the traffic light cluster in the container view, the union of the system buttons' frames.
  private var clusterFrame: CGRect?

  /// The tracking area over the traffic light cluster.
  private var trackingArea: NSTrackingArea?

  /// The owner of the tracking area, which forwards the mouse events.
  private lazy var mouseEventReceiver = MouseEventReceiver { [weak self] event in
    self?.handleMouseEvent(event)
  }

  /// Whether the mouse is over the traffic light cluster.
  private var isMouseInside = false

  /// Whether the window is in full screen. It's updated after the full screen transitions end, so that the buttons
  /// show the glyph of the current mode during the transitions.
  private var isFullScreen = false

  /// Whether the window is exiting full screen. The glyphs are hidden during the transition.
  private var isExitingFullScreen = false

  /// Whether the window became key since it was shown, see `scheduleKeyWindowRefresh()`.
  private var hasBecomeKey = false

  /// Whether the system uses the graphite accent color.
  private var isGraphite = AquaTrafficLightButtons.isGraphiteAccentColor()

  /// The notification observers of the window and the system.
  private var notificationObservers: [(center: NotificationCenter, token: NSObjectProtocol)] = []

  /// The key-value observations of the window and the system buttons.
  private var keyValueObservations: [NSKeyValueObservation] = []

  /// The tokens of the system buttons' layout observations.
  private var layoutObservationTokens: [CancellableToken] = []

  /// The local monitor of the modifier flag changes, for the Option key.
  private var flagsChangedMonitor: Any?

  /// The global monitor of the mouse events in other apps, which means the mouse is outside of the window.
  private var globalMouseMonitor: Any?

  /// The timers that refresh the buttons after the close button changes, see `scheduleCloseButtonRefreshes()`.
  private var closeButtonRefreshTimers: [Timer] = []

  /// Creates traffic light buttons for a window.
  ///
  /// Call `install()` to show the buttons.
  ///
  /// - Parameter window: The window to install the buttons on. It must have the `.titled` style.
  public init(window: NSWindow) {
    self.window = window
  }

  deinit {
    // the deinit isn't isolated to the main actor, but the instance is only used on the main thread
    MainActor.assumeIsolated {
      stopObserving()
    }
  }

  // MARK: - Public

  /// Installs the buttons on the window.
  ///
  /// The installation removes the titlebar background views and makes the system buttons almost transparent, see the
  /// type's documentation. Calling it again does nothing.
  public func install() {
    guard !isInstalled else {
      return
    }

    guard let window else {
      ChouTi.assertFailure("the window is deallocated")
      return
    }

    guard window.styleMask.contains(.titled) else {
      ChouTi.assertFailure("only titled windows are supported", metadata: ["styleMask": "\(window.styleMask)"])
      return
    }

    let systemButtons = AquaTrafficLightButtonKind.allCases.compactMap { kind in
      window.standardWindowButton(kind.systemButtonType).map { (kind, $0) }
    }
    guard !systemButtons.isEmpty else {
      // the window has no traffic light buttons, there's nothing to draw
      return
    }

    // check the private hierarchy before changing anything, so that an unrecognized window is left untouched
    guard let hierarchy = TitlebarHierarchy(window: window) else {
      return
    }
    guard systemButtons.allSatisfy({ $0.1.superview === hierarchy.titlebarView }) else {
      ChouTi.assertFailure("the system buttons aren't in NSTitlebarView")
      return
    }
    guard !hierarchy.titlebarView.subviews.contains(where: { $0 is AquaTrafficLightButtonView }) else {
      ChouTi.assertFailure("the window already has traffic light buttons installed by another instance")
      return
    }

    hierarchy.removeBackgroundViews(window: window)
    containerView = hierarchy.titlebarView

    for (kind, systemButton) in systemButtons {
      let buttonView = AquaTrafficLightButtonView(kind: kind)
      buttonView.isGraphite = isGraphite
      hierarchy.titlebarView.addSubview(buttonView, positioned: .above, relativeTo: systemButton)

      self.systemButtons[kind] = WeakBox(systemButton)
      buttonViews[kind] = buttonView
    }

    isInstalled = true
    isFullScreen = window.styleMask.contains(.fullScreen)

    syncLayout()
    startObserving(window: window)
    update()
  }

  /// Refreshes the buttons with the current window state.
  ///
  /// The buttons observe the window to stay in sync. Call this method after a change that the window doesn't
  /// announce, for example, a change of the system buttons' enabled state.
  public func refresh() {
    guard isInstalled else {
      return
    }
    syncLayout()
    update()
  }

  /// Sets whether the close button is hidden.
  ///
  /// Both the system button and the custom button are hidden, so that the button neither shows nor takes clicks.
  ///
  /// - Parameter isHidden: Whether the close button is hidden.
  public func setCloseButtonHidden(_ isHidden: Bool) {
    setButtonHidden(isHidden, kind: .close)
  }

  /// Sets whether the miniaturize button is hidden.
  ///
  /// Both the system button and the custom button are hidden, so that the button neither shows nor takes clicks.
  ///
  /// - Parameter isHidden: Whether the miniaturize button is hidden.
  public func setMiniaturizeButtonHidden(_ isHidden: Bool) {
    setButtonHidden(isHidden, kind: .miniaturize)
  }

  /// Sets whether the zoom button is hidden.
  ///
  /// Both the system button and the custom button are hidden, so that the button neither shows nor takes clicks.
  ///
  /// - Parameter isHidden: Whether the zoom button is hidden.
  public func setZoomButtonHidden(_ isHidden: Bool) {
    setButtonHidden(isHidden, kind: .zoom)
  }

  // MARK: - Layout

  /// Sets whether a button is hidden.
  ///
  /// - Parameters:
  ///   - isHidden: Whether the button is hidden.
  ///   - kind: The button kind.
  private func setButtonHidden(_ isHidden: Bool, kind: AquaTrafficLightButtonKind) {
    if let systemButton = systemButton(kind) ?? window?.standardWindowButton(kind.systemButtonType) {
      systemButton.isHidden = isHidden
    }
    buttonViews[kind]?.isHidden = isHidden
  }

  /// Returns the system button of a kind.
  ///
  /// - Parameter kind: The button kind.
  /// - Returns: The system button, or `nil` if the window has no such button.
  private func systemButton(_ kind: AquaTrafficLightButtonKind) -> NSButton? {
    systemButtons[kind]?.object
  }

  /// Makes the custom buttons follow the system buttons' frames, and updates the tracking area.
  private func syncLayout() {
    var clusterFrame: CGRect?
    for (kind, buttonView) in buttonViews {
      guard let systemButton = systemButton(kind) else {
        continue
      }

      // the system buttons must stay hittable, so they're almost transparent instead of hidden. AppKit can reset
      // the alpha, e.g. when the window becomes key, so it's set on every layout.
      if systemButton.alphaValue != Constants.systemButtonAlpha {
        systemButton.alphaValue = Constants.systemButtonAlpha
      }

      let frame = Self.buttonFrame(systemButtonFrame: systemButton.frame, isTahoe: System.macOS_tahoe)
      if buttonView.frame != frame {
        buttonView.frame = frame
      }
      if buttonView.isHidden != systemButton.isHidden {
        buttonView.isHidden = systemButton.isHidden
      }

      clusterFrame = clusterFrame.map { $0.union(systemButton.frame) } ?? systemButton.frame
    }

    self.clusterFrame = clusterFrame
    updateTrackingArea()
  }

  /// Returns the frame of a custom button for a system button frame.
  ///
  /// - Parameters:
  ///   - systemButtonFrame: The system button's frame.
  ///   - isTahoe: Whether the system is macOS 26 (Tahoe) or later.
  /// - Returns: The custom button frame.
  static func buttonFrame(systemButtonFrame: CGRect, isTahoe: Bool) -> CGRect {
    // the Tahoe system buttons draw beyond their frames
    isTahoe ? systemButtonFrame.insetBy(dx: -1, dy: -1) : systemButtonFrame
  }

  /// Updates the tracking area to cover the traffic light cluster.
  private func updateTrackingArea() {
    guard let containerView, let clusterFrame else {
      return
    }

    if let trackingArea {
      guard trackingArea.rect != clusterFrame else {
        return
      }
      containerView.removeTrackingArea(trackingArea)
    }

    let trackingArea = NSTrackingArea(
      rect: clusterFrame,
      options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .enabledDuringMouseDrag],
      owner: mouseEventReceiver,
      userInfo: nil
    )
    containerView.addTrackingArea(trackingArea)
    self.trackingArea = trackingArea
  }

  // MARK: - Update

  /// Resolves the button states from the window state and updates the buttons.
  private func update() {
    guard isInstalled, let window else {
      return
    }

    let inputs = AquaTrafficLightInputs(
      isKey: window.isKeyWindow,
      isMouseInside: isMouseInside && !isExitingFullScreen,
      isOptionPressed: NSEvent.modifierFlags.contains(.option),
      isFullScreen: isFullScreen,
      isNormalWindow: window.level == .normal,
      isDocumentEdited: window.isDocumentEdited,
      close: systemButtonState(.close),
      miniaturize: systemButtonState(.miniaturize),
      zoom: systemButtonState(.zoom)
    )
    let outputs = resolveAquaTrafficLightStates(inputs)

    buttonViews[.close]?.state = outputs.close
    buttonViews[.miniaturize]?.state = outputs.miniaturize
    buttonViews[.zoom]?.state = outputs.zoom
  }

  /// Returns the state of a system button.
  ///
  /// - Parameter kind: The button kind.
  /// - Returns: The system button state. A missing button is disabled.
  private func systemButtonState(_ kind: AquaTrafficLightButtonKind) -> AquaTrafficLightSystemButtonState {
    let button = systemButton(kind)
    return AquaTrafficLightSystemButtonState(isEnabled: button?.isEnabled ?? false, isHighlighted: button?.isHighlighted ?? false)
  }

  // MARK: - Mouse

  /// Handles a mouse event from the tracking area or the global monitor.
  ///
  /// - Parameter event: The mouse event.
  private func handleMouseEvent(_ event: NSEvent) {
    // the titlebar is in its own window in full screen, so the events are checked against the container view's window
    let isMouseInside: Bool
    if let containerView, let containerWindow = containerView.window, event.window === containerWindow, let clusterFrame {
      isMouseInside = clusterFrame.contains(containerView.convert(event.locationInWindow, from: nil))
    } else {
      // an event of another window or app, the mouse is outside of the cluster
      isMouseInside = false
    }
    setMouseInside(isMouseInside)
  }

  /// Sets whether the mouse is over the traffic light cluster, and updates the buttons if it changes.
  ///
  /// - Parameter isMouseInside: Whether the mouse is over the cluster.
  private func setMouseInside(_ isMouseInside: Bool) {
    guard self.isMouseInside != isMouseInside else {
      return
    }
    self.isMouseInside = isMouseInside
    update()
  }

  /// Checks whether the cursor is over the traffic light cluster, from the cursor location.
  ///
  /// The tracking area doesn't report a change when the cluster moves under a still cursor, e.g. when the window is
  /// zoomed or exits full screen, so the location is checked after the window changes its frame.
  ///
  /// - Returns: Whether the cursor is over the cluster and the window is the frontmost window at the cursor.
  private func isCursorInsideCluster() -> Bool {
    // the titlebar is in its own window in full screen, so the location is checked in the container view's window
    guard let containerView, let containerWindow = containerView.window, containerWindow.isVisible, let clusterFrame else {
      return false
    }

    let screenLocation = NSEvent.mouseLocation
    guard NSWindow.windowNumber(at: screenLocation, belowWindowWithWindowNumber: 0) == containerWindow.windowNumber else {
      return false
    }

    let locationInWindow = containerWindow.convertPoint(fromScreen: screenLocation)
    return clusterFrame.contains(containerView.convert(locationInWindow, from: nil))
  }

  // MARK: - Observation

  /// Starts observing the window, the system buttons and the system.
  ///
  /// - Parameter window: The window to observe.
  private func startObserving(window: NSWindow) {
    let center = NotificationCenter.default

    func observe(_ name: Notification.Name, _ handler: @escaping (AquaTrafficLightButtons) -> Void) {
      let token = center.addObserver(forName: name, object: window, queue: .main) { [weak self] _ in
        MainActor.assumeIsolated {
          guard let self else {
            return
          }
          handler(self)
        }
      }
      notificationObservers.append((center, token))
    }

    // the frame changes can move the cluster away from a still cursor (e.g. zooming), which the tracking area doesn't
    // report
    observe(NSWindow.didResizeNotification) { $0.windowFrameDidChange() }
    observe(NSWindow.didMoveNotification) { $0.windowFrameDidChange() }

    observe(NSWindow.didBecomeKeyNotification) { $0.windowDidBecomeKey() }
    observe(NSWindow.didResignKeyNotification) { $0.refresh() }
    observe(NSWindow.didChangeOcclusionStateNotification) { $0.windowOcclusionStateDidChange() }
    observe(NSWindow.willCloseNotification) { $0.windowWillClose() }
    observe(NSWindow.didChangeBackingPropertiesNotification) { $0.windowBackingPropertiesDidChange() }

    observe(NSWindow.willEnterFullScreenNotification) { $0.windowFullScreenWillChange(isEntering: true) }
    observe(NSWindow.didEnterFullScreenNotification) { $0.windowFullScreenDidChange(isFullScreen: true) }
    observe(NSWindow.willExitFullScreenNotification) { $0.windowFullScreenWillChange(isEntering: false) }
    observe(NSWindow.didExitFullScreenNotification) { $0.windowFullScreenDidChange(isFullScreen: false) }

    // the graphite accent color turns the buttons gray
    let controlTintToken = center.addObserver(forName: NSColor.currentControlTintDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
      MainActor.assumeIsolated {
        self?.accentColorDidChange()
      }
    }
    notificationObservers.append((center, controlTintToken))

    let accentColorToken = DistributedNotificationCenter.default().addObserver(forName: .accentColorDidChange, object: nil, queue: .main) { [weak self] _ in
      // AppKit updates the control tint after the notification, so it's read on the next run loop
      onMainAsync { [weak self] in
        self?.accentColorDidChange()
      }
    }
    notificationObservers.append((DistributedNotificationCenter.default(), accentColorToken))

    keyValueObservations.append(
      window.observe(\.isDocumentEdited, options: [.new]) { [weak self] _, _ in
        onMainAsync { [weak self] in
          self?.refresh()
        }
      }
    )

    for kind in AquaTrafficLightButtonKind.allCases {
      guard let systemButton = systemButton(kind) else {
        continue
      }

      // the system buttons lay out when their states change (highlighted, enabled, the document edited dot), which
      // drives the custom buttons' states
      layoutObservationTokens.append(
        systemButton.onLayoutSubviews { [weak self] _ in
          guard let self else {
            return
          }
          self.refresh()
          if kind == .close {
            self.scheduleCloseButtonRefreshes()
          }
        }
      )

      keyValueObservations.append(
        systemButton.observe(\.isEnabled, options: [.new]) { [weak self] _, _ in
          onMainAsync { [weak self] in
            self?.refresh()
          }
        }
      )
    }

    startEventMonitors()
  }

  /// Stops observing the window, the system buttons and the system.
  private func stopObserving() {
    for (center, token) in notificationObservers {
      center.removeObserver(token)
    }
    notificationObservers.removeAll()

    keyValueObservations.forEach { $0.invalidate() }
    keyValueObservations.removeAll()

    layoutObservationTokens.forEach { $0.cancel() }
    layoutObservationTokens.removeAll()

    closeButtonRefreshTimers.forEach { $0.invalidate() }
    closeButtonRefreshTimers.removeAll()

    stopEventMonitors()

    if let trackingArea {
      containerView?.removeTrackingArea(trackingArea)
      self.trackingArea = nil
    }
  }

  /// Starts the event monitors if they're not started.
  ///
  /// The monitors are process-wide, so they're only kept while the window is open, see `windowWillClose()`.
  private func startEventMonitors() {
    if flagsChangedMonitor == nil {
      flagsChangedMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
        MainActor.assumeIsolated {
          self?.update()
        }
        return event
      }
    }

    if globalMouseMonitor == nil {
      // the events of other apps, so that the cluster is left when the mouse moves to another app's window above it
      globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(
        matching: [.leftMouseDown, .leftMouseUp, .rightMouseDown, .otherMouseDown, .mouseMoved]
      ) { [weak self] event in
        MainActor.assumeIsolated {
          self?.handleMouseEvent(event)
        }
      }
    }
  }

  /// Stops the event monitors.
  private func stopEventMonitors() {
    if let flagsChangedMonitor {
      NSEvent.removeMonitor(flagsChangedMonitor)
      self.flagsChangedMonitor = nil
    }
    if let globalMouseMonitor {
      NSEvent.removeMonitor(globalMouseMonitor)
      self.globalMouseMonitor = nil
    }
  }

  // MARK: - Window Events

  /// Handles a change of the window's frame.
  private func windowFrameDidChange() {
    syncLayout()
    isMouseInside = isCursorInsideCluster()
    update()
  }

  /// Handles the window becoming key.
  private func windowDidBecomeKey() {
    startEventMonitors()
    refresh()
    scheduleKeyWindowRefresh()
  }

  /// Schedules a refresh on the next run loop after the window becomes key for the first time since it's shown.
  ///
  /// When an app launches, the window can become key before AppKit finishes activating the app, and the system
  /// buttons report their states for the inactive window. Refreshing again on the next run loop picks up the final
  /// states, so the buttons don't stay gray.
  private func scheduleKeyWindowRefresh() {
    guard !hasBecomeKey else {
      return
    }
    hasBecomeKey = true

    DispatchQueue.main.async { [weak self] in
      MainActor.assumeIsolated {
        self?.refresh()
      }
    }
  }

  /// Handles a change of the window's visibility, e.g. when it's ordered front.
  private func windowOcclusionStateDidChange() {
    guard let window, window.occlusionState.contains(.visible) else {
      return
    }

    // the window is shown (e.g. ordered front or reopened): the tracking area doesn't report a cursor that is already
    // there, so the cursor location is checked
    startEventMonitors()
    syncLayout()
    isMouseInside = isCursorInsideCluster()
    update()
  }

  /// Handles the window closing.
  private func windowWillClose() {
    // the window can be reopened (e.g. from a menu), so it should start from a clean state instead of showing the
    // hovered or pressed state from when it closed
    isMouseInside = false
    isExitingFullScreen = false
    hasBecomeKey = false
    closeButtonRefreshTimers.forEach { $0.invalidate() }
    closeButtonRefreshTimers.removeAll()

    // the monitors are process-wide, they shouldn't run for a closed window. they start again when the window shows.
    stopEventMonitors()

    for buttonView in buttonViews.values {
      buttonView.state = .normal(nil)
    }
  }

  /// Handles a change of the window's screen scale.
  private func windowBackingPropertiesDidChange() {
    // the hairlines are drawn for the screen's scale
    for buttonView in buttonViews.values {
      buttonView.setNeedsRefresh(animated: false)
    }
  }

  /// Handles the start of a full screen transition.
  ///
  /// - Parameter isEntering: Whether the window is entering full screen.
  private func windowFullScreenWillChange(isEntering: Bool) {
    // the glyphs are hidden while the window exits full screen
    isExitingFullScreen = !isEntering && isFullScreen
    refresh()
  }

  /// Handles the end of a full screen transition.
  ///
  /// - Parameter isFullScreen: Whether the window is in full screen.
  private func windowFullScreenDidChange(isFullScreen: Bool) {
    self.isFullScreen = isFullScreen
    isExitingFullScreen = false

    // the tracking area doesn't report the cursor after the transition, so the cursor location is checked
    syncLayout()
    isMouseInside = isCursorInsideCluster()
    update()
  }

  /// Handles a change of the system accent color.
  private func accentColorDidChange() {
    let isGraphite = Self.isGraphiteAccentColor()
    guard self.isGraphite != isGraphite else {
      return
    }
    self.isGraphite = isGraphite
    for buttonView in buttonViews.values {
      buttonView.isGraphite = isGraphite
    }
  }

  /// Schedules refreshes for a short period after the close button changes.
  ///
  /// The close button can show its pressed state briefly without a layout to restore it, e.g. when a close is
  /// cancelled by the window's delegate (`windowShouldClose(_:)`), or when the button is disabled for a sheet. Refreshing
  /// a few times after each layout picks up the restored state. The refreshes are cheap: the buttons only redraw when
  /// their states change.
  private func scheduleCloseButtonRefreshes() {
    closeButtonRefreshTimers.forEach { $0.invalidate() }
    closeButtonRefreshTimers.removeAll()

    let startTime = Date()
    let repeatingTimer = Timer(timeInterval: Constants.closeButtonRefreshInterval, repeats: true) { [weak self] timer in
      MainActor.assumeIsolated {
        if Date().timeIntervalSince(startTime) >= Constants.closeButtonRefreshDuration {
          timer.invalidate()
        }
        self?.refresh()
      }
    }
    RunLoop.main.add(repeatingTimer, forMode: .common)

    // a modal window (e.g. an alert) runs the run loop in the modal mode until it closes, a timer in the default mode
    // fires after that
    let finalTimer = Timer(timeInterval: Constants.closeButtonRefreshDuration, repeats: false) { [weak self] _ in
      MainActor.assumeIsolated {
        self?.refresh()
      }
    }
    RunLoop.main.add(finalTimer, forMode: .default)

    closeButtonRefreshTimers = [repeatingTimer, finalTimer]
  }

  // MARK: - Graphite

  /// Returns whether the system uses the graphite accent color, which turns the system traffic light buttons gray.
  ///
  /// - Returns: `true` if the accent color is graphite.
  static func isGraphiteAccentColor() -> Bool {
    NSColor.currentControlTint == .graphiteControlTint
  }

  // MARK: - Constants

  private enum Constants {

    /// The alpha of the system buttons. It isn't zero so that the buttons still take clicks and lay out.
    static let systemButtonAlpha: CGFloat = 0.001

    /// The interval of the refreshes after the close button changes.
    static let closeButtonRefreshInterval: TimeInterval = 0.05

    /// The duration of the refreshes after the close button changes.
    static let closeButtonRefreshDuration: TimeInterval = 0.2
  }
}

// MARK: - MouseEventReceiver

/// The owner of the traffic light tracking area, which forwards the mouse events.
private final class MouseEventReceiver: NSResponder {

  private let handler: (NSEvent) -> Void

  /// Creates a receiver.
  ///
  /// - Parameter handler: The handler of the mouse entered, moved and exited events.
  init(handler: @escaping (NSEvent) -> Void) {
    self.handler = handler
    super.init()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  override func mouseEntered(with event: NSEvent) {
    handler(event)
  }

  override func mouseMoved(with event: NSEvent) {
    handler(event)
  }

  override func mouseExited(with event: NSEvent) {
    handler(event)
  }
}

// MARK: - TitlebarHierarchy

/// The titlebar views of a window, found in AppKit's private view hierarchy.
///
/// The hierarchy, which `install()` relies on:
/// ```
/// macOS 15 (Sequoia)
/// NSThemeFrame
/// |-- NSVisualEffectView
/// |-- window.contentView
/// |-- NSTitlebarContainerView
///     |-- _NSTitlebarDecorationView
///     |-- NSTitlebarView
///         |-- NSVisualEffectView
///         |-- NSView
///         |-- _NSThemeCloseWidget
///         |-- _NSThemeZoomWidget
///         |-- _NSThemeWidget (miniaturize)
///         |-- NSTextField
///
/// macOS 26 (Tahoe), 26.4.1
/// NSThemeFrame
/// |-- NSVisualEffectView
/// |-- window.contentView
/// |-- NSTitlebarContainerView
///     |-- NSTitlebarView
///     |   |-- NSTitlebarBackgroundView
///     |   |-- NSView (not in 26.4.1)
///     |   |-- NSTextField (usually hidden, shows the title)
///     |   |-- _NSThemeCloseWidget
///     |   |-- _NSThemeZoomWidget
///     |   |-- _NSThemeWidget (miniaturize)
///     |-- _NSTitlebarDecorationView (adds a top highlight to the titlebar in dark mode)
///
/// macOS 27, 27.0.1
/// NSThemeFrame
/// |-- NSVisualEffectView
/// |-- window.contentView
/// |-- NSTitlebarContainerView
///     |-- NSTitlebarBackgroundView
///     |-- _NSTitlebarDecorationView
///     |-- NSView (not with `.fullSizeContentView`)
///     |-- NSTitlebarView
///         |-- NSView (empty)
///         |-- _NSThemeCloseWidget
///         |-- _NSThemeZoomWidget
///         |-- _NSThemeWidget (miniaturize)
///         |-- NSTextField
/// ```
private struct TitlebarHierarchy {

  /// The window's frame view, `NSThemeFrame`.
  let themeFrame: NSView

  /// The titlebar container view, `NSTitlebarContainerView`.
  let titlebarContainerView: NSView

  /// The titlebar view, `NSTitlebarView`, which holds the system buttons.
  ///
  /// It's kept in the window so that tools that look for the system buttons (e.g. window managers, accessibility)
  /// still find them.
  let titlebarView: NSView

  /// Finds the titlebar views of a window.
  ///
  /// - Parameter window: The window.
  /// - Returns: The titlebar views, or `nil` if the hierarchy isn't recognized.
  init?(window: NSWindow) {
    guard let themeFrame = window.contentView?.superview, themeFrame.className == "NSThemeFrame" else {
      ChouTi.assertFailure("the window's frame view isn't NSThemeFrame", metadata: ["frameView": "\(String(describing: window.contentView?.superview))"])
      return nil
    }

    guard let titlebarContainerView = themeFrame.subviews.first(where: { $0.className == "NSTitlebarContainerView" }) else {
      ChouTi.assertFailure("NSTitlebarContainerView isn't found")
      return nil
    }

    guard let titlebarView = titlebarContainerView.subviews.first(where: { $0.className == "NSTitlebarView" }) else {
      ChouTi.assertFailure("NSTitlebarView isn't found")
      return nil
    }

    self.themeFrame = themeFrame
    self.titlebarContainerView = titlebarContainerView
    self.titlebarView = titlebarView
  }

  /// Removes the titlebar background views, so that the window draws its own titlebar background.
  ///
  /// - Parameter window: The window.
  func removeBackgroundViews(window: NSWindow) {
    let windowBackgroundCount = themeFrame.removeSubviews(ofClassNames: ["NSVisualEffectView"])
    ChouTi.assert(windowBackgroundCount > 0 || window.backgroundColor == .clear, "a window with a background should have NSVisualEffectView")

    // the titlebar background moves between OS versions, see the hierarchy above
    var titlebarBackgroundCount = titlebarContainerView.removeSubviews(ofClassNames: ["_NSTitlebarDecorationView", "NSTitlebarBackgroundView"])
    if #available(macOS 26, *) {
      titlebarBackgroundCount += titlebarView.removeSubviews(ofClassNames: ["NSTitlebarBackgroundView"])
    } else {
      titlebarBackgroundCount += titlebarView.removeSubviews(ofClassNames: ["NSVisualEffectView", "NSView"])
    }
    ChouTi.assert(titlebarBackgroundCount > 0, "the titlebar background views aren't found")
  }
}

private extension NSView {

  /// Removes the direct subviews of the class names.
  ///
  /// - Parameter classNames: The class names of the subviews to remove.
  /// - Returns: The number of the removed subviews.
  @discardableResult
  func removeSubviews(ofClassNames classNames: Set<String>) -> Int {
    let subviewsToRemove = subviews.filter { classNames.contains($0.className) }
    subviewsToRemove.forEach { $0.removeFromSuperview() }
    return subviewsToRemove.count
  }
}

private extension AquaTrafficLightButtonKind {

  /// The type of the system button.
  var systemButtonType: NSWindow.ButtonType {
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
