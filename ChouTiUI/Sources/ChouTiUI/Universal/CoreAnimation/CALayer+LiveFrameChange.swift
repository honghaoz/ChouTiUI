//
//  CALayer+LiveFrameChange.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/1/25.
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

import ChouTi

private extension CALayer {

  private enum AssociateKey {
    static var positionToken: UInt8 = 0
    static var boundsToken: UInt8 = 0
    static var frameChangeBlocks: UInt8 = 0
    static var displayLayer: UInt8 = 0
    static var firstTickTime: UInt8 = 0
    static var tickCount: UInt8 = 0
    static var lastFrame: UInt8 = 0
    static var lastNotifiedFrames: UInt8 = 0
  }

  /// The token for the position change listener.
  private var positionToken: CancellableToken? {
    get { getAssociatedObject(for: &AssociateKey.positionToken) as? CancellableToken }
    set { setAssociatedObject(newValue, for: &AssociateKey.positionToken) }
  }

  /// The token for the bounds change listener.
  private var boundsToken: CancellableToken? {
    get { getAssociatedObject(for: &AssociateKey.boundsToken) as? CancellableToken }
    set { setAssociatedObject(newValue, for: &AssociateKey.boundsToken) }
  }

  /// The token for the frame change blocks.
  private var frameChangeBlocks: OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGRect) -> Void>> {
    get {
      getAssociatedObject(for: &AssociateKey.frameChangeBlocks) as? OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGRect) -> Void>> ?? OrderedDictionary<ObjectIdentifier, ValueCancellableToken<(CALayer, CGRect) -> Void>>()
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.frameChangeBlocks)
    }
  }

  /// The layer that can trigger display calls.
  private var displayLayer: DisplayLayer? {
    get { getAssociatedObject(for: &AssociateKey.displayLayer) as? DisplayLayer }
    set { setAssociatedObject(newValue, for: &AssociateKey.displayLayer) }
  }

  /// The first tick time.
  private var firstTickTime: TimeInterval {
    get { getAssociatedObject(for: &AssociateKey.firstTickTime) as? TimeInterval ?? 0 }
    set { setAssociatedObject(newValue, for: &AssociateKey.firstTickTime) }
  }

  /// The tick counter.
  private var tickCount: Int {
    get { getAssociatedObject(for: &AssociateKey.tickCount) as? Int ?? 0 }
    set { setAssociatedObject(newValue, for: &AssociateKey.tickCount) }
  }

  /// The last frame used for frame change blocks.
  private var lastFrame: CGRect {
    get { getAssociatedObject(for: &AssociateKey.lastFrame) as? CGRect ?? CGRect.zero }
    set { setAssociatedObject(newValue, for: &AssociateKey.lastFrame) }
  }

  /// The last notified frames for each block.
  private var lastNotifiedFrames: [ObjectIdentifier: CGRect] {
    get { getAssociatedObject(for: &AssociateKey.lastNotifiedFrames) as? [ObjectIdentifier: CGRect] ?? [:] }
    set { setAssociatedObject(newValue, for: &AssociateKey.lastNotifiedFrames) }
  }
}

public extension CALayer {

  /// Adds a block to be called when the layer's frame changes with animations in near real time.
  ///
  /// This method supports live frame update when the layer's frame is changed by Core Animation, specifically for key paths "position", "position.x", "position.y", "bounds", "bounds.size", "bounds.size.width", and "bounds.size.height" changes.
  ///
  /// This method should be called on the main thread.
  ///
  /// - Parameters:
  ///   - block: The block to be called when the frame changes. It will be called with the layer and the new frame.
  /// - Returns: A cancellable token that can be used to remove the block.
  @discardableResult
  func onLiveFrameChange(_ block: @escaping (CALayer, CGRect) -> Void) -> CancellableToken {
    lastFrame = frame // set initial last frame

    let token = ValueCancellableToken(value: block) { [weak self] token in
      guard let self else {
        return
      }
      token.remove(from: &self.frameChangeBlocks)

      // stop frame observation if there's no callbacks
      if frameChangeBlocks.isEmpty {
        self.tearDownFrameObservation()
        self.tearDownDisplayLayer()
      }
    }
    token.store(in: &frameChangeBlocks)

    lastNotifiedFrames[ObjectIdentifier(token)] = frame // set initial last notified frame

    setUpFrameObservation()
    setUpDisplayLayer()

    return token
  }

  private func setUpFrameObservation() {
    if positionToken == nil {
      positionToken = onPositionChange { [weak self] layer, old, new in
        // schedule to the next run loop to make sure the animation added after the position change can be found
        // layer's implicit animation will be added to the next run loop
        RunLoop.main.perform {
          self?.onPositionChange(oldPosition: old, newPosition: new)
        }
      }
    }

    if boundsToken == nil {
      boundsToken = onBoundsChange { [weak self] layer, old, new in
        // schedule to the next run loop to make sure the animation added after the bounds change can be found
        // layer's implicit animation will be added to the next run loop
        RunLoop.main.perform {
          self?.onBoundsChange(oldBounds: old, newBounds: new)
        }
      }
    }
  }

  private func tearDownFrameObservation() {
    positionToken?.cancel()
    positionToken = nil
    boundsToken?.cancel()
    boundsToken = nil
  }

  private func setUpDisplayLayer() {
    guard displayLayer == nil else {
      return
    }

    let displayLayer = DisplayLayer()
    insertSublayer(displayLayer, at: 0)
    self.displayLayer = displayLayer
  }

  private func tearDownDisplayLayer() {
    displayLayer?.removeFromSuperlayer()
    displayLayer = nil
  }

  private func onPositionChange(oldPosition: CGPoint, newPosition: CGPoint) {
    let maxDuration = getMaxAnimationDuration(keyPaths: ["position", "position.x", "position.y"])
    guard maxDuration > 0 else {
      // no position animation, use model value
      notifyFrameChangeBlocks(with: self.frame)
      return
    }

    displayLayer?.run(for: maxDuration * 1.5) { [weak self] in
      self?.tick()
    }
  }

  private func onBoundsChange(oldBounds: CGRect, newBounds: CGRect) {
    let maxDuration = getMaxAnimationDuration(keyPaths: ["bounds", "bounds.size", "bounds.size.width", "bounds.size.height"])
    guard maxDuration > 0 else {
      // no bounds animation, use model value
      notifyFrameChangeBlocks(with: self.frame)
      return
    }

    displayLayer?.run(for: maxDuration * 1.5) { [weak self] in
      self?.tick()
    }
  }

  private func getMaxAnimationDuration(keyPaths: [String]) -> TimeInterval {
    var maxDuration: TimeInterval = 0
    for key in animationKeys() ?? [] {
      if let animation = animation(forKey: key) as? CAPropertyAnimation, keyPaths.contains(animation.keyPath ?? "") {
        maxDuration = max(maxDuration, animation.duration)
      }
    }
    return maxDuration
  }

  private func tick() {
    if self.animationKeys() == nil {
      // no animation, meaning the animations are finished, notify with the model value to finalize the frame
      notifyFrameChangeBlocks(with: self.frame)
      tearDownDisplayLayer()
      return
    }

    // Tick Average Duration Calculation
    let tickTime = CACurrentMediaTime()

    if firstTickTime == 0 {
      firstTickTime = tickTime
    }

    let averageTickDuration: TimeInterval
    if tickCount == 0 {
      averageTickDuration = 0.016 // use 16ms as the average tick duration for the first tick
    } else {
      averageTickDuration = (tickTime - firstTickTime) / Double(tickCount)
    }

    tickCount += 1

    // Frame Calculation
    var xBase: CGFloat = self.position.x
    var yBase: CGFloat = self.position.y
    var xDelta: CGFloat = 0
    var yDelta: CGFloat = 0

    var widthBase: CGFloat = self.bounds.size.width
    var heightBase: CGFloat = self.bounds.size.height
    var widthDelta: CGFloat = 0
    var heightDelta: CGFloat = 0

    for animation in self.animations() {
      guard let animation = animation as? CABasicAnimation else {
        // layer's implicit animations can have "transition" (CATransition), skip it
        if animation is CATransition {
          continue
        }
        ChouTi.assertFailure("not CAPropertyAnimation: \(animation)")
        return
      }

      guard animation.isAbsoluteBeginTimeMode(), animation.beginTime > 0 else {
        // skip the animation if it's not added in the render tree (begin time is negative)
        // use the last frame for the frame change blocks
        notifyFrameChangeBlocks(with: lastFrame)
        return
      }

      let beginTime = animation.beginTime
      let timeProgress = (tickTime - beginTime + averageTickDuration) / animation.duration
      let progress: Double = Double(animation.progress(for: Float(timeProgress)) ?? 1)

      switch animation.keyPath {
      case "position":
        let fromValue = (animation.fromValue as? CGPoint) ?? self.position
        let toValue = (animation.toValue as? CGPoint) ?? self.position

        if animation.isAdditive {
          xDelta += (fromValue.x - toValue.x) * (1 - progress)
          yDelta += (fromValue.y - toValue.y) * (1 - progress)
        } else {
          xBase = fromValue.x + (toValue.x - fromValue.x) * progress
          yBase = fromValue.y + (toValue.y - fromValue.y) * progress
        }
      case "position.x":
        let fromValue = (animation.fromValue as? CGFloat) ?? self.position.x
        let toValue = (animation.toValue as? CGFloat) ?? self.position.x

        if animation.isAdditive {
          xDelta += (fromValue - toValue) * (1 - progress)
        } else {
          xBase = fromValue + (toValue - fromValue) * progress
        }
      case "position.y":
        let fromValue = (animation.fromValue as? CGFloat) ?? self.position.y
        let toValue = (animation.toValue as? CGFloat) ?? self.position.y

        if animation.isAdditive {
          yDelta += (fromValue - toValue) * (1 - progress)
        } else {
          yBase = fromValue + (toValue - fromValue) * progress
        }
      case "bounds":
        let fromValue = (animation.fromValue as? CGRect) ?? self.bounds
        let toValue = (animation.toValue as? CGRect) ?? self.bounds

        if animation.isAdditive {
          widthDelta += (fromValue.width - toValue.width) * (1 - progress)
          heightDelta += (fromValue.height - toValue.height) * (1 - progress)
        } else {
          widthBase = fromValue.width + (toValue.width - fromValue.width) * progress
          heightBase = fromValue.height + (toValue.height - fromValue.height) * progress
        }
      case "bounds.size":
        let fromValue = (animation.fromValue as? CGSize) ?? self.bounds.size
        let toValue = (animation.toValue as? CGSize) ?? self.bounds.size

        if animation.isAdditive {
          widthDelta += (fromValue.width - toValue.width) * (1 - progress)
          heightDelta += (fromValue.height - toValue.height) * (1 - progress)
        } else {
          widthBase = fromValue.width + (toValue.width - fromValue.width) * progress
          heightBase = fromValue.height + (toValue.height - fromValue.height) * progress
        }
      case "bounds.size.width":
        let fromValue = (animation.fromValue as? CGFloat) ?? self.bounds.size.width
        let toValue = (animation.toValue as? CGFloat) ?? self.bounds.size.width

        if animation.isAdditive {
          widthDelta += (fromValue - toValue) * (1 - progress)
        } else {
          widthBase = fromValue + (toValue - fromValue) * progress
        }
      case "bounds.size.height":
        let fromValue = (animation.fromValue as? CGFloat) ?? self.bounds.size.height
        let toValue = (animation.toValue as? CGFloat) ?? self.bounds.size.height

        if animation.isAdditive {
          heightDelta += (fromValue - toValue) * (1 - progress)
        } else {
          heightBase = fromValue + (toValue - fromValue) * progress
        }
      default:
        break
      }
    }

    let x = xBase + xDelta
    let y = yBase + yDelta

    let width = widthBase + widthDelta
    let height = heightBase + heightDelta

    let frameX = x - anchorPoint.x * width
    let frameY = y - anchorPoint.y * height

    let frame = CGRect(x: frameX, y: frameY, width: width, height: height)

    // Notify the frame change blocks
    notifyFrameChangeBlocks(with: frame)
  }

  private func notifyFrameChangeBlocks(with frame: CGRect) {
    for token in frameChangeBlocks.values {
      let tokenIdentifier = ObjectIdentifier(token)
      if let lastNotifiedFrame = lastNotifiedFrames[tokenIdentifier], lastNotifiedFrame == frame {
        continue
      }
      lastNotifiedFrames[tokenIdentifier] = frame
      token.value(self, frame)
    }

    lastFrame = frame
  }
}

private extension CAAnimation {

  func isAbsoluteBeginTimeMode() -> Bool {
    // non-zero: when the begin time is zero. when just added to the layer
    // absolute: when the begin time is positive

    guard let beginTimeMode = value(forKey: "beginTimeMode") as? String else {
      ChouTi.assertFailure("beginTimeMode is not set")
      return false
    }

    switch beginTimeMode {
    case "absolute":
      return true
    case "non-zero":
      return false
    default:
      ChouTi.assertFailure("unknown beginTimeMode: \(beginTimeMode)")
      return false
    }
  }
}
