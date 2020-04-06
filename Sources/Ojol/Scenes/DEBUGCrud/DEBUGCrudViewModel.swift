#if DEBUG
//
//  DEBUGCrudViewModel.swift
//  Ojol
//
//  Created by Muis on 15/02/20.
//
import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol DEBUGCrudDomainFieldView: UIView {
    var value: Any? { get set }
    static func create() -> Self
}

extension DEBUGCrudDomainFieldView {
    static func create() -> Self { Self.init() }
}

struct DEBUGCrudDomainField {
    let field: String
    let view: DEBUGCrudDomainFieldView
}

extension DEBUGCrudDomainFieldView {
    static func new(field: String) -> DEBUGCrudDomainField {
        DEBUGCrudDomainField(field: field, view: Self.create())
    }
}

protocol DEBUGCrudDomain {
    static var primaryKey: String { get }
    static var fields: [DEBUGCrudDomainField] { get }
    func save(value: Any?, key: String)
    func get(key: String) -> Any?
    var asCellString: String { get }
}

protocol DEBUGCrudRepository: class {
    func newModel() -> DEBUGCrudDomain
    
    func crudAll() throws -> [DEBUGCrudDomain]
    func crudGet(uid: String) throws -> DEBUGCrudDomain?
    func crudCreate(model: DEBUGCrudDomain) throws -> DEBUGCrudDomain
    func crudUpdate(model: DEBUGCrudDomain) throws -> DEBUGCrudDomain
    func crudDelete(uid: String) throws
}

extension Reactive where Base == RxRepo<DEBUGCrudRepository> {
    func all() -> Observable<[DEBUGCrudDomain]> {
        self.base.ObservableBy {
            try self.base.repo.crudAll()
        }
    }
    
    func get(uid: String) -> Observable<DEBUGCrudDomain?> {
        self.base.ObservableBy {
            try self.base.repo.crudGet(uid: uid)
        }
    }
    
    func create(model: DEBUGCrudDomain) -> Observable<DEBUGCrudDomain> {
        self.base.ObservableBy {
            try self.base.repo.crudCreate(model: model)
        }
    }
    
    func update(model: DEBUGCrudDomain) -> Observable<DEBUGCrudDomain> {
        self.base.ObservableBy {
            try self.base.repo.crudUpdate(model: model)
        }
    }
    
    func delete(uid: String) -> Observable<Void> {
        self.base.ObservableBy {
            try self.base.repo.crudDelete(uid: uid)
        }
    }
}

final class DEBUGCrudViewModel: ViewModelType {
    let input: Input
    let output: Output
    
    struct Input {
        let load: AnyObserver<Void>
        let create: AnyObserver<DEBUGCrudDomain>
        let update: AnyObserver<DEBUGCrudDomain>
        let delete: AnyObserver<String>
    }
    
    struct Output {
        let back: Driver<Void>
        let items: Driver<[DEBUGCrudDomain]>
        let action: Driver<Void>
        let error: Driver<Error>
        let activity: Driver<Bool>
    }
    
    private let navigator: DEBUGCrudNavigator
    let repo: RxRepo<DEBUGCrudRepository>
    
    init(navigator: DEBUGCrudNavigator, repo: RxRepo<DEBUGCrudRepository>) {
        self.navigator = navigator
        self.repo = repo
        
        let sLoad = PublishSubject<Void>()
        let sBack = PublishSubject<Void>()
        
        let sCreate = PublishSubject<DEBUGCrudDomain>()
        let sUpdate = PublishSubject<DEBUGCrudDomain>()
        let sDelete = PublishSubject<String>()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        input = Input(
            load: sLoad.asObserver(),
            create: sCreate.asObserver(),
            update: sUpdate.asObserver(),
            delete: sDelete.asObserver()
        )
        
        let loadAll = sLoad
            .flatMapLatest({ [unowned repo] in
                repo.rx.all()
            })
        
        let afterCreate = sCreate
            .flatMapLatest({ [unowned repo] in
                repo.rx.create(model: $0)
            })
            .mapToVoid()
            .flatMapLatest({ [unowned repo] in
                repo.rx.all()
            })
        
        let afterUpdate = sUpdate
            .flatMapLatest({ [unowned repo] in
                repo.rx.update(model: $0)
            })
            .mapToVoid()
            .flatMapLatest({ [unowned repo] in
                repo.rx.all()
            })
        
        let afterDelete = sDelete
            .flatMapLatest({ [unowned repo] uid in
                repo.rx.delete(uid: uid)
            })
            .mapToVoid()
            .flatMapLatest({ [unowned repo] in
                repo.rx.all()
            })
        
        let items = Observable.merge(
            loadAll,
            afterCreate,
            afterUpdate,
            afterDelete
        )
        
        let action = Observable<Void>.merge()
        
        output = Output(
            back: sBack.asDriverOnErrorJustComplete(),
            items: items.asDriverOnErrorJustComplete(),
            action: action.asDriverOnErrorJustComplete(),
            error: errorTracker.asDriver(),
            activity: activityIndicator.asDriver()
        )
    }
}

#endif
