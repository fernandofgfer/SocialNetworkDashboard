//
//  PostMapperTests.swift
//  TumblrbotTests
//
//  Created by Fernando Garcia Fernandez on 30/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import XCTest
@testable import Tumblrbot

final class PostMapperTests: XCTestCase {
    
    var sut: PostMapper!
    
    override func setUp() {
        super.setUp()
        sut = PostMapper()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Text type tests
    func test_map_dashboardResponseWithTextType_shouldReturn_postWithTextType() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithText
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        // Then
        if case .text = result.first?.type.first {
            XCTAssert(true)
        } else {
            XCTAssert(false, "Type is not .text")
        }
    }
    
    func test_map_dashboardResponseWithTextType_withContentType_shouldReturn_postTextContentArray() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithText
        let expectedContent = dataToTest.posts.first?.content.first
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        // Then
        if case .text(let postTextContent) = result.first?.type.first {
            XCTAssertEqual(expectedContent?.text, postTextContent.text)
            XCTAssertEqual(expectedContent?.subtype, postTextContent.subtype)
        } else {
            XCTAssert(false, "Type is not .text")
        }
    }
    
    func test_map_dashboardResponseWithTextType_withContentType_shouldReturn_postTextContentArray_withFormattingArray() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithText
        let expectedFormatting = dataToTest.posts.first?.content.first?.formatting?.first
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        // Then
        if case .text(let postTextContent) = result.first?.type.first {
            let formattingResult = postTextContent.formatting?.first
            XCTAssertEqual(expectedFormatting?.start, formattingResult?.start)
            XCTAssertEqual(expectedFormatting?.end, formattingResult?.end)
            XCTAssertEqual(expectedFormatting?.type, formattingResult?.type)
            XCTAssertEqual(expectedFormatting?.url, formattingResult?.url)
            XCTAssertEqual(expectedFormatting?.hex, formattingResult?.hex)
            
            XCTAssertEqual(expectedFormatting?.blog?.uuid, formattingResult?.blog?.uuid)
            XCTAssertEqual(expectedFormatting?.blog?.url, formattingResult?.blog?.url)
            XCTAssertEqual(expectedFormatting?.blog?.name, formattingResult?.blog?.name)
        } else {
            XCTAssert(false, "Type is not .text")
        }
    }
    
    // MARK: - Image type tests
    func test_map_dashboardResponseWithImageType_shouldReturn_postWithImageType() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        // Then
        if case .image = result.first?.type.first {
            XCTAssert(true)
        } else {
            XCTAssert(false, "Type is not .image")
        }
    }
    
    func test_map_dashboardResponseWithImageType_shouldReturn_postImageContentArray() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithImage
        let expectedMedia = dataToTest.posts.first?.content.first?.media
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        // Then
        if case .image(let postImageContent) = result.first?.type.first,
           case .mediaImages(let mediaResponse) = expectedMedia  {
            XCTAssertEqual(mediaResponse.first?.type, postImageContent.media.first?.type)
            XCTAssertEqual(mediaResponse.first?.url, postImageContent.media.first?.url)
            XCTAssertEqual(mediaResponse.first?.height, postImageContent.media.first?.height)
            XCTAssertEqual(mediaResponse.first?.width, postImageContent.media.first?.width)
        } else {
            XCTAssert(false, "Type is not .image")
        }
    }
    
    // MARK: - Video type tests
    func test_map_dashboardResponseWithVideoType_shouldReturn_postWithVideoType() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithVideo
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        // Then
        if case .video = result.first?.type.first {
            XCTAssert(true)
        } else {
            XCTAssert(false, "Type is not .video")
        }
    }
    
    func test_map_dashboardResponseWithVideoType_shouldReturn_postVideoContent() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithVideo
        let expectedMedia = dataToTest.posts.first?.content.first?.media
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        // Then
        if case .video(let postImageContent) = result.first?.type.first,
           case .media(let mediaResponse) = expectedMedia  {
            XCTAssertEqual(mediaResponse.type, postImageContent.media.type)
            XCTAssertEqual(mediaResponse.url, postImageContent.media.url)
            XCTAssertEqual(mediaResponse.height, postImageContent.media.height)
            XCTAssertEqual(mediaResponse.width, postImageContent.media.width)
        } else {
            XCTAssert(false, "Type is not .video")
        }
    }
    
    // MARK: - Unknown types
    func test_map_dashboardResponseWithUnkownTypes_shoulntReturnAnyPost() {
        // Given
        let dataToTest = PostMapperTestsUtils.dashboardResponseWithAudio
        
        // When
        let result = sut.map(dashboardResponse: dataToTest)
        
        XCTAssertEqual(0, result.first?.type.count)
    }
}
