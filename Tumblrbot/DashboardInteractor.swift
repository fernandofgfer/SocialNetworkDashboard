//
//  DashboardInteractor.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 31/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

typealias Pagination = (offset: Int, limit: Int)

class DashboardInteractor {
    
    private enum Constants {
        static let postLimit = 10
        static let postNextOffset = 2
        static let timestampFetchParameter = "timestamp"
    }
    
    weak var delegate: DashboardInteractorOutputProtocol?
    private let networkDashboardDataManager: NetworkDashboardDataManagerProtocol
    private let storageDashboardDataManager: StorageDashboardDataManagerProtocol
    private let reachabilityProvider: ReachabilityProviderProtocol
    private var pagination = Pagination(0, Constants.postLimit)
    private var lastTimestamp: Int? = 0
    
    init(networkDashboardDataManager: NetworkDashboardDataManagerProtocol,
         storageDashboardDataManager: StorageDashboardDataManagerProtocol,
         reachabilityProvider: ReachabilityProviderProtocol) {
        self.networkDashboardDataManager = networkDashboardDataManager
        self.storageDashboardDataManager = storageDashboardDataManager
        self.reachabilityProvider = reachabilityProvider
    }
}

// MARK: - DashboardInteractorProtocol implementation
extension DashboardInteractor: DashboardInteractorProtocol {
    func fetchPosts() {
        if reachabilityProvider.isReachable {
            fetchRemotePosts(pag: pagination, timestamp: lastTimestamp) {[weak self] posts in
                self?.fetchNetworkPostsSuccess(posts: posts)
            } failure: { [weak self] error in
                self?.fetchNetworkPostsfailure(error: error)
            }
        } else {
            fetchLocalPosts(pag: pagination) { [weak self] posts in
                self?.fetchStoragePostsSuccess(posts: posts)
            } failure: { [weak self] error in
                self?.fetchStoragePostsfailure(error: error)
            }
        }
    }
    
    func postWillDisplay(index: Int) {
        if index == pagination.offset - Constants.postNextOffset {
            fetchPosts()
        }
    }
    
    func fetchLastPosts() {
        if reachabilityProvider.isReachable {
            fetchRemotePosts(pag: Pagination(0, Constants.postLimit), timestamp: nil) { [weak self] posts in
                self?.fetchNewNetworkPostsSuccess(posts: posts)
            } failure: { [weak self] error in
                self?.fetchNetworkPostsfailure(error: error)
            }
        } else {
            delegate?.newPostsDidntFetch()
        }
    }
}

// MARK: - DashboardInteractor private methods
extension DashboardInteractor {
    
    private func fetchRemotePosts(pag: Pagination, timestamp: Int?, success: @escaping ([Post]) -> Void, failure: @escaping (ApiClientError) -> Void) {
        networkDashboardDataManager.fetchDashboard(offset: pag.offset, limit: pag.limit, timestamp: timestamp) { result in
            switch result {
            case .success(let posts):
                success(posts)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    private func fetchLocalPosts(pag: Pagination, success: @escaping ([Post]) -> Void, failure: @escaping (Error) -> Void) {
        storageDashboardDataManager.fetchPosts(offset: pag.offset, limit: pag.limit, sortedBy: Constants.timestampFetchParameter, ascending: false) { result in
           switch result{
           case .success(let posts):
               success(posts)
           case .failure(let error):
               failure(error)
           }
        }
    }
    
    //MARK: - New Network Posts methods
    
    private func fetchNewNetworkPostsSuccess(posts: [Post]) {
        storageDashboardDataManager.savePosts(posts: posts) {[weak self] result in
            if result {
                self?.fetchLocalPosts(pag: Pagination(0, Constants.postLimit), success: { [weak self] coreDataPosts in
                    self?.fetchStorageNewPostsSuccess(networkPosts: posts, localPosts: coreDataPosts)
                }, failure: { [weak self] error in
                    self?.fetchStorageNewPostsFailure(error: error)
                })
            }
        }
    }
    
    //MARK: - Network Posts methods
    
    private func fetchNetworkPostsSuccess(posts: [Post]) {
        storageDashboardDataManager.savePosts(posts: posts) {[weak self] result in
            guard let self = self else { return }
            if result {
                self.fetchLocalPosts(pag: self.pagination) { [weak self] posts in
                    self?.fetchStoragePostsSuccess(posts: posts)
                } failure: { [weak self] error in
                    self?.fetchStoragePostsfailure(error: error)
                }
            }
        }
    }
    
    private func fetchNetworkPostsfailure(error: ApiClientError) {
        delegate?.postDidFetchError(error: error)
    }
    
    //MARK: - Storage posts methods
    
    private func fetchStoragePostsSuccess(posts: [Post]) {
        self.delegate?.postDidFetch(posts: posts)
        pagination.offset = pagination.offset + posts.count
        saveLastTimestamp(posts: posts)
    }
    
    private func fetchStoragePostsfailure(error: Error) {
        delegate?.postDidFetchError(error: .unknown)
    }
    
    // MARK: - Storage new posts methods
    
    private func fetchStorageNewPostsSuccess(networkPosts: [Post], localPosts: [Post]) {
        guard networkPosts.indices.contains(0),
              localPosts.indices.contains(0),
              networkPosts[0] != localPosts [0] else {
            delegate?.newPostsDidntFetch()
            return
        }
        
        delegate?.newPostsDidFetch(posts: localPosts)
        pagination.offset = localPosts.count
        saveLastTimestamp(posts: localPosts)
    }
    
    private func fetchStorageNewPostsFailure(error: Error) {
        delegate?.postDidFetchError(error: .unknown)
        delegate?.newPostsDidntFetch()
    }
    
    // MARK: - saveLastTimestamp
    
    private func saveLastTimestamp(posts: [Post]) {
        guard let post = posts.last else {
            return
        }
        lastTimestamp = Int(post.date.timeIntervalSince1970)
    }
}
