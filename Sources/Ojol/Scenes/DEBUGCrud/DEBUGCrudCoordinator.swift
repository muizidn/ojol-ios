#if DEBUG
//
//  DEBUGCrudCoordinator.swift
//  Ojol
//
//  Created by Muis on 15/02/20.
//

import UIKit
import RxSwift
import RxCocoa

final class DEBUGCrudCoordinator: BaseCoordinator<Void> {
    private unowned let uiNav: UINavigationController
    private let repo: DEBUGCrudRepository
    init(uiNav: UINavigationController, repo: DEBUGCrudRepository) {
        self.uiNav = uiNav
        self.repo = repo
        super.init()
    }
    
    override func start() -> Observable<Void> {
        let vc = DEBUGCrudController()
        uiNav.isNavigationBarHidden = false
        vc.viewModel = DEBUGCrudViewModel(
            navigator: self,
            repo: RxRepo(repo: repo)
        )
        uiNav.pushViewController(vc, animated: true)

        vc.viewModel.output.back
            .drive(onNext: { [unowned self] _ in
                self.uiNav.popViewController(animated: true) })
            .disposed(by: disposeBag)
        return .empty()
    }
}

extension DEBUGCrudCoordinator {
    override var description: String {
        "DBGCRUD<\(type(of:repo))>"
    }
}

extension DEBUGCrudCoordinator: DEBUGCrudNavigator {
}
#endif
