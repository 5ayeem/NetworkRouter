//
//  HTTPTask.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    
    case request
    
    case requestWith(
        urlParameters: Encodable?,
        bodyParameters: Encodable?,
        encoding: URLRequestEncoding
    )
    
    // case download, upload...etc
}
