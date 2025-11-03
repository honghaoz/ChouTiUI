//
//  CALayer+FrameAnimation.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/1/25.
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
@_spi(Private) import ComposeUI

public extension CALayer {

  /// Add frame animation to the layer based on the reference animation's characteristics.
  ///
  /// This method is useful when you want to animate a sublayer's frame based on the size change animation of the host layer.
  /// For example, if a sublayer wants to follow the host layer's size change, even when the host layer is animated. You can do:
  /// ```swift
  /// // in host layer's layoutSublayers()
  /// if let sizeAnimation = self.sizeAnimation() { // get the host layer's size change animation, this could be an explicit size change animation or an implicit size change animation
  ///   sublayer.addFrameAnimation(from: sublayer.frame, to: hostLayer.frame, presentationBounds: hostLayer.presentation()?.bounds, with: sizeAnimation) // add a frame animation to the sublayer so that the sublayer can follow the host layer's during animation
  /// }
  /// sublayer.frame = hostLayer.frame // set the sublayer's frame model value
  /// ```
  ///
  /// - Parameters:
  ///   - oldBounds: The old bounds of the layer. This is used when the reference animation is an additive animation.
  ///   - newBounds: The new bounds of the layer. This is used when the reference animation is an additive animation.
  ///   - presentationBounds: The bounds of the layer's presentation layer. This value is used as the from frame when the reference animation is a non-additive animation.
  ///   - referenceAnimation: The reference animation to base the frame animation on.
  func addFrameAnimation(from oldBounds: CGRect, to newBounds: CGRect, presentationBounds: @autoclosure () -> CGRect?, with referenceAnimation: CABasicAnimation) {
    if let positionAnimationCopy = referenceAnimation.copy() as? CABasicAnimation,
       let sizeAnimationCopy = referenceAnimation.copy() as? CABasicAnimation
    {

      positionAnimationCopy.keyPath = "position"
      let positionAnimationKey: String
      if positionAnimationCopy.isAdditive {
        let oldPosition = self.position(from: oldBounds)
        let newPosition = self.position(from: newBounds)
        positionAnimationCopy.fromValue = CGPoint(x: oldPosition.x - newPosition.x, y: oldPosition.y - newPosition.y)
        positionAnimationCopy.toValue = CGPoint.zero
        positionAnimationKey = self.uniqueAnimationKey(key: "position")
      } else {
        positionAnimationCopy.fromValue = (presentationBounds() ?? oldBounds).center
        positionAnimationCopy.toValue = newBounds.center
        positionAnimationKey = "position"
      }

      sizeAnimationCopy.keyPath = "bounds.size"
      let sizeAnimationKey: String
      if sizeAnimationCopy.isAdditive {
        sizeAnimationCopy.fromValue = CGSize(width: oldBounds.size.width - newBounds.size.width, height: oldBounds.size.height - newBounds.size.height)
        sizeAnimationCopy.toValue = CGSize.zero
        sizeAnimationKey = self.uniqueAnimationKey(key: "bounds.size")
      } else {
        sizeAnimationCopy.fromValue = (presentationBounds() ?? oldBounds).size
        sizeAnimationCopy.toValue = newBounds.size
        sizeAnimationKey = "bounds.size"
      }

      self.add(positionAnimationCopy, forKey: positionAnimationKey)
      self.add(sizeAnimationCopy, forKey: sizeAnimationKey)
    } else {
      ChouTi.assertFailure("failed to copy reference animation", metadata: [
        "referenceAnimation": "\(referenceAnimation)",
      ])
    }
  }
}
