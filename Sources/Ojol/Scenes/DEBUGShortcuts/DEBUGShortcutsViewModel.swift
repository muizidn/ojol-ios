#if DEBUG
//
//  DEBUGShortcutsViewModel.swift
//  Ojol
//
//  Created by Muis on 14/02/20.
//
import Foundation
import RxSwift
import RxCocoa

final class DEBUGShortcutsViewModel: ViewModelType {
    let input: Input
    let output: Output
    
    struct Input {
        let load: AnyObserver<Void>
        let launchSceneAtIndex: AnyObserver<IndexPath>
    }
    
    struct Output {
        let back: Driver<Void>
        let scenes: Driver<[String]>
        let action: Driver<Void>
        let error: Driver<Error>
        let activity: Driver<Bool>
    }
    
    private let navigator: DEBUGShortcutsNavigator
    
    init(navigator: DEBUGShortcutsNavigator, scenes: [String]) {
        self.navigator = navigator
        
        let sLoad = PublishSubject<Void>()
        let sBack = PublishSubject<Void>()
        let sLaunchSceneIndexPath = PublishSubject<IndexPath>()
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        input = Input(
            load: sLoad.asObserver(),
            launchSceneAtIndex: sLaunchSceneIndexPath.asObserver()
        )
        
        let sScenes = Observable.just(scenes)
        
        let actionLaunchScene = sLaunchSceneIndexPath
            .flatMapLatest({ [unowned navigator] in navigator.launchSceneAtIndex(index: $0) })
        
        let action = Observable<Void>.merge(
            actionLaunchScene
        )
        
        output = Output(
            back: sBack.asDriverOnErrorJustComplete(),
            scenes: sScenes.asDriverOnErrorJustComplete(),
            action: action.asDriverOnErrorJustComplete(),
            error: errorTracker.asDriver(),
            activity: activityIndicator.asDriver()
        )
    }
}
#endif
