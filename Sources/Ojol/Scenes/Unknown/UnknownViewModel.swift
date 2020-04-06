//  
//  UnknownViewModel.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//
import Foundation
import RxSwift
import RxCocoa

final class UnknownViewModel: ViewModelType {
  let input: Input
  let output: Output
  
  struct Input {
    let load: AnyObserver<Void>
    let back: AnyObserver<Void>
  }
  
  struct Output {
    let back: Driver<Void>
    let action: Driver<Void>
    let error: Driver<Error>
    let activity: Driver<Bool>
  }
  
  init(navigator: UnknownNavigator) {
    let sLoad = PublishSubject<Void>()
    let sBack = PublishSubject<Void>()
    
    let errorTracker = ErrorTracker()
    let activityIndicator = ActivityIndicator()
    
    input = Input(
      load: sLoad.asObserver(),
      back: sBack.asObserver()
    )
    
    let action = Observable<Void>.merge(
    )
    
    output = Output(
      back: sBack.asDriverOnErrorJustComplete(),
      action: action.asDriverOnErrorJustComplete(),
      error: errorTracker.asDriver(),
      activity: activityIndicator.asDriver()
    )
  }
}
