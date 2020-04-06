//  
//  HomeCoordinator.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeCoordinator: BaseCoordinator<Void> {
    private unowned let uiNav: UINavigationController
    init(uiNav: UINavigationController) {
        self.uiNav = uiNav
        super.init()
    }
    
    override func start() -> Observable<Void> {
//        let vc = AppToolbarController(rootViewController: StarViewController())
        let vc = HomeController()
        vc.viewModel = HomeViewModel(navigator: self)
        uiNav.isNavigationBarHidden = true
        uiNav.pushViewController(vc, animated: true)

        vc.viewModel.output.back
            .drive(onNext: { [unowned self] _ in
                self.uiNav.popViewController(animated: true) })
            .disposed(by: disposeBag)
        return .empty()
    }
}

extension HomeCoordinator: HomeNavigator {
    func launchNext() -> Observable<Void> {
        let coordinator = UnknownCoordinator(uiNav: uiNav)
        return coordinate(to: coordinator)
    }
}
