//
//  OjolError.swift
//  Ojol
//
//  Created by Muis on 08/03/20.
//

import Foundation

enum OjolError: LocalizedError {
    case msg(String)
    var errorDescription: String? {
        switch self {
        case .msg(let str): return str
        }
    }
}
