//
//  AquaTrafficLightButtonsWindow.swift
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

import AppKit

import ChouTi
import ComposeUI

import ChouTiUI

/// A window that shows the Aqua traffic light buttons, with controls for the states that the buttons follow.
class AquaTrafficLightButtonsWindow: NSWindow {

  private lazy var trafficLights = AquaTrafficLightButtons(window: self)

  private var isCloseButtonEnabled = true
  private var isZoomButtonHidden = false

  private var toolbarButtons: [String: NSButton] = [:]

  init() {
    super.init(
      contentRect: NSRect(x: 0, y: 0, width: 800, height: 400),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false
    )

    print("\(self) initialized")

    setupWindow()
  }

  deinit {
    print("\(self) deallocated")
  }

  private func setupWindow() {
    title = "Aqua Traffic Light Buttons"
    isReleasedWhenClosed = false
    titleVisibility = .hidden
    titlebarAppearsTransparent = true
    center()

    let contentView = ComposeView { [unowned self] in // swiftlint:disable:this unowned_variable_capture
      ZStack {
        UnifiedColorNode(
          light: LinearGradientColor([.whiteRGB(0.95), .whiteRGB(0.85)]),
          dark: LinearGradientColor([.blackRGB(0.75), .blackRGB(0.9)])
        )

        VStack(spacing: 8) {
          LabelNode("Hover the buttons, hold Option, or use ⌘W / ⌘M.")
          LabelNode("Switch the accent color to Graphite in System Settings to see the gray buttons.")
        }

        self.makeToolbar().alignment(.bottom)
      }
    }
    self.contentView = contentView

    trafficLights.install()
  }

  /// Shows the window.
  func show() {
    makeKeyAndOrderFront(nil)
  }

  private func makeToolbar() -> ComposeNode {
    HStack(spacing: 8) {
      makeButton(title: "Toggle Edited") { [weak self] in
        guard let self else {
          return
        }
        self.isDocumentEdited.toggle()
      }

      makeButton(title: "Toggle Close Enabled") { [weak self] in
        guard let self else {
          return
        }
        self.isCloseButtonEnabled.toggle()
        self.standardWindowButton(.closeButton)?.isEnabled = self.isCloseButtonEnabled
        self.trafficLights.refresh()
      }

      makeButton(title: "Toggle Zoom Hidden") { [weak self] in
        guard let self else {
          return
        }
        self.isZoomButtonHidden.toggle()
        self.trafficLights.setZoomButtonHidden(self.isZoomButtonHidden)
      }

      makeButton(title: "Show Sheet") { [weak self] in
        guard let self else {
          return
        }
        let alert = NSAlert()
        alert.messageText = "A sheet disables the close button."
        alert.beginSheetModal(for: self)
      }

      makeButton(title: "Toggle Theme") { [weak self] in
        guard let self else {
          return
        }
        self.overrideTheme = self.theme.isDark ? .light : .dark
      }
    }
    .frame(width: .flexible, height: Constants.toolbarHeight)
  }

  private func makeButton(title: String, action: @escaping () -> Void) -> ComposeNode {
    // the buttons are made once, so that refreshes (e.g. a theme change) keep them
    let button: NSButton
    if let existingButton = toolbarButtons[title] {
      button = existingButton
    } else {
      button = NSButton(title: title, target: nil, action: nil)
      button.wantsLayer = true
      button.addAction(action)
      button.sizeToFit()
      toolbarButtons[title] = button
    }

    let size = button.frame.size
    return ViewNode(button, intrinsicSize: { _ in size })
      .fixedSize()
  }

  // MARK: - Constants

  private enum Constants {

    static let toolbarHeight: CGFloat = 44
  }
}
