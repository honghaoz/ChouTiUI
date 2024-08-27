//
//  CGSize+Extensions.swift
//
//  Created by Honghao Zhang on 11/10/20.
//  Copyright © 2024 ChouTi. All rights reserved.
//

import CoreGraphics
import ChouTi

public extension CGSize {

  /// The greatest finite size.
  static let greatestFiniteMagnitude = CGSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)

  /// Create a CGSize with the given width and height.
  ///
  /// - Parameters:
  ///   - width: The width of the size.
  ///   - height: The height of the size.
  @inlinable
  @inline(__always)
  init(_ width: CGFloat, _ height: CGFloat) {
    self.init(width: width, height: height)
  }

  /// Create a CGSize with the given width and height.
  ///
  /// - Parameters:
  ///   - width: The width of the size.
  ///   - height: The height of the size.
  @inlinable
  @inline(__always)
  init(_ width: Int, _ height: Int) {
    self.init(width: width, height: height)
  }

  /// Create a CGSize with the given size.
  ///
  /// - Parameters:
  ///   - size: The size of the size.
  @inlinable
  @inline(__always)
  init(_ size: CGFloat) {
    self.init(width: size, height: size)
  }

  /// Create a CGSize with the given size.
  ///
  /// - Parameters:
  ///   - size: The size of the size.
  @inlinable
  @inline(__always)
  init(_ size: Int) {
    self.init(width: size, height: size)
  }

  /// Create a CGSize with the given width and aspect ratio.
  ///
  /// - Parameters:
  ///   - width: The width of the size.
  ///   - aspectRatio: The aspect ratio of the size.
  @inlinable
  @inline(__always)
  init(width: CGFloat, aspectRatio: CGFloat) {
    self.init(width: width, height: width / aspectRatio)
  }

  /// Create a CGSize with the given height and aspect ratio.
  ///
  /// - Parameters:
  ///   - height: The height of the size.
  ///   - aspectRatio: The aspect ratio of the size.
  @inlinable
  @inline(__always)
  init(height: CGFloat, aspectRatio: CGFloat) {
    self.init(width: height * aspectRatio, height: height)
  }

  static prefix func - (value: Self) -> Self {
    Self(-value.width, -value.height)
  }

  static func + (left: CGSize, right: CGSize) -> CGSize {
    CGSize(left.width + right.width, left.height + right.height)
  }

  static func += (left: inout CGSize, right: CGSize) {
    left.width += right.width
    left.height += right.height
  }

  static func - (left: CGSize, right: CGSize) -> CGSize {
    CGSize(left.width - right.width, left.height - right.height)
  }

  static func -= (left: inout CGSize, right: CGSize) {
    left.width -= right.width
    left.height -= right.height
  }

  static func * (left: CGSize, right: CGSize) -> CGSize {
    CGSize(left.width * right.width, left.height * right.height)
  }

  static func *= (left: inout CGSize, right: CGSize) {
    left.width *= right.width
    left.height *= right.height
  }

  static func / (left: CGSize, right: CGSize) -> CGSize {
    CGSize(left.width / right.width, left.height / right.height)
  }

  static func /= (left: inout CGSize, right: CGSize) {
    left.width /= right.width
    left.height /= right.height
  }

  static func * (left: CGSize, right: CGFloat) -> CGSize {
    CGSize(left.width * right, left.height * right)
  }

  static func *= (left: inout CGSize, right: CGFloat) {
    left.width *= right
    left.height *= right
  }

  static func / (left: CGSize, right: CGFloat) -> CGSize {
    CGSize(left.width / right, left.height / right)
  }

  static func /= (left: inout CGSize, right: CGFloat) {
    left.width /= right
    left.height /= right
  }

  /// Add the given width and height to the size.
  ///
  /// - Parameters:
  ///   - width: The width to add to the size.
  ///   - height: The height to add to the size.
  func adding(width: CGFloat = 0, height: CGFloat = 0) -> CGSize {
    CGSize(width: self.width + width, height: self.height + height)
  }

  /// Subtract the given width and height from the size.
  ///
  /// - Parameters:
  ///   - width: The width to subtract from the size.
  ///   - height: The height to subtract from the size.
  func subtracting(width: CGFloat = 0, height: CGFloat = 0) -> CGSize {
    CGSize(width: self.width - width, height: self.height - height)
  }

  /// Multiply the size by the given factor.
  ///
  /// - Parameters:
  ///   - factor: The factor to multiply the size by.
  func multiply(by factor: CGFloat) -> CGSize {
    if factor == 1 {
      return self
    }
    return CGSize(width * factor, height * factor)
  }

  /// Inset the size by the given length.
  ///
  /// - Parameters:
  ///   - length: The length to inset the size by. Positive value decrements size in both sides.
  func inset(_ length: CGFloat) -> CGSize {
    if length == 0 {
      return self
    }
    return subtracting(width: length * 2, height: length * 2)
  }

  /// Inset the size by the given horizontal and vertical length.
  ///
  /// - Parameters:
  ///   - horizontal: The horizontal length to inset the size by. Positive value decrement size in both sides.
  ///   - vertical: The vertical length to inset the size by. Positive value decrement size in both sides.
  func inset(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> CGSize {
    subtracting(width: horizontal * 2, height: vertical * 2)
  }

  /// Inset the size by the given horizontal and vertical length.
  ///
  /// - Parameters:
  ///   - horizontal: The horizontal length to inset the size by. Positive value decrement size in both sides.
  ///   - vertical: The vertical length to inset the size by. Positive value decrement size in both sides.
  func inset(_ horizontal: CGFloat, _ vertical: CGFloat) -> CGSize {
    subtracting(width: horizontal * 2, height: vertical * 2)
  }

  /// Get a new CGSize with new width.
  ///
  /// - Parameters:
  ///   - newWidth: The new width of the size.
  func width(_ newWidth: CGFloat) -> CGSize {
    CGSize(newWidth, height)
  }

  /// Get a new CGSize with new height.
  ///
  /// - Parameters:
  ///   - newHeight: The new height of the size.
  func height(_ newHeight: CGFloat) -> CGSize {
    CGSize(width, newHeight)
  }

  /// Check if the size is positive.
  @inlinable
  @inline(__always)
  var isPositive: Bool {
    width > 0 && height > 0
  }

  /// Check if the size is non-negative.
  @inlinable
  @inline(__always)
  var isNonNegative: Bool {
    width >= 0 && height >= 0
  }

  /// Get the area of the size.
  @inlinable
  @inline(__always)
  var area: CGFloat {
    width * height
  }

  // MARK: - Shapes

  /// Get the aspect ratio (width / height).
  @inlinable
  @inline(__always)
  var aspectRatio: CGFloat {
    width / height
  }

  /// Check if the size is a portrait size.
  ///
  /// Square shape is counted as portrait.
  @inlinable
  @inline(__always)
  var isPortrait: Bool {
    aspectRatio <= 1
  }

  /// Check if the size is a landscape size.
  ///
  /// Square shape is **NOT** counted as landscape.
  @inlinable
  @inline(__always)
  var isLandScape: Bool {
    aspectRatio > 1
  }

  /// Check if the size is a square.
  @inlinable
  @inline(__always)
  var isSquare: Bool {
    aspectRatio == 1
  }
}

// MARK: - Rounding

public extension CGSize {

  /// Round the size up to the nearest value that is a multiple of the given scale factor.
  ///
  /// This is useful for pixel-perfect UI rendering where the size needs to be a multiple of the device's scale factor.
  ///
  /// - Parameters:
  ///   - scaleFactor: The scale factor to round the size by.
  mutating func roundUp(scaleFactor: CGFloat) {
    guard scaleFactor > 0 else {
      ChouTi.assertFailure("Scale factor must be positive.", metadata: [
        "scaleFactor": "\(scaleFactor)",
      ])
      return
    }

    let pixelWidth: CGFloat = 1 / scaleFactor
    width = width.ceil(nearest: pixelWidth)
    height = height.ceil(nearest: pixelWidth)
  }

  /// Round the size up to the nearest value that is a multiple of the given scale factor.
  ///
  /// This is useful for pixel-perfect UI rendering where the size needs to be a multiple of the device's scale factor.
  ///
  /// - Parameters:
  ///   - scaleFactor: The scale factor to round the size by.
  func roundedUp(scaleFactor: CGFloat) -> CGSize {
    guard scaleFactor > 0 else {
      ChouTi.assertFailure("Scale factor must be positive.", metadata: [
        "scaleFactor": "\(scaleFactor)",
      ])
      return .zero
    }

    let pixelWidth: CGFloat = 1 / scaleFactor
    let width = width.ceil(nearest: pixelWidth)
    let height = height.ceil(nearest: pixelWidth)
    return CGSize(width: width, height: height)
  }

  /// Round the size to the nearest value that is a multiple of the given scale factor.
  ///
  /// This is useful for pixel-perfect UI rendering where the size needs to be a multiple of the device's scale factor.
  ///
  /// - Parameters:
  ///   - scaleFactor: The scale factor to round the size by.
  func rounded(scaleFactor: CGFloat) -> CGSize {
    guard scaleFactor > 0 else {
      ChouTi.assertFailure("Scale factor must be positive.", metadata: [
        "scaleFactor": "\(scaleFactor)",
      ])
      return .zero
    }

    let pixelWidth: CGFloat = 1 / scaleFactor
    let width = width.round(nearest: pixelWidth)
    let height = height.round(nearest: pixelWidth)
    return CGSize(width: width, height: height)
  }

  /// Round the size up to the nearest whole number.
  mutating func roundUp() {
    width = ceil(width)
    height = ceil(height)
  }

  /// Round the size up to the nearest whole number.
  @inlinable
  @inline(__always)
  func roundedUp() -> CGSize {
    CGSize(ceil(width), ceil(height))
  }
}

public extension CGSize {

  /// Check if the size is approximately equal to the given size.
  ///
  /// - Parameters:
  ///   - other: The size to compare to.
  ///   - absoluteTolerance: The absolute tolerance to use for the comparison.
  func isApproximatelyEqual(to other: Self, absoluteTolerance: CGFloat) -> Bool {
    width.isApproximatelyEqual(to: other.width, absoluteTolerance: absoluteTolerance) &&
      height.isApproximatelyEqual(to: other.height, absoluteTolerance: absoluteTolerance)
  }
}

public extension CGSize {

  /// The rectangle orientation
  enum Orientation {
    case portrait
    case landscape
  }

  /// Get rectangle orientation.
  ///
  /// Square shape is counted as portrait. Zero size is also counted as portrait.
  var orientation: Orientation {
    guard area > 0, self != .zero else {
      return .portrait // assume zero size is portrait
    }

    if width <= height {
      return .portrait
    } else {
      return .landscape
    }
  }
}

// MARK: - Hashable

extension CGSize: Hashable {

  public func hash(into hasher: inout Hasher) {
    hasher.combine(width)
    hasher.combine(height)
  }
}
