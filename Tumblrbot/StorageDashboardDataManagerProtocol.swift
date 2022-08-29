//
//  StorageDashboardDataManagerProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

typealias StorageDashboardResult = (Result<[Post], Error>) -> Void

protocol StorageDashboardDataManagerProtocol {
    var storageClient: CoreDataManagerProtocol { get }
    func fetchPosts(offset: Int, limit: Int, sortedBy: String, ascending: Bool, completion: @escaping StorageDashboardResult)
    func savePosts(posts: [Post], completion: @escaping (Bool) -> Void)
}
