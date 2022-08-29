//
//  DashboardViewController.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 31/5/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UITableViewController {
    
    private enum Constants {
        static let numSections = 1
        
        static let navigationBackgroundColor: String = "TumblrMain"
        static let navigationbarTintColor: String = "TumblrMain"
        static let viewBackgroundColor: String = "TumblrMain"
        
        static let navigationImage: String = "TumblrLogo"
        static let navigationTitleTintColor: String = "Background"
    }
    
    private lazy var activityIndictor: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .gray)
    }()
        
    var presenter: DashboardPresenterProtocol
    private var posts: [Post] = []
    private var postCellItemFactory: PostCellItemFactoryProtocol
    
    init(presenter: DashboardPresenterProtocol,
         postCellItemFactory: PostCellItemFactoryProtocol) {
        self.presenter = presenter
        self.postCellItemFactory = postCellItemFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.screenWidthSetted(screenWidth: Int(UIScreen.main.bounds.width))
        setupTable()
        setUpRefreshControl()
        addActivityIndicator()
        presenter.viewDidLoad()
    }
    
    private func insertPosts(newPosts: [Post]) {
        let totalPostsCount = posts.count + newPosts.count
        let indexPathsToInsert = (posts.count..<totalPostsCount).map{ IndexPath(row: $0, section: 0) }
        posts.append(contentsOf: newPosts)
        tableView.beginUpdates()
        tableView.insertRows(at: indexPathsToInsert, with: .bottom)
        tableView.endUpdates()
    }
    
    private func setupTable() {
        tableView.register(DashboardCell.self, forCellReuseIdentifier: String(describing: DashboardCell.self))
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func addActivityIndicator() {
        activityIndictor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndictor)
        NSLayoutConstraint.activate([
            activityIndictor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndictor.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndictor.startAnimating()
    }
    private func setupView() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: Constants.navigationBackgroundColor)
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants.navigationbarTintColor)
        self.view.backgroundColor = UIColor(named: Constants.viewBackgroundColor)
        
        let image = UIImage(named: Constants.navigationImage)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        navigationItem.titleView?.tintColor = UIColor(named: Constants.navigationTitleTintColor)
    }
    
    private func setUpRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didRefreshTable), for: .valueChanged)
    }
    
    @objc
    private func didRefreshTable() {
        presenter.didRefreshTable()
    }
}

// MARK: - DashboardViewProtocol implementation
extension DashboardViewController: DashboardViewProtocol {
    func showPosts(posts: [Post]) {
        activityIndictor.stopAnimating()
        insertPosts(newPosts: posts)
    }
    
    func showNewPosts(posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    func stopRefresh() {
        tableView.refreshControl?.endRefreshing()
    }
    
    func showError(error: ApiClientError) {
        // Show error
    }
}

// MARK: - TableView Delegates and Data Source
extension DashboardViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        Constants.numSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DashboardCell.self), for: indexPath) as? DashboardCell,
           posts.indices.contains(indexPath.row) {
            let post = posts[indexPath.row]
            cell.setup(name: post.name, date: post.date, childViews: postCellItemFactory.make(postTypeArray: post.type))
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.cellWillDisplay(index: indexPath.row)
    }
}
