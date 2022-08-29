//
//  DashboardAssembler.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 31/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

final class Assembler: AssemblerProtocol {
        
    private let apiClient: ApiClientProtocol
    private let coreDataManager: CoreDataManagerProtocol
    
    init(apiClient: ApiClientProtocol,
         coreDataManager: CoreDataManagerProtocol) {
        self.apiClient = apiClient
        self.coreDataManager = coreDataManager
    }
    
    func provideDashboard() -> UIViewController {
        let networkDashboardDataManager = NetworkDashboardDataManager(apiClient: apiClient,
                                                                      dashboardMapper: PostMapper())
        let storageDashaboardDataManager = StorageDashboardDataManager(storageClient: coreDataManager,
                                                                       mapper: StorageDashboardMapper())
        let postCellItemFactory: PostCellItemFactoryProtocol = PostCellItemFactory(imageDownloader: ImageDownloader.self)
        
        let interactor = DashboardInteractor(networkDashboardDataManager: networkDashboardDataManager,
                                             storageDashboardDataManager: storageDashaboardDataManager, reachabilityProvider: ReachabilityProvider())
        let presenter = DashboardPresenter(interactor: interactor)
        let viewController = DashboardViewController(presenter: presenter,
                                                     postCellItemFactory: postCellItemFactory)
        
        interactor.delegate = presenter
        presenter.view = viewController
        
        return UINavigationController(rootViewController: viewController)
    }
}
