//
//  ViewController.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/28/24.
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

import AppKit

import ChouTi
import ChouTiUI

class ViewController: NSViewController {

  private var layerBoundsObserver: KVOObserverType?
  private var appearanceObserver: KVOObserverType?

  private var textField: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.wantsLayer = true

    let gradientLayer = BaseCAGradientLayer()
    view.unsafeLayer.addSublayer(gradientLayer)

    gradientLayer.setBackgroundGradientColor(
      LinearGradientColor([.red, .blue], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1))
    )

    view.layer?.onBoundsChange { [weak self, weak gradientLayer] layer in
      print("layer bounds changed: \(layer.bounds)")
      self?.updateTextField()
      gradientLayer?.frame = layer.bounds
    }

    appearanceObserver = view.observe("effectiveAppearance") { [weak self] (object, old: NSAppearance, new: NSAppearance) in
      print("view appearance changed: \(old) -> \(new)")
      self?.updateTextField()
    }

    textField = NSTextField()
    textField.stringValue = "Hello, World!"
    textField.isEditable = false
    textField.isBordered = false
    textField.drawsBackground = false
    textField.alignment = .center

    textField.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(textField)

    NSLayoutConstraint.activate([
      textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ])
  }

  deinit {
    appearanceObserver = nil
  }

  private func updateTextField() {
    textField.stringValue = "Bounds: \(view.layer?.bounds ?? .zero)\n"
      + "Appearance: \(view.effectiveAppearance.isDarkMode ? "Dark" : "Light")\n"
  }
}

private extension NSAppearance {

  var isDarkMode: Bool {
    return self.name == .darkAqua || self.name == .vibrantDark
  }
}
