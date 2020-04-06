//
// Created by sergdort on 03/02/2017.
// Copyright (c) 2017 sergdort. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa

final class ActivityIndicator: SharedSequenceConvertibleType  {
    typealias SharingStrategy = DriverSharingStrategy
    typealias Element = Bool
    
    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
        return subject.asDriverOnErrorJustComplete()
    }
    
    private let subject = PublishSubject<Bool>()
    
    func track<O>(source: O) -> Observable<O.Element> where O: ObservableConvertibleType {
        return source.asObservable()
            .do(onNext: {[weak self] _ in self?.subject.onNext(false)}
                ,onError: {[weak self] _ in self?.subject.onNext(false)}
                ,onCompleted: {[weak self] in self?.subject.onNext(false)}
                ,onSubscribe: {[weak self] in self?.subject.onNext(true)}
                ,onDispose: {[weak self] in self?.subject.onNext(false)})
    }
    
    deinit {
        subject.onCompleted()
    }
}
