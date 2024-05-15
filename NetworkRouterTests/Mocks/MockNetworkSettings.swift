//
//  MockNetworkSettings.swift
//  NetworkRouterTests
//
//  Created by Sayeem Hussain on 10/8/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation
@testable import NetworkRouter

class MockNetworkSettings: NetworkConfigurations {
    
    var cahcePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
    
    var baseURLString: String {
        return "https://api.stackexchange.com"
    }
    
    var headers: [String: String] {
        return [
            "Accept":"application/json",
        ]
    }
    
    var baseURL: URL {
        guard let url = URL(string: baseURLString) else {
            fatalError("urlString failed: \(baseURLString)")
        }
        
        return url
    }
    
    var sessionType: URLSessionConfiguration {
        return .default
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }
    
    var timeoutInterval: TimeInterval {
        return 1
    }
}
