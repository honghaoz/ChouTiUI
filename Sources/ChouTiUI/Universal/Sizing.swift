//
//  Sizing.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 12/5/20.
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

import CoreGraphics

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

import ChouTi

public enum Sizing {

  #if os(iOS)
  public enum iPhone {

    // https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
    //
    // switch screenSize.height {
    // case Device.Size.iPhoneSE.height ..< Device.Size.iPhone8.height:
    //   fontSize = 20
    // case Device.Size.iPhone8.height ..< Device.Size.iPhone8Plus.height:
    //   fontSize = 24
    // default:
    //   fontSize = 28
    // }

    // https://www.ios-resolution.com/

    public enum Screen {

      public static let iPhone4 = CGSize(width: 320, height: 480)
      public static let iPhoneSE = CGSize(width: 320, height: 568)
      public static let iPhone8 = CGSize(width: 375, height: 667)
      public static let iPhone8Plus = CGSize(width: 414, height: 736)
      public static let iPhone11Pro = CGSize(width: 375, height: 812)
      /// iPhone 11 Pro Max
      public static let iPhone11ProMax = CGSize(width: 414, height: 896)
      /// iPhone 12 mini, iPhone 13 mini
      public static let iPhone12mini = iPhone11Pro
      /// iPhone 12/13/14
      public static let iPhone12 = CGSize(width: 390, height: 844)
      /// iPhone 12 Pro, iPhone 13 Pro
      public static let iPhone12Pro = iPhone12
      /// iPhone 12 Pro Max, iPhone 13 Pro Max
      public static let iPhone12ProMax = CGSize(width: 428, height: 926)
      /// iPhone 14 Pro, iPhone 15, iPhone 15 Pro
      public static let iPhone14Pro = CGSize(width: 393, height: 852)
      /// iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max
      public static let iPhone14ProMax = CGSize(width: 430, height: 932)
      /// iPhone 14 Plus
      public static let iPhone14Plus = iPhone12ProMax

      /// The iPhone screen size category.
      public enum SizeCategory: Comparable {

        /// iPhone 1/2/3/3GS, iPhone 4/4s
        ///
        /// 320 x 480
        case iPhone4

        /// iPhone 5, iPhone 5s, iPhone SE (1st gen)
        ///
        /// 320 x 568
        case iPhone5

        /// iPhone 6/7/8, iPhone SE (2nd gen), iPhone SE (3rd gen)
        ///
        /// 375 x 667
        case iPhone8

        /// iPhone 6/7/8 Plus
        ///
        /// 414 x 736
        case iPhone8Plus

        /// iPhone X, iPhone XS, iPhone 11/12/13/14/15 Pro, iPhone 12/13 mini
        ///
        /// 375 x 812 to 393 x 852
        case iPhonePro

        /// iPhone XR, iPhone XS Max, iPhone 11/12/13/14/15 Pro Max, iPhone 15/14 Plus
        ///
        /// 414 x 896 to 430 x 932
        case iPhoneProMax

        /// Determines if the current screen size category is bigger than or equal to the provided category.
        ///
        /// Example:
        /// ```
        /// sizeCategory.isBiggerThanOrEqualTo(.iPhonePro) {
        ///   // logic for iPhone Pro or larger screen sizes...
        /// }
        /// ```
        ///
        /// - Parameter category: The screen size category to compare against the current screen size category.
        /// - Returns: Returns `true` if the current screen size category is bigger than or equal to the provided category, otherwise returns `false`.
        public func isBiggerThanOrEqualTo(_ category: SizeCategory) -> Bool {
          self >= category
        }

        /// Determines if the current screen size category is smaller than or equal to the provided category.
        ///
        /// Example:
        /// ```
        /// sizeCategory.isSmallerThanOrEqualTo(.iPhonePro) {
        ///   // logic for iPhone Pro or smaller screen sizes...
        /// }
        /// ```
        ///
        /// - Parameter category: The screen size category to compare against the current screen size category.
        /// - Returns: Returns `true` if the current screen size category is smaller than or equal to the provided category, otherwise returns `false`.
        public func isSmallerThanOrEqualTo(_ category: SizeCategory) -> Bool {
          self <= category
        }

        /// Determines if the current screen size category is strictly bigger than the provided category.
        ///
        /// Example:
        /// ```
        /// if sizeCategory.isBiggerThan(.iPhonePro) {
        ///     // logic for iPhone Pro Max screen sizes...
        /// }
        /// ```
        ///
        /// - Parameter category: The screen size category to compare against the current screen size category.
        /// - Returns: Returns `true` if the current screen size category is strictly bigger than the provided category, otherwise returns `false`.
        public func isBiggerThan(_ category: SizeCategory) -> Bool {
          self > category
        }

        /// Determines if the current screen size category is strictly smaller than the provided category.
        ///
        /// Example:
        /// ```
        /// if sizeCategory.isSmallerThan(.iPhone8) {
        ///     // logic for iPhone SE (1st gen), iPhone 4s screen sizes...
        /// }
        /// ```
        ///
        /// - Parameter category: The screen size category to compare against the current screen size category.
        /// - Returns: Returns `true` if the current screen size category is strictly smaller than the provided category, otherwise returns `false`.
        public func isSmallerThan(_ category: SizeCategory) -> Bool {
          self < category
        }

        static func sizeCategory(for height: CGFloat) -> SizeCategory {
          if height < Screen.iPhoneSE.height {
            return .iPhone4
          } else if height < Screen.iPhone8.height {
            return .iPhone5
          } else if height < Screen.iPhone8Plus.height {
            return .iPhone8
          } else if height < Screen.iPhone11Pro.height {
            return .iPhone8Plus
          } else if height < Screen.iPhone11ProMax.height {
            return .iPhonePro
          } else {
            return .iPhoneProMax
          }
        }
      }
    }
  }
  #endif

  // MARK: - Cross-platform

  /// The navigation bar height.
  public static let navigationBarHeight: CGFloat = {
    #if os(macOS)
    macOS.navigationBarHeight
    #else
    iOS.navigationBarHeight
    #endif
  }()

  /// The expanded distance for a button to be pressed.
  ///
  /// When the user presses a button, the button will stay pressed even if the user's finger is moved outside the button's bounds.
  /// This is the distance that the button will stay pressed.
  public static let buttonPressExpandedMarginDistance: CGFloat = 60

  // MARK: - iOS

  public enum iOS {

    // MARK: - UI

    /// The navigation bar height.
    public static let navigationBarHeight: CGFloat = {
      #if os(iOS)
      if Device.hasRoundedDisplayCorners {
        return 50
      } else {
        return 44
      }
      #else
      return 44
      #endif
    }()

    /// The navigation bar button height.
    public static let navigationBarButtonHeight: CGFloat = {
      #if os(iOS)
      if Device.hasRoundedDisplayCorners {
        return 34
      } else {
        return 30
      }
      #else
      return 30
      #endif
    }()

    /// The edge spacing from the navigation bar button to the screen edge.
    public static let navigationBarButtonEdgeInsets: CGFloat = {
      #if os(iOS)
      if Device.hasRoundedDisplayCorners {
        return 8
      } else {
        return 6
      }
      #else
      return 10
      #endif
    }()

    /// The space between the navigation bar button and the center title.
    public static let navigationBarButtonTitleInset: CGFloat = 16

    /// The gap between the navigation bar buttons.
    public static let navigationBarButtonGap: CGFloat = 8

    /// The corner radius of the navigation bar button.
    public static let navigationBarButtonCornerRadius: CGFloat = {
      #if os(iOS)
      if Device.hasRoundedDisplayCorners {
        return 5
      } else {
        return 4
      }
      #else
      return 4
      #endif
    }()

    /// The push button height.
    public enum TouchButton {

      /// The small push button height. For example, the snooze button on alarm alert.
      public static let small: CGFloat = 29

      /// The normal push button height. For example, buttons on share sheets / alert.
      public static let normal: CGFloat = 39

      /// The big push button height. For example, call buttons, "Start" button in timer.
      public static let big: CGFloat = 44
    }

    /// The standard action button height.
    public static let actionButtonHeight: CGFloat = 46

    /// The standard action button height.
    public static let actionSheetButtonHeight: CGFloat = 46

    /// Black toast size. For example, loading black toast.
    public static let toastSize = CGSize(120, 120)
  }

  // MARK: - macOS

  #if os(macOS)
  public enum macOS {

    // MARK: - UI

    /// The window title bar height.
    public static let windowTitleBarHeight: CGFloat = 28

    /// The window bottom bar height.
    public static let windowBottomBarHeight: CGFloat = 34

    /// The window corner radius.
    public static let windowCornerRadius: CGFloat = System.macOS_bigSur ? 10 : 5

    /// The navigation bar height.
    public static let navigationBarHeight: CGFloat = windowTitleBarHeight + iOS.navigationBarHeight - (iOS.navigationBarHeight - iOS.navigationBarButtonHeight) / 2
  }
  #endif

  // MARK: - visionOS

  #if os(visionOS)
  public enum visionOS {

    // MARK: - UI

    /// The default scale factor for visionOS.
    public static let scaleFactor: CGFloat = 2

    /// The default window corner radius.
    public static let windowCornerRadius: CGFloat = {
      ChouTi.assertFailure("TODO: windowCornerRadius is not implemented for visionOS yet")
      return 10
    }()
  }
  #endif
}

/**
 References:
 - https://28b.co.uk/ios-device-dimensions-reference-table/
 - https://www.ios-resolution.com/
 - https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
 */
