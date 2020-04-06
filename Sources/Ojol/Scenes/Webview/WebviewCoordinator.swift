//  
//  WebviewCoordinator.swift
//  Ojol
//
//  Created by Muis on 12/03/20.
//

import UIKit
import RxSwift
import RxCocoa

final class WebviewCoordinator: BaseCoordinator<Void> {
    private unowned let uiNav: UINavigationController
    private let url: String
    init(uiNav: UINavigationController, url: String) {
        self.uiNav = uiNav
        self.url = url
        super.init()
    }
    
    override func start() -> Observable<Void> {
        let vc = WebviewController()
        vc.viewModel = WebviewViewModel(navigator: self, url: url)
        uiNav.pushViewController(vc, animated: true)

        vc.viewModel.output.back
            .drive(onNext: { [unowned self] _ in
                self.uiNav.popViewController(animated: true) })
            .disposed(by: disposeBag)
        return .empty()
    }
}

extension WebviewCoordinator: WebviewNavigator {
}
