import Foundation
import CoreData

@objc(CDJustRandom)
final class CDJustRandom: NSManagedObject, OjolNSManagedObject {}
extension CDJustRandom {
    @NSManaged public var uid: String
}

extension JustRandom: CoreDataConvertible {
    static var primaryKey: String { "uid" }
    
    func asCoreData(ctx: NSManagedObjectContext) -> CDJustRandom {
        let o = CDJustRandom
            .firstOrNew(value: uid, ctx: ctx)
        o.uid = uid
        return o
    }
}

extension CDJustRandom: DomainConvertible {
    func asDomain() -> JustRandom {
        let m = JustRandom(uid: uid)
        return m
    }
}


final class CDJustRandomRepository: JustRandomRepository {
    private let ctx: NSManagedObjectContext
    
    init() {
        ctx = CoreDataManager.shared.managedContext
    }
    
    func all() throws -> [JustRandom] {
        ctx.reset()
        let fetchRq = CDJustRandom.fetchReq()
        let JustRandoms = try ctx.fetch(fetchRq)
        return JustRandoms.map { $0.asDomain() }
    }
    func get(uid: String) throws -> JustRandom? {
        if let o = CDJustRandom.first(value: uid, ctx: ctx) {
            return o.asDomain()
        }
        return nil
    }
    func save(item: JustRandom) throws -> JustRandom {
        let JustRandom = item.asCoreData(ctx: ctx)
        try ctx.save()
        return JustRandom.asDomain()
    }
        
    func delete(uid: String) throws {
        let o = try get(uid: uid)
        guard let item = o?.asCoreData(ctx: ctx) else { fatalError() }
        ctx.delete(item)
        try ctx.save()
    }
}

#if DEBUG

extension CDJustRandom: DEBUGCrudDomain {
    static var primaryKey: String { DomainType.primaryKey }
    
    static var fields: [DEBUGCrudDomainField] = [ CrudTextField.new(field: "uid"),
    ]
    
    func save(value: Any?, key: String) {
        setValue(value, forKey: key)
    }
    
    func get(key: String) -> Any? {
        value(forKey: key)
    }
    
    var asCellString: String {
        """
        uid: \(uid)
        
        """
    }
}

extension CDJustRandomRepository: DEBUGCrudRepository {
    func newModel() -> DEBUGCrudDomain {
        let o = CDJustRandom.new(ctx: ctx)
        o.uid = "DEBUG-\(UUID())".lowercased()
        return o
    }
    
    func crudAll() throws -> [DEBUGCrudDomain] {
        let i = try all()
        return i.map({ $0.asCoreData(ctx: ctx) })
    }
    func crudGet(uid: String) throws -> DEBUGCrudDomain? {
        let i = try get(uid: uid)
        return i?.asCoreData(ctx: ctx)
    }
    func crudCreate(model: DEBUGCrudDomain) throws -> DEBUGCrudDomain {
        guard let model = model as? CDJustRandom else { fatalError() }
        let o = try save(item: model.asDomain())
        return o.asCoreData(ctx: ctx)
    }
    func crudUpdate(model: DEBUGCrudDomain) throws -> DEBUGCrudDomain {
        guard let model = model as? CDJustRandom else { fatalError() }
        let o = try save(item: model.asDomain())
        return o.asCoreData(ctx: ctx)
    }
    func crudDelete(uid: String) throws {
        try delete(uid: uid)
    }
}

#endif
