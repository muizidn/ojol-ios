//
//  AnalyticsManager.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//

import UIKit
import FirebaseCore
//import Crashlytics
import FirebaseMessaging
import RxSwift

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    func initialize() -> Observable<Void> {
        Observable.create { (o) in
            FirebaseApp.configure()
            o.onNext(())
            o.onCompleted()
            return Disposables.create()
        }
    }
    
    func messaging(application: UIApplication, notificationDelegate: UNUserNotificationCenterDelegate,delegate: MessagingDelegate) -> Observable<Void> {
        Observable.create { (o) in
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = notificationDelegate
                
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            Messaging.messaging().delegate = delegate
            o.onNext(())
            o.onCompleted()
            return Disposables.create()
        }
    }
    
    private static var fcmToken: String?
    
    /// Should be called first time in AppDelegate.MessagingDelegate, token must not be nil
    func registerFCM(fcmToken: String? = FirebaseManager.fcmToken) -> Observable<Void> {
        guard let fcmToken = fcmToken else {
            #if DEBUG
            fatalError(Error.fcmTokenNotSet.localizedDescription)
            #else
            return Observable.error(Error.fcmTokenNotSet)
            #endif
        }
        FirebaseManager.fcmToken = fcmToken
        #if DEBUG
        log.debug("FCMToken: \(fcmToken)")
        #endif
        
        return Observable<(fImei: String, fcmToken: String)>.create { (o) in
            guard (try? KeyValuePairStorage.shared.get(key: .accessToken)) != nil else {
                o.onCompleted()
                return Disposables.create()
            }
            guard let uid = UIDevice.current.identifierForVendor?.uuidString else {
                o.onError(Error.failedToGetDeviceIdentifierVendorOrImei)
                return Disposables.create()
            }
            let fImei = uid + "-" + Bundle.main.bundleIdentifier!
            o.onNext((fImei, fcmToken))
            o.onCompleted()
            return Disposables.create()
        }
        .debug("@firebase")
        .mapToVoid()
    }
    
    enum Error: LocalizedError {
        case failedToGetDeviceIdentifierVendorOrImei
        case fcmTokenNotSet
        var errorDescription: String? {
            switch self {
            case .failedToGetDeviceIdentifierVendorOrImei:
                return "Failed to construct IMEI"
            case .fcmTokenNotSet:
                return "FCM token not set"
            }
        }
    }
}
