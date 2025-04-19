//
//  ThemeMonitor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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

import Combine

import ChouTi

/// A type that can provide the current theme and listen to theme changes.
public protocol ThemeMonitorType {

  /// The shared instance of the theme monitor.
  static var shared: Self { get }

  /// The current theme.
  var theme: Theme { get }

  /// A binding to the current theme.
  var themeBinding: AnyBinding<Theme> { get }

  #if os(macOS)
  /// A binding to the current accent color.
  var accentColorBinding: Binding<Color> { get }
  #endif
}

#if os(macOS)

import AppKit

/// A monitor that can provide the current theme and listen to theme changes.
public final class ThemeMonitor: ThemeMonitorType {

  /// The shared instance of the theme monitor.
  public static let shared = ThemeMonitor()

  /// The current theme.
  public var theme: Theme {
    NSApplication.shared.theme
  }

  /// A binding to the current theme.
  public private(set) lazy var themeBinding: AnyBinding<Theme> = NSApplication.shared.themeBinding

  private weak var accentColorListeningToken: (any NSObjectProtocol)?

  /// A binding to the current accent color.
  public lazy var accentColorBinding: Binding<Color> = {
    let binding = Binding<Color>(Color.controlAccentColor)

    accentColorListeningToken = Foundation.DistributedNotificationCenter.default().addObserver(
      forName: .accentColorDidChange,
      object: nil,
      queue: nil,
      using: { [weak binding] _ in
        onMainAsync { [weak binding] in
          binding?.value = Color.controlAccentColor // strongly capture the binding object
        }
      }
    )

    return binding
  }()

  deinit {
    if let accentColorListeningToken = accentColorListeningToken {
      Foundation.DistributedNotificationCenter.default().removeObserver(accentColorListeningToken)
    }
  }
}

/// Reference:
/// https://indiestack.com/2018/10/supporting-dark-mode-responding-to-change/

#else

import UIKit

/// A monitor that can provide the current theme and listen to theme changes.
public final class ThemeMonitor: UIWindow, ThemeMonitorType {

  /// The shared instance of the theme monitor.
  public static let shared = ThemeMonitor()

  /// A binding to the current theme.
  public private(set) lazy var themeBinding = _themeBinding.eraseToAnyBinding()

  private lazy var _themeBinding = Binding<Theme>(theme)

  public init() {
    /// can use `UITraitCollection.current.userInterfaceStyle.theme` to get the current theme
    guard let windowScene = Application.shared.windowScenes.first else {
      ChouTi.assertFailure("no window scenes")
      super.init(frame: .zero)
      return
    }
    super.init(windowScene: windowScene)

    if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
      registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
        self.updateThemeIfNeeded()
      }
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    // swiftlint:disable:next fatal_error
    fatalError("init(coder:) is unavailable")
  }

  @available(visionOS, deprecated: 1.0, message: "Use trait change registration APIs")
  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    updateThemeIfNeeded()
  }

  private func updateThemeIfNeeded() {
    if _themeBinding.value != theme {
      _themeBinding.value = theme
    }
  }
}

#endif
