//
//  Screens.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/28/24.
//  Copyright © 2020 Honghao Zhang (github.com/honghaoz).
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang
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

#if !os(visionOS)

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

public enum Screens {

  /// The explicitly set main screen.
  ///
  /// If not set, this is set to `UIScreen.main` on iOS/visionOS and `NSScreen.main` on macOS.
  ///
  /// It is recommended to set this in the app delegate or scene delegate.
  ///
  /// - For apps, make the app's `SceneDelegate` inherit from `BaseUIWindowSceneDelegate`, the delegate will be set to `UIApplication.shared.mainScreen` automatically.
  /// - For extensions, in the extension view controller, in the `loadView` or `viewDidLoad`, do:
  ///
  /// ```
  /// class ShareViewController: UIViewController {
  ///
  ///   ...
  ///
  ///   override func loadView() {
  ///     super.loadView()
  ///
  ///     // initialize application's mainScreen
  ///     if let screen = view.window?.screen.assert() {
  ///       hostApplication()?.mainScreen = screen
  ///     }
  ///   }
  /// }
  /// ```
  public static var mainScreen: Screen? {
    get {
      _mainScreen ?? Screen.mainScreen()
    }
    set {
      _mainScreen = newValue
    }
  }

  private static var _mainScreen: Screen?
}
#endif
