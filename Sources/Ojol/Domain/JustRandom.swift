//
//  JustRandom.swift
//  Ojol
//
//  Created by Muis on 15/02/20.
//

import Foundation
import RxSwift

struct JustRandom {
    let uid: String
}

protocol JustRandomRepository {
    func all() throws -> [JustRandom]
    func get(uid: String) throws -> JustRandom?
    func save(item: JustRandom) throws -> JustRandom
    func delete(uid: String) throws
}

extension Reactive where Base == RxRepo<JustRandomRepository> {
    func all() -> Observable<[JustRandom]> {
        self.base.ObservableBy {
            try self.base.repo.all()
        }
    }
    
    func get(uid: String) -> Observable<JustRandom?> {
        self.base.ObservableBy {
            try self.base.repo.get(uid: uid)
        }
    }
    
    func create(item: JustRandom) -> Observable<JustRandom> {
        self.base.ObservableBy {
            try self.base.repo.save(item: item)
        }
    }
    
    func update(item: JustRandom) -> Observable<JustRandom> {
        self.base.ObservableBy {
            try self.base.repo.save(item: item)
        }
    }
    
    func delete(uid: String) -> Observable<Void> {
        self.base.ObservableBy {
            try self.base.repo.delete(uid: uid)
        }
    }
    
}
