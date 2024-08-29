//
//  UIScreen+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(UIKit) && !os(visionOS)

import UIKit

import ChouTiTest
import ChouTiUI

class UIScreenExtensionsTests: XCTestCase {

  func test_displayCornerRadius() {
    expect(UIScreen.main.displayCornerRadius) > 0
  }
}

#endif
