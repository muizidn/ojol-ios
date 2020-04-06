//
//  Date+Ext.swift
//  Ojol
//
//  Created by Muis on 10/03/20.
//

import Foundation

extension Date {
    static func df(format: String) -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = format
        return df
    }
}

extension Date {
    // 3/10/20, 11:55:43 AM
    static let historyChatDf = df(format: "MM/dd/yy, hh:mm:ss a")
    
    // 3/10/2020, 11:55:43 AM
    static let chatDf = df(format: "MM/dd/yyyy, hh:mm:ss a")
    
    func toChatDateFormatString() -> String {
        Self.chatDf.string(from: self)
    }
    
    static func fromChatDateFormat(str: String) -> Date {
        if let value = Self.chatDf.date(from: str) {
            return value
        }
        fatalError("fail parse \(str) with \(String(describing: chatDf.dateFormat))")
    }
}

extension Date {
    // 2020-03-11T11:40:49.000Z
    static let chatHistoryDf = df(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    
    func toChatHistorySync() -> String {
        Self.chatDf.string(from: self)
    }
}

extension Date {
    static let jan_1_1970 = Date.init(timeIntervalSince1970: 0)
}
