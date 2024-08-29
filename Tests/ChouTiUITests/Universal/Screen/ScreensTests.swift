//
//  ScreensTests.swift
//
//  Created by Honghao Zhang on 8/28/24.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if !os(visionOS)

import ChouTiTest
import ChouTiUI

class ScreensTests: XCTestCase {

  func testMainScreen() {
    expect(Screens.mainScreen) == Screen.mainScreen()

    Screens.mainScreen = Screen.mainScreen()
    expect(Screens.mainScreen) == Screen.mainScreen()
  }
}

#endif
