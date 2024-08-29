//
//  Screens.swift
//
//  Created by Honghao Zhang on 8/28/24.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import Foundation

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
