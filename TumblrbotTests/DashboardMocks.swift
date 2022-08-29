//
//  DashboardMocks.swift
//  TumblrbotTests
//
//  Created by Fernando Garcia Fernandez on 3/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
@testable import Tumblrbot

class DashboardInteractorMock: DashboardInteractorProtocol {

    var delegate: DashboardInteractorOutputProtocol?
    var fetchPostCallCount: Int = 0
    var fetchPostCalled = false
    var cellWillDisplayCallCount: Int = 0
    var cellWillDisplayCalled = false
    var checkReachabilityCalled = false
    var checkReachabilityCallCount = 0
    var fetchLastPostsCalled = false
    var fetchLastPostsCallCount = 0
    
    func fetchPosts() {
        fetchPostCalled = true
        fetchPostCallCount += 1
    }
    
    func postWillDisplay(index: Int) {
        cellWillDisplayCalled = true
        cellWillDisplayCallCount += 1
    }
    
    func checkReachability() {
        checkReachabilityCalled = true
        checkReachabilityCallCount += 1
    }
    
    func fetchLastPosts() {
        fetchLastPostsCalled = true
        fetchLastPostsCallCount += 1
    }
}

class DashboardViewMock: DashboardViewProtocol {
    
    var presenter: DashboardPresenterProtocol {
        get { return underlyingPresenter }
        set(value) { underlyingPresenter = value }
    }
    var underlyingPresenter: DashboardPresenterProtocol!
    var postsShowed: [Post] = []
    
    var showPostCalled = false
    var showPostCallCount = 0
    var showErrorCalled = false
    var showErrorCallCount = 0
    var showNewPostsCalled = false
    var showNewPostsCallCount = 0
    var stopRefreshCalled = false
    var stopRefreshCallCount = 0
    
    func showPosts(posts: [Post]) {
        showPostCalled = true
        showPostCallCount += 1
        postsShowed = posts
    }
    
    func showError(error: ApiClientError) {
        showErrorCalled = true
        showErrorCallCount += 1
    }
    
    func showNewPosts(posts: [Post]) {
        showNewPostsCalled = true
        showNewPostsCallCount += 1
    }
    
    func stopRefresh() {
        stopRefreshCalled = true
        stopRefreshCallCount += 1
    }
}

class NetworkDashboardDataManagerMock: NetworkDashboardDataManagerProtocol {
    var apiClient: ApiClientProtocol {
        get { return underlyingApiClient }
        set(value) { underlyingApiClient = value }
    }
    var underlyingApiClient: ApiClientProtocol!
    
    var fetchDashboardCalled = false
    var fetchDashboardCallCount = 0
    var lastTimestampSpy: Int = 0
    var fetchDashboardCompletionClosure: ((@escaping (Result<[Post], ApiClientError>) -> Void) -> Void)?
    
    func fetchDashboard(offset: Int, limit: Int, timestamp: Int?, completion: @escaping (Result<[Post], ApiClientError>) -> Void) {
        fetchDashboardCalled = true
        fetchDashboardCallCount += 1
        lastTimestampSpy = timestamp ?? 0
        fetchDashboardCompletionClosure?(completion)
    }
    
}

class DashboardInteractorOutputMock: DashboardInteractorOutputProtocol {
    
    var postDidFetchCalled = false
    var postDidFetchCallCount = 0
    var postDidFetchErrorCalled = false
    var postDidFetchErrorCallCount = 0
    var newPostsDidFetchCalled = false
    var newPostsDidFetchCallCount = 0
    var newPostsDidntFetchCalled = false
    var newPostsDidntFetchCallCount = 0
    
    func postDidFetch(posts: [Post]) {
        postDidFetchCalled = true
        postDidFetchCallCount += 1
    }
    
    func postDidFetchError(error: ApiClientError) {
        postDidFetchErrorCalled = true
        postDidFetchErrorCallCount += 1
    }
    
    func newPostsDidFetch(posts: [Post]) {
        newPostsDidFetchCalled = true
        newPostsDidFetchCallCount += 1
    }
    
    func newPostsDidntFetch() {
        newPostsDidntFetchCalled = true
        newPostsDidntFetchCallCount += 1
    }
}

class StorageDashboardDataManagerMock: StorageDashboardDataManagerProtocol {
    var storageClient: CoreDataManagerProtocol {
        get { return underlyingstorageClient }
        set(value) { underlyingstorageClient = value }
    }
    var underlyingstorageClient: CoreDataManagerProtocol!
    
    var fetchPostsCalled = false
    var fetchPostsCallCount = 0
    var savePostsCalled = false
    var savePostsCallCount = 0
    var fetchPostsCompletionClosure: ((@escaping (Result<[Post], Error>) -> Void) -> Void)?
    var saveCompletionClosure: ((@escaping (Bool) -> Void) -> Void)?
    
    func fetchPosts(offset: Int, limit: Int, sortedBy: String, ascending: Bool, completion: @escaping StorageDashboardResult) {
        fetchPostsCallCount += 1
        fetchPostsCalled = true
        fetchPostsCompletionClosure?(completion)
    }
    
    func savePosts(posts: [Post], completion: @escaping (Bool) -> Void) {
        savePostsCalled = true
        savePostsCallCount += 1
        saveCompletionClosure?(completion)
    }
}

class ReachabilityProviderMock: ReachabilityProviderProtocol {
    var isReachable: Bool
    
    init() {
        self.isReachable = true
    }
}
