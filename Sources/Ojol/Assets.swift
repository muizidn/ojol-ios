// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let add = ImageAsset(name: "add")
    internal static let close = ImageAsset(name: "close")
    internal static let icAddresBook = ImageAsset(name: "icAddresBook")
    internal static let icAlignmentCenter = ImageAsset(name: "icAlignmentCenter")
    internal static let icApprove = ImageAsset(name: "icApprove")
    internal static let icArrowDiagonalLeftDown = ImageAsset(name: "icArrowDiagonalLeftDown")
    internal static let icArrowDiagonalRightUp = ImageAsset(name: "icArrowDiagonalRightUp")
    internal static let icBelumDibaca = ImageAsset(name: "icBelumDibaca")
    internal static let icCall = ImageAsset(name: "icCall")
    internal static let icCamera = ImageAsset(name: "icCamera")
    internal static let icCreditCard = ImageAsset(name: "icCreditCard")
    internal static let icCsWoman = ImageAsset(name: "icCsWoman")
    internal static let icDefaultProfile = ImageAsset(name: "icDefaultProfile")
    internal static let icEdit = ImageAsset(name: "icEdit")
    internal static let icEdit1 = ImageAsset(name: "icEdit1")
    internal static let icFocus = ImageAsset(name: "icFocus")
    internal static let icJustify = ImageAsset(name: "icJustify")
    internal static let icLike = ImageAsset(name: "icLike")
    internal static let icLikeNo = ImageAsset(name: "icLikeNo")
    internal static let icMessenger = ImageAsset(name: "icMessenger")
    internal static let icMessengerNo = ImageAsset(name: "icMessengerNo")
    internal static let icMore = ImageAsset(name: "icMore")
    internal static let icNewspaper = ImageAsset(name: "icNewspaper")
    internal static let icPrivate = ImageAsset(name: "icPrivate")
    internal static let icSearchZoom = ImageAsset(name: "icSearchZoom")
    internal static let icSetting = ImageAsset(name: "icSetting")
    internal static let icSms = ImageAsset(name: "icSms")
    internal static let icSudahDibaca = ImageAsset(name: "icSudahDibaca")
    internal static let icTimeline = ImageAsset(name: "icTimeline")
    internal static let icUserBlack = ImageAsset(name: "icUserBlack")
    internal static let icUserWhite = ImageAsset(name: "icUserWhite")
    internal static let icVideoCall = ImageAsset(name: "icVideoCall")
    internal static let ilustrasiCall = ImageAsset(name: "ilustrasiCall")
    internal static let ilustrasiGroupChat = ImageAsset(name: "ilustrasiGroupChat")
    internal static let ilustrasiOnboar01 = ImageAsset(name: "ilustrasiOnboar01")
    internal static let ilustrasiOnboar02 = ImageAsset(name: "ilustrasiOnboar02")
    internal static let ilustrasiOnboar03 = ImageAsset(name: "ilustrasiOnboar03")
    internal static let ilustrasiOnboar04 = ImageAsset(name: "ilustrasiOnboar04")
    internal static let ilustrasiPersonalChat = ImageAsset(name: "ilustrasiPersonalChat")
    internal static let ilustrasiTimeline = ImageAsset(name: "ilustrasiTimeline")
    internal static let inbox = ImageAsset(name: "inbox")
    internal static let logo = ImageAsset(name: "logo")
    internal static let welcomeLogo = ImageAsset(name: "welcome-logo")
  }
  internal enum Figma {
    internal static let chatIsPhoto = ImageAsset(name: "chat-is-photo")
    internal static let chatIsVideo = ImageAsset(name: "chat-is-video")
    internal static let chatSent = ImageAsset(name: "chat-sent")
    internal static let chatStatusRead = ImageAsset(name: "chat-status-read")
    internal static let defaultProfile = ImageAsset(name: "default-profile")
    internal static let icBack = ImageAsset(name: "icBack")
    internal static let launchscreen = ImageAsset(name: "launchscreen")
    internal static let more = ImageAsset(name: "more")
    internal static let newChat = ImageAsset(name: "new-chat")
    internal static let search = ImageAsset(name: "search")
    internal static let tabCall = ImageAsset(name: "tab-call")
    internal static let tabChat = ImageAsset(name: "tab-chat")
    internal static let tabConference = ImageAsset(name: "tab-conference")
    internal static let tabLogo = ImageAsset(name: "tab-logo")
    internal static let tabMore = ImageAsset(name: "tab-more")
    internal static let tabStatus = ImageAsset(name: "tab-status")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
