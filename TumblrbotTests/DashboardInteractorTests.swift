//
//  DashboardInteractorTests.swift
//  TumblrbotTests
//
//  Created by Fernando Garcia Fernandez on 3/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import XCTest
@testable import Tumblrbot

class DashboardInteractorTests: XCTestCase {
    
    var sut: DashboardInteractor!
    var networkDashboardDataManager: NetworkDashboardDataManagerMock!
    var storageDashboardDataManager: StorageDashboardDataManagerMock!
    var reachabilityMock: ReachabilityProviderMock!
    var delegate: DashboardInteractorOutputMock!
    
    override func setUp()  {
        super.setUp()
        delegate = DashboardInteractorOutputMock()
        networkDashboardDataManager = NetworkDashboardDataManagerMock()
        storageDashboardDataManager = StorageDashboardDataManagerMock()
        reachabilityMock = ReachabilityProviderMock()
        sut = DashboardInteractor(networkDashboardDataManager: networkDashboardDataManager,
                                  storageDashboardDataManager: storageDashboardDataManager,
                                  reachabilityProvider: reachabilityMock)
        sut.delegate = delegate
    }

    override func tearDown() {
        networkDashboardDataManager = nil
        storageDashboardDataManager = nil
        reachabilityMock = nil
        delegate = nil
        sut = nil
        super.tearDown()
    }
    
    func test_fetchPosts_withReachability_shouldCall_fetchRemoteDashboard() {
        // Given
        reachabilityMock.isReachable = true
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(1, networkDashboardDataManager.fetchDashboardCallCount)
    }
    
    func test_fetchPosts_withoutReachability_shouldCall_fetchStorageDashboard() {
        // Given
        reachabilityMock.isReachable = false
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(1, storageDashboardDataManager.fetchPostsCallCount)
    }
    
    func test_fetchPosts_withReachability_andRetrievingData_shouldCall_storageSave() {
        // Given
        reachabilityMock.isReachable = true
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let result = PostMapper().map(dashboardResponse: dataToTest)
        let arrayPosts = (1..<10).map{ _ in result.first! }
        
        networkDashboardDataManager.fetchDashboardCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(1, storageDashboardDataManager.savePostsCallCount)
    }
    
    func test_fetchPost_withReachability_andRetrieveData_shouldSaveData_andfetchStorage() {
        // Given
        reachabilityMock.isReachable = true
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let result = PostMapper().map(dashboardResponse: dataToTest)
        let arrayPosts = (1..<10).map{ _ in result.first! }
        
        networkDashboardDataManager.fetchDashboardCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        
        storageDashboardDataManager.saveCompletionClosure = { completion in
            completion(true)
        }
        
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(1, storageDashboardDataManager.fetchPostsCallCount)
    }

    
    func test_fetchPosts_withFailure_shouldCall_postDidFetchError() {
        // Given
        reachabilityMock.isReachable = true
        networkDashboardDataManager.fetchDashboardCompletionClosure = { completion in
            completion(.failure(.badRequest))
        }
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(1, delegate.postDidFetchErrorCallCount)
    }
    
    func test_cellWillDisplay_whenNeedsPagination_shouldCall_fetchDashboard() {
        // Given
        reachabilityMock.isReachable = true
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let result = PostMapper().map(dashboardResponse: dataToTest)
        let arrayPosts = (1..<10).map{ _ in result.first! }
        
        networkDashboardDataManager.fetchDashboardCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        sut.fetchPosts()
        
        // When
        sut.postWillDisplay(index: 7)
        
        // Then
        XCTAssertEqual(1, networkDashboardDataManager.fetchDashboardCallCount)
    }
    
    func test_fetchPosts_withoutReachability_andPostInCoreData_shouldCall_postDidFetch() {
        // Given
        reachabilityMock.isReachable = false
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let result = PostMapper().map(dashboardResponse: dataToTest)
        let arrayPosts = (1..<10).map{ _ in result.first! }
        
        storageDashboardDataManager.fetchPostsCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(1, delegate.postDidFetchCallCount)
    }
    
    func test_fetchPosts_withoutReachability_andReceiveError_shouldCall_postDidFetchError() {
        // Given
        reachabilityMock.isReachable = false
        
        storageDashboardDataManager.fetchPostsCompletionClosure = { completion in
            completion(.failure(NSError()))
        }
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(1, delegate.postDidFetchErrorCallCount)
    }
    
    func test_fetchPosts_withReachability_firstTimestamp_shouldbe_0() {
        // Given
        reachabilityMock.isReachable = true
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(0, networkDashboardDataManager.lastTimestampSpy)
    }
    
    func test_fetchPosts_withReachability_timestampParameter_shouldBeTheSame_than_lastPostPainted() {
        // Given
        reachabilityMock.isReachable = true
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let result = PostMapper().map(dashboardResponse: dataToTest)
        let arrayPosts = (1..<10).map{ _ in result.first! }
        
        networkDashboardDataManager.fetchDashboardCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        
        storageDashboardDataManager.saveCompletionClosure = { completion in
            completion(true)
        }
        
        storageDashboardDataManager.fetchPostsCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        let timestamp = Int(arrayPosts.last!.date.timeIntervalSince1970)
        sut.fetchPosts()
        
        // When
        sut.fetchPosts()
        
        // Then
        XCTAssertEqual(timestamp, networkDashboardDataManager.lastTimestampSpy)
    }
    
    func test_fetchLastPosts_withReachability_withNoNewData_shouldCall_newPostsDidntFetch() {
        // Given
        reachabilityMock.isReachable = true
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let result = PostMapper().map(dashboardResponse: dataToTest)
        let arrayPosts = (1..<10).map{ _ in result.first! }
        
        networkDashboardDataManager.fetchDashboardCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        
        storageDashboardDataManager.saveCompletionClosure = { completion in
            completion(true)
        }
        
        storageDashboardDataManager.fetchPostsCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        
        // When
        sut.fetchLastPosts()
        
        // Then
        XCTAssertEqual(1, delegate.newPostsDidntFetchCallCount)
    }
    
    func test_fetchLastPosts_withReachability_withNewData_shouldCall_newPostsDidFetch() {
        // Given
        reachabilityMock.isReachable = true
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let result = PostMapper().map(dashboardResponse: dataToTest)
        let arrayPosts = (1..<10).map{ _ in result.first! }
        
        networkDashboardDataManager.fetchDashboardCompletionClosure = { completion in
            completion(.success(arrayPosts))
        }
        
        storageDashboardDataManager.saveCompletionClosure = { completion in
            completion(true)
        }
        
        let dataToTest2 = PostMapperTestsUtils.dashboardResponseWithText
        let result2 = PostMapper().map(dashboardResponse: dataToTest2)
        let arrayPosts2 = (1..<10).map{ _ in result2.first! }
        
        storageDashboardDataManager.fetchPostsCompletionClosure = { completion in
            completion(.success(arrayPosts2))
        }
        
        // When
        sut.fetchLastPosts()
        
        // Then
        XCTAssertEqual(1, delegate.newPostsDidFetchCallCount)
    }
    
    func test_fetchLastPosts_withNoReachability_shouldCall_newPostsDidntFetch() {
        // Given
        reachabilityMock.isReachable = false
        
        // When
        sut.fetchLastPosts()
        
        // Then
        XCTAssertEqual(1, delegate.newPostsDidntFetchCallCount)
    }
}
