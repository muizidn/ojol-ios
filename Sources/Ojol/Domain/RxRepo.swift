//
//  RxRepo.swift
//  Ojol
//
//  Created by Muis on 15/02/20.
//

import Foundation
import RxSwift

/// Expose a Repository using Reactive interface
final class RxRepo<Repository>: ReactiveCompatible {
    let repo: Repository
    init(repo: Repository) {
        self.repo = repo
    }
}

extension RxRepo {
    func ObservableBy<O>(
        closure: @escaping () throws -> O) -> Observable<O> {
        Observable<O>
            .create { o in
                do {
                    let i = try closure()
                    o.onNext(i)
                    o.onCompleted()
                } catch {
                    o.onError(error)
                }
                return Disposables.create()
        }
    }
}
