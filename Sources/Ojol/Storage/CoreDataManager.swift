//
//  CoreDataManager.swift
//  Ojol
//
//  Created by Muis on 15/02/20.
//

import Foundation
import CoreData
import RxSwift

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Ojol")
        container.loadPersistentStores { (desc, err) in
            if let error = err {
                fatalError("\(error)")
            }
        }
        print("@store.url",container.persistentStoreCoordinator.persistentStores.map({ $0.url?.absoluteString }).compactMap({ $0 }))
        return container
    }()
    
    var managedContext: NSManagedObjectContext {
        let ctx = persistentContainer.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }
}

protocol OjolNSManagedObject: NSManagedObject {}

extension OjolNSManagedObject where Self: DomainConvertible, Self.DomainType: CoreDataConvertible, Self.DomainType.CoreDataType == Self {
    static func fetchReq() -> NSFetchRequest<Self> {
        NSFetchRequest<Self>(entityName: "\(Self.self)")
    }
    static func entityDesc(ctx: NSManagedObjectContext) -> NSEntityDescription? {
        NSEntityDescription.entity(
            forEntityName: "\(Self.self)",
            in: ctx
        )
    }
    static func new(ctx: NSManagedObjectContext) -> Self {
        guard let entity = entityDesc(ctx: ctx) else {
            fatalError("Cannot create EntityDescription : \(Self.self)")
        }
        return Self.init(entity: entity, insertInto: ctx)
    }
    
    static func first(primaryKey: String = DomainType.primaryKey, value: Any, ctx: NSManagedObjectContext) -> Self? {
        let fetchRq = Self.fetchReq()
        fetchRq.fetchLimit = 1
        guard let value = value as? CVarArg else {
            fatalError("value must conform CVarArg")
        }
        fetchRq.predicate = NSPredicate(
            format: "\(primaryKey) == %@", value)
        return try? ctx.fetch(fetchRq).first
    }
    
    static func firstOrNew(primaryKey: String = DomainType.primaryKey, value: Any, ctx: NSManagedObjectContext) -> Self {
        
        let o = first(primaryKey: primaryKey, value: value, ctx: ctx) ?? Self.new(ctx: ctx)
        return o
    }
}



extension CoreDataManager {
    
    func rawFetch<DomainObject: CoreDataConvertible>(
        predicate: NSPredicate? = nil,
        sort: [NSSortDescriptor]? = nil,
        limit: Int = 0,
        to: DomainObject.Type) -> Observable<[DomainObject]>
        where DomainObject.CoreDataType: OjolNSManagedObject {
        Observable<[DomainObject]>.create { [unowned self] o in
            do {
                let ctx = self.managedContext
                let fetchRq = DomainObject.CoreDataType.fetchReq()
                fetchRq.predicate = predicate
                fetchRq.fetchLimit = limit
                fetchRq.sortDescriptors = sort
                #if DEBUG
                print("@raw fetching", fetchRq.predicate)
                #endif
                let items = try ctx.fetch(fetchRq).map({ $0.asDomain() })
                o.onNext(items)
                o.onCompleted()
            } catch {
                o.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func rawSave<DomainObject: CoreDataConvertible>(_ object: DomainObject, primaryKeyValue: Any) -> Observable<DomainObject> where DomainObject.CoreDataType: OjolNSManagedObject {
        return Observable.create { (o) in
            do {
                let ctx = self.managedContext
                let obj = object.asCoreData(ctx: ctx)
                try ctx.save()
                o.onNext(obj.asDomain())
                o.onCompleted()
            } catch {
                o.onError(error)
            }
            return Disposables.create()
        }
    }
}
