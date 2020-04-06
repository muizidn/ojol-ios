//  
//  WebviewViewModel.swift
//  Ojol
//
//  Created by Muis on 12/03/20.
//
import Foundation
import RxSwift
import RxCocoa

final class WebviewViewModel: ViewModelType {
    let input: Input
    let output: Output
    
    struct Input {
        let load: AnyObserver<Void>
        let back: AnyObserver<Void>
    }
    
    struct Output {
        let back: Driver<Void>
        let url: Driver<URL>
        let action: Driver<Void>
        let error: Driver<Error>
        let activity: Driver<Bool>
    }
    
    private let navigator: WebviewNavigator
    
    init(navigator: WebviewNavigator, url: String) {
        self.navigator = navigator
        
        let sLoad = PublishSubject<Void>()
        let sBack = PublishSubject<Void>()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        input = Input(
            load: sLoad.asObserver(),
            back: sBack.asObserver()
        )
        
        let url = sLoad
            .compactMap({ URL(string: url) })
        
        let action = Observable<Void>.merge()
        
        output = Output(
            back: sBack.asDriverOnErrorJustComplete(),
            url: url.asDriverOnErrorJustComplete(),
            action: action.asDriverOnErrorJustComplete(),
            error: errorTracker.asDriver(),
            activity: activityIndicator.asDriver()
        )
    }
}
