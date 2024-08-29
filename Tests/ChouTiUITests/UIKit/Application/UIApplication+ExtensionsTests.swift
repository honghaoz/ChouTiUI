//
//  UIApplication+ExtensionsTests.swift
//
//  Created by Honghao Zhang on 6/9/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(UIKit)

import UIKit

import ChouTiTest
import ChouTiUI

class UIApplication_ExtensionsTests: XCTestCase {

  func test_windowScenes() {
    expect(UIApplication.shared.windowScenes) == []
  }

  func test_foregroundActiveWindowScenes() {
    expect(UIApplication.shared.foregroundActiveWindowScenes) == []
  }
}

#endif
