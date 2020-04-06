//
//  JSONDecoder+Ext.swift
//  Ojol
//
//  Created by Muis on 21/03/20.
//

import Foundation

extension JSONDecoder {
    static let `default` = JSONDecoder()
    static let socketChat: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Date.chatDf)
        return decoder
    }()
    
    static let historyChat: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Date.historyChatDf)
        return decoder
    }()
}
