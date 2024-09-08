//
//  SizeRangeTests.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 5/17/23.
//  Copyright © 2020 Honghao Zhang.
//
//  MIT License
//
//  Copyright (c) 2020 Honghao Zhang (github.com/honghaoz)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import ChouTiTest

import ChouTiUI

class SizeRangeTests: XCTestCase {

  // Test the `min` and `max` properties
  func testMinMaxProperties() {
    let exact = SizeRange.exact(10)
    expect(exact.min) == 10
    expect(exact.max) == 10

    let range = SizeRange.range(min: 10, max: 20)
    expect(range.min) == 10
    expect(range.max) == 20
  }

  func testContains() {
    let exact = SizeRange.exact(10)
    expect(exact.contains(10)) == true
    expect(exact.contains(20)) == false

    let range = SizeRange.range(min: 10, max: 20)
    expect(range.contains(10)) == true
    expect(range.contains(20)) == true
    expect(range.contains(15)) == true
    expect(range.contains(5)) == false
    expect(range.contains(25)) == false
  }

  // MARK: - Union

  func testUnionMethodWithExact() {
    // Test merging two exact sizes that are the same
    let exact1 = SizeRange.exact(10)
    let exact2 = SizeRange.exact(10)
    let mergedExact = exact1.union(exact2)
    expect(mergedExact) == [.exact(10)]

    // Test merging two exact sizes that are different
    let exact3 = SizeRange.exact(10)
    let exact4 = SizeRange.exact(20)
    let mergedExactDifferent = exact3.union(exact4)
    expect(mergedExactDifferent) == [.exact(10), .exact(20)]

    // Test merging two exact sizes that are different in reverse order
    let mergedExactDifferentReverse = exact4.union(exact3)
    expect(mergedExactDifferentReverse) == [.exact(10), .exact(20)]
  }

  func testUnionMethodWithExactAndRange() {
    // Test merging exact size with a range where the exact size is within the range
    let exact = SizeRange.exact(15)
    let range = SizeRange.range(min: 10, max: 20)
    let mergedExactInRange = exact.union(range)
    expect(mergedExactInRange) == [.range(10, 20)]

    // Test merging exact size with a range where the exact size is smaller than the range
    let exactSmaller = SizeRange.exact(5)
    let mergedExactSmaller = exactSmaller.union(range)
    expect(mergedExactSmaller) == [.exact(5), .range(min: 10, max: 20)]

    // Test merging exact size with a range where the exact size is adjacent to the range minimum
    let exactAdjacent = SizeRange.exact(10)
    let mergedExactAdjacent = exactAdjacent.union(range)
    expect(mergedExactAdjacent) == [.range(min: 10, max: 20)]

    // Test merging exact size with a range where the exact size is larger than the range
    let exactLarger = SizeRange.exact(25)
    let mergedExactLarger = exactLarger.union(range)
    expect(mergedExactLarger) == [.range(min: 10, max: 20), .exact(25)]

    // Test merging exact size with a range where the exact size is adjacent to the range maximum
    let exactAdjacentMax = SizeRange.exact(20)
    let mergedExactAdjacentMax = exactAdjacentMax.union(range)
    expect(mergedExactAdjacentMax) == [.range(min: 10, max: 20)]
  }

  func testUnionMethodWithRange() {
    // Test merging two ranges that overlap
    let range1 = SizeRange.range(min: 10, max: 20)
    let range2 = SizeRange.range(min: 15, max: 25)
    let mergedRangeOverlap = range1.union(range2)
    expect(mergedRangeOverlap) == [.range(min: 10, max: 25)]

    // Test merging two ranges that do not overlap and are in order
    let range3 = SizeRange.range(min: 10, max: 20)
    let range4 = SizeRange.range(min: 30, max: 40)
    let mergedRangeNoOverlap = range3.union(range4)
    expect(mergedRangeNoOverlap) == [.range(min: 10, max: 20), .range(min: 30, max: 40)]

    // Test merging two ranges that do not overlap and are not in order
    let mergedRangeNoOverlapUnordered = range4.union(range3)
    expect(mergedRangeNoOverlapUnordered) == [.range(min: 10, max: 20), .range(min: 30, max: 40)]
  }

  func testUnionMethodWithAdjacentRanges() {
    // Test merging two adjacent ranges
    let range1 = SizeRange.range(min: 10, max: 20)
    let range2 = SizeRange.range(min: 20, max: 30)
    let mergedAdjacentRanges = range1.union(range2)
    expect(mergedAdjacentRanges) == [.range(min: 10, max: 30)]

    // Test merging two adjacent ranges in reverse order
    let mergedAdjacentRangesReverse = range2.union(range1)
    expect(mergedAdjacentRangesReverse) == [.range(min: 10, max: 30)]

    // Test merging a range and an exact size that is adjacent to the range
    let range3 = SizeRange.range(min: 10, max: 20)
    let exactAdjacent = SizeRange.exact(20)
    let mergedRangeAndExactAdjacent = range3.union(exactAdjacent)
    expect(mergedRangeAndExactAdjacent) == [.range(min: 10, max: 20)]
  }

  // MARK: - Addition Operator

  func testAdditionOperator() {
    let exactRange: SizeRange = .exact(10)
    let addedExactRange = exactRange + 5
    expect(addedExactRange) == .exact(15)

    let sizeRange: SizeRange = .range(min: 10, max: 20)
    let addedSizeRange = sizeRange + 5
    expect(addedSizeRange) == .range(min: 15, max: 25)

    expect(SizeRange.range(min: 0, max: .infinity) + 5) == SizeRange.range(min: 5, max: .infinity)
    expect(SizeRange.range(min: 0, max: .infinity) + .infinity) == SizeRange.exact(.infinity)

    expect(SizeRange.range(min: 0, max: .greatestFiniteMagnitude) + 5) == SizeRange.range(min: 5, max: .greatestFiniteMagnitude)
  }

  func testAdditionAssignmentOperator() {
    var exactRange: SizeRange = .exact(10)
    exactRange += 5
    expect(exactRange) == .exact(15)

    var sizeRange: SizeRange = .range(min: 10, max: 20)
    sizeRange += 5
    expect(sizeRange) == .range(min: 15, max: 25)
  }

  func testStackUpRanges() {
    expect(SizeRange.exact(10) + .exact(20)) == .exact(30)

    expect(SizeRange.exact(10) + .range(min: 10, max: 20)) == .range(min: 20, max: 30)
    expect(SizeRange.range(min: 10, max: 20) + .exact(10)) == .range(min: 20, max: 30)

    expect(SizeRange.exact(10) + .range(min: 10, max: 10)) == .exact(20)

    expect(SizeRange.range(min: 10, max: 20) + SizeRange.range(min: 10, max: 20)) == .range(min: 20, max: 40)
    expect(SizeRange.range(min: 0, max: 20) + SizeRange.range(min: 10, max: 20)) == .range(min: 10, max: 40)

    expect(SizeRange.range(min: 10, max: 10) + SizeRange.range(min: 0, max: 0)) == .exact(10)

    expect(SizeRange.range(min: 0, max: .infinity) + SizeRange.range(min: 10, max: 20)) == .range(min: 10, max: .infinity)

    var sizeRange: SizeRange = .range(min: 10, max: 20)
    sizeRange += .range(min: 10, max: 20)
    expect(sizeRange) == .range(min: 20, max: 40)
  }
}

class SizeRangeArrayExtensionTests: XCTestCase {

  func testUnionEmptyArray() {
    let ranges: [SizeRange] = []
    let merged = ranges.union()
    expect(merged.isEmpty) == true
  }

  func testUnionSingleExactSize() {
    let ranges: [SizeRange] = [.exact(20)]
    let merged = ranges.union()
    expect(merged) == [.exact(20)]
  }

  func testUnionMultipleExactSizes() {
    let ranges: [SizeRange] = [.exact(20), .exact(20)]
    let merged = ranges.union()
    expect(merged) == [.exact(20)]
  }

  func testUnionSingleRange() {
    let ranges: [SizeRange] = [.range(min: 10, max: 20)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 10, max: 20)]
  }

  func testUnionOverlappingRanges() {
    let ranges: [SizeRange] = [.range(min: 10, max: 20), .range(min: 15, max: 25)]
    let merged = ranges.union(isSorted: true)
    expect(merged) == [.range(min: 10, max: 25)]
  }

  func testUnionNonOverlappingRanges() {
    let ranges: [SizeRange] = [.range(min: 10, max: 20), .range(min: 30, max: 40)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 10, max: 20), .range(min: 30, max: 40)]
  }

  func testUnionExactSizeAndRange() {
    let ranges: [SizeRange] = [.exact(20), .range(min: 15, max: 25)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 15, max: 25)]
  }

  func testUnionExactSizeWithRangeOutside() {
    let ranges: [SizeRange] = [.exact(25), .range(min: 10, max: 20)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 10, max: 20), .exact(25)]
  }

  func testUnionMultipleExactSizesAndRanges() {
    let ranges: [SizeRange] = [.exact(5), .range(min: 10, max: 20), .exact(15), .range(min: 25, max: 30), .exact(40)]
    let merged = ranges.union()
    expect(merged) == [.exact(5), .range(min: 10, max: 20), .range(min: 25, max: 30), .exact(40)]
  }

  func testUnionAdjacentRanges() {
    let ranges: [SizeRange] = [.range(min: 10, max: 20), .range(min: 20, max: 30)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 10, max: 30)]
  }

  func testUnionUnsortedRanges() {
    let ranges: [SizeRange] = [.range(min: 30, max: 40), .range(min: 10, max: 20)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 10, max: 20), .range(min: 30, max: 40)]
  }

  func testUnionInfiniteRangeWithExactSize() {
    let ranges: [SizeRange] = [.exact(20), .range(min: 0, max: .infinity)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 0, max: .infinity)]
  }

  func testUnionInfiniteRanges() {
    let ranges: [SizeRange] = [.range(min: 0, max: .infinity), .range(min: 10, max: .infinity)]
    let merged = ranges.union()
    expect(merged) == [.range(min: 0, max: .infinity)]
  }

  func testUnionZeroSize() {
    let ranges: [SizeRange] = [.exact(0), .exact(10)]
    let merged = ranges.union()
    expect(merged) == [.exact(0), .exact(10)]
  }

  func testUnionNegativeExactSize() {
    let ranges: [SizeRange] = [.exact(-10), .exact(10)]
    let merged = ranges.union()
    expect(merged) == [.exact(-10), .exact(10)]
  }

  func testHashable() {
    let range1 = SizeRange.exact(10)
    let range2 = SizeRange.exact(10)
    expect(range1.hashValue) == range2.hashValue

    let range3 = SizeRange.range(min: 10, max: 20)
    let range4 = SizeRange.range(min: 10, max: 20)
    expect(range3.hashValue) == range4.hashValue
    expect(range1.hashValue) != range3.hashValue

    let range5 = SizeRange.range(min: 10, max: 20)
    let range6 = SizeRange.range(min: 20, max: 30)
    expect(range5.hashValue) != range6.hashValue
  }
}
