//
//  ApiClient.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 29/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation


/// ApiClient class that manages network calls
final class ApiClient {

    internal let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
}

// MARK: - ApiClientProtocol implementation
extension ApiClient: ApiClientProtocol {
    func fetch<T>(request: Request, completion: @escaping ApiClientClosure<T>) where T: Decodable {
        urlSession.task(endpoint: request.endpoint, parameters: request.parameters) { jsonDictionary, statusCode, success in
            if success, let jsonDictionary = jsonDictionary {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
                    let dtoResponse = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(dtoResponse))
                } catch {
                    completion(.failure(.mappingDTO))
                }
            } else {
                completion(.failure(ApiClientError.getApiClientError(with: statusCode)))
            }
        }
    }
}
