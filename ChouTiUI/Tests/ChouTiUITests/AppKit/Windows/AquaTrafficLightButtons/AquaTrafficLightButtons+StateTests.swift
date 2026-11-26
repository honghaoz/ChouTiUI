//
//  AquaTrafficLightButtons+StateTests.swift
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

import ChouTiTest

@testable import ChouTiUI

class AquaTrafficLightButtons_StateTests: XCTestCase {

  private let enabled = AquaTrafficLightSystemButtonState(isEnabled: true, isHighlighted: false)
  private let pressed = AquaTrafficLightSystemButtonState(isEnabled: true, isHighlighted: true)
  private let disabled = AquaTrafficLightSystemButtonState(isEnabled: false, isHighlighted: false)

  /// Makes inputs with all system buttons enabled and not pressed.
  private func makeInputs(isKey: Bool,
                          isMouseInside: Bool,
                          isOptionPressed: Bool = false,
                          isFullScreen: Bool = false,
                          canEnterFullScreen: Bool = true,
                          isDocumentEdited: Bool = false) -> AquaTrafficLightInputs
  {
    AquaTrafficLightInputs(
      isKey: isKey,
      isMouseInside: isMouseInside,
      isOptionPressed: isOptionPressed,
      isFullScreen: isFullScreen,
      canEnterFullScreen: canEnterFullScreen,
      isDocumentEdited: isDocumentEdited,
      close: enabled,
      miniaturize: enabled,
      zoom: enabled
    )
  }

  // MARK: - Button State

  func test_buttonState_glyphAndInactive() {
    expect(AquaTrafficLightButtonState.normal(nil).glyph) == nil
    expect(AquaTrafficLightButtonState.normal(.documentEdited).glyph) == .documentEdited
    expect(AquaTrafficLightButtonState.hovered(.close).glyph) == .close
    expect(AquaTrafficLightButtonState.pressed(.zoom).glyph) == .zoom
    expect(AquaTrafficLightButtonState.inactive(.documentEdited).glyph) == .documentEdited

    expect(AquaTrafficLightButtonState.normal(nil).isInactive) == false
    expect(AquaTrafficLightButtonState.hovered(.close).isInactive) == false
    expect(AquaTrafficLightButtonState.pressed(.close).isInactive) == false
    expect(AquaTrafficLightButtonState.inactive(nil).isInactive) == true
  }

  // MARK: - Key Window

  func test_key_mouseInside_showsGlyphs() {
    // given a key normal window with the mouse over the cluster
    let inputs = makeInputs(isKey: true, isMouseInside: true)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then the buttons show their glyphs, and zoom shows the enter full screen glyph
    expect(outputs) == AquaTrafficLightOutputs(close: .hovered(.close), miniaturize: .hovered(.miniaturize), zoom: .hovered(.enterFullScreen))
  }

  func test_key_mouseInside_fullScreen_showsExitFullScreenGlyph() {
    // given a key window in full screen with the mouse over the cluster
    let inputs = makeInputs(isKey: true, isMouseInside: true, isFullScreen: true)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then zoom shows the exit full screen glyph
    expect(outputs.zoom) == .hovered(.exitFullScreen)
  }

  func test_key_mouseInside_option_showsZoomGlyph() {
    // given a key window with the mouse over the cluster and the Option key pressed
    let inputs = makeInputs(isKey: true, isMouseInside: true, isOptionPressed: true)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then zoom shows "+", the others are unchanged
    expect(outputs) == AquaTrafficLightOutputs(close: .hovered(.close), miniaturize: .hovered(.miniaturize), zoom: .hovered(.zoom))
  }

  func test_key_mouseInside_option_fullScreen_showsExitFullScreenGlyph() {
    // given a key window in full screen with the mouse over the cluster and the Option key pressed
    let inputs = makeInputs(isKey: true, isMouseInside: true, isOptionPressed: true, isFullScreen: true)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then zoom still shows the exit full screen glyph
    expect(outputs.zoom) == .hovered(.exitFullScreen)
  }

  func test_key_mouseInside_cannotEnterFullScreen_showsZoomGlyph() {
    // given a key window that can't enter full screen (e.g. a panel, a window with a sheet)
    let inputs = makeInputs(isKey: true, isMouseInside: true, canEnterFullScreen: false)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then zoom shows "+"
    expect(outputs.zoom) == .hovered(.zoom)
  }

  func test_key_mouseInside_pressedButtons() {
    // given a key window with the mouse over the cluster and pressed system buttons
    var inputs = makeInputs(isKey: true, isMouseInside: true)
    inputs.close = pressed
    inputs.miniaturize = pressed
    inputs.zoom = pressed

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then the buttons show the pressed state with their glyphs
    expect(outputs) == AquaTrafficLightOutputs(close: .pressed(.close), miniaturize: .pressed(.miniaturize), zoom: .pressed(.enterFullScreen))
  }

  func test_key_mouseInside_disabledButtons() {
    // given a key window with the mouse over the cluster and disabled system buttons
    var inputs = makeInputs(isKey: true, isMouseInside: true)
    inputs.close = disabled
    inputs.miniaturize = disabled
    inputs.zoom = disabled

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then the buttons are inactive without glyphs
    expect(outputs) == AquaTrafficLightOutputs(close: .inactive(nil), miniaturize: .inactive(nil), zoom: .inactive(nil))
  }

  func test_key_mouseOutside_showsColorsWithoutGlyphs() {
    // given a key window with the mouse outside of the cluster
    let inputs = makeInputs(isKey: true, isMouseInside: false)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then the buttons show their colors without glyphs
    expect(outputs) == AquaTrafficLightOutputs(close: .normal(nil), miniaturize: .normal(nil), zoom: .normal(nil))
  }

  func test_key_mouseOutside_pressedButtons() {
    // given a key window with the mouse outside of the cluster and the buttons pressed by key equivalents
    var inputs = makeInputs(isKey: true, isMouseInside: false)
    inputs.close = pressed // ⌘W while the window has a child window
    inputs.miniaturize = pressed // ⌘M
    inputs.zoom = pressed // exiting full screen

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then close and miniaturize show the pressed state, zoom hides its glyph
    expect(outputs) == AquaTrafficLightOutputs(close: .pressed(.close), miniaturize: .pressed(.miniaturize), zoom: .normal(nil))
  }

  func test_key_mouseOutside_disabledButtons() {
    // given a key window with the mouse outside of the cluster and disabled system buttons (e.g. a sheet is shown)
    var inputs = makeInputs(isKey: true, isMouseInside: false)
    inputs.close = disabled
    inputs.miniaturize = disabled
    inputs.zoom = disabled

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then the buttons are inactive
    expect(outputs) == AquaTrafficLightOutputs(close: .inactive(nil), miniaturize: .inactive(nil), zoom: .inactive(nil))
  }

  // MARK: - Non-Key Window

  func test_nonKey_mouseInside_showsGlyphs_ignoresOption() {
    // given a non-key window with the mouse over the cluster and the Option key pressed
    let inputs = makeInputs(isKey: false, isMouseInside: true, isOptionPressed: true)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then the buttons show their glyphs, and the Option key doesn't turn zoom into "+"
    expect(outputs) == AquaTrafficLightOutputs(close: .hovered(.close), miniaturize: .hovered(.miniaturize), zoom: .hovered(.enterFullScreen))
  }

  func test_nonKey_mouseInside_cannotEnterFullScreen_showsZoomGlyph() {
    // given a non-key window that can't enter full screen, with the mouse over the cluster
    let inputs = makeInputs(isKey: false, isMouseInside: true, canEnterFullScreen: false)

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then zoom shows "+"
    expect(outputs.zoom) == .hovered(.zoom)
  }

  func test_nonKey_mouseOutside_isInactive() {
    // given a non-key window with the mouse outside of the cluster, even with pressed buttons
    var inputs = makeInputs(isKey: false, isMouseInside: false)
    inputs.close = pressed

    // when resolving
    let outputs = resolveAquaTrafficLightStates(inputs)

    // then the buttons are gray
    expect(outputs) == AquaTrafficLightOutputs(close: .inactive(nil), miniaturize: .inactive(nil), zoom: .inactive(nil))
  }

  // MARK: - Document Edited

  func test_documentEdited_showsDotInEveryCloseState() {
    // given the window has unsaved changes
    let cases: [(inputs: AquaTrafficLightInputs, expected: AquaTrafficLightButtonState)] = [
      (makeInputs(isKey: true, isMouseInside: true, isDocumentEdited: true), .hovered(.documentEdited)),
      (makeInputs(isKey: true, isMouseInside: true, isOptionPressed: true, isDocumentEdited: true), .hovered(.documentEdited)),
      (makeInputs(isKey: true, isMouseInside: false, isDocumentEdited: true), .normal(.documentEdited)),
      (makeInputs(isKey: false, isMouseInside: true, isDocumentEdited: true), .hovered(.documentEdited)),
      (makeInputs(isKey: false, isMouseInside: false, isDocumentEdited: true), .inactive(.documentEdited)),
    ]

    for (inputs, expected) in cases {
      // when resolving
      let outputs = resolveAquaTrafficLightStates(inputs)

      // then the close button shows the dot instead of the cross
      expect(outputs.close) == expected
    }
  }

  func test_documentEdited_pressedAndDisabledClose() {
    // given the window has unsaved changes, with the close button pressed or disabled
    var pressedInputs = makeInputs(isKey: true, isMouseInside: true, isDocumentEdited: true)
    pressedInputs.close = pressed
    var pressedOutsideInputs = makeInputs(isKey: true, isMouseInside: false, isDocumentEdited: true)
    pressedOutsideInputs.close = pressed
    var disabledInputs = makeInputs(isKey: true, isMouseInside: true, isDocumentEdited: true)
    disabledInputs.close = disabled
    var disabledOutsideInputs = makeInputs(isKey: true, isMouseInside: false, isDocumentEdited: true)
    disabledOutsideInputs.close = disabled

    // when resolving, then the dot stays on the close button
    expect(resolveAquaTrafficLightStates(pressedInputs).close) == .pressed(.documentEdited)
    expect(resolveAquaTrafficLightStates(pressedOutsideInputs).close) == .pressed(.documentEdited)
    expect(resolveAquaTrafficLightStates(disabledInputs).close) == .inactive(.documentEdited)
    expect(resolveAquaTrafficLightStates(disabledOutsideInputs).close) == .inactive(.documentEdited)
  }
}

#endif
