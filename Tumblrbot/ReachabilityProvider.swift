//
//  ReachabilityProvider.swift
//  Tumblrbot
//
//  Created by Fernando Garcia Fernandez on 6/6/22.
//  Copyright © 2022 Tumblr. All rights reserved.
//

import Foundation
import Reachability

protocol ReachabilityProviderProtocol {
    var isReachable: Bool { get }
}

final class ReachabilityProvider: ReachabilityProviderProtocol {
    private lazy var reachability: Reachability? = {
        do {
            return try Reachability()
        } catch {
            print("Unable to use Reachability")
            return nil
        }
    }()
    
    init() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }
    
    deinit {
        reachability?.stopNotifier()
    }
    
    var isReachable: Bool {
        reachability?.connection != .unavailable
    }
}
