//
//  ImageDowloader.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 5/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

protocol ImageDownloadable {
    static func getData(url: URL, completion: @escaping (Data?) -> Void)
}

final class ImageDownloader: ImageDownloadable {
    static private func download(url: URL, file: URL, completion: @escaping () -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, _, _ in
            guard let tempURL = tempURL else {
                completion()
                return
            }
            
            do {
                if FileManager.default.fileExists(atPath: file.path){
                    _ = try FileManager.default.replaceItemAt(file, withItemAt: tempURL)
                } else {
                    try FileManager.default.copyItem(at: tempURL, to: file)
                }
                completion()
            } catch {
                completion()
            }
            
        }
        task.resume()
    }
    
    static func getData(url: URL, completion: @escaping (Data?) -> Void) {
        let imageFile = FileManager.default.temporaryDirectory.appendingPathComponent(url.path.replacingOccurrences(of: "/", with: "-"), isDirectory: false)
        
        if let data = NSData(contentsOfFile: imageFile.path) {
            completion(data as Data)
        } else {
            download(url: url, file: imageFile) {
                let data = NSData(contentsOfFile: imageFile.path)
                completion(data as Data?)
            }
        }
    }
}
