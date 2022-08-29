//
//  DashboardInteractorProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 31/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

protocol DashboardInteractorProtocol {
    var delegate: DashboardInteractorOutputProtocol? { get set }
    func fetchPosts()
    func postWillDisplay(index: Int)
    func fetchLastPosts()
}

protocol DashboardInteractorOutputProtocol: AnyObject {
    func postDidFetch(posts: [Post])
    func newPostsDidFetch(posts: [Post])
    func postDidFetchError(error: ApiClientError)
    func newPostsDidntFetch()
}
