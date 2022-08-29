//
//  StorageDashboardMapper.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import CoreData

protocol StorageDashboardMapperProtocol {
    func mapPostToPostEntity(from post: Post, with context: NSManagedObjectContext)
    func mapPostEntitiesToPosts(from postsEntity: [PostEntity]) -> [Post]
    func mapUpdatePostEntityWithPost(postEntity: PostEntity, with post: Post, with context: NSManagedObjectContext)
}

final class StorageDashboardMapper: StorageDashboardMapperProtocol {

    private enum Contants {
        static let imageType = "image"
        static let videoType = "video"
        static let textType = "text"
    }
    
    func mapPostEntitiesToPosts(from postsEntity: [PostEntity]) -> [Post] {
        return postsEntity.compactMap { postEntity in
            let postTypeArray = map(postContentEntityArray: postEntity.content?.allObjects as? [PostContentEntity] ?? [])
            return Post(id: postEntity.id ?? "",
                 name: postEntity.name ?? "",
                 date: Date(timeIntervalSince1970: TimeInterval(postEntity.timestamp)),
                 type: postTypeArray)
        }
    }
    
    func mapPostToPostEntity(from post: Post, with context: NSManagedObjectContext) {
        let postEntity = PostEntity(context: context)
        mapUpdatePostEntityWithPost(postEntity: postEntity, with: post, with: context)
    }
    
    func mapUpdatePostEntityWithPost(postEntity: PostEntity, with post: Post, with context: NSManagedObjectContext) {
        postEntity.id = post.id
        postEntity.name = post.name
        postEntity.timestamp = Int64(TimeInterval(post.date.timeIntervalSince1970))
        postEntity.content = NSSet(array: map(type: post.type, with: context))
    }
}

// MARK: - Map Post to PostEntity methods
extension StorageDashboardMapper {
    private func map(type: [PostType], with context: NSManagedObjectContext) -> [PostContentEntity] {
        return type.compactMap { postType in
            switch postType {
            case .video(let postVideoContent):
                return map(postVideoContent: postVideoContent, with: context)
            case .image(let postImageContent):
                return map(postImageContent: postImageContent, with: context)
            case .text(let postTextContent):
                return map(postTextContent: postTextContent, with: context)
            }
        }
    }
    
    private func map(postTextContent: PostTextContent, with context: NSManagedObjectContext) -> PostContentEntity {
        let entity = PostContentEntity(context: context)
        entity.type = Contants.textType
        entity.text = postTextContent.text
        entity.subtype = postTextContent.subtype
        entity.addToFormatting(NSSet(array: postTextContent.formatting?.compactMap{ map(postFormatting: $0, with: context) } ?? [] ))
        
        return entity
    }
    
    private func map(postVideoContent: PostVideoContent, with context: NSManagedObjectContext) -> PostContentEntity {
        let entity = PostContentEntity(context: context)
        entity.type = Contants.videoType
        entity.videoMedia = map(postMedia: postVideoContent.media, with: context)
        
        return entity
    }
    
    private func map(postImageContent: PostImageContent, with context: NSManagedObjectContext) -> PostContentEntity {
        let entity = PostContentEntity(context: context)
        entity.type = Contants.imageType
        entity.addToImageMedia(NSSet(array: postImageContent.media.compactMap{  map(postMedia: $0, with: context) } ))
        
        return entity
    }
    
    private func map(postMedia: PostMedia, with context: NSManagedObjectContext) -> PostMediaEntity {
        let entity = PostMediaEntity(context: context)
        entity.url = postMedia.url
        entity.type = postMedia.type
        entity.width = Int16(postMedia.width ?? 0)
        entity.height = Int16(postMedia.height ?? 0)
        
        return entity
    }
    
    private func map(postFormatting: PostFormatting?, with context: NSManagedObjectContext) -> PostFormattingEntity? {
        guard let postFormatting = postFormatting else {
            return nil
        }

        let entity = PostFormattingEntity(context: context)
        entity.start = Int16(postFormatting.start)
        entity.end = Int16(postFormatting.end)
        entity.type = postFormatting.type
        entity.hex = postFormatting.hex
        entity.url = postFormatting.url
        entity.blog = map(postFormattingBlog: postFormatting.blog, with: context)
        
        return entity
    }
    
    private func map(postFormattingBlog: PostFormatting.PostFormattingBlogResponse?, with context: NSManagedObjectContext) -> PostFormattingBlogEntity? {
        guard let postFormattingBlog = postFormattingBlog else {
            return nil
        }

        let entity = PostFormattingBlogEntity(context: context)
        entity.uuid = postFormattingBlog.uuid
        entity.name = postFormattingBlog.name
        entity.url = postFormattingBlog.url
        
        return entity
    }
}

// MARK: - Map PostEntity to Post
extension StorageDashboardMapper {
    private func map(postContentEntityArray: [PostContentEntity]) -> [PostType] {
        return postContentEntityArray.compactMap { postContentEntity in
            switch postContentEntity.type {
            case Contants.textType:
                return .text(content: map(postContentEntity: postContentEntity))
            case Contants.videoType:
                return .video(content: map(postMediaEntity: postContentEntity.videoMedia))
            case Contants.imageType:
                return .image(content: map(postMediaEntityArray: postContentEntity.imageMedia?.allObjects as? [PostMediaEntity]))
            default:
                return nil
            }
        }
        
    }
    
    private func map(postContentEntity: PostContentEntity) -> PostTextContent {
            PostTextContent(text: postContentEntity.text ?? "",
                            subtype: postContentEntity.subtype,
                            formatting: (postContentEntity.formatting?.allObjects as? [PostFormattingEntity])?.compactMap{ map(postFormattingEntity: $0) })
        
    }
    
    private func map(postFormattingEntity: PostFormattingEntity?) -> PostFormatting? {
        guard let postFormattingEntity = postFormattingEntity else {
            return nil
        }

        return PostFormatting(start: Int(postFormattingEntity.start),
                              end: Int(postFormattingEntity.end),
                              type: postFormattingEntity.type,
                              url: postFormattingEntity.url,
                              blog: PostFormatting.PostFormattingBlogResponse(uuid: postFormattingEntity.blog?.uuid,
                                                                              name: postFormattingEntity.blog?.name,
                                                                              url: postFormattingEntity.blog?.url),
                              hex: postFormattingEntity.hex)
    }
    
    private func map(postMediaEntity: PostMediaEntity?) -> PostVideoContent {
        return PostVideoContent(media: PostMedia(url: postMediaEntity?.url ?? "",
                                                 type: postMediaEntity?.type,
                                                 width: Int(postMediaEntity?.width ?? 0),
                                                 height: Int(postMediaEntity?.height ?? 0)))
    }
    
    private func map(postMediaEntityArray: [PostMediaEntity]?) -> PostImageContent {
        PostImageContent(media: postMediaEntityArray?.compactMap({ postMediaEntity in
            PostMedia(url: postMediaEntity.url ?? "",
                      type: postMediaEntity.type,
                      width: Int(postMediaEntity.width),
                      height: Int(postMediaEntity.height))
        }) ?? [])
    }
}
