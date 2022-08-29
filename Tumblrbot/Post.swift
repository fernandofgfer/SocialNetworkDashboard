//
//  Post.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 30/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

enum PostType: Equatable {
    case text(content: PostTextContent)
    case image(content: PostImageContent)
    case video(content: PostVideoContent)
}

struct Post: Equatable {
    let id: String
    let name: String
    let date: Date
    let type: [PostType]
    
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && Calendar.current.compare(lhs.date, to: rhs.date, toGranularity: .second) == .orderedSame
    }
}

// MARK: - Media struct
struct PostMedia: Equatable {
    let url: String
    let type: String?
    let width: Int?
    let height: Int?
}

// MARK: - Text type structs
struct PostTextContent: Equatable {
    let text: String
    let subtype: String?
    let formatting: [PostFormatting]?
}

struct PostFormatting: Equatable {
    let start: Int
    let end: Int
    let type: String?
    let url: String?
    let blog: PostFormattingBlogResponse?
    let hex: String?
    
    struct PostFormattingBlogResponse: Equatable {
        let uuid: String?
        let name: String?
        let url: String?
    }
}

// MARK: - Image type structs
struct PostImageContent: Equatable {
    let media: [PostMedia]
}

// MARK: - Video type structs
struct PostVideoContent: Equatable {
    let media: PostMedia
}
