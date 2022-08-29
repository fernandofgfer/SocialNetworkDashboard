//
//  NetworkDashboardDataManager.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 29/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

final class NetworkDashboardDataManager {
    
    private enum Constants {
        static let limitParameter = "limit"
        static let offsetParameter = "offset"
        static let npfParameter = "npf"
        static let beforeParameter = "before"
    }
    
    internal var apiClient: ApiClientProtocol
    private var dashboardMapper: PostMapperProtocol
    
    init(apiClient: ApiClientProtocol,
         dashboardMapper: PostMapperProtocol) {
        self.apiClient = apiClient
        self.dashboardMapper = dashboardMapper
    }
    
    private func fetchDashboard(request: Request, completion: @escaping (Result<[Post], ApiClientError>) -> Void) {
        apiClient.fetch(request: request, completion: { (result: Result<DashboardResponse, ApiClientError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let posts = self.dashboardMapper.map(dashboardResponse: response)
                    completion(.success(posts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}

extension NetworkDashboardDataManager: NetworkDashboardDataManagerProtocol {
    func fetchDashboard(offset: Int, limit: Int, timestamp: Int?, completion: @escaping (Result<[Post], ApiClientError>) -> Void) {

        let parameters = [Constants.limitParameter: String(limit),
                          Constants.offsetParameter: String(offset),
                          Constants.beforeParameter: String(timestamp ?? Int(Date().timeIntervalSince1970)),
                          Constants.npfParameter: "true"]


        let request = Request(endpoint: .dashboard, parameters: parameters)
        fetchDashboard(request: request, completion: completion)
    }
}
