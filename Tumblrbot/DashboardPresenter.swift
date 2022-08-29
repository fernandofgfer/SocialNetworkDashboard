//
//  DashboardPresenter.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 31/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

class DashboardPresenter {
    weak var view: DashboardViewProtocol?
    internal var interactor: DashboardInteractorProtocol
    private var screenWidth: Int = 0
    
    init(interactor: DashboardInteractorProtocol) {
        self.interactor = interactor
    }
    
    private func getOnlyPostImageNearToScreenWidth(posts: [Post]) -> [Post] {
        return posts.map { post -> Post in
            let typeArray = post.type.map { type -> PostType in
                if case let .image(content: content) = type,
                        let postMedia = getMediaResponseAccordingToWidth(mediaResponseArray: content.media) {
                    
                    return PostType.image(content: PostImageContent(media: [postMedia]))
                } else {
                    return type
                }
            }
            return Post(id: post.id, name: post.name, date: post.date, type: typeArray)
        }
    }
    
    private func getMediaResponseAccordingToWidth(mediaResponseArray: [PostMedia]) -> PostMedia? {
        mediaResponseArray.min(by: { abs(($0.width ?? 0) - screenWidth) < abs(($1.width ?? 0) - screenWidth) })
    }
}

// MARK: - DashboardPresenterProtocol implementation
extension DashboardPresenter: DashboardPresenterProtocol {
    func viewDidLoad() {
        interactor.fetchPosts()
    }
    
    func cellWillDisplay(index: Int) {
        interactor.postWillDisplay(index: index)
    }

    func screenWidthSetted(screenWidth: Int) {
        self.screenWidth = screenWidth
    }
    
    func didRefreshTable() {
        interactor.fetchLastPosts()
    }
}

// MARK: - DashboardInteractorOutputProtocol implementation
extension DashboardPresenter: DashboardInteractorOutputProtocol {
    func postDidFetch(posts: [Post]) {
        view?.showPosts(posts: getOnlyPostImageNearToScreenWidth(posts: posts))
    }
    
    func postDidFetchError(error: ApiClientError) {
        view?.showError(error: error)
    }
    
    func newPostsDidFetch(posts: [Post]) {
        view?.showNewPosts(posts: posts)
    }
    
    func newPostsDidntFetch() {
        view?.stopRefresh()
    }
}
