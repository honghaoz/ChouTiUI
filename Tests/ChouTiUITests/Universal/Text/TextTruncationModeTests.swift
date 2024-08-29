//
//  TextTruncationModeTests.swift
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

class TextTruncationModeTests: XCTestCase {

  func test() {
    expect(TextTruncationMode.none.lineBreakMode) == NSLineBreakMode.byClipping
    expect(TextTruncationMode.head.lineBreakMode) == NSLineBreakMode.byTruncatingHead
    expect(TextTruncationMode.tail.lineBreakMode) == NSLineBreakMode.byTruncatingTail
    expect(TextTruncationMode.middle.lineBreakMode) == NSLineBreakMode.byTruncatingMiddle

    expect(TextTruncationMode.none.textLayerTruncationMode) == CATextLayerTruncationMode.none
    expect(TextTruncationMode.head.textLayerTruncationMode) == CATextLayerTruncationMode.start
    expect(TextTruncationMode.tail.textLayerTruncationMode) == CATextLayerTruncationMode.end
    expect(TextTruncationMode.middle.textLayerTruncationMode) == CATextLayerTruncationMode.middle
  }
}
