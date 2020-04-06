//
//  CoreDataConvertible.swift
//  Ojol
//
//  Created by Muis on 15/02/20.
//

import Foundation
import CoreData


protocol CoreDataConvertible {
    associatedtype CoreDataType: DomainConvertible where CoreDataType.DomainType == Self
    static var primaryKey: String { get }
    func asCoreData(ctx: NSManagedObjectContext) -> CoreDataType
}
