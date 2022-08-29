//
//  DashboardViewProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 31/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

protocol DashboardViewProtocol: AnyObject {
    var presenter: DashboardPresenterProtocol { get }
    func showPosts(posts: [Post])
    func showError(error: ApiClientError)
    func showNewPosts(posts: [Post])
    func stopRefresh()
}
