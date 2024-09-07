//
//  Easing.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 8/30/23.
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

import Foundation

/// InterpolationFunction type.
/// - t: The current time. Must be non-negative and less than or equal to `d`.
/// - b: The beginning value.
/// - c: The change in value.
/// - d: The duration. Must be greater than 0.
public typealias InterpolationFunction = (_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat

/// A type that supports easing interpolation.
public protocol EasingInterpolatable {

  /// Interpolates between two values with the ease in function.
  ///
  /// - Parameters:
  ///   - t: The current time. Must be non-negative and less than or equal to `d`.
  ///   - b: The beginning value.
  ///   - c: The change in value.
  ///   - d: The duration. Must be greater than 0.
  /// - Returns: The interpolated value.
  func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat

  /// Interpolates between two values with the ease out function.
  ///
  /// - Parameters:
  ///   - t: The current time. Must be non-negative and less than or equal to `d`.
  ///   - b: The beginning value.
  ///   - c: The change in value.
  ///   - d: The duration. Must be greater than 0.
  /// - Returns: The interpolated value.
  func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat

  /// Interpolates between two values with the ease in & out function.
  ///
  /// - Parameters:
  ///   - t: The current time. Must be non-negative and less than or equal to `d`.
  ///   - b: The beginning value.
  ///   - c: The change in value.
  ///   - d: The duration. Must be greater than 0.
  /// - Returns: The interpolated value.
  func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat
}

public enum Easing {

  /// Linear easing.
  ///
  /// Example usage:
  /// ```
  /// let sineEasing = Linear()
  /// let y1 = sineEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = sineEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = sineEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Linear: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      b + c * (t / d)
    }

    @inlinable
    @inline(__always)
    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      easeIn(t, b, c, d)
    }

    @inlinable
    @inline(__always)
    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      easeIn(t, b, c, d)
    }
  }

  /// Sine easing. Smooth and natural sine curve-based easing.
  ///
  /// Example usage:
  /// ```
  /// let sineEasing = Sine()
  /// let y1 = sineEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = sineEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = sineEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Sine: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      b - c * cos(t / d * (.pi / 2)) + c
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      b + c * sin(t / d * (.pi / 2))
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      b - c / 2 * (cos(.pi * t / d) - 1)
    }
  }

  /// Quadratic easing. Ease-in accelerates, Ease-out decelerates.
  ///
  /// Example usage:
  /// ```
  /// let sineEasing = Quad()
  /// let y1 = sineEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = sineEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = sineEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Quad: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      return b + c * t * t
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      return b - c * t * (t - 2)
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / (d / 2)
      if t < 1 {
        return b + c / 2 * t * t
      }
      let t1 = t - 1
      return b - c / 2 * (t1 * (t1 - 2) - 1)
    }
  }

  /// Cubic easing. Ease-in accelerates more sharply, Ease-out decelerates more sharply.
  ///
  /// Example usage:
  /// ```
  /// let sineEasing = Cubic()
  /// let y1 = sineEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = sineEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = sineEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Cubic: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      return b + c * t * t * t
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d - 1
      return b + c * (t * t * t + 1)
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var t = t / (d / 2)
      if t < 1 {
        return b + c / 2 * t * t * t
      }
      t -= 2
      return b + c / 2 * (t * t * t + 2)
    }
  }

  /// Quartic easing. Ease-in accelerates more sharply than Cubic, Ease-out decelerates more sharply than Cubic.
  ///
  /// Example usage:
  /// ```
  /// let sineEasing = Quart()
  /// let y1 = sineEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = sineEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = sineEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Quart: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      return b + c * t * t * t * t
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d - 1
      return b - c * (t * t * t * t - 1)
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var t = t / (d / 2)
      if t < 1 {
        return b + c / 2 * t * t * t * t
      }
      t -= 2
      return b - c / 2 * (t * t * t * t - 2)
    }
  }

  /// Quintic easing. Ease-in accelerates, Ease-out decelerates.
  ///
  /// Example usage:
  /// ```
  /// let sineEasing = Quint()
  /// let y1 = sineEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = sineEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = sineEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Quint: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      return b + c * t * t * t * t * t
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d - 1
      return b + c * (t * t * t * t * t + 1)
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var t = t / (d / 2)
      if t < 1 {
        return b + c / 2 * t * t * t * t * t
      }
      t -= 2
      return b + c / 2 * (t * t * t * t * t + 2)
    }
  }

  /// Exponential (Expo) easing. Starts slow and ends very fast or starts very fast and ends slow.
  ///
  /// Example usage:
  /// ```
  /// let expoEasing = Expo()
  /// let y1 = expoEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = expoEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = expoEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Expo: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      (t == 0) ? b : c * pow(2, 10 * (t / d - 1)) + b
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      (t == d) ? b + c : c * (-pow(2, -10 * t / d) + 1) + b
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      if t == 0 {
        return b
      }
      if t == d {
        return b + c
      }

      let t = t / (d / 2)
      if t < 1 {
        return c / 2 * pow(2, 10 * (t - 1)) + b
      }

      return c / 2 * (-pow(2, -10 * (t - 1)) + 2) + b
    }
  }

  /// Circular (Circ) easing. The motion follows a circle or parts of a circle.
  ///
  /// Example usage:
  /// ```
  /// let circEasing = Circ()
  /// let y1 = circEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = circEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = circEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Circ: EasingInterpolatable {

    public init() {}

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      return -c * (sqrt(1 - t * t) - 1) + b
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d - 1
      return c * sqrt(1 - t * t) + b
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var t = t / (d / 2)
      if t < 1 {
        return -c / 2 * (sqrt(1 - t * t) - 1) + b
      }
      t -= 2
      return c / 2 * (sqrt(1 - t * t) + 1) + b
    }
  }

  /// Elastic easing. The motion feels like a spring or rubber band.
  ///
  /// Example usage:
  /// ```
  /// let elasticEasing = Elastic(amplitude: 1.0, period: 0.3)
  /// let y1 = elasticEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = elasticEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = elasticEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Elastic: EasingInterpolatable {

    public let amplitude: CGFloat
    public let period: CGFloat

    /// Make an `Elastic` easing.
    ///
    /// - Parameters:
    ///   - amplitude: Controls the "stretchiness" of the elastic motion. Higher values make the motion more exaggerated.
    ///                Must be non-negative.
    ///                Example: 1.0
    ///   - period: Controls the "bounciness" or frequency of the oscillations. Determines how many oscillations occur over the duration.
    ///             Example: 0.3
    public init(amplitude: CGFloat = 1.0, period: CGFloat = 0.3) {
      self.amplitude = amplitude
      self.period = period
    }

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var t = t / d
      if t == 0 {
        return b
      }
      if t == 1 {
        return b + c
      }
      let p = d * period
      var a = c * amplitude
      var s = 0.0
      if a < abs(c) {
        a = c
        s = p / 4
      } else {
        s = p / (2 * .pi) * asin(c / a)
      }
      t -= 1
      return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * .pi) / p)) + b
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      if t == 0 {
        return b
      }
      if t == 1 {
        return b + c
      }
      let p = d * period
      var a = c * amplitude
      var s = 0.0
      if a < abs(c) {
        a = c
        s = p / 4
      } else {
        s = p / (2 * .pi) * asin(c / a)
      }
      return a * pow(2, -10 * t) * sin((t * d - s) * (2 * .pi) / p) + c + b
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var t = t / (d / 2)
      if t == 0 {
        return b
      }
      if t == 2 {
        return b + c
      }
      let p = d * period * 1.5
      var a = c * amplitude
      var s = 0.0
      if a < abs(c) {
        a = c
        s = p / 4
      } else {
        s = p / (2 * .pi) * asin(c / a)
      }
      if t < 1 {
        t -= 1
        return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * .pi) / p)) + b
      }
      t -= 1
      return a * pow(2, -10 * t) * sin((t * d - s) * (2 * .pi) / p) * 0.5 + c + b
    }
  }

  /// Back easing. Overshoots and then comes back.
  ///
  /// Example usage:
  /// ```
  /// let backEasing = Back(scale: 1.70158)
  /// let y1 = backEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = backEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = backEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Back: EasingInterpolatable {

    /// The scale factor that determines the amount of overshoot.
    /// Higher values will result in more overshoot.
    public let scale: CGFloat

    /// Initializes a new `Back` easing with a given scale factor.
    ///
    /// - Parameter scale: The scale factor for the overshoot. Defaults to 1.70158.
    public init(scale: CGFloat = 1.70158) {
      self.scale = scale
    }

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d
      return b + c * t * t * ((scale + 1) * t - scale)
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      let t = t / d - 1
      return b + c * (t * t * ((scale + 1) * t + scale) + 1)
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var s = scale
      var t = t / (d / 2)
      if t < 1 {
        s *= 1.525
        return b + c / 2 * (t * t * ((s + 1) * t - s))
      }
      t -= 2
      s *= 1.525
      return b + c / 2 * (t * t * ((s + 1) * t + s) + 2)
    }
  }

  /// Bounce easing. The motion feels as if an object is bouncing to its final position.
  ///
  /// - Example usage:
  /// ```
  /// let bounceEasing = Bounce()
  /// let y1 = bounceEasing.easeIn(0.5, 0, 1, 1)
  /// let y2 = bounceEasing.easeOut(0.5, 0, 1, 1)
  /// let y3 = bounceEasing.easeInOut(0.5, 0, 1, 1)
  /// ```
  public struct Bounce: EasingInterpolatable {

    public let amplitude: CGFloat

    /// Make a `Bounce` easing.
    /// - Parameter amplitude: A factor to scale the height of the bounce. Default is 1. Higher values make it more bouncy.
    public init(amplitude: CGFloat = 1.0) {
      self.amplitude = amplitude
    }

    public func easeIn(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      (c - easeOut(d - t, 0, c, d)) + b
    }

    public func easeOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      var time = t / d
      if time < (1 / 2.75) {
        return c * (7.5625 * time * time * amplitude) + b
      } else if time < (2 / 2.75) {
        time -= 1.5 / 2.75
        return c * (7.5625 * time * time * amplitude + 0.75) + b
      } else if time < (2.5 / 2.75) {
        time -= 2.25 / 2.75
        return c * (7.5625 * time * time * amplitude + 0.9375) + b
      } else {
        time -= 2.625 / 2.75
        return c * (7.5625 * time * time * amplitude + 0.984375) + b
      }
    }

    public func easeInOut(_ t: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat) -> CGFloat {
      if t < d / 2 {
        return easeIn(t * 2, 0, c, d) * 0.5 + b
      } else {
        return easeOut(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b
      }
    }
  }
}

/// http://robertpenner.com/easing/
/// http://robertpenner.com/easing/penner_chapter7_tweening.pdf
///
/// t = currentTime
/// b = beginning
/// c = change
/// d = duration
///
/// https://github.com/janselv/smooth-gradient/blob/master/EasingFunction.swift
/// https://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js

/// https://gizma.com/easing/#easeInElastic
/// https://easings.net/
