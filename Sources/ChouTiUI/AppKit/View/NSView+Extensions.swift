//
//  NSView+Extensions.swift
//
//  Created by Honghao Zhang on 8/28/24.
//  Copyright © 2024 ChouTi. All rights reserved.
//

#if canImport(AppKit)

import AppKit
import ChouTi

public extension NSView {

  /// Some NSView common settings in ChouTi projects.
  func updateCommonSettings() {
    // seems like using auto layout can avoid certain ambiguous layout issues
    //
    // don't use auto layout
    // translatesAutoresizingMaskIntoConstraints = false

    wantsLayer = true
    layer()?.cornerCurve = .continuous
    layer()?.contentsScale = Screen.mainScreenScale

    // turns off clipping
    // https://stackoverflow.com/a/53176282/3164091
    layer()?.masksToBounds = false
  }
}

// MARK: - Ignore Hit Test

public extension NSView {

  private static let _key = Obfuscation.deobfuscate(#"}{y\}hy"#, key: 20) // "ignoreHitTest"

  var ignoreHitTest: Bool {
    /// https://avaidyam.github.io/2018/03/22/Exercise-Modern-Cocoa-Views.html
    /// https://stackoverflow.com/a/2906605/3164091
    /// https://stackoverflow.com/questions/11923597/using-valueforkey-to-access-view-in-uibarbuttonitem-private-api-violation

    get {
      (value(forKey: Self._key) as? Bool).assert("missing ignoreHitTest key") ?? false
    }
    set {
      setValue(newValue, forKey: Self._key)
    }
  }
}

#endif
