//
//  LayoutAlignmentTests.swift
//
//  Created by Honghao Zhang on 3/18/22.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import ChouTiUI
import ChouTiTest

class LayoutAlignmentTests: XCTestCase {

  func test_verticallyFlipped() {
    expect(LayoutAlignment.center.verticallyFlipped()) == LayoutAlignment.center
    expect(LayoutAlignment.left.verticallyFlipped()) == LayoutAlignment.left
    expect(LayoutAlignment.right.verticallyFlipped()) == LayoutAlignment.right
    expect(LayoutAlignment.top.verticallyFlipped()) == LayoutAlignment.bottom
    expect(LayoutAlignment.bottom.verticallyFlipped()) == LayoutAlignment.top
    expect(LayoutAlignment.topLeft.verticallyFlipped()) == LayoutAlignment.bottomLeft
    expect(LayoutAlignment.topRight.verticallyFlipped()) == LayoutAlignment.bottomRight
    expect(LayoutAlignment.bottomLeft.verticallyFlipped()) == LayoutAlignment.topLeft
    expect(LayoutAlignment.bottomRight.verticallyFlipped()) == LayoutAlignment.topRight
  }
}
