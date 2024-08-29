//
//  SizingTests.swift
//
//  Created by Honghao Zhang on 10/20/23.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTiTest
@testable import ChouTiUI
import ChouTi

class SizingTests: XCTestCase {

  func test_navigationBarHeight() {
    #if os(macOS)
    expect(Sizing.navigationBarHeight) == Sizing.macOS.navigationBarHeight
    #else
    expect(Sizing.navigationBarHeight) == Sizing.iOS.navigationBarHeight
    #endif
  }

  func test_navigationBarButtonHeight() {
    expect(Sizing.iOS.navigationBarButtonHeight) == Sizing.iOS.navigationBarButtonHeight
  }

  func test_navigationBarButtonEdgeInsets() {
    expect(Sizing.iOS.navigationBarButtonEdgeInset) == Sizing.iOS.navigationBarButtonEdgeInset
  }

  func test_navigationBarButtonCornerRadius() {
    expect(Sizing.iOS.navigationBarButtonCornerRadius) == Sizing.iOS.navigationBarButtonCornerRadius
  }

  #if os(visionOS)
  func testWindowCornerRadius() {
    Assert.setTestAssertionFailureHandler { message, metadata, file, line, column in
      expect(message) == "TODO: windowCornerRadius is not implemented for visionOS yet"
    }

    expect(Sizing.visionOS.windowCornerRadius) == 10

    Assert.resetTestAssertionFailureHandler()
  }
  #endif
}

#if os(iOS)
class Iphone_Screen_SizeCategoryTests: XCTestCase {

  func testIsBiggerThanOrEqualTo() {
    // iPhone5
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThanOrEqualTo(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThanOrEqualTo(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThanOrEqualTo(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThanOrEqualTo(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThanOrEqualTo(.iPhoneProMax)) == false

    // iPhone8
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThanOrEqualTo(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThanOrEqualTo(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThanOrEqualTo(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThanOrEqualTo(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThanOrEqualTo(.iPhoneProMax)) == false

    // iPhone8Plus
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThanOrEqualTo(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThanOrEqualTo(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThanOrEqualTo(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThanOrEqualTo(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThanOrEqualTo(.iPhoneProMax)) == false

    // iPhonePro
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThanOrEqualTo(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThanOrEqualTo(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThanOrEqualTo(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThanOrEqualTo(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThanOrEqualTo(.iPhoneProMax)) == false

    // iPhoneProMax
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThanOrEqualTo(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThanOrEqualTo(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThanOrEqualTo(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThanOrEqualTo(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThanOrEqualTo(.iPhoneProMax)) == true
  }

  func testIsBiggerThan() {
    // iPhone5
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThan(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThan(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThan(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThan(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isBiggerThan(.iPhoneProMax)) == false

    // iPhone8
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThan(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThan(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThan(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThan(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isBiggerThan(.iPhoneProMax)) == false

    // iPhone8Plus
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThan(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThan(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThan(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThan(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isBiggerThan(.iPhoneProMax)) == false

    // iPhonePro
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThan(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThan(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThan(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThan(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isBiggerThan(.iPhoneProMax)) == false

    // iPhoneProMax
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThan(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThan(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThan(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThan(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isBiggerThan(.iPhoneProMax)) == false
  }

  func testIsSmallerThanOrEqualTo() {
    // iPhone5
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThanOrEqualTo(.iPhone5)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThanOrEqualTo(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThanOrEqualTo(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThanOrEqualTo(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThanOrEqualTo(.iPhoneProMax)) == true

    // iPhone8
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThanOrEqualTo(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThanOrEqualTo(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThanOrEqualTo(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThanOrEqualTo(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThanOrEqualTo(.iPhoneProMax)) == true

    // iPhone8Plus
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThanOrEqualTo(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThanOrEqualTo(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThanOrEqualTo(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThanOrEqualTo(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThanOrEqualTo(.iPhoneProMax)) == true

    // iPhonePro
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThanOrEqualTo(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThanOrEqualTo(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThanOrEqualTo(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThanOrEqualTo(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThanOrEqualTo(.iPhoneProMax)) == true

    // iPhoneProMax
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThanOrEqualTo(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThanOrEqualTo(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThanOrEqualTo(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThanOrEqualTo(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThanOrEqualTo(.iPhoneProMax)) == true
  }

  func testIsSmallerThan() {
    // iPhone5
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThan(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThan(.iPhone8)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThan(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThan(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone5.isSmallerThan(.iPhoneProMax)) == true

    // iPhone8
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThan(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThan(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThan(.iPhone8Plus)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThan(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8.isSmallerThan(.iPhoneProMax)) == true

    // iPhone8Plus
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThan(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThan(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThan(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThan(.iPhonePro)) == true
    expect(Sizing.iPhone.Screen.SizeCategory.iPhone8Plus.isSmallerThan(.iPhoneProMax)) == true

    // iPhonePro
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThan(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThan(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThan(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThan(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhonePro.isSmallerThan(.iPhoneProMax)) == true

    // iPhoneProMax
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThan(.iPhone5)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThan(.iPhone8)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThan(.iPhone8Plus)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThan(.iPhonePro)) == false
    expect(Sizing.iPhone.Screen.SizeCategory.iPhoneProMax.isSmallerThan(.iPhoneProMax)) == false
  }

  func testSizeCategoryForHeight() {
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 480)) == .iPhone4
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 568)) == .iPhone5
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 667)) == .iPhone8
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 736)) == .iPhone8Plus
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 812)) == .iPhonePro
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 896)) == .iPhoneProMax

    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 500)) == .iPhone4
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 600)) == .iPhone5
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 700)) == .iPhone8
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 800)) == .iPhone8Plus
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 850)) == .iPhonePro
    expect(Sizing.iPhone.Screen.SizeCategory.sizeCategory(for: 900)) == .iPhoneProMax
  }
}
#endif
