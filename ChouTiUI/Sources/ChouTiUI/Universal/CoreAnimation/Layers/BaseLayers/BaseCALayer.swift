//
//  BaseCALayer.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/5/21.
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

/// A base `CALayer` class.
open class BaseCALayer: CALayer, BaseCALayerInternalType {

  override public init() {
    super.init()

    commonInit()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    // swiftlint:disable:next fatal_error
    fatalError("init(coder:) is unavailable")
  }

  override public init(layer: Any) {
    if let layer = layer as? BaseCALayer {
      _debugDescription = layer._debugDescription
    }

    super.init(layer: layer)

    // Q: why need this initializer?
    // A: because Core Animation needs to create a copy of the layer to use it as a presentation layer. This can happen
    // when animating a layer or rendering a layer in the Xcode view debugger.
    //
    // https://stackoverflow.com/questions/31892986/why-does-cabasicanimation-try-to-initialize-another-instance-of-my-custom-calaye/36017699
    // https://stackoverflow.com/questions/38468515/cabasicanimation-creates-empty-default-value-copy-of-calayer/38468678#38468678
  }

  // MARK: - BaseCALayerInternalType

  public private(set) lazy var bindingObservationStorage = BindingObservationStorage()

  var _debugDescription: String?

  // MARK: - Debug

  override open var debugDescription: String {
    _debugDescription ?? super.debugDescription
  }
}

/**
 CALayer action orders:
 1. check's `action(forKey:)`
   a) if returns `nil`, stops searching
   b) if returns `NSNull()`, stops searching
   c) if return `super.defaultAction(forKey: event)`, continues searching
 2. check delegate's `action(for:forKey:)`
   a) if returns `nil`, continue searching
   b) if returns `NSNull()`, stops searching
 3. check `class defaultAction(forKey:)`
   a) if returns `nil`, has implicit animations
   b) if returns `NSNull()`, disables implicit animations

 UIView subclass
 1. `action(for:forKey:)`
   a) return `nil` enables implicit animations
   b) return `super.action(for: layer, forKey: event)` disables implicit animation because UIView returns `NSNull`.
 */

/**
 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/ReactingtoLayerChanges/ReactingtoLayerChanges.html
 Core Animation looks for action objects in the following order:

 1. If the layer has a delegate and that delegate implements the actionForLayer:forKey: method, the layer calls that method. The delegate must do one of the following:
   - Return the action object for the given key.
   - Return nil if it does not handle the action, in which case the search continues.
   - Return the NSNull object, in which case the search ends immediately.
 2. The layer looks for the given key in the layer’s actions dictionary.
 3. The layer looks in the style dictionary for an actions dictionary that contains the key. (In other word, the style dictionary contains an actions key whose value is also a dictionary. The layer looks for the given key in this second dictionary.)
 4. The layer calls its defaultActionForKey: class method.
 5. The layer performs the implicit action (if any) defined by Core Animation.
 */

/**
  Code left for updating content scale, seems like deprecated.
  Should make CALayer.delegate to be the hosting view (aka NSView)

 // TBH, I don't know if it's necessary to set delegate for
 // NSViewLayerContentScaleDelegate's layer(_:shouldInheritContentsScale:from:)
 self.delegate = self

 #if os(macOS)
 extension BaseCALayer: NSViewLayerContentScaleDelegate {

   /// http://supermegaultragroovy.com/2012/10/24/coding-for-high-resolution-on-os-x-read-this/
   /// https://stackoverflow.com/a/20606142/3164091
   public func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool {
     true
   }
 }
 #endif
  */

/**
 Core Animation Performance:

 Seeing high CPU usage when dragging a window
 CA::Transaction::commit()
 https://stackoverflow.com/questions/24071587/bottleneck-in-catransactioncommit

 ⭐️ Tips on using Core Animation.
 https://stackoverflow.com/questions/5003616/ios-core-animation-performance-tuning
 */

// MARK: - frame, bounds, anchorPoint, transform

/**
 ------------------------------------
 ------------------------------------
 // anchorPoint is (0.5, 0.5)

 (lldb) po layer.frame
 ▿ (50.0, 100.0, 50.0, 100.0)

 (lldb) po layer.bounds
 ▿ (0.0, 0.0, 50.0, 100.0)

 (lldb) po layer.anchorPoint
 ▿ (0.5, 0.5)

 (lldb) po layer.position
 ▿ (75.0, 150.0)

 ------------------------------------
 // changes transform
 (lldb) po layer.transform = .scale(x: 2, y: 2, z: 1)

 (lldb) po layer.frame
 ▿ (25.0, 50.0, 100.0, 200.0)

 (lldb) po layer.bounds
 ▿ (0.0, 0.0, 50.0, 100.0)

 (lldb) po layer.anchorPoint
 ▿ (0.5, 0.5)

 (lldb) po layer.position
 ▿ (75.0, 150.0)

 ------------------------------------
 // changes frame
 (lldb) po layer.frame = CGRect(50.0, 100.0, 50.0, 100.0)

 (lldb) po layer.frame
 ▿ (50.0, 100.0, 50.0, 100.0)

 (lldb) po layer.bounds
 ▿ (0.0, 0.0, 25.0, 50.0) // <-- change frame affects the bounds.size

 (lldb) po layer.anchorPoint
 ▿ (0.5, 0.5)

 (lldb) po layer.position
 ▿ (75.0, 150.0)

 ------------------------------------
 ------------------------------------
 // anchorPoint is (0, 0)

 (lldb) po layer.frame
 ▿ (50.0, 100.0, 50.0, 100.0)

 (lldb) po layer.bounds
 ▿ (0.0, 0.0, 50.0, 100.0)

 (lldb) po layer.anchorPoint
 ▿ (0.0, 0.0)

 (lldb) po layer.position
 ▿ (50.0, 100.0)

 ------------------------------------
 // changes transform
 (lldb) po layer.transform = .scale(x: 2, y: 2)

 (lldb) po layer.frame
 ▿ (50.0, 100.0, 100.0, 200.0)

 (lldb) po layer.bounds
 ▿ (0.0, 0.0, 50.0, 100.0)

 (lldb) po layer.anchorPoint
 ▿ (0.0, 0.0)

 (lldb) po layer.position
 ▿ (50.0, 100.0)

 ------------------------------------
 // changes frame
 (lldb) po layer.frame = CGRect(50, 100, 50, 100)

 (lldb) po layer.frame
 ▿ (50.0, 100.0, 100.0, 200.0) // <-- changing frame doesn't work

 (lldb) po layer.bounds
 ▿ (0.0, 0.0, 50.0, 100.0)

 (lldb) po layer.anchorPoint
 ▿ (0.0, 0.0)

 (lldb) po layer.position
 ▿ (50.0, 100.0)

 (lldb) po layer.transform = .identity

 (lldb) po layer.frame
 ▿ (50.0, 100.0, 50.0, 100.0)

 (lldb) po layer.transform = .rotation(angle: .init(degrees: 45), z: 1)

 (lldb) po layer.transform
 ▿ CATransform3D
   - m11 : 0.7071067811865476
   - m12 : 0.7071067811865475
   - m13 : 0.0
   - m14 : 0.0
   - m21 : -0.7071067811865475
   - m22 : 0.7071067811865476
   - m23 : 0.0
   - m24 : 0.0
   - m31 : 0.0
   - m32 : 0.0
   - m33 : 1.0
   - m34 : 0.0
   - m41 : 0.0
   - m42 : 0.0
   - m43 : 0.0
   - m44 : 1.0

 (lldb) po layer.frame
 ▿ (-20.710678118654748, 100.0, 106.06601717798213, 106.06601717798213)

 (lldb) po testBorderColorLayer.bounds
 ▿ (0.0, 0.0, 50.0, 100.0)

 (lldb) po layer.anchorPoint
 ▿ (0.0, 0.0)

 (lldb) po layer.position
 ▿ (50.0, 100.0)

 (lldb) po layer.frame = CGRect(50, 100, 50, 100)

 (lldb) po layer.frame
 ▿ (24.999999999999996, 100.0, 100.0, 100.0)

 (lldb) po layer.bounds
 ▿ (0.0, 0.0, 106.06601717798212, 35.355339059327385)

 Summary:
 - `frame` is controlled by `position`, `bounds.size` and `transform`
 - changes `frame` may or may not affect `bounds.size` depends on the anchorPoint
 - changing `frame` is not a good idea. Should change `position`, `bounds.size` and `transform`.
 */

/// On mac, setting layer's position can make the view's frame and layer's frame out of sync
/// should use the backed view to set frame. Some testing code:
///
/// ```swift
/// let dummyView = BaseView()
/// dummyView.frame = CGRect(100, 200, 100, 200)
/// dummyView.setBackgroundColor(.red)
/// view.addSubview(dummyView)
///
/// dummyView.printGeometryInfo()
/// // ➜ geometry<<ChouTiUI.BaseNSView: 0x1476859f0>>:
/// //   frame: (100.0, 200.0, 100.0, 200.0)
/// //   bounds: (0.0, 0.0, 100.0, 200.0)
/// //   layer.frame: (100.0, 200.0, 100.0, 200.0)
/// //   layer.bounds: (0.0, 0.0, 100.0, 200.0)
/// //   layer.position: (100.0, 200.0)
/// //   layer.anchorPoint: (0.0, 0.0)
///
/// dummyView.layer!.position = dummyView.layer!.position.translate(dx: 100, dy: 0)
/// dummyView.printGeometryInfo()
/// // ➜ geometry<<ChouTiUI.BaseNSView: 0x1476859f0>>:
/// //   frame: (100.0, 200.0, 100.0, 200.0) // <---
/// //   bounds: (0.0, 0.0, 100.0, 200.0)
/// //   layer.frame: (200.0, 200.0, 100.0, 200.0) // <--- layer frame is mismatched with view frame
/// //   layer.bounds: (0.0, 0.0, 100.0, 200.0)
/// //   layer.position: (200.0, 200.0)
/// //   layer.anchorPoint: (0.0, 0.0)
/// ```

// Apply Core Image filtering to CALayer
// https://www.reddit.com/r/iOSProgramming/comments/ru292r/realtime_core_image_filtering_core_animation_on/

// Advanced Graphics with Core Animation
// https://academy.realm.io/posts/tryswift-tim-oliver-advanced-graphics-with-core-animation/
// magnificationFilter, CALayerContentsFilter
// CATiledLayer
// CAScrollLayer

// Private APIs
// https://github.com/avaidyam/QuartzInternal/tree/master/CoreAnimationPrivate
