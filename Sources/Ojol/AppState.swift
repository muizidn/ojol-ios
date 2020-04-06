import Foundation

// UserDefault is threadsafe
// https://developer.apple.com/documentation/foundation/userdefaults

struct State<T>: Equatable where T: Codable & Equatable {
    fileprivate let id: String
    fileprivate let `default`: T
}

extension State {
    static var isFirstTime: State<Bool> {
        return .init(id: "isFirstTime", default: true) }
}

enum AppState {

    static func get<T>(_ state: State<T>) -> T {
        let value = UserDefaults.standard.value(forKey: state.id) as? T
        return value ?? state.default
    }
    
    static func set<T>(_ state: State<T>, newValue: T) {
        UserDefaults.standard.set(newValue, forKey: state.id)
    }
}

extension AppState {
    static func reset() {
        set(.isFirstTime, newValue: true)
        try? KeyValuePairStorage.shared.remove(key: .accessToken)
        try? KeyValuePairStorage.shared.remove(key: .refreshToken)
        try? KeyValuePairStorage.shared.remove(key: .userId)
        try? KeyValuePairStorage.shared.remove(key: .fcmToken)
        try? KeyValuePairStorage.shared.remove(key: .profileName)
        try? KeyValuePairStorage.shared.remove(key: .profileAbout)
        try? KeyValuePairStorage.shared.remove(key: .profileAvatar)
    }
    
    static func logout() throws {
        
    }
}

