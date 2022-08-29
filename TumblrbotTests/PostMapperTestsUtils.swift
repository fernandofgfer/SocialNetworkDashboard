//
//  PostMapperUtils.swift
//  TumblrbotTests
//
//  Created by Fernando Garcia Fernandez on 30/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
@testable import Tumblrbot

class PostMapperTestsUtils {
    static var dashboardResponseWithText = DashboardResponse(posts: [PostResponse(id: 234234, blogName: "Test name", timestamp: 1653924294, content: [ContentResponse(type: "text", text: "Test text", subtype: nil, formatting: [FormattingResponse(start: 0, end: 10, type: "bold", url: nil, blog: FormattingResponse.FormattingBlogResponse(uuid: "1j23nd", name: "Test", url: "http:\\google.es"), hex: "#0057a4")], media: nil)], trail: [])])
    
    static var dashboardResponseWithImage = DashboardResponse(posts: [PostResponse(id: 56432,
                                                                                   blogName: "Test image name",
                                                                                   timestamp: 1653924294,
                                                                                   content: [ContentResponse(type: "image",
                                                                                                             text: nil,
                                                                                                             subtype: nil,
                                                                                                             formatting: nil,
                                                                                                             media: .mediaImages([MediaResponse(url: "http:\\google.es",
                                                                                                                                                type: "image",
                                                                                                                                                width: 500,
                                                                                                                                                height: 300)]) )], trail: [])])
    
    static var dashboardResponseWithVideo = DashboardResponse(posts: [PostResponse(id: 56432,
                                                                                   blogName: "Test video name",
                                                                                   timestamp: 1653924294,
                                                                                   content: [ContentResponse(type: "video",
                                                                                                             text: nil,
                                                                                                             subtype: nil,
                                                                                                             formatting: nil,
                                                                                                             media: .media(MediaResponse(url: "http:\\google.es",
                                                                                                                                                type: "video",
                                                                                                                                                width: 500,
                                                                                                                                         height: 300)))], trail: [])])
    
    static var dashboardResponseWithAudio = DashboardResponse(posts: [PostResponse(id: 56432,
                                                                                   blogName: "Test audio name",
                                                                                   timestamp: 1653924294,
                                                                                   content: [ContentResponse(type: "audio",
                                                                                                             text: nil,
                                                                                                             subtype: nil,
                                                                                                             formatting: nil,
                                                                                                             media: .media(MediaResponse(url: "http:\\google.es",
                                                                                                                                                type: "video",
                                                                                                                                                width: 500,
                                                                                                                                         height: 300)))], trail: [])])
    
    static var dashboardResponseWithTwoImages = DashboardResponse(posts: [PostResponse(id: 56432,
                                                                                   blogName: "Test image name",
                                                                                   timestamp: 1653924294,
                                                                                   content: [ContentResponse(type: "image",
                                                                                                             text: nil,
                                                                                                             subtype: nil,
                                                                                                             formatting: nil,
                                                                                                             media: .mediaImages([MediaResponse(url: "http:\\google.es",
                                                                                                                                                type: "image",
                                                                                                                                                width: 1000,
                                                                                                                                                height: 300),
                                                                                                                                  MediaResponse(url: "http:\\google.es",
                                                                                                                                                type: "image",
                                                                                                                                                width: 500,
                                                                                                                                                height: 300)]) )], trail: [])])
    
    
}
