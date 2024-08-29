//
//  UIScreen+Extensions.swift
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(UIKit) && !os(visionOS)

import ChouTi
import UIKit

// MARK: - Display Corner Radius

public extension UIScreen {

  private static let _displayCornerRadius = Obfuscation.deobfuscate("afkurnc{EqtpgtTcfkwu", key: 2) // "_displayCornerRadius"

  var displayCornerRadius: CGFloat {
    guard let value = value(forKey: Self._displayCornerRadius) else {
      ChouTi.assertFailure("Failed to get display corner radius.")
      return 0
    }
    return (value as? CGFloat).assert("Got invalid display corner radius.", metadata: ["value": "\(value)"]) ?? 0
  }

  // https://kylebashour.com/posts/finding-the-real-iphone-x-corner-radius
}

#endif
