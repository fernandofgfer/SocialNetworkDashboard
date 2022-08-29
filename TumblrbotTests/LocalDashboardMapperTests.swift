//
//  LocalDashboardMapperTests.swift
//  TumblrbotTests
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import XCTest
import CoreData
@testable import Tumblrbot

final class LocalDashboardMapperTests: XCTestCase {
    
    static var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "Tumblrbot")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container.viewContext
    }()
    
    var sut: StorageDashboardMapper!

    override func setUp()  {
        super.setUp()
        sut = StorageDashboardMapper()
    }

    override func tearDown() {
        flushData()
        sut = nil
        super.tearDown()
    }
    
    func test_mapPost_withVideoType_shouldSave_PostEntity_withVideoInfo() {
        // Given
        let postMedia = PostMedia(url: "asdsad", type: "video", width: 100, height: 200)
        let postVideotype: PostType = .video(content: PostVideoContent(media: postMedia))
        let post = Post(id: "1232", name: "asds", date: Date(), type: [postVideotype])
        
        // When
        sut.mapPostToPostEntity(from: post, with: LocalDashboardMapperTests.context)
        
        // Then
        guard let postEntity = getFirstPostEntity(),
              let contentEntity = (postEntity.content?.allObjects as? [PostContentEntity])?.first
        else {
            XCTFail("Post Entity casting error")
            return
        }
        XCTAssertEqual(post.id, postEntity.id)
        XCTAssertEqual(post.name, postEntity.name ?? "")
        XCTAssertEqual(Int64(post.date.timeIntervalSince1970), postEntity.timestamp)
        XCTAssertEqual("video", contentEntity.type)
        XCTAssertEqual(postMedia.url, contentEntity.videoMedia?.url)
        XCTAssertEqual(postMedia.type, contentEntity.videoMedia?.type)
        XCTAssertEqual(postMedia.width, Int(contentEntity.videoMedia?.width ?? 0))
        XCTAssertEqual(postMedia.height, Int(contentEntity.videoMedia?.height ?? 0))
    }
    
    func test_mapPost_withImageType_shouldSave_PostEntity_withImageInfo() {
        // Given
        let postMedia = PostMedia(url: "asdsad", type: "image", width: 100, height: 200)
        let postImageType: PostType = .image(content: PostImageContent(media: [postMedia]))
        let post = Post(id: "1232", name: "asds", date: Date(), type: [postImageType])
        
        // When
        sut.mapPostToPostEntity(from: post, with: LocalDashboardMapperTests.context)
        
        // Then
        guard let postEntity = getFirstPostEntity(),
              let contentEntity = (postEntity.content?.allObjects as? [PostContentEntity])?.first,
              let imageMediaEntity = (contentEntity.imageMedia?.allObjects as? [PostMediaEntity])?.first
        else {
            XCTFail("Post Entity casting error")
            return
        }
        XCTAssertEqual(post.id, postEntity.id)
        XCTAssertEqual(post.name, postEntity.name ?? "")
        XCTAssertEqual(Int64(post.date.timeIntervalSince1970), postEntity.timestamp)
        XCTAssertEqual("image", contentEntity.type)
        XCTAssertEqual(postMedia.url, imageMediaEntity.url)
        XCTAssertEqual(postMedia.type, imageMediaEntity.type)
        XCTAssertEqual(postMedia.width, Int(imageMediaEntity.width))
        XCTAssertEqual(postMedia.height, Int(imageMediaEntity.height))
    }
    
    func test_mapPost_withTextType_shouldSave_PostEntity_withTextInfo() {
        // Given
        let postBlog = PostFormatting.PostFormattingBlogResponse(uuid: "asds", name: "name", url: "http:\\google.es")
        let postFormatting = PostFormatting(start: 1, end: 2, type: "text", url: "http:\\google.es", blog: postBlog, hex: "color")
        let postTextContent = PostTextContent(text: "Text", subtype: nil, formatting: [postFormatting])
        let postTextType: PostType = .text(content: postTextContent)
        let post = Post(id: "1232", name: "asds", date: Date(), type: [postTextType])
        
        // When
        sut.mapPostToPostEntity(from: post, with: LocalDashboardMapperTests.context)
        
        // Then
        guard let postEntity = getFirstPostEntity(),
              let contentEntity = (postEntity.content?.allObjects as? [PostContentEntity])?.first,
              let formattingEntity = (contentEntity.formatting?.allObjects as? [PostFormattingEntity])?.first,
              let blogEntity = formattingEntity.blog
        else {
            XCTFail("Post Entity casting error")
            return
        }
        XCTAssertEqual(post.id, postEntity.id)
        XCTAssertEqual(post.name, postEntity.name ?? "")
        XCTAssertEqual(Int64(post.date.timeIntervalSince1970), postEntity.timestamp)
        XCTAssertEqual("text", contentEntity.type)
        XCTAssertEqual(postTextContent.text, contentEntity.text)
        XCTAssertEqual(postTextContent.subtype, contentEntity.subtype)
        XCTAssertEqual(postFormatting.start, Int(formattingEntity.start))
        XCTAssertEqual(postFormatting.end, Int(formattingEntity.end))
        XCTAssertEqual(postFormatting.url, formattingEntity.url)
        XCTAssertEqual(postFormatting.type, formattingEntity.type)
        XCTAssertEqual(postFormatting.hex, formattingEntity.hex)
        XCTAssertEqual(postBlog.uuid, blogEntity.uuid)
        XCTAssertEqual(postBlog.url, blogEntity.url)
        XCTAssertEqual(postBlog.name, blogEntity.name)
    }
    
    func test_mapPostEntity_withVideoType_shouldBeMapped_toPostWithVideoInfo() {
        // Given
        let postMedia = PostMedia(url: "asdsad", type: "video", width: 100, height: 200)
        let postVideotype: PostType = .video(content: PostVideoContent(media: postMedia))
        let post = Post(id: "1232", name: "asds", date: Date(), type: [postVideotype])
        sut.mapPostToPostEntity(from: post, with: LocalDashboardMapperTests.context)
        
        // When
        guard let postEntity = getFirstPostEntity(),
              let result = sut.mapPostEntitiesToPosts(from: [postEntity]).first
        else {
            XCTFail("Post Entity casting error")
            return
        }
        
        // Then
        XCTAssertEqual(post, result)
    }
    
    func test_mapPostEntity_withImageType_shouldBeMapped_toPostWithImageInfo() {
        // Given
        let postMedia = PostMedia(url: "asdsad", type: "image", width: 100, height: 200)
        let postImageType: PostType = .image(content: PostImageContent(media: [postMedia]))
        let post = Post(id: "1232", name: "asds", date: Date(), type: [postImageType])
        sut.mapPostToPostEntity(from: post, with: LocalDashboardMapperTests.context)
        
        // When
        guard let postEntity = getFirstPostEntity(),
              let result = sut.mapPostEntitiesToPosts(from: [postEntity]).first
        else {
            XCTFail("Post Entity casting error")
            return
        }
        
        // Then
        XCTAssertEqual(post, result)
    }
    
    func test_mapPostEntity_withTextType_shouldBeMapped_toPostWithTextInfo() {
        // Given
        let postBlog = PostFormatting.PostFormattingBlogResponse(uuid: "asds", name: "name", url: "http:\\google.es")
        let postFormatting = PostFormatting(start: 1, end: 2, type: "text", url: "http:\\google.es", blog: postBlog, hex: "color")
        let postTextContent = PostTextContent(text: "Text", subtype: nil, formatting: [postFormatting])
        let postTextType: PostType = .text(content: postTextContent)
        let post = Post(id: "1232", name: "asds", date: Date(), type: [postTextType])
        sut.mapPostToPostEntity(from: post, with: LocalDashboardMapperTests.context)
        
        // When
        guard let postEntity = getFirstPostEntity(),
              let result = sut.mapPostEntitiesToPosts(from: [postEntity]).first
        else {
            XCTFail("Post Entity casting error")
            return
        }
        
        // Then
        XCTAssertEqual(post, result)
    }
    
    private func getFirstPostEntity() -> PostEntity? {
        do {
            return (try LocalDashboardMapperTests.context.fetch(getFetch()) as? [PostEntity])?.first
        } catch {
            XCTFail("Error getting PostEntity from CoreData")
        }
        return nil
    }
    
    // Method to remove coredata data
    private func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        let objs = try! LocalDashboardMapperTests.context.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            LocalDashboardMapperTests.context.delete(obj)
        }
        try! LocalDashboardMapperTests.context.save()
    }
    
    private func getFetch() -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
    }
}
