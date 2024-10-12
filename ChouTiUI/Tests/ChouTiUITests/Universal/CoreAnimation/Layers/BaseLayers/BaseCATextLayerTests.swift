//
//  BaseCATextLayerTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/6/24.
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
#endif

#if canImport(UIKit)
import UIKit
#endif

import CoreText
import QuartzCore

import ChouTiTest

import ChouTi
import ChouTiUI

class BaseCATextLayerTests: XCTestCase {

  func test_init() {
    let layer = BaseCATextLayer()
    expect(layer.contents) == nil
    expect(layer.debugDescription.hasPrefix("<ChouTiUI.BaseCATextLayer:")) == true

    #if !os(macOS)
    expect(layer.cornerCurve) == CALayerCornerCurve.continuous
    #endif

    #if os(visionOS)
    expect(layer.wantsDynamicContentScaling) == true
    #else
    expect(layer.contentsScale) == Screen.mainScreenScale
    #endif

    expect(layer.strongDelegate) === CATextLayer.DisableImplicitAnimationDelegate.shared

    expect(layer.verticalAlignment) == .top
    expect(layer.isMultiline) == false
    expect(layer.usesCoreTextDrawingForMultiline) == false
    expect(layer.drawsBoundingBox) == false
  }

  func test_debugDescription() {
    let layer = BaseCATextLayer()
    expect(layer.debugDescription.hasPrefix("<ChouTiUI.BaseCATextLayer:")) == true

    layer.setDebugDescription("Hello")
    expect(layer.debugDescription) == "Hello"
  }

  func test_init_withLayer() throws {
    let layer = BaseCATextLayer()
    layer.setDebugDescription("Hello")
    layer.verticalAlignment = .center
    layer.usesCoreTextDrawingForMultiline = true
    layer.drawsBoundingBox = true

    let testEnvironment = LayerTestEnvironment()
    testEnvironment.containerLayer.addSublayer(layer)

    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 1.0
    animation.toValue = 0.5
    animation.duration = 1.0

    layer.add(animation, forKey: "opacity")

    wait(timeout: 0.05)

    let presentationLayer = try layer.presentation().unwrap()
    expect(presentationLayer.debugDescription) == "Hello"
    expect(presentationLayer.verticalAlignment) == .center
    expect(presentationLayer.usesCoreTextDrawingForMultiline) == true
    expect(presentationLayer.drawsBoundingBox) == true
  }

  func test_bindingObservationStorage() {
    let layer = BaseCATextLayer()
    Binding("").observe { _ in }.store(in: layer.bindingObservationStorage)
  }

  func test_attributedString() throws {
    let layer = BaseCATextLayer()

    // when string is a normal string
    layer.string = "Hello"
    expect(layer.attributedString) == NSAttributedString(
      string: "Hello",
      attributes: try [
        .font: Font(name: "Helvetica", size: 36).unwrap(),
        .foregroundColor: layer.foregroundColor as Any,
        .paragraphStyle: {
          let style = NSMutableParagraphStyle()
          style.alignment = .natural
          style.lineBreakMode = .byWordWrapping
          return style
        }(),
      ]
    )

    // when string is an attributed string
    layer.string = NSAttributedString(string: "Hello", attributes: [.font: Font.systemFont(ofSize: 12)])
    expect(layer.attributedString) == NSAttributedString(string: "Hello", attributes: [.font: Font.systemFont(ofSize: 12)])

    // when string is nil
    layer.string = nil
    expect(layer.attributedString) == nil
  }

  func test_isMultiline() {
    let layer = BaseCATextLayer()
    expect(layer.isMultiline) == false

    layer.isMultiline = true
    expect(layer.isMultiline) == true

    layer.isWrapped = false
    expect(layer.isMultiline) == false
  }

  func test_uiFont() {
    let layer = BaseCATextLayer()
    layer.uiFont = .systemFont(ofSize: 12)
    expect(layer.uiFont) == Font.systemFont(ofSize: 12)
    expect(layer.font) === Font.systemFont(ofSize: 12)
    expect(layer.fontSize) == 12

    // change point size
    layer.fontSize = 14
    expect(layer.uiFont) == Font.systemFont(ofSize: 14)
    expect(layer.font) === Font.systemFont(ofSize: 12)
    expect(layer.fontSize) == 14

    // remove font
    layer.uiFont = nil
    expect(layer.uiFont) == nil
    expect(layer.font) == nil
    expect(layer.fontSize) == 36.0
  }

  func test_setToSingleLineMode() {
    let layer = BaseCATextLayer()
    layer.setToSingleLineMode(truncationMode: .none)
    expect(layer.isMultiline) == false
    expect(layer.truncationMode) == CATextLayerTruncationMode.none

    layer.setToSingleLineMode(truncationMode: .head)
    expect(layer.truncationMode) == CATextLayerTruncationMode.start

    layer.setToSingleLineMode(truncationMode: .tail)
    expect(layer.truncationMode) == CATextLayerTruncationMode.end

    layer.setToSingleLineMode(truncationMode: .middle)
    expect(layer.truncationMode) == CATextLayerTruncationMode.middle
  }

  func test_setToMultilineMode() {
    let layer = BaseCATextLayer()
    layer.setToMultilineMode(truncationMode: .none)
    expect(layer.isMultiline) == true
    expect(layer.truncationMode) == CATextLayerTruncationMode.none

    layer.setToMultilineMode(truncationMode: .head)
    expect(layer.truncationMode) == CATextLayerTruncationMode.start

    layer.setToMultilineMode(truncationMode: .tail)
    expect(layer.truncationMode) == CATextLayerTruncationMode.end

    layer.setToMultilineMode(truncationMode: .middle)
    expect(layer.truncationMode) == CATextLayerTruncationMode.middle
  }

  func test_draw() {
    let testEnvironment = LayerTestEnvironment()
    let layer = BaseCATextLayer()
    testEnvironment.containerLayer.addSublayer(layer)

    layer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

    wait(timeout: 0.01)

    layer.string = NSAttributedString(string: "Hello", attributes: [.font: Font.systemFont(ofSize: 12)])
    layer.setNeedsDisplay()
    wait(timeout: 0.01)

    layer.verticalAlignment = .center
    layer.setNeedsDisplay()
    wait(timeout: 0.01)

    layer.verticalAlignment = .bottom
    layer.setNeedsDisplay()
    wait(timeout: 0.01)

    layer.setToMultilineMode(truncationMode: .none)
    layer.setNeedsDisplay()
    wait(timeout: 0.01)

    layer.usesCoreTextDrawingForMultiline = true
    layer.drawsBoundingBox = true
    layer.setNeedsDisplay()
    wait(timeout: 0.01)
  }
}
