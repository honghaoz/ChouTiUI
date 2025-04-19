//
//  UniversalTypes.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 10/18/20.
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

#if canImport(UIKit)
import UIKit

public typealias Application = UIApplication
#if os(visionOS)
public enum Screen {}
#else
public typealias Screen = UIScreen
#endif
public typealias Control = UIControl
public typealias Image = UIImage
public typealias ImageView = UIImageView
public typealias TextField = UITextField

// public typealias BaseViewType = BaseUIViewType
// public typealias BaseView = BaseUIView
// public typealias BaseScrollView = BaseUIScrollView
// public typealias BaseImageView = BaseUIImageView
// public typealias BaseLabel = BaseUILabel
// public typealias BaseTextField = BaseUITextField

public typealias LayoutPriority = UILayoutPriority
public typealias RectCorner = UIRectCorner

public typealias Event = UIEvent
public typealias KeyModifierFlags = UIKeyModifierFlags

#endif

#if canImport(AppKit)
import AppKit

public typealias Application = NSApplication
public typealias Screen = NSScreen
public typealias Control = NSControl
public typealias Image = NSImage
public typealias ImageView = NSImageView
public typealias TextField = NSTextField

// public typealias BaseViewType = BaseNSViewType
// public typealias BaseView = BaseNSView
// public typealias BaseScrollView = BaseNSScrollView
// public typealias BaseImageView = BaseNSImageView
// public typealias BaseLabel = BaseNSLabel
// public typealias BaseTextField = BaseNSTextField

public typealias LayoutPriority = NSLayoutConstraint.Priority
public typealias RectCorner = NSRectCorner

public typealias Event = NSEvent
public typealias KeyModifierFlags = NSEvent.ModifierFlags
#endif
