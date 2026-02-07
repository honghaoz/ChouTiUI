//
//  BorderLayerTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 2/5/26.
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

import QuartzCore

import ChouTiTest

import ChouTi
@testable import ChouTiUI

class BorderLayerTests: XCTestCase {

  // MARK: - Solid Color + Corner Radius

  func test_solidColor_cornerRadius_zeroOffset_useNativeBorderOffset() {
    // given: a border layer with native border offset support
    let layer = makeBorderLayer(usesNativeBorderOffset: true)
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    layer.borderWidth = 4
    layer.borderContent = .color(.red)
    layer.borderMask = .cornerRadius(12)

    // when: layout the layer
    layer.layoutSublayers()

    // then: the layer should not have a mask and no sublayers
    expect(layer.mask) == nil
    expect(layer.sublayers?.count ?? 0) == 0

    // then: the layer should have a border properties set as expected
    expect(layer.borderColor) == Color.red.cgColor
    expect(layer.cornerRadius) == 12
    expect(layer.borderWidth) == 4
    expect(layer.cornerCurve) == .continuous
    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      expect(layer.borderOffset) == 0
    }

    // then: the layer's internal layers should be nil
    expect(DynamicLookup(layer).keyPath("borderContentColorLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentGradientLayer") as CAGradientLayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentExternalLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderMaskLayer") as CALayer?) == nil
  }

  func test_solidColor_cornerRadius_zeroOffset_useMaskLayer() throws {
    // given: a border layer with fallback border offset support
    let layer = makeBorderLayer(usesNativeBorderOffset: false)
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    layer.borderWidth = 4
    layer.borderContent = .color(.red)
    layer.borderMask = .cornerRadius(12)

    // when: layout the layer
    layer.layoutSublayers()

    // then: the layer should have a content layer for the solid color
    let contentLayer = try (layer.sublayers?.first as? CALayer).unwrap()
    expect(contentLayer.frame) == layer.bounds
    expect(contentLayer.backgroundColor) == Color.red.cgColor
    expect(contentLayer.contentsScale) == layer.contentsScale

    // then: the layer should have a mask layer for masking the solid color
    let maskLayer = try layer.mask.unwrap()
    expect(maskLayer.frame) == layer.bounds
    expect(maskLayer.cornerRadius) == 12
    expect(maskLayer.borderWidth) == 4
    expect(maskLayer.cornerCurve) == .continuous
    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      expect(layer.borderOffset) == 0
    }

    // then: the layer's internal layers should be set as expected
    expect(DynamicLookup(layer).keyPath("borderContentColorLayer") as CALayer?) === contentLayer
    expect(DynamicLookup(layer).keyPath("borderContentGradientLayer") as CAGradientLayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentExternalLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderMaskLayer") as CALayer?) === maskLayer
  }

  func test_solidColor_cornerRadius_positiveOffset_useNativeBorderOffset() {
    // given: a border layer with native border offset support
    let layer = makeBorderLayer(usesNativeBorderOffset: true)
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    layer.borderWidth = 4
    layer.borderContent = .color(.red)
    layer.borderMask = .cornerRadius(12, offset: 3)

    // when: layout the layer
    layer.layoutSublayers()

    // then: the layer should not have a mask and no sublayers
    expect(layer.mask) == nil
    expect(layer.sublayers?.count ?? 0) == 0

    // then: the layer should have border properties set as expected
    expect(layer.borderColor) == Color.red.cgColor
    expect(layer.cornerRadius) == 12
    expect(layer.borderWidth) == 4
    expect(layer.cornerCurve) == .continuous
    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      expect(layer.borderOffset) == 3
    }

    // then: the layer's internal layers should be nil
    expect(DynamicLookup(layer).keyPath("borderContentColorLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentGradientLayer") as CAGradientLayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentExternalLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderMaskLayer") as CALayer?) == nil
  }

  func test_solidColor_cornerRadius_positiveOffset_useMaskLayer() throws {
    // given: a border layer with fallback border offset support
    let layer = makeBorderLayer(usesNativeBorderOffset: false)
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    layer.borderWidth = 4
    layer.borderContent = .color(.red)
    layer.borderMask = .cornerRadius(12, offset: 3)

    // when: layout the layer
    layer.layoutSublayers()

    // then: the layer should have a content layer for the solid color
    let contentLayer = try (layer.sublayers?.first as? CALayer).unwrap()
    expect(contentLayer.frame) == layer.bounds.expanded(by: 3)
    expect(contentLayer.backgroundColor) == Color.red.cgColor
    expect(contentLayer.contentsScale) == layer.contentsScale

    // then: the layer should have a mask layer for masking the solid color
    let maskLayer = try layer.mask.unwrap()
    expect(maskLayer.frame) == layer.bounds.expanded(by: 3)
    expect(maskLayer.cornerRadius) == 15
    expect(maskLayer.borderWidth) == 4
    expect(maskLayer.cornerCurve) == .continuous
    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      expect(layer.borderOffset) == 0
    }

    // then: the layer's internal layers should be set as expected
    expect(DynamicLookup(layer).keyPath("borderContentColorLayer") as CALayer?) === contentLayer
    expect(DynamicLookup(layer).keyPath("borderContentGradientLayer") as CAGradientLayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentExternalLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderMaskLayer") as CALayer?) === maskLayer
  }

  func test_solidColor_cornerRadius_negativeOffset_useNativeBorderOffset() {
    // given: a border layer with native border offset support
    let layer = makeBorderLayer(usesNativeBorderOffset: true)
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    layer.borderWidth = 4
    layer.borderContent = .color(.red)
    layer.borderMask = .cornerRadius(12, offset: -3)

    // when: layout the layer
    layer.layoutSublayers()

    // then: the layer should not have a mask and no sublayers
    expect(layer.mask) == nil
    expect(layer.sublayers?.count ?? 0) == 0

    // then: the layer should have border properties set as expected
    expect(layer.borderColor) == Color.red.cgColor
    expect(layer.cornerRadius) == 12
    expect(layer.borderWidth) == 4
    expect(layer.cornerCurve) == .continuous
    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      expect(layer.borderOffset) == -3
    }

    // then: the layer's internal layers should be nil
    expect(DynamicLookup(layer).keyPath("borderContentColorLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentGradientLayer") as CAGradientLayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentExternalLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderMaskLayer") as CALayer?) == nil
  }

  func test_solidColor_cornerRadius_negativeOffset_useMaskLayer() throws {
    // given: a border layer with fallback border offset support
    let layer = makeBorderLayer(usesNativeBorderOffset: false)
    layer.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
    layer.borderWidth = 4
    layer.borderContent = .color(.red)
    layer.borderMask = .cornerRadius(12, offset: -3)

    // when: layout the layer
    layer.layoutSublayers()

    // then: the layer should have a content layer for the solid color
    let contentLayer = try (layer.sublayers?.first as? CALayer).unwrap()
    expect(contentLayer.frame) == layer.bounds
    expect(contentLayer.backgroundColor) == Color.red.cgColor
    expect(contentLayer.contentsScale) == layer.contentsScale

    // then: the layer should have a mask layer for masking the solid color
    let maskLayer = try layer.mask.unwrap()
    expect(maskLayer.frame) == layer.bounds.expanded(by: -3)
    expect(maskLayer.cornerRadius) == 9
    expect(maskLayer.borderWidth) == 4
    expect(maskLayer.cornerCurve) == .continuous
    if #available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
      expect(layer.borderOffset) == 0
    }

    // then: the layer's internal layers should be set as expected
    expect(DynamicLookup(layer).keyPath("borderContentColorLayer") as CALayer?) === contentLayer
    expect(DynamicLookup(layer).keyPath("borderContentGradientLayer") as CAGradientLayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderContentExternalLayer") as CALayer?) == nil
    expect(DynamicLookup(layer).keyPath("borderMaskLayer") as CALayer?) === maskLayer
  }

  // MARK: - Gradient + Corner Radius

  func test_gradient_cornerRadius_positiveOffset_useNativeBorderOffset() {
    let layer = makeBorderLayer(usesNativeBorderOffset: true)
    layer.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
    layer.borderWidth = 3
    layer.borderContent = .gradient(.linearGradient(LinearGradientColor(colors: [.red, .green], locations: [0, 1])))
    layer.borderMask = .cornerRadius(10, cornerCurve: .circular, offset: 6)

    layer.layoutSublayers()

    expect(layer.mask as? CAShapeLayer) == nil
    expect(layer.mask?.frame) == layer.bounds
    expect(layer.mask?.cornerRadius) == 10
  }

  func test_gradient_cornerRadius_positiveOffset_useMaskLayer() {
    let layer = makeBorderLayer(usesNativeBorderOffset: false)
    layer.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
    layer.borderWidth = 3
    layer.borderContent = .gradient(.linearGradient(LinearGradientColor(colors: [.red, .green], locations: [0, 1])))
    layer.borderMask = .cornerRadius(10, cornerCurve: .circular, offset: 6)

    layer.layoutSublayers()

    expect(layer.mask as? CAShapeLayer) == nil
    expect(layer.mask?.frame) == layer.bounds.expanded(by: 6)
    expect(layer.mask?.cornerRadius) == 16
  }

  // MARK: - Solid Color + Shape

  /// Verifies `.shape(Rectangle, offset:)` updates the internal mask path even when bounds stay the same.
  ///
  /// Regression context:
  /// When offset changed from `0` to a negative value without any bounds change, the stroke path updated
  /// but the nested mask path could remain stale, making the visible border appear thicker.
  /// This test ensures the stroke path and mask path remain aligned after the offset-only update.
  func test_solidColor_shape_negativeOffset_updatesMaskPath_whenBoundsUnchanged() {
    // given: a shape border starts with offset 0 so baseline stroke/mask geometry is captured
    let layer = makeBorderLayer()
    layer.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
    layer.borderWidth = 4
    layer.borderContent = .color(.red)
    layer.borderMask = .shape(Rectangle(cornerRadius: 12), offset: 0)

    layer.layoutSublayers()

    guard let initialBorderMaskLayer = layer.mask as? CAShapeLayer else {
      fail("expected shape border mask layer.")
      return
    }
    let initialMaskPathBounds = (initialBorderMaskLayer.mask as? CAShapeLayer)?.path?.boundingBoxOfPath

    // when: only offset changes to a negative value while bounds stay unchanged
    layer.borderMask = .shape(Rectangle(cornerRadius: 12), offset: -8)
    layer.layoutSublayers()

    guard let updatedBorderMaskLayer = layer.mask as? CAShapeLayer else {
      fail("expected shape border mask layer after offset update.")
      return
    }

    let updatedStrokePathBounds = updatedBorderMaskLayer.path?.boundingBoxOfPath
    let updatedMaskPathBounds = (updatedBorderMaskLayer.mask as? CAShapeLayer)?.path?.boundingBoxOfPath

    // then: stroke and nested mask paths are both updated and remain aligned
    expect(initialMaskPathBounds) != nil
    expect(updatedStrokePathBounds) != nil
    expect(updatedMaskPathBounds) != nil
    expect(updatedMaskPathBounds) == updatedStrokePathBounds
    expect(updatedMaskPathBounds) != initialMaskPathBounds
  }

  // MARK: - Helper Methods

  private func makeBorderLayer(usesNativeBorderOffset: Bool = false) -> BorderLayer {
    let layer = BorderLayer()
    layer.test.usesNativeBorderOffset = usesNativeBorderOffset
    _ = layer.test.usesNativeBorderOffset // to cover the property setter
    return layer
  }
}
