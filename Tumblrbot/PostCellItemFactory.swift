//
//  PostCellItemFactory.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

protocol PostCellItemFactoryProtocol {
    func make(postTypeArray: [PostType]) -> [UIView]
}

final class PostCellItemFactory: PostCellItemFactoryProtocol {
    
    private let imageDownloader: ImageDownloadable.Type
    init(imageDownloader: ImageDownloadable.Type) {
        self.imageDownloader = imageDownloader
    }
    
    func make(postTypeArray: [PostType]) -> [UIView] {
        return postTypeArray.map { postType in
            switch postType {
            case .text(let textContent):
                return TextPostCellItem(textContent: textContent).defaultView()
            case .image(let imageContent):
                return ImagePostCellItem(imageContent: imageContent,
                                         imageDownloader: imageDownloader).defaultView()
            case .video(let videoContent):
                return VideoPostCellItem(videoContent: videoContent).defaultView()
            }
        }
    }
}
