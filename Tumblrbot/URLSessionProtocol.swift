//
//  URLSessionProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 29/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

typealias URLSessionCompletion = (_ jsonDictionary: [String : Any]?, _ statusCode: Int, _ success: Bool) -> Void

/// Protocol to create abstractions of URLSession
protocol URLSessionProtocol {
    
    /// Execute tasks
    ///
    /// - Parameter endpoint: Enpoint enum
    /// - Parameter parameters: Dictionary with parameters to execute
    /// - Parameter completionHandler: URLSessionCompletion type:
    /// (_ jsonDictionary: [String : Any]?, _ statusCode: Int, _ success: Bool) -> Void)
    func task(endpoint: Endpoints, parameters: [String: Any], completionHandler: @escaping URLSessionCompletion)
}

