//
//  CASpringAnimation+Extensions.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 7/2/23.
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

extension CASpringAnimation: SolveForInputable {}

public extension CASpringAnimation {

  func durationForEpsilon(_ epsilon: Double) -> TimeInterval? {
    // #if DEBUG
    // DispatchQueue.once {
    //   printObfuscationTable()
    // }
    // #endif

    // durationForEpsilon:
    let selectorString = Obfuscation.deobfuscate("l}zi|qwvNwzMx{qtwvB", key: obfuscationKey)
    let selector = Selector(selectorString)
    guard self.responds(to: selector) else {
      ChouTi.assertFailure("spring animation doesn't respond to selector \(selector)")
      return nil
    }

    typealias Method = @convention(c) (AnyObject, Selector, Double) -> Double
    let methodIMP = method(for: selector)
    let method: Method = unsafeBitCast(methodIMP, to: Method.self)
    let duration = method(self, selector, epsilon)

    return duration
  }
}

private let obfuscationKey: Int = 8

// #if DEBUG
// // https://github.com/avaidyam/QuartzInternal/blob/master/CoreAnimationPrivate/CAAnimationPrivate.h
//
// /// durationForEpsilon:: l}zi|qwvNwzMx{qtwvB
// private func printObfuscationTable() {
//   let filterNames = [
//     "durationForEpsilon:",
//   ]
//
//   let obfuscatedFilterNames = filterNames.map {
//     Obfuscation.obfuscate($0, key: obfuscationKey)
//   }
//
//   print("🔑 \(#fileID) \(#function) 🔑 ==== BEGIN")
//   for (name, obfuscatedName) in zip(filterNames, obfuscatedFilterNames) {
//     print("\(name): \(obfuscatedName)")
//   }
//   print("🔑 \(#fileID) \(#function) 🔑 ==== END")
// }
// #endif
