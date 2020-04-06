//
//  Encodable+Ext.swift
//  Ojol
//
//  Created by Muis on 11/03/20.
//

import Foundation
import SocketIO

protocol SocketEncodable: Encodable, SocketData {
}

extension SocketEncodable {
    func socketRepresentation() throws -> SocketData {
        let data = try JSONEncoder().encode(self)
        let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return dict
    }
}
