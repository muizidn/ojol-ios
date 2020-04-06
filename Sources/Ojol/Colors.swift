// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d9f5c3"></span>
  /// Alpha: 100% <br/> (0xd9f5c3ff)
  internal static let chatBubbleOut = ColorName(rgbaValue: 0xd9f5c3ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dfdfdf"></span>
  /// Alpha: 100% <br/> (0xdfdfdfff)
  internal static let chatInputContainerBorder = ColorName(rgbaValue: 0xdfdfdfff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f0f0f0"></span>
  /// Alpha: 100% <br/> (0xf0f0f0ff)
  internal static let chatInputViewBackground = ColorName(rgbaValue: 0xf0f0f0ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f1f0ed"></span>
  /// Alpha: 100% <br/> (0xf1f0edff)
  internal static let chatInputViewBorder = ColorName(rgbaValue: 0xf1f0edff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#707070"></span>
  /// Alpha: 100% <br/> (0x707070ff)
  internal static let dugong = ColorName(rgbaValue: 0x707070ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#12b505"></span>
  /// Alpha: 100% <br/> (0x12b505ff)
  internal static let greenGamora = ColorName(rgbaValue: 0x12b505ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#7b7b7b"></span>
  /// Alpha: 100% <br/> (0x7b7b7bff)
  internal static let namaraGrey = ColorName(rgbaValue: 0x7b7b7bff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e3e8e1"></span>
  /// Alpha: 100% <br/> (0xe3e8e1ff)
  internal static let poeticLicense = ColorName(rgbaValue: 0xe3e8e1ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#979797"></span>
  /// Alpha: 100% <br/> (0x979797ff)
  internal static let spanishGrey = ColorName(rgbaValue: 0x979797ff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
