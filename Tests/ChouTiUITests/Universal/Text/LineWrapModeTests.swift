//
//  LineWrapModeTests.swift
//
//  Created by Honghao Zhang on 12/24/23.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiUI
import ChouTiTest

class LineWrapModeTests: XCTestCase {

  func test() {
    expect(LineWrapMode.byWord.lineBreakMode) == NSLineBreakMode.byWordWrapping
    expect(LineWrapMode.byChar.lineBreakMode) == NSLineBreakMode.byCharWrapping
  }
}
