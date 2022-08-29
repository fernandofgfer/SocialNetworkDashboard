//
//  Date+extensions.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 6/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation

extension Date {
    func getTubmlrDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }
}
