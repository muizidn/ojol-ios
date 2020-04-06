import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    init(window: UIWindow) {
        self.window = window
        self.window.backgroundColor = .white
        self.window.makeKeyAndVisible()
        super.init()
    }
    override func start() -> Observable<Void> {
        let navigationController = UINavigationController()
        defer {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        #if DEBUG
        return launchDEBUGShortcuts(uiNav: navigationController)
        #else
        if AppState.isFirstTime() {
            AppState.reset()
            AppState.set(.isFirstTime, newValue: false)
            let coordinator = OnboardingCoordinator(uiNav: navigationController)
            return coordinate(to: coordinator)
        } else {
            let dashboard = DashboardTabBarCoordinator(uiNav: navigationController)
            return coordinate(to: dashboard)
        }
        #endif
    }
}

extension AppState {
    static func isFirstTime() -> Bool {
        return (get(.isFirstTime)) ||
            ((try? KeyValuePairStorage.shared.get(key: .accessToken)) == nil)
    }
}


#if DEBUG
fileprivate extension AppCoordinator {
    func launchDEBUGShortcuts(uiNav: UINavigationController) -> Observable<Void> {
        coordinate(to: DEBUGShortcutsCoordinator(uiNav: uiNav) )
    }
}
#endif
