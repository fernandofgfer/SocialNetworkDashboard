//
//  StorageDashboardDataManager.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import CoreData

final class StorageDashboardDataManager {
    
    private enum Constants {
        static let postEntityName = "PostEntity"
        static let timestamp = "timestamp"
    }
    
    internal let storageClient: CoreDataManagerProtocol
    private var mapper: StorageDashboardMapperProtocol

    init(storageClient: CoreDataManagerProtocol,
         mapper: StorageDashboardMapperProtocol) {
        self.storageClient = storageClient
        self.mapper = mapper
    }
}

// MARK: - LocalDashboardDataManagerProtocol implementation
extension StorageDashboardDataManager: StorageDashboardDataManagerProtocol {
    func fetchPosts(offset: Int, limit: Int, sortedBy: String, ascending: Bool, completion: @escaping StorageDashboardResult) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.postEntityName)
        request.sortDescriptors = [NSSortDescriptor(key: sortedBy, ascending: ascending)]
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        storageClient.fetchAsync(fetchRequest: request) {[weak self] result in
            switch result {
            case .success(let data):
                self?.fetchDataSuccess(data: data, completion: completion)
            case .failure(let error):
                self?.fetchDataError(error: error, completion: completion)
            }
        }
    }
    
    func savePosts(posts: [Post], completion: @escaping (Bool) -> Void) {
        
        storageClient.saveAsync { [weak self] context in
            guard let self = self else { return }
            posts.forEach { post in
                if let postEntity =  try? context.fetch(self.fetchById(id: post.id)).first as? PostEntity {
                    self.mapper.mapUpdatePostEntityWithPost(postEntity: postEntity, with: post, with: context)
                } else {
                    self.mapper.mapPostToPostEntity(from: post, with: context)
                }
            }
        } completion: { result in
            completion(result)
        }
    }
}

// MARK: - Private methods
extension StorageDashboardDataManager {
    
    private func fetchById(id: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.postEntityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.sortDescriptors = [NSSortDescriptor(key: Constants.timestamp, ascending: false)]
        request.fetchLimit = 1
        return request
    }
    
    private func fetchDataSuccess(data: ([NSManagedObject]?), completion: @escaping StorageDashboardResult) {
        let posts = mapper.mapPostEntitiesToPosts(from: data as? [PostEntity] ?? [])
        DispatchQueue.main.async {
            completion(.success(posts))
        }
    }
    
    private func fetchDataError(error: Error, completion: @escaping StorageDashboardResult) {
        DispatchQueue.main.async {
            completion(.failure(error))
        }
    }
}
