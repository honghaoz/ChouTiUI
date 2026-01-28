//
//  CALayer+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/23/21.
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

public extension CALayer {

  convenience init(frame: CGRect) {
    self.init()
    self.frame = frame
  }

  /// The layer's backed view if it is a backing layer for a view.
  ///
  /// On Mac, for layer-backed views, setting the layer's frame won't affect the backed view's frame.
  /// Use this property to find the backed view if you want to manipulate the view's frame.
  @inlinable
  @inline(__always)
  var backedView: View? {
    delegate as? View
  }

  /// Find the view that is presenting this layer.
  ///
  /// If this layer has a backed view, it returns the backed view as the presenting view.
  /// Otherwise, it traverse the layer hierarchy to find the first backed view.
  ///
  /// This method is useful if you want to find the view that shows the layer, and can use the view to find the presenting view controller.
  /// For example: `layer.presentingView?.presentingViewController`
  var presentingView: View? {
    if let backedView {
      return backedView
    } else {
      return superlayer?.presentingView
    }
  }

  private static let borderOffsetKey = String("redrob".reversed() + "Offset")

  /// The offset of the border of the layer.
  ///
  /// Positive value makes the border move outward, negative value makes the border move inward.
  @available(macOS 15.0, iOS 18.0, tvOS 18.0, visionOS 2.0, *)
  var borderOffset: CGFloat {
    get {
      value(forKey: Self.borderOffsetKey).assert("missing value for key \(Self.borderOffsetKey)") as? CGFloat ?? 0
    }
    set {
      setValue(newValue, forKey: Self.borderOffsetKey)
    }
  }
}

// MARK: - Strong

public extension CALayer {

  private enum AssociateKey {
    static var layerDelegate: UInt8 = 0
  }

  /// add a strong referenced delegate.
  var strongDelegate: CALayerDelegate? {
    get {
      getAssociatedObject(for: &AssociateKey.layerDelegate) as? CALayerDelegate
    }
    set {
      setAssociatedObject(newValue, for: &AssociateKey.layerDelegate)
      delegate = newValue
    }
  }
}
