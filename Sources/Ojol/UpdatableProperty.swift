//
//  UpdatableProperty.swift
//  Ojol
//
//  Created by Muis on 16/03/20.
//

import Foundation

protocol UpdatableProperty {
    func withUpdatedProperty<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self
}

extension UpdatableProperty {
    func withUpdatedProperty<Value>(_ keyPath: WritableKeyPath<Self, Value>, _ value: Value) -> Self {
        var this = self
        this[keyPath: keyPath] = value
        return this
    }
}
