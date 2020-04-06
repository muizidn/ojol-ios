//
//  AuthApi.swift
//  Ojol
//
//  Created by Muis on 24/02/20.
//

import Foundation

enum AuthApi: RestApi {
    /// response: RespStatus
    case registration(stateCode: String, phone: String)
    case verification(stateCode: String, phone: String, otp: String)
    case callOtp(stateCode: String, phone: String)
    /// response: RespData<RespRefreshAccessToken>
    case refreshToken(accessToken: String)
}

extension AuthApi {
    var baseURL: URL { URL(string: "https://api.hiapp.id/api/v1")! }
    
    var path: String {
        switch self {
        case .registration:
            return "/registration"
        case .verification:
            return "/verification"
        case .callOtp:
            return "/callOtp"
        case .refreshToken:
            return "/refreshToken"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var task: Task {
        switch self {
        case .registration(let stateCode, let phone):
            return .requestJSON(try! JSONEncoder().encode([
                "state_code": stateCode,
                "phone": phone
            ]))
        case .verification(let stateCode, let phone, let otp):
            return .requestJSON(try! JSONEncoder().encode([
                "state_code": stateCode,
                "phone": phone,
                "otp": otp
            ]))
        case .callOtp(let stateCode, let phone):
            return .requestJSONDict([
                "state_code": stateCode,
                "phone": phone
            ])
        case .refreshToken(let accessToken):
            return .requestJSONDict([
                "access_token": accessToken
            ])
        }
    }
    
    var headers: [String : String]? {
        var headers = [
            "Content-Type": "application/json"
        ]
        
        if case .refreshToken = self, let token = KeyValuePairStorage.shared.refreshTokenOrNil {
            headers["Authorization"] = "JWT" + " " + token
        }
        
        return headers
    }
}
