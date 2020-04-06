//
//  DomainConvertible.swift
//  Ojol
//
//  Created by Muis on 06/04/20.
//

import Foundation

protocol DomainConvertible {
    associatedtype DomainType
    func asDomain() -> DomainType
}
