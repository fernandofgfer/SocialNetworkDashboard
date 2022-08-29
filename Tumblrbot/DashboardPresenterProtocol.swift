//
//  DashboardPresenterProtocol.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 31/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

protocol DashboardPresenterProtocol {
    var view: DashboardViewProtocol? { get set }
    func viewDidLoad()
    func cellWillDisplay(index: Int)
    func screenWidthSetted(screenWidth: Int)
    func didRefreshTable()
}
