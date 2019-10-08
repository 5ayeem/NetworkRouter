//
//  EndPointType.swift
//  StarRounder
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public protocol EndPointType: Request, JsonParsing { }

public extension EndPointType {
    
    var baseURLString: String {
        guard let url = NetworkManager.shared.defaultBaseURL else { fatalError("baseURLString could not be configured.") }
        return url
    }
    
    var baseURL: URL {
        guard let url = URL(string: baseURLString) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
}

public protocol JsonParsing {
    associatedtype ParsedType
    func parse(data: Data) throws -> ParsedType
}

public protocol Request {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
