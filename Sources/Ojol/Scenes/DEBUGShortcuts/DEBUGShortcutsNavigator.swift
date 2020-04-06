#if DEBUG
//
//  DEBUGShortcutsNavigator.swift
//  Ojol
//
//  Created by Muis on 14/02/20.
//

import Foundation
import RxSwift

protocol DEBUGShortcutsNavigator: class, Navigator {
    func launchSceneAtIndex(index: IndexPath) -> Observable<Void>
}
#endif
