//
//  View+ThemedBackgroundColorTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/13/24.
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

import ChouTiTest

import ChouTi
import ChouTiUI

class View_ThemedBackgroundColorTests: XCTestCase {

  func test_setBackgroundColor() {
    // On iOS, the view must be in a window hierarchy for trait changes to propagate
    let window = TestWindow()

    let view = View()
    #if os(macOS)
    view.wantsLayer = true
    #endif

    window.contentView().addSubview(view)

    if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
      view.setBackgroundColor(ThemedUnifiedColor(light: .color(.red), dark: .color(.blue)))
    }

    // verify the underlying theme binding observation is set up
    let observations = DynamicLookup(view.bindingObservationStorage).lazyProperty("observations") as? [AnyHashable: BindingObservation]
    try expect(Array(observations.unwrap().keys)) == ["io.chouti.ChouTiUI.ThemeUpdating.themed-background-color"]

    view.overrideTheme = .light
    wait(timeout: 0.01)
    expect(view.layer()?.backgroundColor) == Color.red.cgColor

    view.overrideTheme = .dark
    wait(timeout: 0.01)
    expect(view.layer()?.backgroundColor) == Color.blue.cgColor

    if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
      view.setBackgroundColor(ThemedColor(light: .yellow, dark: .green))
    }

    // verify the underlying theme binding observations still have only one observation
    let observations1 = DynamicLookup(view.bindingObservationStorage).lazyProperty("observations") as? [AnyHashable: BindingObservation]
    try expect(Array(observations1.unwrap().keys)) == ["io.chouti.ChouTiUI.ThemeUpdating.themed-background-color"]

    view.overrideTheme = .light
    wait(timeout: 0.01)
    expect(view.layer()?.backgroundColor) == Color.yellow.cgColor

    view.overrideTheme = .dark
    wait(timeout: 0.01)
    expect(view.layer()?.backgroundColor) == Color.green.cgColor
  }
}
