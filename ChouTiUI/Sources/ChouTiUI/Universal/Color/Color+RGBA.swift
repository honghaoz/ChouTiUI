//
//  Color+RGBA.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 9/4/21.
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

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import CoreGraphics
import CoreImage

import ChouTi

// MARK: - Create Color with RGBA

public extension Color {

  // MARK: - RGBA with CGFloat

  /// Makes an opaque `Color` with the specified red, green, blue channel values.
  ///
  /// - Parameters:
  ///   - r: The red component of the color.
  ///   - g: The green component of the color.
  ///   - b: The blue component of the color.
  ///   - colorSpace: The color space for the RGBA components. Defaults to `.sRGB`.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, colorSpace: ColorSpace = .sRGB) -> Color {
    rgb(r: r, g: g, b: b, colorSpace: colorSpace)
  }

  /// Makes an opaque `Color` with the specified red, green, blue channel values.
  ///
  /// - Parameters:
  ///   - r: The red component of the color. Defaults to 0.
  ///   - g: The green component of the color. Defaults to 0.
  ///   - b: The blue component of the color. Defaults to 0.
  ///   - colorSpace: The color space for the RGBA components. Defaults to `.sRGB`.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func rgb(r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, colorSpace: ColorSpace = .sRGB) -> Color {
    rgba(r: r, g: g, b: b, a: 1, colorSpace: colorSpace)
  }

  /// Makes a `Color` with the specified red, green, blue and alpha channel values.
  ///
  /// - Parameters:
  ///   - r: The red component of the color.
  ///   - g: The green component of the color.
  ///   - b: The blue component of the color.
  ///   - a: The alpha component of the color.
  ///   - colorSpace: The color space for the RGBA components. Defaults to `.sRGB`.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> Color {
    rgba(r: r, g: g, b: b, a: a, colorSpace: colorSpace)
  }

  /// Makes a `Color` with the specified red, green, blue and alpha channel values.
  ///
  /// - Parameters:
  ///   - r: The red component of the color.
  ///   - g: The green component of the color.
  ///   - b: The blue component of the color.
  ///   - a: The alpha component of the color.
  ///   - colorSpace: The color space for the RGBA components. Defaults to `.sRGB`.
  /// - Returns: The color object.
  @inlinable
  @inline(__always)
  static func rgba(r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1, colorSpace: ColorSpace = .sRGB) -> Color {
    Color(red: r, green: g, blue: b, alpha: a, colorSpace: colorSpace)
  }

  // MARK: - Init

  /// Create a new color with the specified red, green, blue and alpha channel values.
  ///
  /// - Parameters:
  ///   - r: The red component of the color.
  ///   - g: The green component of the color.
  ///   - b: The blue component of the color.
  ///   - a: The alpha component of the color. Defaults to 1.
  ///   - colorSpace: The color space for the RGBA components. Defaults to `.sRGB`.
  convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1, colorSpace: ColorSpace = .sRGB) {
    ChouTi.assert(alpha >= 0 && alpha <= 1, "Invalid alpha component", metadata: ["alpha": "\(alpha)"])
    let alpha = alpha.clamped(to: 0.0 ... 1.0)

    switch colorSpace {
    case .sRGB:
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    case .displayP3:
      /// The following customized initializer can be 0.004s slow for 10000 iterations.
      /// The benefit is that on iOS, the cgColor has a correct color space for displayP3
      //
      // if let cgColor = CGColor.rgba(red: red, green: green, blue: blue, alpha: alpha, colorSpace: .displayP3()) {
      //   #if canImport(AppKit)
      //   self.init(cgColor: cgColor)!
      //   #else
      //   self.init(cgColor: cgColor)
      //   #endif
      // } else {
      //   ChouTi.assertFailure("Failed to use CGColor to initialize Color")
      //   self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
      // }
      //
      self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
  }
}

// MARK: - Get RGBA

public extension Color {

  // MARK: - Get RGBA

  /// Get red, green, blue and alpha components from the color.
  ///
  /// - Parameter colorSpace: The color space to get the components. Default value is extended sRGB color space (`.sRGB`).
  ///                         Use `.sRGB` to indicate to use extended sRGB color space.
  /// - Returns: The red, green, blue, alpha component values represented as `RGBA` or `nil` if the color doesn't support RGBA.
  func rgba(colorSpace: ColorSpace = .sRGB) -> RGBA? {
    #if canImport(AppKit)
    switch colorSpace {
    case .sRGB:
      let color: NSColor
      if self.isRGB, self.colorSpace == NSColorSpace.sRGB || self.colorSpace == NSColorSpace.extendedSRGB {
        color = self
      } else if let convertedColor = usingColorSpace(.extendedSRGB) {
        color = convertedColor
      } else {
        ChouTi.assertFailure("Failed to get rgba components", metadata: [
          "color": "\(self)",
        ])
        return nil
      }

      var red: CGFloat = 0.0
      var green: CGFloat = 0.0
      var blue: CGFloat = 0.0
      var alpha: CGFloat = 0.0
      color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      return RGBA(red, green, blue, alpha)

    case .displayP3:
      let color: NSColor
      if self.isRGB, self.colorSpace == NSColorSpace.displayP3 {
        color = self
      } else if let convertedColor = usingColorSpace(.displayP3) {
        color = convertedColor
      } else {
        ChouTi.assertFailure("Failed to convert color in displayP3", metadata: [
          "color": "\(self)",
        ])
        return nil
      }

      var red: CGFloat = 0.0
      var green: CGFloat = 0.0
      var blue: CGFloat = 0.0
      var alpha: CGFloat = 0.0
      color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      return RGBA(red, green, blue, alpha)
    }
    #else
    switch colorSpace {
    case .sRGB:
      var red: CGFloat = 0.0
      var green: CGFloat = 0.0
      var blue: CGFloat = 0.0
      var alpha: CGFloat = 0.0
      let isConverted = getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      if isConverted {
        return RGBA(red, green, blue, alpha)
      } else {
        ChouTi.assertFailure("Failed to get rgba components", metadata: [
          "color": "\(self)",
        ])
        return nil
      }

    case .displayP3:
      if let convertedColor: CGColor = cgColor.usingColorSpace(.displayP3()), let components = convertedColor.components {
        let numComponents = convertedColor.numberOfComponents

        // https://gist.github.com/nicklockwood/96aea92b8cf3997cd4a0e87e1edde570
        // https://stackoverflow.com/questions/74608754/convert-display-p3-to-esrgb-by-hex-color-in-ios-swift
        // https://stackoverflow.com/questions/49039235/best-practices-when-initializing-a-uicolor-displayp3-color

        if numComponents == 4 {
          return RGBA(
            red: components[0],
            green: components[1],
            blue: components[2],
            alpha: components[3]
          )
        } else if numComponents == 2 {
          // This is a grayscale color, which is a special case.
          // The first component is the white value (same as red, green, and blue),
          // and the second is the alpha value.
          return RGBA(
            red: components[0],
            green: components[0],
            blue: components[0],
            alpha: components[1]
          )
        } else {
          ChouTi.assertFailure("Invalid CGColor numberOfComponents", metadata: ["numberOfComponents": "\(numComponents)"])
          return nil
        }
      } else {
        ChouTi.assertFailure("Failed to convert color in displayP3", metadata: ["color": "\(self)"])
        return nil
      }
    }
    #endif
  }

  /// Get the red component from the color.
  ///
  /// - Parameter colorSpace: The color space to get the components. Default value is extended sRGB color space (`.sRGB`).
  ///                         Use `.sRGB` to indicate to use extended sRGB color space.
  /// - Returns: The red component or `nil` if the color doesn't support RGBA.
  @inlinable
  @inline(__always)
  func red(colorSpace: ColorSpace = .sRGB) -> CGFloat? {
    rgba(colorSpace: colorSpace)?.red
  }

  /// Get the green component from the color.
  ///
  /// - Parameter colorSpace: The color space to get the components. Default value is extended sRGB color space (`.sRGB`).
  ///                         Use `.sRGB` to indicate to use extended sRGB color space.
  /// - Returns: The green component or `nil` if the color doesn't support RGBA.
  @inlinable
  @inline(__always)
  func green(colorSpace: ColorSpace = .sRGB) -> CGFloat? {
    rgba(colorSpace: colorSpace)?.green
  }

  /// Get the blue component from the color.
  ///
  /// - Parameter colorSpace: The color space to get the components. Default value is extended sRGB color space (`.sRGB`).
  ///                         Use `.sRGB` to indicate to use extended sRGB color space.
  /// - Returns: The blue component or `nil` if the color doesn't support RGBA.
  @inlinable
  @inline(__always)
  func blue(colorSpace: ColorSpace = .sRGB) -> CGFloat? {
    rgba(colorSpace: colorSpace)?.blue
  }

  /// Get alpha component from the color.
  ///
  /// - Returns: The alpha value
  func alpha() -> CGFloat {
    #if canImport(AppKit)
    return alphaComponent
    #else
    var alpha: CGFloat = 0.0
    getRed(nil, green: nil, blue: nil, alpha: &alpha)
    return alpha
    #endif
  }

  /// Get the alpha value
  @inlinable
  @inline(__always)
  var opacity: CGFloat {
    alpha()
  }
}

// MARK: - Color interpolation in RGBA

public extension Color {

  /// Get a linear interpolated color in RGBA model, from `self` to `toColor`.
  ///
  /// Example:
  /// ```
  /// let color = fromColor.lerp(to: toColor, t: progress)
  /// ```
  ///
  /// - Parameters:
  ///   - toColor: The end `Color`.
  ///   - t: The interpolation progress. The value is allowed to be be out of the `[0 ... 1]` range.
  ///   - colorSpace: The working color space. Default value is `.sRGB`.
  /// - Returns: An interpolated `Color`.
  func lerp(to toColor: Color, t: Double, colorSpace: ColorSpace = .sRGB) -> Color {
    guard let from = rgba(colorSpace: colorSpace), let to = toColor.rgba(colorSpace: colorSpace) else {
      ChouTi.assertFailure("Failed to get rgba components", metadata: [
        "from": "\(self)",
        "to": "\(toColor)",
      ])
      return self
    }

    let red = from.red + (to.red - from.red) * t
    let green = from.green + (to.green - from.green) * t
    let blue = from.blue + (to.blue - from.blue) * t
    let alpha = from.alpha + (to.alpha - from.alpha) * t

    return Color(red: red, green: green, blue: blue, alpha: alpha, colorSpace: colorSpace)
  }
}

// References on getting RGBA

// https://stackoverflow.com/a/34115587/3164091
// https://stackoverflow.com/a/45234656/3164091

// Performance:
/**
 let color = Color.hsba(h: 0.5, s: 0.6, b: 0.7, a: 1)
 // [CIColor] elapsed time: 0.005666624987497926
 // [CIColor] elapsed time: 0.0053725416655652225
 PerformanceMeasurer.measure(tag: "CIColor", repeatCount: 10000) {
   let ciColor = CIColor(color: color)!
   let (r, g, b, a) = (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
 }

 // with color.usingColorSpace(.deviceRGB)
 // [ConvertingColorSpace] elapsed time: 0.01426424999954179
 // without color.usingColorSpace(.deviceRGB)
 // [ConvertingColorSpace] elapsed time: 0.004364916647318751
 PerformanceMeasurer.measure(tag: "ConvertingColorSpace", repeatCount: 10000) {
   let rgbColor = color.usingColorSpace(.deviceRGB) // should avoid converting when possible
   var red: CGFloat = 0.0
   var green: CGFloat = 0.0
   var blue: CGFloat = 0.0
   var alpha: CGFloat = 0.0
   rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
 }
 */
//
// without using color.usingColorSpace(.deviceRGB)
//
// .sRGB
// let color = Color(colorSpace: .sRGB, hue: 0.5, saturation: 0.6, brightness: 0.8, alpha: 1)
// [CIColor] elapsed time: 0.005414333310909569
// [ConvertingColorSpace] elapsed time: 0.0028592500020749867
// [CIColor] elapsed time: 0.005393791710957885
// [ConvertingColorSpace] elapsed time: 0.0028764583403244615

// .deviceRGB
// let color = Color(colorSpace: .deviceRGB, hue: 0.5, saturation: 0.6, brightness: 0.8, alpha: 1)
// [CIColor] elapsed time: 0.005573250004090369
// [ConvertingColorSpace] elapsed time: 0.004268708289600909
// [CIColor] elapsed time: 0.012531374988611788
// [ConvertingColorSpace] elapsed time: 0.0028575832839123905

// .genericRGB
// [CIColor] elapsed time: 0.005317375005688518
// [ConvertingColorSpace] elapsed time: 0.002906374982558191
// [CIColor] elapsed time: 0.005399083311203867
// [ConvertingColorSpace] elapsed time: 0.002816166670527309

// .extendedSRGB
// let color = Color(colorSpace: .extendedSRGB, hue: 0.5, saturation: 0.6, brightness: 0.8, alpha: 1)
// [CIColor] elapsed time: 0.005397333297878504
// [ConvertingColorSpace] elapsed time: 0.0038551249890588224
// [CIColor] elapsed time: 0.005463624955154955
// [ConvertingColorSpace] elapsed time: 0.002866833354346454

// .adobeRGB1998
// let color = Color(colorSpace: .adobeRGB1998, hue: 0.5, saturation: 0.6, brightness: 0.8, alpha: 1)
// [CIColor] elapsed time: 0.005501916632056236
// [ConvertingColorSpace] elapsed time: 0.0030864166910760105
// [CIColor] elapsed time: 0.0055825000163167715
// [ConvertingColorSpace] elapsed time: 0.0029360000044107437
