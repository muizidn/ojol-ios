//  
//  HomeViewModel.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//
import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    let input: Input
    let output: Output
    
    struct Input {
        let back: AnyObserver<Void>
        let load: AnyObserver<Void>
        let launchNext: AnyObserver<Void>
    }
    
    struct Output {
        let back: Driver<Void>
        let action: Driver<Void>
        let error: Driver<Error>
        let activity: Driver<Bool>
    }
    
    private let navigator: HomeNavigator
    
    init(navigator: HomeNavigator) {
        self.navigator = navigator
        let sLoad = PublishSubject<Void>()
        let sBack = PublishSubject<Void>()
        let sLaunchNext = PublishSubject<Void>()
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        input = Input(
            back: sBack.asObserver(),
            load: sLoad.asObserver(),
            launchNext: sLaunchNext.asObserver()
        )
        
        let actionLaunchNext = sLaunchNext
            .flatMapLatest({ [unowned navigator] in navigator.launchNext() })
        
        let action = Observable<Void>.merge(
            actionLaunchNext
        )
        
        output = Output(
            back: sBack.asDriverOnErrorJustComplete(),
            action: action.asDriverOnErrorJustComplete(),
            error: errorTracker.asDriver(),
            activity: activityIndicator.asDriver()
        )
    }
}
