//
//  HeaderView.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 13/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

final class HeaderView: UIView {
    
    private enum Constants {
        static let nameLabelFont: UIFont = UIFont(name: "Avenir-Black", size: 18) ?? UIFont.systemFont(ofSize: 18)
        static let followLabelFont: UIFont = UIFont(name: "Avenir-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
        static let followFontColor: UIColor = .blue
        
        static let viewBackgroundColor: String = "Background"
        
        static let nameLabelTopAnchor: CGFloat = 10.0
        static let nameLabelLeadingAnchor: CGFloat = 10.0
        static let nameLabelBottomAnchor: CGFloat = -10.0
        
        static let followLabelTopAnchor: CGFloat = 10.0
        static let followLabelLeadingAnchor: CGFloat = 10.0
        static let followLabelTrailingAnchor: CGFloat = -10.0
        static let followLabelBottomAnchor: CGFloat = -10.0
        
        static let followKey: String = "headerView.follow"
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Constants.nameLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var followLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Constants.followLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.followFontColor
        return label
    }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setup(nameText: String, dateString: String) {
        nameLabel.text = nameText
        followLabel.text = NSLocalizedString(Constants.followKey, comment: "Follow")
        setupViews()
    }
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(followLabel)
        setupContraints()
        backgroundColor = UIColor(named: Constants.viewBackgroundColor)
    }
    
    private func setupContraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.nameLabelTopAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.nameLabelLeadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.nameLabelBottomAnchor),
            
            followLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.followLabelTopAnchor),
            followLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: Constants.followLabelLeadingAnchor),
            followLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.followLabelTrailingAnchor),
            followLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.followLabelBottomAnchor)
        ])
    }
}
