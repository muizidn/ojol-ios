//  ___FILEHEADER___

import UIKit
import RxSwift
import RxCocoa

final class ___VARIABLE_productName:identifier___Coordinator: BaseCoordinator<Void> {
    private unowned let uiNav: UINavigationController
    init(uiNav: UINavigationController) {
        self.uiNav = uiNav
        super.init()
    }
    
    override func start() -> Observable<Void> {
        let vc = ___VARIABLE_productName:identifier___Controller()
        vc.viewModel = ___VARIABLE_productName:identifier___ViewModel(navigator: self)
        uiNav.pushViewController(vc, animated: true)

        vc.viewModel.output.back
            .drive(onNext: { [unowned self] _ in
                self.uiNav.popViewController(animated: true) })
            .disposed(by: disposeBag)
        return .empty()
    }
}

extension ___VARIABLE_productName:identifier___Coordinator: ___VARIABLE_productName:identifier___Navigator {
}