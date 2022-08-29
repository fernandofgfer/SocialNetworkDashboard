//
//  ImagePostCellItem.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

final class ImagePostCellItem: PostCellItem {
    
    private enum Constants {
        static let imageBackgroundColor: String = "Background"
    }
    
    private let imageContent: PostImageContent
    private let imageDownloader: ImageDownloadable.Type
    init(imageContent: PostImageContent,
         imageDownloader: ImageDownloadable.Type) {
        self.imageContent = imageContent
        self.imageDownloader = imageDownloader
    }
    
    func defaultView() -> UIView {
        
        guard let imageMedia = imageContent.media.first,
              let url = URL(string: imageMedia.url) else { return UIView() }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageMedia.width ?? 0, height: imageMedia.height ?? 0))
        
        imageDownloader.getData(url: url) { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(named: Constants.imageBackgroundColor)
        return imageView
    }
}
