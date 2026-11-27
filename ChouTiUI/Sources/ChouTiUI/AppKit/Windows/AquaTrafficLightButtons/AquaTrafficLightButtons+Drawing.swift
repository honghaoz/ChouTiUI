//
//  AquaTrafficLightButtons+Drawing.swift
//  ChouTiUI
//
//  Created by Honghao Zhang on 11/3/21.
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

import ChouTi
import ComposeUI

/// The kind of an Aqua traffic light button.
enum AquaTrafficLightButtonKind: CaseIterable {

  /// The close button (red).
  case close

  /// The miniaturize button (yellow).
  case miniaturize

  /// The zoom button (green).
  case zoom

  /// Returns the fill color of the button when it's active.
  ///
  /// - Parameter isGraphite: Whether the system uses the graphite accent color, which turns the buttons gray.
  /// - Returns: The active fill color.
  func primaryColor(isGraphite: Bool) -> ThemedColor {
    if isGraphite {
      return Constants.graphiteColor
    }
    switch self {
    case .close:
      return Constants.closeColor
    case .miniaturize:
      return Constants.miniaturizeColor
    case .zoom:
      return Constants.zoomColor
    }
  }

  private enum Constants {

    /// iTunes 11.4 -> #fc564c, Big Sur -> #fe5f57
    static let closeColor = ThemedColor(Color.hex("#fe5f57"))

    /// iTunes 11.4 -> #f8c35f, Big Sur -> #febc2e
    static let miniaturizeColor = ThemedColor(Color.hex("#febc2e"))

    /// iTunes 11.4 -> #99d372, Big Sur -> #28c840
    static let zoomColor = ThemedColor(Color.hex("#28c840"))

    /// The graphite accent color turns the system buttons gray.
    static let graphiteColor = ThemedColor(Color.hex("#8E8E8E"))
  }
}

/// A view that draws an Aqua traffic light button over a system traffic light button.
///
/// The view passes clicks through to the system button below it.
final class AquaTrafficLightButtonView: ComposeView {

  /// The kind of the button.
  let kind: AquaTrafficLightButtonKind

  /// The appearance state of the button.
  var state: AquaTrafficLightButtonState = .normal(nil) {
    didSet {
      if state != oldValue {
        setNeedsRefresh(animated: false)
      }
    }
  }

  /// Creates a button view.
  ///
  /// - Parameter kind: The kind of the button.
  init(kind: AquaTrafficLightButtonKind) {
    self.kind = kind
    super.init(frame: .zero)

    // the system buttons switch states at once
    animationBehavior = .disabled

    // the content changes its layers beyond what ComposeUI resets for reuse (e.g. the shape masks), so the layers
    // don't go to the shared pool
    renderablePool = nil
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable") // swiftlint:disable:this fatal_error
  }

  override var content: ComposeContent {
    let size = bounds.size
    guard size.width > Constants.buttonInset * 2, size.height > Constants.buttonInset * 2 else {
      return Empty()
    }
    return Self.makeButton(
      primaryColor: kind.primaryColor(isGraphite: Self.isGraphiteAccentColor()),
      state: state,
      size: size,
      theme: effectiveAppearance.theme, // `theme` is ambiguous between ComposeUI and ChouTiUI
      pixelSize: pixelSize,
      isTahoe: System.macOS_tahoe
    )
    // the circle is at the top left of the frame: the system button images leave their extra space at the trailing and
    // bottom edges
    .frame(size, alignment: .topLeft)
  }

  override func setFrameSize(_ newSize: NSSize) {
    let oldSize = frame.size
    super.setFrameSize(newSize)

    // the content is made for the view's size, and a resize only lays out the content that is already made
    if newSize != oldSize {
      setNeedsRefresh(animated: false)
    }
  }

  override func viewDidChangeEffectiveAppearance() {
    super.viewDidChangeEffectiveAppearance()

    // an accent color change (e.g. to graphite) changes the effective appearance without changing the theme, which is
    // what ComposeView refreshes for
    setNeedsRefresh(animated: false)
  }

  override func hitTest(_ point: NSPoint) -> NSView? {
    nil // clicks go to the system button below
  }

  override var acceptsFirstResponder: Bool { false }

  // the system buttons below are the accessible controls, the drawing isn't
  override func isAccessibilityElement() -> Bool {
    false
  }

  override func accessibilityChildren() -> [Any]? {
    []
  }

  /// The size of a device pixel on the window's screen, for the hairlines.
  var pixelSize: CGFloat {
    #if DEBUG
    if let backingScaleFactorOverride {
      return 1 / backingScaleFactorOverride
    }
    #endif
    return 1 / (window?.backingScaleFactor ?? Screen.mainScreenScale)
  }

  #if DEBUG
  /// The screen scale to draw for instead of the window's, for tests.
  var backingScaleFactorOverride: CGFloat?
  #endif

  // MARK: - Graphite

  /// Returns whether the system uses the graphite accent color, which turns the system traffic light buttons gray.
  ///
  /// - Returns: `true` if the accent color is graphite.
  static func isGraphiteAccentColor() -> Bool {
    #if DEBUG
    if let isGraphiteAccentColorOverride {
      return isGraphiteAccentColorOverride
    }
    #endif
    return NSColor.currentControlTint == .graphiteControlTint
  }

  #if DEBUG
  /// The accent color to use instead of the system's, for tests: AppKit reads the control tint once per process.
  static var isGraphiteAccentColorOverride: Bool?
  #endif

  // MARK: - Drawing

  /// Makes the node of a button.
  ///
  /// The button is a gradient filled circle with a glow at the bottom, a white reflection below it, inner shadows, a
  /// specular highlight at the top, an optional glyph, and a hairline border in dark mode.
  ///
  /// - Parameters:
  ///   - primaryColor: The fill color of the button when it's active.
  ///   - state: The appearance state of the button.
  ///   - size: The size of the system button. The button circle is inset by 1pt to match the system button's size.
  ///   - theme: The theme to draw for.
  ///   - pixelSize: The size of a device pixel on the screen, for the hairlines.
  ///   - isTahoe: Whether to use the macOS 26 (Tahoe) glyph geometry.
  /// - Returns: The button node.
  static func makeButton(primaryColor: ThemedColor,
                         state: AquaTrafficLightButtonState,
                         size: CGSize,
                         theme: Theme,
                         pixelSize: CGFloat,
                         isTahoe: Bool) -> some ComposeNode
  {
    // screenshots: https://forums.macrumors.com/threads/snow-leopard-theme-for-el-capitan-ongoing-project.1956681/page-2
    let isInactive = state.isInactive
    let isDark = theme.isDark

    let buttonColor: Color = {
      let primaryColor = primaryColor.resolve(for: theme)
      switch state {
      case .normal,
           .hovered:
        return primaryColor
      case .pressed:
        return primaryColor.darker(by: Constants.pressedDarkening) ?? primaryColor
      case .inactive:
        return Constants.inactiveColor.resolve(for: theme)
      }
    }()

    // the fill is lighter at the top and bottom edges
    let edgeColor = buttonColor.blending(with: isDark ? 0.1 : 0.5, of: .whiteRGB) ?? buttonColor
    let fillGradient = LinearGradientColor([edgeColor, buttonColor, edgeColor])

    // the system buttons can be taller than wide (e.g. 14 x 16 on macOS 26), the circle is in the centered square
    let buttonSize = CGSize(width: size.width - Constants.buttonInset * 2, height: size.height - Constants.buttonInset * 2)

    // the circle and its bottom glow, clipped to the circle. the clip is on a nested view so that the outer shadows
    // below aren't clipped
    return ComposeViewNode {
      UnifiedColorNode(fillGradient)
        .shape(Circle())
        .frame(buttonSize)
        .overlay(alignment: .bottom) {
          // bottom glow
          DropShadowNode(
            color: .white,
            opacity: isDark ? (isInactive ? 0.25 : 0.35) : 0.45,
            radius: 1.5,
            offset: .zero,
            path: circlePath(in:)
          )
          .frame(Constants.bottomGlowSize)
        }
    }
    .shape(Circle())
    // bottom reflection
    .dropShadow(
      color: .white,
      opacity: isDark ? 0.2 : (isInactive ? 0.3 : 0.5),
      radius: isDark ? 0.5 : 0.25,
      offset: CGSize(width: 0, height: 1),
      path: circlePath(in:)
    )
    .innerShadow(color: .black, opacity: isInactive ? 0.1 : 0.2, radius: 1, offset: .zero, paths: circleInnerShadowPaths(spread: 0.5))
    .innerShadow(color: .black, opacity: isInactive ? 0.3 : 0.35, radius: 0.5, offset: CGSize(width: 0, height: 0.5), paths: circleInnerShadowPaths(spread: 0.5))
    .innerShadow(color: .black, opacity: isInactive ? 0.3 : 0.45, radius: 0, offset: .zero, paths: circleInnerShadowPaths(spread: 0.25))
    .overlay {
      // top highlight
      UnifiedColorNode(
        LinearGradientColor(
          colors: [
            .white.opacity(isDark ? (isInactive ? 0.15 : 0.6) : (isInactive ? 0.8 : 0.7)),
            .white.opacity(0),
          ],
          locations: [0, 0.75]
        )
      )
      .shape(Ellipse())
      .frame(width: size.width / 2, height: size.height / 5)
      .offset(x: 0, y: -size.height / 4 + 1)

      // glyph
      if let glyph = state.glyph {
        LayerNode<CAShapeLayer>(update: { layer, _ in
          layer.fillColor = Color.black.opacity(0.2).cgColor
          layer.path = glyph.path(in: layer.bounds, isTahoe: isTahoe)
        })
        // inner radius shadow
        .innerShadow(color: .black, opacity: 0.6, radius: pixelSize, offset: CGSize(width: 0, height: pixelSize)) {
          glyph.path(in: CGRect(origin: .zero, size: $0), isTahoe: isTahoe)
        }
        // inner top dark shadow
        .innerShadow(color: .black, opacity: 0.3, radius: 0, offset: CGSize(width: 0, height: pixelSize)) {
          glyph.path(in: CGRect(origin: .zero, size: $0), isTahoe: isTahoe)
        }
      }

      // dark mode hairline border
      if isDark {
        LayerNode<CAShapeLayer>(update: { layer, _ in
          // the path strokes on both sides of the circle, the mask clips the outer half
          layer.fillColor = nil
          layer.strokeColor = Color.black(alpha: isInactive ? 0.4 : 0.3).cgColor
          layer.lineWidth = pixelSize * 2
          layer.path = circlePath(in: layer.bounds.size)
        })
        .shape(Circle())
        .padding(-pixelSize)
      }
    }
  }

  /// Makes a circle path in the centered square of a size.
  ///
  /// - Parameter size: The size to draw in.
  /// - Returns: The circle path.
  private static func circlePath(in size: CGSize) -> CGPath {
    CGPath(ellipseIn: CGRect(origin: .zero, size: size).squareRect(), transform: nil)
  }

  /// Makes the paths of an inner shadow in a circle, with the shadow spreading inward.
  ///
  /// - Parameter spread: The distance the shadow spreads inward from the circle.
  /// - Returns: The paths provider for the shadow's size.
  private static func circleInnerShadowPaths(spread: CGFloat) -> (CGSize) -> InnerShadowPaths {
    { size in
      let circle = CGRect(origin: .zero, size: size).squareRect()
      return InnerShadowPaths(
        shadowPath: CGPath(ellipseIn: circle.insetBy(dx: spread, dy: spread), transform: nil),
        clipPath: CGPath(ellipseIn: circle, transform: nil)
      )
    }
  }

  // MARK: - Constants

  private enum Constants {

    /// The inset of the button circle from the system button's frame.
    static let buttonInset: CGFloat = 1

    /// The size of the glow at the bottom of the button.
    static let bottomGlowSize: CGFloat = 5

    /// How much darker the pressed button is than the active button.
    static let pressedDarkening: CGFloat = 0.25

    /// iTunes 11.4 -> #ebeceb, Big Sur -> #d3d4d3
    static let inactiveColor = ThemedColor(light: Color.hex("#E6E6E6"), dark: Color.hex("#3D3D3D"))
  }
}

private extension ComposeNode {

  /// Clips the node's renderables to a shape, with a mask layer that follows the renderables' bounds.
  ///
  /// The renderables can be reused by other views after they're removed, so the shape is removed with them.
  ///
  /// - Parameter shape: The shape to clip to.
  /// - Returns: A new node with the shape.
  func shape(_ shape: some Shape) -> some ComposeNode {
    onUpdate { renderable, _ in
      renderable.layer.shape = shape
    }
    .willRemove { renderable, _ in
      renderable.layer.shape = nil
    }
  }
}

#endif
