//
//  PostMapper.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 30/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

protocol PostMapperProtocol {
    func map(dashboardResponse: DashboardResponse) -> [Post]
}

final class PostMapper: PostMapperProtocol {
    
    private enum Constants {
        static let textType = "text"
        static let imageType = "image"
        static let videoType = "video"
    }
    
    func map(dashboardResponse: DashboardResponse) -> [Post] {
        dashboardResponse.posts.compactMap { postResponse in
            let content = postResponse.content.isEmpty ? postResponse.trail.flatMap{ $0.content } : postResponse.content
            return Post(id: String(postResponse.id),
                        name: postResponse.blogName,
                        date: Date(timeIntervalSince1970: TimeInterval(postResponse.timestamp)),
                        type: getContentByType(content: content))
        }
    }
    
    private func getContentByType(content: [ContentResponse]) -> [PostType] {
       return content.compactMap { content in
            switch content.type {
            case Constants.textType:
                return .text(content: makePostTextContent(content: content) )
            case Constants.imageType:
                if case let .mediaImages(mediaImages) = content.media {
                    return .image(content:  makePostImageContent(mediaResponseArray: mediaImages))
                }
            case Constants.videoType:
                if case let .media(mediaVideo) = content.media {
                    return .video(content:  makePostVideoContent(mediaResponse: mediaVideo))
                }
            default:
                return nil
            }
            return nil
        }
        
    }

    private func makePostImageContent(mediaResponseArray: [MediaResponse]) -> PostImageContent {
        return PostImageContent(media: mediaResponseArray.compactMap{ PostMedia(url: $0.url,
                                                                              type: $0.type,
                                                                              width: $0.width,
                                                                              height: $0.height) })

    }
    
    private func makePostTextContent(content: ContentResponse) -> PostTextContent {
        return PostTextContent(text: content.text ?? "",
                               subtype: content.subtype,
                               formatting: content.formatting?.compactMap{ PostFormatting(start: $0.start,
                                                                                         end: $0.end,
                                                                                         type: $0.type,
                                                                                         url: $0.url,
                                                                                          blog: makePostFormattingBlogResponse(blogResponse: $0.blog),
                                                                                         hex: $0.hex) })
    }
    
    private func makePostVideoContent(mediaResponse: MediaResponse) -> PostVideoContent {
        return PostVideoContent(media: PostMedia(url: mediaResponse.url,
                                                 type: mediaResponse.type,
                                                 width: mediaResponse.width,
                                                 height: mediaResponse.height))
    }
    
    private func makePostFormattingBlogResponse(blogResponse: FormattingResponse.FormattingBlogResponse?) -> PostFormatting.PostFormattingBlogResponse? {
        guard let blogResponse = blogResponse else {
            return nil
        }
        return PostFormatting.PostFormattingBlogResponse(uuid: blogResponse.uuid,
                                                         name: blogResponse.name,
                                                         url: blogResponse.url)
    }
}
