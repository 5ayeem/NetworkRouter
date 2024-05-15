//
//  NetworkConfigurations.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public protocol NetworkConfigurations {
    
    var baseURLString: String { get }
    var headers: [String: String] { get }
    var baseURL: URL { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var sessionType: URLSessionConfiguration { get }
    var timeoutInterval: TimeInterval { get }
}
