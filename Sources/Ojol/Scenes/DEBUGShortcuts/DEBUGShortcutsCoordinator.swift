#if DEBUG
//
//  DEBUGShortcutsCoordinator.swift
//  Ojol
//
//  Created by Muis on 14/02/20.
//

import UIKit
import RxSwift
import RxCocoa

final class DEBUGShortcutsCoordinator: BaseCoordinator<Void> {
    private unowned let uiNav: UINavigationController
    init(uiNav: UINavigationController) {
        self.uiNav = uiNav
        super.init()
    }
    
    override func start() -> Observable<Void> {
        let vc = DEBUGShortcutsController()
        vc.viewModel = DEBUGShortcutsViewModel(
            navigator: self,
            scenes: scenes.enumerated()
                .map({
                    let name = ($0.element as? CustomStringConvertible)?.description ??
                    "\($0.element)"
                    return "\($0.offset) - \(name)"
                }))
        
        uiNav.pushViewController(vc, animated: true)
        
        vc.viewModel.output.back
            .drive(onNext: { [unowned self] _ in
                self.uiNav.popViewController(animated: true) })
            .disposed(by: disposeBag)
        return .empty()
    }
    
    private lazy var scenes = createScenes(uiNav: uiNav)
}

extension DEBUGShortcutsCoordinator: DEBUGShortcutsNavigator {
    func launchSceneAtIndex(index: IndexPath) -> Observable<Void> {
        uiNav.isNavigationBarHidden = true
        return coordinate(to: scenes[index.row])
    }
}

extension DEBUGShortcutsCoordinator {
    func createScenes(uiNav: UINavigationController) -> [BaseCoordinator<Void>] {
        [
            DEBUGCrudCoordinator(uiNav: uiNav, repo: CDJustRandomRepository()),
        ]
    }
}
#endif
