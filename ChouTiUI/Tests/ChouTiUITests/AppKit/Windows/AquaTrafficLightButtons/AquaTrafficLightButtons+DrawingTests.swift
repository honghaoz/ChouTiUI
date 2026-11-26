//
//  AquaTrafficLightButtons+DrawingTests.swift
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
class AquaTrafficLightButtons_DrawingTests: XCTestCase {

  /// Counts the layers that a view's content renders, including the layers of the nested views.
  private func layerCount(_ view: NSView) -> Int {
    func count(_ layer: CALayer) -> Int {
      (layer.sublayers ?? []).reduce(0) { $0 + 1 + count($1) }
    }
    return (view.layer.map(count) ?? 0) + view.subviews.reduce(0) { $0 + layerCount($1) }
  }

  func test_primaryColor() {
    // given the default accent color, the buttons use the Big Sur colors
    expect(AquaTrafficLightButtonKind.close.primaryColor(isGraphite: false)) == ThemedColor(Color.hex("#fe5f57"))
    expect(AquaTrafficLightButtonKind.miniaturize.primaryColor(isGraphite: false)) == ThemedColor(Color.hex("#febc2e"))
    expect(AquaTrafficLightButtonKind.zoom.primaryColor(isGraphite: false)) == ThemedColor(Color.hex("#28c840"))

    // given the graphite accent color, all buttons use the same gray
    let graphite = ThemedColor(Color.hex("#8E8E8E"))
    for kind in AquaTrafficLightButtonKind.allCases {
      expect(kind.primaryColor(isGraphite: true)) == graphite
    }
  }

  func test_buttonView_passesClicksThrough() {
    // given a button view
    let view = AquaTrafficLightButtonView(kind: .close)
    view.frame = CGRect(x: 0, y: 0, width: 16, height: 18)

    // when hit testing a point inside, then the view passes the click through
    expect(view.hitTest(CGPoint(x: 8, y: 9))) == nil
    expect(view.acceptsFirstResponder) == false
  }

  func test_buttonView_rendersContent() {
    // given a button view in a window
    let window = NSWindow(contentRect: CGRect(x: 0, y: 0, width: 100, height: 100), styleMask: [.titled], backing: .buffered, defer: false)
    let view = AquaTrafficLightButtonView(kind: .close)
    view.frame = CGRect(x: 0, y: 0, width: 16, height: 18)
    window.contentView?.addSubview(view)

    // when refreshing without a glyph and then with a glyph
    view.state = .normal(nil)
    view.refresh(animated: false)
    let layerCountWithoutGlyph = layerCount(view)

    view.state = .hovered(.close)
    view.refresh(animated: false)
    let layerCountWithGlyph = layerCount(view)

    // then the glyph adds its layers
    expect(layerCountWithoutGlyph) > 0
    expect(layerCountWithGlyph) > layerCountWithoutGlyph
  }

  func test_buttonView_emptyForTinySize() {
    // given a button view too small for the button circle
    let view = AquaTrafficLightButtonView(kind: .zoom)
    view.frame = CGRect(x: 0, y: 0, width: 2, height: 2)

    // when refreshing, then nothing is drawn
    let emptyLayerCount = layerCount(view)
    view.refresh(animated: false)
    expect(layerCount(view)) == emptyLayerCount
  }
}

#endif
