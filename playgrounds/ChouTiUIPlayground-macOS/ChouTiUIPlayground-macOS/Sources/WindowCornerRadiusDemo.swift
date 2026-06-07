//
//  WindowCornerRadiusDemo.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 6/2/26.
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

final class WindowCornerRadiusDemo {

  private var windows: [NSWindow] = []

  func show() {
    close()

    let origin = NSScreen.main?.visibleFrame.origin ?? .zero
    let baseFrame = NSRect(x: origin.x + 120, y: origin.y + 580, width: 360, height: 220)

    windows = [
      makeTitledWindow(
        title: "Titled",
        subtitle: "Expected radius: \(Self.expectedCornerRadius(toolbarStyle: nil))",
        frame: baseFrame
      ),
      makeTitledWindow(
        title: "Toolbar Automatic",
        subtitle: "Expected radius: \(Self.expectedCornerRadius(toolbarStyle: .automatic))",
        frame: baseFrame.offsetBy(dx: 390, dy: 50),
        toolbarStyle: .automatic
      ),
      makeTitledWindow(
        title: "Toolbar Expanded",
        subtitle: "Expected radius: \(Self.expectedCornerRadius(toolbarStyle: .expanded))",
        frame: baseFrame.offsetBy(dx: 780, dy: 50),
        toolbarStyle: .expanded
      ),
      makeTitledWindow(
        title: "Toolbar Preference",
        subtitle: "Expected radius: \(Self.expectedCornerRadius(toolbarStyle: .preference))",
        frame: baseFrame.offsetBy(dx: 0, dy: -280),
        toolbarStyle: .preference
      ),
      makeTitledWindow(
        title: "Toolbar Unified",
        subtitle: "Expected radius: \(Self.expectedCornerRadius(toolbarStyle: .unified))",
        frame: baseFrame.offsetBy(dx: 390, dy: -280),
        toolbarStyle: .unified
      ),
      makeTitledWindow(
        title: "Toolbar Compact",
        subtitle: "Expected radius: \(Self.expectedCornerRadius(toolbarStyle: .unifiedCompact))",
        frame: baseFrame.offsetBy(dx: 780, dy: -280),
        toolbarStyle: .unifiedCompact
      ),
      makeBorderlessWindow(
        title: "Borderless",
        subtitle: "Expected radius: 0",
        frame: baseFrame.offsetBy(dx: 390, dy: -560)
      ),
    ]

    windows.forEach { $0.makeKeyAndOrderFront(nil) }
  }

  func close() {
    windows.forEach { $0.close() }
    windows.removeAll()
  }

  private func makeTitledWindow(title: String,
                                subtitle: String,
                                frame: NSRect,
                                toolbarStyle: DemoToolbarStyle? = nil) -> NSWindow
  {
    let window = NSWindow(
      contentRect: frame,
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )

    window.title = title
    window.isReleasedWhenClosed = false

    if let toolbarStyle {
      let toolbar = NSToolbar(identifier: "\(title)-toolbar")
      toolbar.displayMode = .iconOnly
      toolbar.sizeMode = .regular
      toolbar.delegate = WindowCornerRadiusToolbarDelegate.shared
      window.toolbar = toolbar
      if #available(macOS 11, *) {
        switch toolbarStyle {
        case .automatic:
          window.toolbarStyle = .automatic
        case .expanded:
          window.toolbarStyle = .expanded
        case .preference:
          window.toolbarStyle = .preference
        case .unified:
          window.toolbarStyle = .unified
        case .unifiedCompact:
          window.toolbarStyle = .unifiedCompact
        }
      }
    }

    window.contentView = makeContentView(title: title, subtitle: subtitle, radius: Self.expectedCornerRadius(toolbarStyle: toolbarStyle))
    return window
  }

  private func makeBorderlessWindow(title: String, subtitle: String, frame: NSRect) -> NSWindow {
    let window = NSWindow(
      contentRect: frame,
      styleMask: [.borderless, .resizable],
      backing: .buffered,
      defer: false
    )

    window.title = title
    window.isReleasedWhenClosed = false
    window.isMovableByWindowBackground = true
    window.backgroundColor = .clear
    window.isOpaque = false
    window.contentView = makeContentView(title: title, subtitle: subtitle, radius: 0)
    return window
  }

  private func makeContentView(title: String, subtitle: String, radius: CGFloat) -> NSView {
    let contentView = NSView()
    contentView.wantsLayer = true
    contentView.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor

    let label = NSTextField(labelWithString: "\(title)\n\(subtitle)")
    label.translatesAutoresizingMaskIntoConstraints = false
    label.alignment = .center
    label.font = .systemFont(ofSize: 18, weight: .medium)
    label.textColor = .labelColor
    label.maximumNumberOfLines = 2

    let outline = NSView()
    outline.translatesAutoresizingMaskIntoConstraints = false
    outline.wantsLayer = true
    outline.layer?.borderColor = NSColor.systemPink.cgColor
    outline.layer?.borderWidth = 1
    outline.layer?.cornerRadius = radius

    contentView.addSubview(outline)
    contentView.addSubview(label)

    NSLayoutConstraint.activate([
      outline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
      outline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
      outline.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
      outline.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),

      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 24),
      label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -24),
    ])

    return contentView
  }

  private static func expectedCornerRadius(toolbarStyle: DemoToolbarStyle?) -> CGFloat {
    guard System.macOS_tahoe else {
      return System.macOS_bigSur ? 10 : 5
    }

    switch toolbarStyle {
    case .some(.unifiedCompact):
      return 20
    case .some(.automatic), .some(.unified):
      return 26
    case .none, .some(.expanded), .some(.preference):
      return 16
    }
  }
}

private enum DemoToolbarStyle {
  case automatic
  case expanded
  case preference
  case unified
  case unifiedCompact
}

private final class WindowCornerRadiusToolbarDelegate: NSObject, NSToolbarDelegate {

  static let shared = WindowCornerRadiusToolbarDelegate()

  private let itemIdentifier = NSToolbarItem.Identifier("window-corner-radius-demo-item")

  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    [itemIdentifier]
  }

  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
    [itemIdentifier]
  }

  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
               willBeInsertedIntoToolbar flag: Bool
  ) -> NSToolbarItem? {
    let item = NSToolbarItem(itemIdentifier: itemIdentifier)
    item.label = "Radius"
    item.paletteLabel = "Radius"
    if #available(macOS 11, *) {
      item.image = NSImage(systemSymbolName: "rectangle.roundedtop", accessibilityDescription: "Radius")
    }
    return item
  }
}
