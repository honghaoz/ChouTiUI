//
//  SizeRange.swift
//
//  Created by Honghao Zhang on 5/16/23.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import Foundation

/// A type that represents a single size or a range of size.
public enum SizeRange: Hashable, Sendable {

  /// Create a size range with the given minimum and maximum.
  ///
  /// - Parameters:
  ///   - min: The minimum size.
  ///   - max: The maximum size.
  /// - Returns: A size range with the given minimum and maximum.
  @inline(__always)
  public static func range(_ min: CGFloat, _ max: CGFloat) -> SizeRange {
    .range(min: min, max: max)
  }

  /// An exact size.
  case exact(CGFloat)

  /// A continuous range of sizes from minimum to maximum, inclusive.
  ///
  /// `min` must be less than `max`.
  /// Use `.exact` if `min` and `max` are the same.
  case range(min: CGFloat, max: CGFloat)

  /// The range minimum.
  public var min: CGFloat {
    switch self {
    case .exact(let size):
      return size
    case .range(let min, _):
      return min
    }
  }

  /// The range maximum.
  public var max: CGFloat {
    switch self {
    case .exact(let size):
      return size
    case .range(_, let max):
      return max
    }
  }

  /// Checks if the size range contains the size.
  /// - Parameter size: The size to check.
  /// - Returns: `true` if the size range contains the size, `false` otherwise.
  public func contains(_ size: CGFloat) -> Bool {
    switch self {
    case .exact(let value):
      return value == size
    case .range(let min, let max):
      return min <= size && size <= max
    }
  }

  /// Merge two size ranges, so that the result can express both size ranges.
  ///
  /// The result will be an array of size ranges with minimum count that covers both size ranges.
  /// For example, merging `.exact(10)` with `.exact(10)` will return `[.exact(10)]`.
  ///
  /// - Parameter other: The other size range to merge with.
  /// - Returns: An array of size ranges that covers both size ranges.
  public func union(_ other: SizeRange) -> [SizeRange] {
    switch (self, other) {
    case (.exact(let size1), .exact(let size2)):
      if size1 == size2 {
        return [.exact(size1)]
      } else {
        if size1 < size2 {
          return [.exact(size1), .exact(size2)]
        } else {
          return [.exact(size2), .exact(size1)]
        }
      }
    case (.exact(let size), .range(let min, let max)),
         (.range(let min, let max), .exact(let size)):
      if size < min {
        return [.exact(size), .range(min: min, max: max)]
      } else if size > max {
        return [.range(min: min, max: max), .exact(size)]
      } else {
        return [.range(min: min, max: max)]
      }
    case (.range(let min1, let max1), .range(let min2, let max2)):
      if max1 < min2 {
        // no overlap, self is before other

        //
        //          self
        // │                     │
        // ├─────────────────────┤
        // │                     │
        //                                        other
        //                               │                     │
        //                               ├─────────────────────┤
        //                               │                     │
        return [self, other]
      } else if min1 > max2 {
        // no overlap, self is after other

        //
        //                                   self
        //                          │                     │
        //                          ├─────────────────────┤
        //                          │                     │
        //          other
        // │                     │
        // ├─────────────────────┤
        // │                     │
        return [other, self]
      } else {
        // overlaps

        //
        //          self
        // │                     │
        // ├─────────────────────┤
        // │                     │
        //                             other
        //                    │                     │
        //                    ├─────────────────────┤
        //                    │                     │
        //
        //
        //
        //          self
        // │                                           │
        // ├───────────────────────────────────────────┤
        // │                                           │
        //                             other
        //                    │                     │
        //                    ├─────────────────────┤
        //                    │                     │
        let min = Swift.min(min1, min2)
        let max = Swift.max(max1, max2)
        return [.range(min: min, max: max)]
      }
    }
  }
}

public extension [SizeRange] {

  /// Merge all size ranges in the array.
  /// The result will be an array of size ranges with minimum count that covers all size ranges.
  /// For example, merging `[.exact(10), .exact(10)]` will return `[.exact(10)]`.
  ///
  /// - Parameter isSorted: A flag indicates if the array of `SizeRange` is already sorted by the min. Default is `false`.
  ///                       If `true`, the merging algorithm skips the sorting step. The time complexity will be O(n).
  ///                       If `false`, the merging algorithm will sort the array first. The time complexity will be O(nlogn).
  /// - Returns: A new array of `SizeRange` that has a minimum count to express the ranges.
  func union(isSorted: Bool = false) -> [SizeRange] {
    guard !isEmpty else {
      return []
    }

    var result: [SizeRange] = []
    result.reserveCapacity(count)

    let sortedRanges = isSorted ? self : self.sorted(by: { $0.min < $1.min })

    var current = sortedRanges[0]
    for range in sortedRanges.dropFirst() {
      if current.max >= range.min {
        // They do overlap or are adjacent, so merge them
        current = current.union(range)[0]
      } else {
        // They don't overlap or are adjacent, so add the current range to the result and start a new current range.
        result.append(current)
        current = range
      }
    }

    // Add the last range to the result.
    result.append(current)

    return result
  }
}

public extension SizeRange {

  /// Support addition of a `CGFloat` to a `SizeRange`.
  ///
  /// The addition of a `CGFloat` to a `SizeRange` moves the entire range by the amount of the `CGFloat`,
  /// preserving the size of the range.
  ///
  /// - Parameters:
  ///   - lhs: A `SizeRange`.
  ///   - rhs: A `CGFloat`.
  /// - Returns: A moved range.
  static func + (lhs: SizeRange, rhs: CGFloat) -> SizeRange {
    switch lhs {
    case .exact(let value):
      return .exact(value + rhs)
    case .range(let min, let max):
      let newMin = min + rhs
      let newMax = max + rhs
      if newMin == newMax {
        return .exact(newMin)
      } else {
        return .range(min: newMin, max: newMax)
      }
    }
  }

  /// Support addition of a `CGFloat` to a `SizeRange`.
  ///
  /// - Parameters:
  ///   - lhs: A `SizeRange`.
  ///   - rhs: A `CGFloat`.
  static func += (lhs: inout SizeRange, rhs: CGFloat) {
    lhs = lhs + rhs
  }

  /// Support addition of a `SizeRange` to a `SizeRange` by stacking them on top of each other.
  /// - Parameters:
  ///   - lhs: A `SizeRange`.
  ///   - rhs: A `SizeRange`.
  /// - Returns: A new `SizeRange` that stacks `lhs` on top of `rhs`.
  static func + (lhs: SizeRange, rhs: SizeRange) -> SizeRange {
    switch (lhs, rhs) {
    case (.exact(let value1), .exact(let value2)):
      return .exact(value1 + value2)
    case (.exact(let value), .range(let min, let max)),
         (.range(let min, let max), .exact(let value)):
      let newMin = min + value
      let newMax = max + value
      if newMin == newMax {
        return .exact(newMin)
      } else {
        return .range(min: newMin, max: newMax)
      }
    case (.range(let min1, let max1), .range(let min2, let max2)):
      let newMin = min1 + min2
      let newMax = max1 + max2
      if newMin == newMax {
        return .exact(newMin)
      } else {
        return .range(min: newMin, max: newMax)
      }
    }
  }

  /// Support addition of a `SizeRange` to a `SizeRange`.
  ///
  /// - Parameters:
  ///   - lhs: A `SizeRange`.
  ///   - rhs: A `SizeRange`.
  static func += (lhs: inout SizeRange, rhs: SizeRange) {
    lhs = lhs + rhs
  }
}
