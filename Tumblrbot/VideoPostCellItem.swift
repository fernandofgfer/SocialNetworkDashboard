//
//  VideoPostCellItem.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

final class VideoPostCellItem: PostCellItem {
    
    private let videoContent: PostVideoContent
    init(videoContent: PostVideoContent) {
        self.videoContent = videoContent
    }
    
    func defaultView() -> UIView {
        UIView()
    }
}
