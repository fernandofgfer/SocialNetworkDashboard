//
//  ApiClientProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 29/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

typealias ApiClientClosure<T> = (Result<T, ApiClientError>) -> Void

struct Request {
    let endpoint: Endpoints
    let parameters: [String: Any]
}

/// Protocol that cointais all network calls
protocol ApiClientProtocol {
    var urlSession: URLSessionProtocol { get }
    
    /// Method to retrieve data
    /// - Parameters request: Request protocol
    /// - Parameters completion: Callback type
    func fetch<T: Decodable>(request: Request, completion: @escaping ApiClientClosure<T>)
}

/// Errors based in Errors and Error Subcodes
/// https://www.tumblr.com/docs/en/api/v2#userdashboard--retrieve-a-users-dashboard
public enum ApiClientError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case serviceUnavailable
    case unknown
    case mappingDTO
    
    static func getApiClientError(with statusCode: Int) -> Self {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500:
            return .serverError
        case 503:
            return .serviceUnavailable
        default:
            return .unknown
        }
    }
}
