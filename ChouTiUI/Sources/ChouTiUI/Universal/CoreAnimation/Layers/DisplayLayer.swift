//
//  DisplayLayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/2/25.
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

import QuartzCore

/// A layer that can trigger display calls while animating.
///
/// This layer could be used with Core Animation to interpolate values while animating. Use `onDisplay` to be notified when the value changes.
///
/// Example:
/// ```swift
/// // add the layer to the layer hierarchy
/// let displayLayer = DisplayLayer()
/// displayLayer.value = 0
/// displayLayer.onDisplay = { value in
///   // called when the value changes while animating
///   print("value: \(value)")
/// }
/// layer.insertSublayer(displayLayer, at: 0)
///
/// // add the animation to the layer
/// let animation = CABasicAnimation(keyPath: "value")
/// animation.fromValue = 0
/// animation.toValue = 1
/// animation.duration = 1
/// displayLayer.add(animation, forKey: "value")
/// ```
open class DisplayLayer: CALayer {

  /// The value to be interpolated.
  @NSManaged public var value: Double

  /// The last value.
  private var lastValue: Double?

  /// The callback to be called when the value changes.
  public var onDisplay: ((Double) -> Void)?

  override open class func needsDisplay(forKey key: String) -> Bool {
    key == Constants.valueKey || super.needsDisplay(forKey: key)
  }

  override public init() {
    super.init()

    self.value = 0
    delegate = CALayer.DisableImplicitAnimationDelegate.shared
  }

  override public init(layer: Any) {
    super.init(layer: layer)

    guard let layer = layer as? DisplayLayer else {
      fatalError("expect the `layer` to be the same type during a ca animation.") // swiftlint:disable:this fatal_error
    }

    self.value = layer.value
    // during core animation, layer is copied aggressively
    // display() is called on different instance
    self.lastValue = layer.lastValue
    self.onDisplay = layer.onDisplay
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  override open func display() {
    guard let presentationLayer = presentation() else {
      return
    }

    let oldValue = lastValue
    let newValue = presentationLayer.value
    lastValue = newValue

    // skips duplicated values
    guard newValue != oldValue else {
      return
    }

    onDisplay?(newValue)
  }

  private var endTime: TimeInterval?

  /// Run the display layer for a duration.
  ///
  /// If multiple calls are made, the longest duration will be used.
  ///
  /// - Parameters:
  ///   - duration: The duration of the animation.
  ///   - onDisplay: The callback to be called when the display() is called. The current `onDisplay` will be replaced.
  open func run(for duration: TimeInterval, onDisplay: @escaping () -> Void) {
    let currentTime = CACurrentMediaTime()
    let newEndTime = currentTime + duration
    let resolvedEndTime = max(endTime ?? 0, newEndTime)
    endTime = resolvedEndTime

    self.onDisplay = { [weak self] _ in
      guard let self else {
        return
      }
      guard CACurrentMediaTime() <= resolvedEndTime else {
        self.onDisplay = nil
        self.removeAnimation(forKey: Constants.valueKey)
        return
      }

      onDisplay()
    }

    let animation = CABasicAnimation(keyPath: Constants.valueKey)
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = (resolvedEndTime - currentTime) * 1.1 // add 10% as a buffer to avoid the animation being removed too early
    add(animation, forKey: Constants.valueKey)
  }

  // MARK: - Constants

  private enum Constants {
    static let valueKey: String = "value"
  }
}
