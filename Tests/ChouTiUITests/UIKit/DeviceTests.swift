//
//  DeviceTests.swift
//
//  Created by Honghao Zhang on 10/18/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(UIKit) && !os(visionOS)

import ChouTiTest
import ChouTiUI

class DeviceTests: XCTestCase {

  func test_isIpad() {
    expect(Device.isIpad) == false
  }

  func test_isSimulator() {
    expect(Device.isSimulator) == true
  }

  func test_hasRoundedDisplayCorners() {
    expect(Device.hasRoundedDisplayCorners) == true
  }
}

#endif
