import UIKit
import RxSwift
import FirebaseMessaging
import IQKeyboardManager

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let disposeBag = DisposeBag()
    private var appCoordinator: AppCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if CommandLine.arguments.contains(Testing.__uitesting) {
            AppState.reset()
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = ColorName.greenGamora.color
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        self.window = window
        
        IQKeyboardManager.shared().isEnabled = true
        
        FirebaseManager.shared.initialize()
            .subscribe()
            .disposed(by: disposeBag)
        
        AnalyticsManager.shared.initialize()
            .subscribe()
            .disposed(by: disposeBag)
        
        FirebaseManager.shared.messaging(
            application: application,
            notificationDelegate: self,
            delegate: self)
            .subscribe()
            .disposed(by: disposeBag)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        FirebaseManager.shared.registerFCM(fcmToken: fcmToken)
            .subscribe(onError: { err in
                #if DEBUG
                fatalError(err.localizedDescription)
                #else
                log.error(err)
                #endif
            })
            .disposed(by: disposeBag)
    }
}
