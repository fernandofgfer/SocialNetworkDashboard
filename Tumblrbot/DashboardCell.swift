//
//  DashboardCell.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

final class DashboardCell: UITableViewCell {
    
    private enum Constants {
        static let childViewHeightConstraintPrioprity: Float = 999
        static let stackBackgroundColor: String = "TumblrMain"
        
        static let separatorBackgroundColor: String = "Separator"
        static let separatorHeight: CGFloat = 1.0
        
        static let footerBackgroundColor: String = "TumblrMain"
        static let footerHeight: CGFloat = 10
    }
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor(named: Constants.stackBackgroundColor)
        return stackView
    }()
    
    private lazy var header = HeaderView()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setup(name: String, date: Date, childViews: [UIView]) {
        cleanCell()
        setupConstraints()
        setupViews(childViews: childViews)
        setupProperties(name: name, date: date)
    }
}

// MARK: - Private methods
extension DashboardCell {
    private func setupViews(childViews: [UIView]) {
        contentStackView.addArrangedSubview(header)
        addSeparator(color: UIColor(named: Constants.separatorBackgroundColor) ?? .gray, height: Constants.separatorHeight)
        childViews.forEach{ childView in
            addChildViewToStack(view: childView)
        }
        addSeparator(color: UIColor(named: Constants.footerBackgroundColor) ?? .black, height: Constants.footerHeight)
    }
    
    private func setupConstraints() {
        contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func addChildViewToStack(view: UIView) {
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: view.frame.height)
        heightConstraint.priority = UILayoutPriority(Constants.childViewHeightConstraintPrioprity)
        heightConstraint.isActive = true
        contentStackView.addArrangedSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            heightConstraint
        ])
    }
    
    private func setupProperties(name: String, date: Date) {
        header.setup(nameText: name, dateString: date.getTubmlrDateFormatted())
    }
    
    private func cleanCell() {
        contentStackView.arrangedSubviews.forEach { view in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        contentStackView.removeFromSuperview()
    }
    
    private func addSeparator(color: UIColor, height: CGFloat) {
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: height).isActive = true
        separator.backgroundColor = color
        contentStackView.addArrangedSubview(separator)
    }
}
