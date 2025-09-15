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
@_spi(Private) import ChouTiUI
@_spi(Private) import ComposeUI

class ViewController: NSViewController {

  private var appearanceObserver: KVOObserverType?

  private var textField: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.wantsLayer = true

    self.view.setBackgroundColor(
      ThemedUnifiedColor(
        light: LinearGradientColor([.red, .yellow], nil, UnitPoint(0.7, 0), UnitPoint(0.3, 1)),
        dark: LinearGradientColor([.red, .blue], nil, UnitPoint(0.3, 1), UnitPoint(0.7, 0))
      )
    )

    self.view.layer?.onBoundsChange { [weak self] layer, _, _ in
      print("layer bounds changed: \(layer.bounds)")
      self?.updateTextField()
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

    // bottom toolbar
    let toolbarView = ComposeView {
      ZStack {
        UnifiedColorNode(
          light: LinearGradientColor([.whiteRGB(0.98), .whiteRGB(0.8)]),
          dark: LinearGradientColor([.blackRGB(0.65), .blackRGB(0.8)])
        )
        .overlay(alignment: .top, content: {
          UnifiedColorNode(light: .whiteRGB, dark: .whiteRGB(0.5))
            .frame(width: .flexible, height: .halfPoint)
        })
        .animation(.easeInEaseOut(duration: 1))
        .dropShadow(color: .black, opacity: 0.3, radius: 1, offset: CGSize(width: 0, height: -1), path: { renderable in
          return CGPath(rect: renderable.frame.insetBy(dx: -4, dy: 0), transform: nil)
        })

        HStack {
          ViewNode(make: { _ in
            let button = NSButton(title: "Layer Background", target: nil, action: nil)
            let windowBox = WeakBox<LayerBackgroundWindow>(nil)
            button.addAction {
              windowBox.object?.close()

              let newWindow = LayerBackgroundWindow()
              newWindow.show()
              windowBox.object = newWindow
            }
            button.wantsLayer = true
            button.sizeToFit()
            return button
          })
          .fixedSize()

          ViewNode(make: { _ in
            let button = NSButton(title: "Layer Shape", target: nil, action: nil)
            let windowBox = WeakBox<LayerShapeWindow>(nil)
            button.addAction {
              windowBox.object?.close()

              let newWindow = LayerShapeWindow()
              newWindow.show()
              windowBox.object = newWindow
            }
            button.wantsLayer = true
            button.sizeToFit()
            return button
          })
          .fixedSize()

          ViewNode(make: { _ in
            let button = NSButton(title: "Layer Border", target: nil, action: nil)
            let windowBox = WeakBox<LayerBorderWindow>(nil)
            button.addAction {
              windowBox.object?.close()

              let newWindow = LayerBorderWindow()
              newWindow.show()
              windowBox.object = newWindow
            }
            button.wantsLayer = true
            button.sizeToFit()
            return button
          })
          .fixedSize()

          ViewNode(make: { _ in
            let button = NSButton(title: "Layer Border Offset", target: nil, action: nil)
            let windowBox = WeakBox<LayerBorderOffsetWindow>(nil)
            button.addAction {
              windowBox.object?.close()

              let newWindow = LayerBorderOffsetWindow()
              newWindow.show()
              windowBox.object = newWindow
            }
            button.wantsLayer = true
            button.sizeToFit()
            return button
          })
          .fixedSize()
        }
      }
    }

    toolbarView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(toolbarView)
    NSLayoutConstraint.activate([
      toolbarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      toolbarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      toolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      toolbarView.heightAnchor.constraint(equalToConstant: 38),
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
