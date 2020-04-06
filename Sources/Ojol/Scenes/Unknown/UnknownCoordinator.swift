//  
//  UnknownCoordinator.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//

import UIKit
import RxSwift
import RxCocoa

final class UnknownCoordinator: BaseCoordinator<Void> {
    private unowned let uiNav: UINavigationController
    init(uiNav: UINavigationController) {
        self.uiNav = uiNav
        super.init()
    }
    
    override func start() -> Observable<Void> {
        let vc = UnknownController()
        vc.viewModel = UnknownViewModel(navigator: self)
        uiNav.pushViewController(vc, animated: true)

        vc.viewModel.output.back
            .drive(onNext: { [unowned self] _ in
                self.uiNav.popViewController(animated: true) })
            .disposed(by: disposeBag)
        return .empty()
    }
}

extension UnknownCoordinator: UnknownNavigator {
}
