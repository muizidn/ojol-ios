//
//  RespFCMRegister.swift
//  Ojol
//
//  Created by Muis on 03/03/20.
//

import Foundation

struct RespFCMRegister: Decodable {
    let infoDevice: String
    let typeDevice: Int
    let fcmToken: String
    
    enum CodingKeys: String, CodingKey {
        case infoDevice = "info_device"
        case typeDevice = "type_device"
        case fcmToken = "fcm_token"
    }
}
