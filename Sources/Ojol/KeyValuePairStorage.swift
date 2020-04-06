import Foundation
import KeychainAccess

final class KeyValuePairStorage {
    static let keychainStorage = Keychain(
        accessGroup: Bundle.main.object(forInfoDictionaryKey: "KEYCHAIN_GROUP") as! String
    )
    static let shared = KeyValuePairStorage()
    func set(key: StaticKey, value: DataCodable) throws {
        let data = value.toData()
        try key.storage.set(key: key.description, value: data)
    }
    
    func get(key: StaticKey) throws -> Data? {
        return try? key.storage.get(key: key.description)
    }
    
    func remove(key: StaticKey) throws {
        try key.storage.remove(key: key.description)
    }
}

// Over Enginnered 🤣
enum StaticKey: CustomStringConvertible {
    case keychain(String)
    /// Using UserDefaults.standard
    case userDefault(String)
    /// Custom
    case customWithStorage(String, Storage)
    
    var description: String {
        switch self {
        case .userDefault(let value):
            return value
        case .customWithStorage(let value, _):
            return value
        case .keychain(let value):
            return value
        }
    }
    
    var storage: Storage {
        switch self {
        case .userDefault:
            return UserDefaults.standard
        case .customWithStorage(_, let storage):
            return storage
        case .keychain:
            return KeyValuePairStorage.keychainStorage
        }
    }
}

extension StaticKey {
    static let accessToken: StaticKey = .keychain("hiapp.ios.hiapp.accessToken")
    static let refreshToken: StaticKey = .keychain("hiapp.ios.hiapp.refreshToken")
    static let userId: StaticKey = .keychain("hiapp.ios.hiapp.userId")
    
    static let fcmToken: StaticKey = .keychain("hiapp.ios.firebase.fcm")
    
    static let profileName: StaticKey = .userDefault("hiapp.ios.user.profile.name")
    static let profileAbout: StaticKey = .userDefault("hiapp.ios.user.profile.about")
    static let profileAvatar: StaticKey = .userDefault("hiapp.ios.user.profile.avatar")
    
    static let personalChatHistoryLatestSync: StaticKey = .userDefault("hiapp.ios.chat.sync.personal.latest-date")
    
    static func chatRoomBg(id: String) -> StaticKey { .userDefault("hiapp.ios.chatroom.bg.\(id)")
    }
    
    static func uploadPercent(url: String) -> StaticKey {
        .userDefault("hiapp.ios.upload.\(url)")
    }
}

protocol Storage {
    func set(key: String, value: DataCodable) throws
    func get(key: String) throws -> Data?
    func remove(key: String) throws
}

extension Keychain: Storage {
    func set(key: String, value: DataCodable) throws {
        try set(value.toData(), key: key)
    }
    
    func get(key: String) throws -> Data? {
        return try? getData(key)
    }
    
    func remove(key: String) throws {
        try remove(key)
    }
}

extension UserDefaults: Storage {
    func set(key: String, value: DataCodable) throws {
        set(value.toData(), forKey: key)
    }
    
    func get(key: String) throws -> Data? {
        return value(forKey: key) as? Data
    }
    
    func remove(key: String) throws {
        removeObject(forKey: key)
    }
}

protocol DataCodable {
    func toData() -> Data
    init(data: Data)
}

extension Data: DataCodable {
    func toData() -> Data {
        return self
    }
    init(data: Data) {
        self = data
    }
}

extension String: DataCodable {
    func toData() -> Data {
        guard let data = self.data(using: .utf8) else {
            fatalError("Cannot encode using UTF8: \(self)")
        }
        return data
    }
    
    init(data: Data) {
        self = String.init(data: data, encoding: .utf8)!
    }
}

extension KeyValuePairStorage {
    func getString(key: StaticKey, default: String = "") throws -> String {
        if let data = try get(key: key) {
            return String.init(data: data)
        }
        return `default`
    }
}

protocol _NumericPrimitiveDataCodable: DataCodable {
    associatedtype Primitive
}

extension _NumericPrimitiveDataCodable where Self.Primitive == Self {
    func toData() -> Data {
        var value = self
        return Data.init(bytes: &value, count: MemoryLayout<Primitive>.size)
    }
    
    init(data: Data) {
        self = data.withUnsafeBytes { (bfr) -> Primitive in
            return bfr.bindMemory(to: Primitive.self).first!
        }
    }
}

extension Int: _NumericPrimitiveDataCodable {
    typealias Primitive = Int
}

extension Double: _NumericPrimitiveDataCodable {
    typealias Primitive = Double
}

extension Bool: _NumericPrimitiveDataCodable {
    typealias Primitive = Bool
}

extension KeyValuePairStorage {
    var isLoggedIn: Bool {
        return (try? KeyValuePairStorage.shared.get(key: .accessToken)) != nil
    }
    
    var accessTokenOrNil: String? {
        try? KeyValuePairStorage.shared.getString(key: .accessToken)
    }
    
    var refreshTokenOrNil: String? {
        try? KeyValuePairStorage.shared.getString(key: .refreshToken)
    }
    
    var currentUserIdOrNil: String? {
        try? KeyValuePairStorage.shared.getString(key: .userId)
    }
}
