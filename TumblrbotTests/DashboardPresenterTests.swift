//
//  DashboardPresenterTests.swift
//  TumblrbotTests
//
//  Created by Fernando Garcia Fernandez on 3/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import XCTest
@testable import Tumblrbot

class DashboardPresenterTests: XCTestCase {

    var sut: DashboardPresenter!
    var interactor: DashboardInteractorMock!
    var view: DashboardViewMock!
    
    override func setUp()  {
        super.setUp()
        interactor = DashboardInteractorMock()
        view = DashboardViewMock()
        sut = DashboardPresenter(interactor: interactor)
        sut.view = view
    }

    override func tearDown() {
        interactor = nil
        view = nil
        sut = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_shouldCall_fetchPosts() {
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(1, interactor.fetchPostCallCount)
    }
    
    func test_postDidFetch_shouldCall_showPosts() {
        // When
        sut.postDidFetch(posts: [])
        
        // Then
        XCTAssertEqual(1, view.showPostCallCount)
    }
    
    func test_postDidFetchError_shouldCall_showPosts() {
        // When
        sut.postDidFetchError(error: .badRequest)
        
        // Then
        XCTAssertEqual(1, view.showErrorCallCount)
    }
    
    func test_cellWillDisplay_shouldCall_cellWillDisplay() {
        // When
        sut.cellWillDisplay(index: 1)
        
        // Then
        XCTAssertEqual(1, interactor.cellWillDisplayCallCount)
    }
    
    func test_postDidFetch_shouldReturn_onlyOneAccurateImage() {
        // Given
        sut.screenWidthSetted(screenWidth: 400)
        let post = Post(id: "123213", name: "name", date: Date(), type: [.image(content: PostImageContent(media: [PostMedia(url: "http://google.es", type: nil, width: 390, height: 500), PostMedia(url: "http://yahoo.com", type: nil, width: 700, height: 900)]))])
        
        // When
        sut.postDidFetch(posts: [post])
        
        // Then
        let result = view.postsShowed
        if case let .image(content) = result.first?.type.first {
            XCTAssertEqual(1, content.media.count)
            XCTAssertEqual("http://google.es", content.media.first?.url)
            XCTAssertEqual(390, content.media.first?.width)
            XCTAssertEqual(500, content.media.first?.height)
        }
    }
    
    func test_didRefreshTable_shouldCall_fetchLastPosts() {
        // When
        sut.didRefreshTable()
        
        // Then
        XCTAssertEqual(1, interactor.fetchLastPostsCallCount)
    }
    
    func test_newPostsDidFetch_shouldCall_showNewPosts() {
        // When
        sut.newPostsDidFetch(posts: [])
        
        // Then
        XCTAssertEqual(1, view.showNewPostsCallCount)
    }
    
    func test_newPostsDidntFetch_shouldCall_stopRefresh() {
        // When
        sut.newPostsDidntFetch()
        
        // Then
        XCTAssertEqual(1, view.stopRefreshCallCount)
    }
}
