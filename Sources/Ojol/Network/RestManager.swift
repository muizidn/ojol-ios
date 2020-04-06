//
//  RestManager.swift
//  Ojol
//
//  Created by Muis on 24/02/20.
//

import UIKit
import RxSwift

private var __networkActivityCounter = 0 {
    didSet {
        DispatchQueue.main.async {
            UIApplication.shared
                .isNetworkActivityIndicatorVisible = (__networkActivityCounter > 0)
        }
    }
}

protocol RestApi {
    /// The target's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    var task: Task { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    var timeout: TimeInterval { get }
}

extension RestApi {
    var timeout: TimeInterval {
        URLSession.shared.configuration.timeoutIntervalForRequest }
    var fullURL: URL {
        var url = baseURL
        url.appendPathComponent(path)
        return url
    }
}


public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}

/// Represents an HTTP task.
public enum Task {
    case requestPlain
    case requestJSON(Data)
    case requestJSONDict([String: Any])
    case requestMultipart([MultipartData], id: String)
}

public enum MultipartData {
    case string(name: String, value: String)
    case data(name: String, value: Data, filename: String, mimeType: String)
}


extension RestApi {
    func toUrlRequest() -> URLRequest {
        var urlReq = URLRequest(
            url: baseURL.appendingPathComponent(path) )
        urlReq.allHTTPHeaderFields = headers
        urlReq.httpMethod = method.rawValue
        
        var body: Data? = nil
        
        switch task {
        case .requestPlain:
            body = nil
        case .requestJSON(let value):
            body = value
        case .requestJSONDict(let dict):
            body = try! JSONSerialization.data(withJSONObject: dict, options: [])
        case .requestMultipart(let params, let id):
            let boundary = "\(UUID().uuidString.lowercased())"
            
            urlReq.setValue("multipart/form-data; charset=utf-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlReq.setValue(id, forHTTPHeaderField: "hiapp-ios-storage-upload-id")
            
            var mbody = Data()
            
            for i in params {
                
                mbody.append("--\(boundary)\r\n"
                    .data(using: .utf8, allowLossyConversion: false)!)
                
                switch i {
                case .string(let name, let value):
                    mbody.append(#"Content-Disposition: form-data; name="\#(name)"\#r\#n\#r\#n"#
                        .data(using: .utf8, allowLossyConversion: false)!)
                    mbody.append("\(value)"
                        .data(using: .utf8, allowLossyConversion: false)!)
                case .data(let name, let value, let filename, let mimeType):
                    mbody.append(#"Content-Disposition: form-data; name="\#(name)"; filename="\#(filename)"\#r\#n"#
                        .data(using: .utf8, allowLossyConversion: false)!)
                    mbody.append(#"Content-Type: \#(mimeType)\#r\#n\#r\#n"#
                        .data(using: .utf8, allowLossyConversion: false)!)
                    mbody.append(value)
                }
                mbody.append("\r\n"
                    .data(using: .utf8, allowLossyConversion: false)!)
                
            }
            
            // Close
            mbody.append("--\(boundary)--"
                .data(using: .utf8, allowLossyConversion: false)!)
            
            body = mbody
        }
        
        switch method {
        case .post:
            urlReq.httpBody = body!
        case .get:
            urlReq.httpBody = nil
        case .put:
            urlReq.httpBody = body!
        }
        
        #if DEBUG
        log.debug("Req: \(fullURL.path) d: \(urlReq.httpBody.debugDescription)")
        #endif
        
        return urlReq
    }
}

final class RestManager {
    static let shared = RestManager()
    fileprivate init() {}
    
    func request<Response: Decodable>(endpoint: RestApi, to response: Response.Type, decoder: JSONDecoder = JSONDecoder.default, delegate: URLSessionTaskDelegate? = nil) -> Observable<Response> {
        __networkActivityCounter += 1
        let request = endpoint.toUrlRequest()
        log.debug(request.cURL() + "\n")
        let urlConfig = URLSessionConfiguration.ephemeral
        urlConfig.timeoutIntervalForRequest = endpoint.timeout
        let session = URLSession.init(
            configuration: .ephemeral,
            delegate: delegate,
            delegateQueue: OperationQueue.main)
        return session.rx
            .response(request: request)
            .flatMap({ arg -> Observable<Response> in
                Observable.create { (o) in
                    switch arg.response.statusCode {
                    case 200, 201:
                        do {
                            #if DEBUG
                            let value = try! decoder
                                .decode(response, from: arg.data)
                            #else
                            let value = try JSONDecoder()
                                .decode(response, from: arg.data)
                            #endif
                            o.onNext(value)
                            o.onCompleted()
                        } catch {
                            #if DEBUG
                            fatalError(String.init(data: arg.data))
                            #else
                            o.onError(error)
                            #endif
                        }
                    case 400:
                        do {
                            #if DEBUG
                            let value = try! decoder
                                .decode(Rest400Error.self, from: arg.data)
                            #else
                            let value = try decoder
                                .decode(Rest400Error.self, from: arg.data)
                            #endif
                            o.onError(RestError.custom(
                                value.message.first!.value))
                        } catch {
                            #if DEBUG
                            fatalError(String.init(data: arg.data))
                            #else
                            o.onError(error)
                            #endif
                        }
                    case 500:
                        #if DEBUG
                        fatalError("""
                            string: \(String.init(data: arg.data))
                            """)
                        #else
                        o.onError(RestError.internalServerError)
                        #endif
                    default:
                        #if DEBUG
                        fatalError("""
                            code: \(arg.response.statusCode)
                            string: \(String.init(data: arg.data))
                            """)
                        #else
                        o.onError(RestError.unhandledError)
                        #endif
                    }
                    return Disposables.create {
                        __networkActivityCounter -= 1
                    }
                }
            })
            .observeOn(MainScheduler.asyncInstance)
        
    }
}

enum RestError: LocalizedError {
    case internalServerError
    case unhandledError
    case err400
    case custom(String)
    var errorDescription: String? {
        switch self {
        case .internalServerError:
            return "Internal Server Error"
        case .unhandledError:
            return "Unhandled Error"
        case .err400:
            return "Unhandled Error 400"
        case .custom(let text):
            return text
        }
    }
}

fileprivate struct Rest400Error: Decodable {
    let message: [String: String]
}
