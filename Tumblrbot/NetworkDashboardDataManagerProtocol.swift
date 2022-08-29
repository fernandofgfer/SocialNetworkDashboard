//
//  NetworkDashboardDataManagerProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 29/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

protocol NetworkDashboardDataManagerProtocol {
    var apiClient: ApiClientProtocol { get }
    func fetchDashboard(offset: Int, limit: Int, timestamp: Int?, completion: @escaping(Result<[Post], ApiClientError>) -> Void)
}
