//
//  Request.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public protocol Request {
    
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var resultType: Codable.Type { get }
    var additionalHeaders: HTTPHeaders { get }
}

extension Request {
    
    var additionalHeaders: HTTPHeaders {
        return [:]
    }
}
