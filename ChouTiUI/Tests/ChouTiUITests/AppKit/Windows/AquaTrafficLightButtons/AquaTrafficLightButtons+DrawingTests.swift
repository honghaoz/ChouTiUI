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

  func test_buttonView_redrawsWhenResized() {
    // given a button view drawn for one size
    let window = NSWindow(contentRect: CGRect(x: 0, y: 0, width: 100, height: 100), styleMask: [.titled], backing: .buffered, defer: false)
    let view = AquaTrafficLightButtonView(kind: .close)
    view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    window.contentView?.addSubview(view)
    view.refresh(animated: false)
    expect(self.layerSizes(view).contains(CGSize(width: 8, height: 8))) == true

    // when the view is resized without a state change
    view.frame = CGRect(x: 0, y: 0, width: 16, height: 18)

    // then the button is drawn for the new size: the circle area is inset by 1pt
    expect(self.layerSizes(view).contains(CGSize(width: 14, height: 16))).toEventually(beTrue())
  }

  /// Returns the sizes of the layers that a view's content renders, including the layers of the nested views.
  private func layerSizes(_ view: NSView) -> [CGSize] {
    func sizes(_ layer: CALayer) -> [CGSize] {
      (layer.sublayers ?? []).flatMap { [$0.bounds.size] + sizes($0) }
    }
    return (view.layer.map(sizes) ?? []) + view.subviews.flatMap { layerSizes($0) }
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

  #if DEBUG
  func test_buttonView_hairlinesFollowScreenScale() throws {
    // the light mode border is tinted with the button color, which is gray with the graphite accent color
    AquaTrafficLightButtonView.isGraphiteAccentColorOverride = false
    defer {
      AquaTrafficLightButtonView.isGraphiteAccentColorOverride = nil
    }

    for isDark in [false, true] {
      for scale in [CGFloat(1), 2] {
        // given a close button view drawn for a theme and a screen scale
        let window = NSWindow(contentRect: CGRect(x: 0, y: 0, width: 100, height: 100), styleMask: [.titled], backing: .buffered, defer: false)
        window.appearance = NSAppearance(named: isDark ? .darkAqua : .aqua)
        let view = AquaTrafficLightButtonView(kind: .close)
        view.backingScaleFactorOverride = scale
        view.frame = CGRect(x: 0, y: 0, width: 16, height: 18)
        window.contentView?.addSubview(view)

        // when rendering
        view.refresh(animated: false)

        // then the border strokes the button circle with a hairline, clipped to the inner half of the stroke
        expect(view.pixelSize) == 1 / scale
        let borderLayers = shapeLayers(view).filter { $0.fillColor == nil && $0.lineWidth > 0 }
        expect(borderLayers.count) == 1
        let borderLayer = try borderLayers.first.unwrap()
        let color = try borderLayer.strokeColor.flatMap { NSColor(cgColor: $0)?.usingColorSpace(.sRGB) }.unwrap()
        let buttonSize = CGSize(width: 14, height: 16)
        if isDark {
          // dark mode: a translucent black, one pixel outside the button
          expect(borderLayer.lineWidth) == 2 / scale
          expect(borderLayer.bounds.size) == CGSize(width: buttonSize.width + 2 / scale, height: buttonSize.height + 2 / scale)
          expect(color.redComponent) == 0
          expect(color.alphaComponent < 1) == true
        } else {
          // light mode: an opaque, darker red, half a pixel inside the button
          expect(borderLayer.lineWidth) == 1 / scale
          expect(borderLayer.bounds.size) == buttonSize
          expect(color.redComponent > color.greenComponent) == true
          expect(color.alphaComponent) == 1
        }
      }
    }
  }
  #endif

  #if DEBUG
  func test_buttonView_followsAccentColor() throws {
    // given a close button drawn with the default accent color
    AquaTrafficLightButtonView.isGraphiteAccentColorOverride = false
    defer {
      AquaTrafficLightButtonView.isGraphiteAccentColorOverride = nil
    }
    let window = NSWindow(contentRect: CGRect(x: 0, y: 0, width: 100, height: 100), styleMask: [.titled], backing: .buffered, defer: false)
    let view = AquaTrafficLightButtonView(kind: .close)
    view.frame = CGRect(x: 0, y: 0, width: 16, height: 18)
    window.contentView?.addSubview(view)
    view.refresh(animated: false)
    expect(try self.fillMiddleColor(view).isGray) == false

    // when the accent color changes to graphite, which changes the effective appearance
    AquaTrafficLightButtonView.isGraphiteAccentColorOverride = true
    view.viewDidChangeEffectiveAppearance()

    // then the button is redrawn gray
    expect((try? self.fillMiddleColor(view))?.isGray).toEventually(beEqual(to: true))
  }
  #endif

  /// Returns the middle color of the button's fill gradient.
  private func fillMiddleColor(_ view: NSView) throws -> (red: CGFloat, green: CGFloat, blue: CGFloat, isGray: Bool) {
    func layers(_ layer: CALayer) -> [CALayer] {
      (layer.sublayers ?? []).flatMap { [$0] + layers($0) }
    }
    func allLayers(_ view: NSView) -> [CALayer] {
      (view.layer.map(layers) ?? []) + view.subviews.flatMap { allLayers($0) }
    }
    let gradient = try allLayers(view).compactMap { $0 as? CAGradientLayer }.first { ($0.colors?.count ?? 0) == 3 }.unwrap()
    let colors = try (gradient.colors as? [CGColor]).unwrap()
    let color = try NSColor(cgColor: colors[1]).unwrap().usingColorSpace(.sRGB).unwrap()
    let isGray = abs(color.redComponent - color.greenComponent) < 0.01 && abs(color.greenComponent - color.blueComponent) < 0.01
    return (color.redComponent, color.greenComponent, color.blueComponent, isGray)
  }

  func test_buttonView_isNotAccessible() {
    let view = AquaTrafficLightButtonView(kind: .close)
    expect(view.isAccessibilityElement()) == false
    expect(view.accessibilityChildren()?.isEmpty) == true
  }

  /// Returns the shape layers that a view's content renders, including the layers of the nested views.
  private func shapeLayers(_ view: NSView) -> [CAShapeLayer] {
    func layers(_ layer: CALayer) -> [CALayer] {
      (layer.sublayers ?? []).flatMap { [$0] + layers($0) }
    }
    let ownLayers = view.layer.map(layers) ?? []
    return ownLayers.compactMap { $0 as? CAShapeLayer } + view.subviews.flatMap { shapeLayers($0) }
  }
}

#endif
