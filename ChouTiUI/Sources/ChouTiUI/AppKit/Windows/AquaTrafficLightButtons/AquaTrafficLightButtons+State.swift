//
//  AquaTrafficLightButtons+State.swift
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

import Foundation

/// The appearance state of an Aqua traffic light button.
enum AquaTrafficLightButtonState: Equatable {

  /// The button shows its color, with an optional glyph.
  case normal(AquaTrafficLightGlyph?)

  /// The mouse is over the button cluster: the button shows its color and its glyph.
  case hovered(AquaTrafficLightGlyph)

  /// The button is pressed: the button shows a darker color and its glyph.
  case pressed(AquaTrafficLightGlyph)

  /// The button is inactive (the window isn't key, or the button is disabled): the button is gray, with an optional
  /// glyph.
  case inactive(AquaTrafficLightGlyph?)

  /// The glyph to draw on the button.
  var glyph: AquaTrafficLightGlyph? {
    switch self {
    case .normal(let glyph),
         .inactive(let glyph):
      return glyph
    case .hovered(let glyph),
         .pressed(let glyph):
      return glyph
    }
  }

  /// Whether the button is drawn gray.
  var isInactive: Bool {
    switch self {
    case .normal,
         .hovered,
         .pressed:
      return false
    case .inactive:
      return true
    }
  }
}

/// The state of a system traffic light button (`_NSThemeWidget`) that drives the custom button's appearance.
struct AquaTrafficLightSystemButtonState: Equatable {

  /// Whether the system button is enabled.
  var isEnabled: Bool

  /// Whether the system button is highlighted, which is while it's pressed by the mouse or by a key equivalent.
  var isHighlighted: Bool
}

/// The inputs to resolve the Aqua traffic light button states.
struct AquaTrafficLightInputs: Equatable {

  /// Whether the window is the key window.
  var isKey: Bool

  /// Whether the mouse is over the traffic light cluster.
  var isMouseInside: Bool

  /// Whether the Option key is pressed.
  var isOptionPressed: Bool

  /// Whether the window is in full screen.
  var isFullScreen: Bool

  /// Whether the window is at the normal window level. Only normal windows can enter full screen.
  var isNormalWindow: Bool

  /// Whether the window has unsaved changes.
  var isDocumentEdited: Bool

  /// The state of the system close button.
  var close: AquaTrafficLightSystemButtonState

  /// The state of the system miniaturize button.
  var miniaturize: AquaTrafficLightSystemButtonState

  /// The state of the system zoom button.
  var zoom: AquaTrafficLightSystemButtonState
}

/// The resolved Aqua traffic light button states.
struct AquaTrafficLightOutputs: Equatable {

  /// The close button state.
  var close: AquaTrafficLightButtonState

  /// The miniaturize button state.
  var miniaturize: AquaTrafficLightButtonState

  /// The zoom button state.
  var zoom: AquaTrafficLightButtonState
}

/*
 The states that the system buttons show, which the resolution below reproduces:

 1. close (red):
   - regular (plain red) + normal
   - regular + inactive (gray)
   - regular + hovered and pressed
   - cross + hovered
   - cross + pressed
   - dot + normal (when the document window is modified)
   - dot + inactive
   - dot + hovered and pressed
 2. miniaturize (yellow):
   - regular + normal
   - regular + inactive (gray)
   - regular + hovered and pressed
 3. zoom (green):
   - enlarge (enter full screen)
   - "+" (zoom, with the Option key, or for a window that can't enter full screen)
   - shrink (exit full screen)

 Note: when a modal window (sheet, alert) is presented, the close button is inactive, the miniaturize button still
 works, and the zoom button becomes "+".
 */

/// Resolves the Aqua traffic light button states from the window state.
///
/// | Window state                | Close                   | Miniaturize   | Zoom                                         |
/// |-----------------------------|-------------------------|---------------|----------------------------------------------|
/// | key, mouse inside, Option   | × (or dot)              | −             | + (exit full screen glyph in full screen)    |
/// | key, mouse inside           | × (or dot)              | −             | full screen glyphs, + for non-normal windows |
/// | key, mouse outside          | colored (dot if edited) | colored       | colored                                      |
/// | not key, mouse inside       | × (or dot)              | −             | full screen glyphs (Option is ignored)       |
/// | not key, mouse outside      | gray (dot if edited)    | gray          | gray                                         |
///
/// A highlighted (pressed) system button shows the pressed state, and a disabled system button shows the inactive state.
///
/// - Parameter inputs: The window state.
/// - Returns: The button states.
func resolveAquaTrafficLightStates(_ inputs: AquaTrafficLightInputs) -> AquaTrafficLightOutputs {
  let closeGlyph: AquaTrafficLightGlyph = inputs.isDocumentEdited ? .documentEdited : .close
  let closeInactiveGlyph: AquaTrafficLightGlyph? = inputs.isDocumentEdited ? .documentEdited : nil

  /// Resolves the state of a button that the mouse is over.
  func hoveredState(_ button: AquaTrafficLightSystemButtonState,
                    glyph: AquaTrafficLightGlyph,
                    inactiveGlyph: AquaTrafficLightGlyph?) -> AquaTrafficLightButtonState
  {
    switch (button.isEnabled, button.isHighlighted) {
    case (true, true):
      return .pressed(glyph)
    case (true, false):
      return .hovered(glyph)
    case (false, _):
      return .inactive(inactiveGlyph)
    }
  }

  switch (inputs.isKey, inputs.isMouseInside) {
  case (_, true):
    // the Option key only matters for the key window: it turns the full screen glyph into "+" (zoom)
    let zoomGlyph: AquaTrafficLightGlyph
    if inputs.isKey, inputs.isOptionPressed {
      zoomGlyph = inputs.isFullScreen ? .exitFullScreen : .zoom
    } else if inputs.isNormalWindow {
      zoomGlyph = inputs.isFullScreen ? .exitFullScreen : .enterFullScreen
    } else {
      zoomGlyph = .zoom
    }
    return AquaTrafficLightOutputs(
      close: hoveredState(inputs.close, glyph: closeGlyph, inactiveGlyph: closeInactiveGlyph),
      miniaturize: hoveredState(inputs.miniaturize, glyph: .miniaturize, inactiveGlyph: nil),
      zoom: hoveredState(inputs.zoom, glyph: zoomGlyph, inactiveGlyph: nil)
    )

  case (true, false):
    let close: AquaTrafficLightButtonState
    switch (inputs.close.isEnabled, inputs.close.isHighlighted) {
    case (true, true):
      // closing by the shortcut while the window has a child window
      close = .pressed(closeGlyph)
    case (true, false):
      close = .normal(closeInactiveGlyph)
    case (false, _):
      close = .inactive(closeInactiveGlyph)
    }

    let miniaturize: AquaTrafficLightButtonState
    switch (inputs.miniaturize.isEnabled, inputs.miniaturize.isHighlighted) {
    case (true, true):
      // miniaturizing by ⌘M
      miniaturize = .pressed(.miniaturize)
    case (true, false):
      miniaturize = .normal(nil)
    case (false, _):
      miniaturize = .inactive(nil)
    }

    // a highlighted zoom button with the mouse outside happens when the zoom button exits full screen: the glyph
    // should be hidden
    let zoom: AquaTrafficLightButtonState = inputs.zoom.isEnabled ? .normal(nil) : .inactive(nil)

    return AquaTrafficLightOutputs(close: close, miniaturize: miniaturize, zoom: zoom)

  case (false, false):
    return AquaTrafficLightOutputs(close: .inactive(closeInactiveGlyph), miniaturize: .inactive(nil), zoom: .inactive(nil))
  }
}

#endif
