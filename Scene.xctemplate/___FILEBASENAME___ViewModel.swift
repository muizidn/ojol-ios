//  ___FILEHEADER___
import Foundation
import RxSwift
import RxCocoa

final class ___VARIABLE_productName:identifier___ViewModel: ViewModelType {
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
  
  init(navigator: ___VARIABLE_productName:identifier___Navigator) {
    let sLoad = PublishSubject<Void>()
    let sBack = PublishSubject<Void>()
    
    let errorTracker = ErrorTracker()
    let activityIndicator = ActivityIndicator()
    
    input = Input(
      load: sLoad.asObserver(),
      back: sBack.asObserver()
    )
    
    let action = Observable<Void>.merge()
    
    output = Output(
      back: sBack.asDriverOnErrorJustComplete(),
      action: action.asDriverOnErrorJustComplete(),
      error: errorTracker.asDriver(),
      activity: activityIndicator.asDriver()
    )
  }
}