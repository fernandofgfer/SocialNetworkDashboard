//
//  TumblrbotURLSession.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 29/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

/// Principal class to handle URLSession using TmTumblrSDK framework
class TumblrbotURLSession {
    private enum Constants {
        static let consumerKey = "consumerKey"
        static let consumerSecret = "consumerSecret"
        static let token = "token"
        static let secret = "secret"
    }
    
    private lazy var session: TMURLSession = {
        let consumerKey = Bundle.main.object(forInfoDictionaryKey: Constants.consumerKey) as? String ?? ""
        let consumerSecret = Bundle.main.object(forInfoDictionaryKey: Constants.consumerSecret) as? String ?? ""
        let token = Bundle.main.object(forInfoDictionaryKey: Constants.token) as? String ?? ""
        let secret = Bundle.main.object(forInfoDictionaryKey: Constants.secret) as? String ?? ""
        
        return TMURLSession(configuration: .default,
                            applicationCredentials: TMAPIApplicationCredentials(consumerKey: consumerKey,
                                                                                     consumerSecret: consumerSecret),
                            userCredentials: TMAPIUserCredentials(token: token,
                                                                  tokenSecret: secret))
    }()

    
    private lazy var factory: TMRequestFactory = {
       TMRequestFactory()
    }()
}

// MARK: - URLSessionProtocol implementation
extension TumblrbotURLSession: URLSessionProtocol {
    func task(endpoint: Endpoints, parameters: [String: Any], completionHandler: @escaping URLSessionCompletion) {
        let task = session.task(with: getTMRequest(by: endpoint, parameter: parameters)) { data, urlResponse, error in
            let parsed = TMResponseParser.init(data: data, urlResponse: urlResponse, error: error, serializeJSON: true).parse()
            completionHandler(parsed.jsonDictionary, parsed.statusCode, parsed.successful)
        }
        task.resume()
    }
    
    private func getTMRequest(by endpoint: Endpoints, parameter: [String: Any]) -> TMRequest {
        switch endpoint {
        case .dashboard:
            return factory.dashboardRequest(parameter)
        }
    }
}
