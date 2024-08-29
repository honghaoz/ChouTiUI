//
//  UIApplication+Extensions.swift
//
//  Created by Honghao Zhang on 6/9/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(UIKit)
import UIKit

import ChouTi

public extension UIApplication {

  /// The application's window scenes.
  var windowScenes: [UIWindowScene] {
    connectedScenes
      .compactMap { $0 as? UIWindowScene }
  }

  /// The application's foreground active window scenes.
  var foregroundActiveWindowScenes: [UIWindowScene] {
    connectedScenes.compactMap { scene in
      if let windowScene = scene as? UIWindowScene, windowScene.activationState == .foregroundActive {
        return windowScene
      } else {
        return nil
      }
    }
  }
}

#endif
