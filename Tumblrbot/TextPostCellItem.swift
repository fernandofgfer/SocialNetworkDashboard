//
//  TextPostCellItem.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 2/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import UIKit

final class TextPostCellItem: PostCellItem {
    
    private enum Constants {
        static let numberOfLinesLabel: Int = 0
        static let fontSize: CGFloat = 18
        
        static let labelTopAnchor: CGFloat = 10.0
        static let labelLeadingAnchor: CGFloat = 10.0
        static let labelTrailingAnchor: CGFloat = -10.0
        static let labelBottomAnchor: CGFloat = -10.0
        
        static let labelFont: UIFont = UIFont(name: "Avenir-Light", size: 18) ?? UIFont.systemFont(ofSize: 18)
        
        static let containerBackgroundColor: String = "Background"
    }
    
    private let screenWidth = UIScreen.main.bounds.width
    
    private let textContent: PostTextContent
    init(textContent: PostTextContent) {
        self.textContent = textContent
    }
    
    func defaultView() -> UIView {        
        let label = getLabel(text: textContent.text)
        let containerView = getContainer(height: label.bounds.height)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.labelTopAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.labelLeadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.labelTrailingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Constants.labelBottomAnchor),
            label.heightAnchor.constraint(equalToConstant: label.bounds.height)
        ])
        
        return containerView
    }
}

// MARK: - Private methods
extension TextPostCellItem {
    
    private func getLabel(text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: .zero,
                                          y: .zero,
                                          width: screenWidth,
                                          height: .greatestFiniteMagnitude))
        label.text = text
        label.font = Constants.labelFont
        label.numberOfLines = Constants.numberOfLinesLabel
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func getContainer(height: CGFloat) -> UIView {
        let containerView = UIView(frame: CGRect(x: .zero, y: .zero, width: screenWidth, height: height))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(named: Constants.containerBackgroundColor)
        
        return containerView
    }
}
