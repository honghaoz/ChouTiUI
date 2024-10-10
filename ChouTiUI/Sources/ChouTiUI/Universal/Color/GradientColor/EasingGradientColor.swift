//
//  EasingGradientColor.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 3/29/23.
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

/// A type represents a segment within an easing gradient. Each segment defines a gradient from one color to another,
/// over a specified number of interpolation steps and with a specified weight.
public struct GradientSegment {

  /// The starting color of the segment.
  public let fromColor: Color

  /// The ending color of the segment.
  public let toColor: Color

  /// The interpolation function to use when determining the gradient within this segment.
  public let interpolationFunction: InterpolationFunction

  /// The number of steps to interpolate between `fromColor` and `toColor`.
  public let steps: Int

  /// The relative weight of this segment in the entire gradient. Affects the proportion of the gradient occupied by this segment.
  public let weight: CGFloat

  /// Initializes a new GradientSegment.
  ///
  /// - Parameters:
  ///   - fromColor: The starting color of the segment.
  ///   - toColor: The ending color of the segment.
  ///   - interpolationFunction: The function to use for interpolating the gradient. Defaults to `Easing.Sine().easeInOut`.
  ///   - steps: The number of steps to interpolate between `fromColor` and `toColor`. Defaults to `10`.
  ///   - weight: The relative weight of this segment in the entire gradient. Defaults to `1`.
  public init(fromColor: Color,
              toColor: Color,
              interpolationFunction: @escaping InterpolationFunction = Easing.Sine().easeInOut,
              steps: Int = 10,
              weight: CGFloat = 1)
  {
    self.fromColor = fromColor
    self.toColor = toColor
    self.interpolationFunction = interpolationFunction
    self.steps = steps
    self.weight = weight
  }
}

/// A type represents an easing gradient composed of multiple segments. Each segment contributes to the final gradient based on its weight.
public struct EasingGradientColor {

  /// The segments that make up this gradient.
  public let segments: [GradientSegment]

  /// The colors generated for this gradient, based on the segments.
  public let colors: [Color]

  /// The locations associated with each color in the gradient.
  public let locations: [CGFloat]

  /// Initializes a new EasingGradientColor using the provided segments.
  /// - Parameter segments: The segments that define the gradient.
  public init(segments: [GradientSegment]) {
    self.segments = segments
    let colorsLocations = EasingGradientColor.generateColorsAndLocations(segments: segments)
    self.colors = colorsLocations.colors
    self.locations = colorsLocations.locations
  }

  /// Generates the colors and locations for a gradient based on the provided segments.
  /// - Parameter segments: The segments that define the gradient.
  /// - Returns: A tuple containing the generated colors and their corresponding locations.
  private static func generateColorsAndLocations(segments: [GradientSegment]) -> (colors: [Color], locations: [CGFloat]) {
    let totalSteps = segments.reduce(0) { $0 + $1.steps }
    var colors: [Color] = []
    colors.reserveCapacity(totalSteps)
    var locations: [CGFloat] = []
    locations.reserveCapacity(totalSteps)

    var locationOffset: CGFloat = 0
    let totalWeight = segments.reduce(0) { $0 + $1.weight }

    for segment in segments {
      let segmentPortion = segment.weight / totalWeight

      for number in 0 ... segment.steps {
        let t: CGFloat = CGFloat(number) / CGFloat(segment.steps)
        let progress = segment.interpolationFunction(t, 0, 1, 1)
        let color = segment.fromColor.lerp(to: segment.toColor, t: progress)
        let offset = t * segmentPortion // adjust location using the segment's proportion

        colors.append(color)
        locations.append(offset + locationOffset)
      }

      locationOffset += segmentPortion
    }

    return (colors, locations)
  }
}

// MARK: - LinearGradientColor

public extension LinearGradientColor {

  /// Creates a linear gradient color with a custom interpolation function.
  ///
  /// This initializer creates a linear gradient based on the provided `fromColor` and `toColor`, and uses
  /// the specified `interpolationFunction` to generate interpolated colors between the two colors.
  ///
  /// Example:
  /// ```swift
  /// let gradient = LinearGradientColor(from: .red, to: .blue, interpolationFunction: Easing.Sine().easeInOut, steps: 10)
  /// ```
  ///
  /// - Parameters:
  ///   - fromColor: The starting color of the gradient.
  ///   - toColor: The ending color of the gradient.
  ///   - interpolationFunction: The function used to interpolate between the `fromColor` and `toColor`. Defaults to `Easing.Sine().easeInOut`.
  ///   - steps: The number of interpolation steps between `fromColor` and `toColor`. The higher the value, the
  ///            smoother the gradient will appear. A value of 1 is a linear gradient. Defaults to 10.
  ///   - startPoint: The starting point of the gradient, expressed as a `UnitPoint`. Defaults to `.top`.
  ///   - endPoint: The ending point of the gradient, expressed as a `UnitPoint`. Defaults to `.bottom`.
  init(from fromColor: Color,
       to toColor: Color,
       interpolationFunction: @escaping InterpolationFunction = Easing.Sine().easeInOut,
       steps: Int = 10,
       startPoint: UnitPoint = .top,
       endPoint: UnitPoint = .bottom)
  {
    let easingGradientColor = EasingGradientColor(segments: [GradientSegment(fromColor: fromColor, toColor: toColor, interpolationFunction: interpolationFunction, steps: steps)])
    self.init(easingGradientColor: easingGradientColor, startPoint: startPoint, endPoint: endPoint)
  }

  /// Creates an easing linear gradient color.
  ///
  /// - Parameters:
  ///   - easingGradientColor: An `EasingGradientColor` type.
  ///   - startPoint: The starting point of the gradient, expressed as a `UnitPoint`. Defaults to `.top`.
  ///   - endPoint: The ending point of the gradient, expressed as a `UnitPoint`. Defaults to `.bottom`.
  @inlinable
  @inline(__always)
  init(easingGradientColor: EasingGradientColor, startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) {
    self.init(colors: easingGradientColor.colors, locations: easingGradientColor.locations, startPoint: startPoint, endPoint: endPoint)
  }
}

// MARK: - RadialGradientColor

public extension RadialGradientColor {

  /// Make a center radial gradient color based on aspect ratio.
  ///
  /// - Parameters:
  ///   - easingGradientColor: An `EasingGradientColor` type.
  ///   - radius: The radius in the narrow axis. For example, if `aspectRatio` < 1, 0.5 radius means the radial circle ends at the edge of x-axis.
  ///   - aspectRatio: The aspect ratio of the frame.
  /// - Returns: A center radial gradient color.
  @inlinable
  @inline(__always)
  static func centerRadial(easingGradientColor: EasingGradientColor,
                           radius: CGFloat,
                           aspectRatio: CGFloat) -> RadialGradientColor
  {
    self.centerRadial(colors: easingGradientColor.colors, locations: easingGradientColor.locations, radius: radius, aspectRatio: aspectRatio)
  }

  /// Make a center radial gradient color based on aspect ratio.
  ///
  /// - Parameters:
  ///   - easingGradientColor: An `EasingGradientColor` type.
  ///   - diameter: The circle diameter.
  ///   - radiusScaleFactor: The radius scale factor. By default this is 1.
  ///   - aspectRatio: The aspect ratio of the frame.
  /// - Returns: A center radial gradient color.
  @inlinable
  @inline(__always)
  static func centerRadial(easingGradientColor: EasingGradientColor,
                           diameter: CircleDiameter,
                           radiusScaleFactor: CGFloat = 1,
                           aspectRatio: CGFloat) -> RadialGradientColor
  {
    self.centerRadial(colors: easingGradientColor.colors, locations: easingGradientColor.locations, diameter: diameter, radiusScaleFactor: radiusScaleFactor, aspectRatio: aspectRatio)
  }

  /// Creates a radial gradient color with a custom interpolation function.
  ///
  /// - Parameters:
  ///   - fromColor: The starting color of the gradient.
  ///   - toColor: The ending color of the gradient.
  ///   - interpolationFunction: The function used to interpolate between the `fromColor` and `toColor`. Defaults to `Easing.Sine().easeInOut`.
  ///   - steps: The number of interpolation steps between `fromColor` and `toColor`. The higher the value, the
  ///            smoother the gradient will appear. A value of 1 is a linear gradient. Defaults to 10.
  ///   - centerPoint: The center point of the gradient, expressed as a `UnitPoint`.
  ///   - endPoint: The end position, expressed in a `UnitPoint`.
  init(from fromColor: Color,
       to toColor: Color,
       interpolationFunction: @escaping InterpolationFunction = Easing.Sine().easeInOut,
       steps: Int = 10,
       centerPoint: UnitPoint,
       endPoint: UnitPoint)
  {
    let easingGradientColor = EasingGradientColor(segments: [GradientSegment(fromColor: fromColor, toColor: toColor, interpolationFunction: interpolationFunction, steps: steps)])
    self.init(easingGradientColor: easingGradientColor, centerPoint: centerPoint, endPoint: endPoint)
  }

  /// Creates an easing radial gradient color.
  ///
  /// - Parameters:
  ///   - easingGradientColor: An `EasingGradientColor` type.
  ///   - centerPoint: The center point of the gradient, expressed as a `UnitPoint`.
  ///   - endPoint: The end point of the gradient, expressed as a `UnitPoint`.
  @inlinable
  @inline(__always)
  init(easingGradientColor: EasingGradientColor, centerPoint: UnitPoint, endPoint: UnitPoint) {
    self.init(colors: easingGradientColor.colors, locations: easingGradientColor.locations, centerPoint: centerPoint, endPoint: endPoint)
  }
}

// MARK: - AngularGradientColor

public extension AngularGradientColor {

  /// Creates a angular gradient color with a custom interpolation function.
  ///
  /// - Parameters:
  ///   - fromColor: The starting color of the gradient.
  ///   - toColor: The ending color of the gradient.
  ///   - interpolationFunction: The function used to interpolate between the `fromColor` and `toColor`. Defaults to `Easing.Sine().easeInOut`.
  ///   - steps: The number of interpolation steps between `fromColor` and `toColor`. The higher the value, the
  ///            smoother the gradient will appear. A value of 1 is a linear gradient. Defaults to 10.
  ///   - centerPoint: The center point of the gradient, expressed as a `UnitPoint`.
  ///   - aimingPoint: The aiming point of the gradient, expressed as a `UnitPoint`.
  init(from fromColor: Color,
       to toColor: Color,
       interpolationFunction: @escaping InterpolationFunction = Easing.Sine().easeInOut,
       steps: Int = 10,
       centerPoint: UnitPoint,
       aimingPoint: UnitPoint)
  {
    let easingGradientColor = EasingGradientColor(segments: [GradientSegment(fromColor: fromColor, toColor: toColor, interpolationFunction: interpolationFunction, steps: steps)])
    self.init(easingGradientColor: easingGradientColor, centerPoint: centerPoint, aimingPoint: aimingPoint)
  }

  /// Creates an easing angular gradient color.
  ///
  /// - Parameters:
  ///   - easingGradientColor: An `EasingGradientColor` type.
  ///   - centerPoint: The center point of the gradient, expressed as a `UnitPoint`.
  ///   - aimingPoint: The aiming point of the gradient, expressed as a `UnitPoint`.
  @inlinable
  @inline(__always)
  init(easingGradientColor: EasingGradientColor, centerPoint: UnitPoint, aimingPoint: UnitPoint) {
    self.init(colors: easingGradientColor.colors, locations: easingGradientColor.locations, centerPoint: centerPoint, aimingPoint: aimingPoint)
  }
}

/// https://github.com/janselv/smooth-gradient
