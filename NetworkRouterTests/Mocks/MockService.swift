//
//  MockAPI.swift
//  NetworkRouterTests
//
//  Created by Sayeem Hussain on 10/8/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation
@testable import NetworkRouter

enum MockAPI: Request {
    
    case getTest
}

extension MockAPI {
    
    var resultType: any Codable.Type {
        switch self {
        case .getTest:
            return MockModel.self
        }
    }
    
    var path: String {
        switch self {
        case .getTest:
            return "/test"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getTest:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getTest:
            return .request
        }
    }
}
