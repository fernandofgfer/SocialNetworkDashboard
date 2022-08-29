//
//  DashboardResponse.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 29/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

/// Dashboard response by https://www.tumblr.com/docs/npf

struct DashboardResponse: Decodable {
    let posts: [PostResponse]
}

struct PostResponse: Decodable {
    let id: Int
    let blogName: String
    let timestamp: Int
    let content: [ContentResponse]
    let trail: [PostTrailResponse]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case blogName = "blog_name"
        case timestamp
        case content
        case trail
    }
}

struct ContentResponse: Decodable {
    let type: String
    let text: String?
    let subtype: String?
    let formatting: [FormattingResponse]?
    let media: ContentMediaReponse?
    
    enum ContentMediaReponse: Decodable {
        case mediaImages([MediaResponse])
        case media(MediaResponse)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let media = try? container.decode([MediaResponse].self) {
                self = .mediaImages(media)
                return
            }
            if let media = try? container.decode(MediaResponse.self) {
                self = .media(media)
                return
            }
            throw DecodingError.typeMismatch(ContentMediaReponse.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong decoding ContentMediaReponse"))
        }
    }
}

struct PostTrailResponse: Decodable {
    let content: [ContentResponse]
}

struct FormattingResponse: Decodable {
    let start: Int
    let end: Int
    let type: String
    let url: String?
    let blog: FormattingBlogResponse?
    let hex: String?
    
    struct FormattingBlogResponse: Decodable {
        let uuid: String
        let name: String
        let url: String
    }
}

struct MediaResponse: Decodable {
    let url: String
    let type: String?
    let width: Int?
    let height: Int?
}
