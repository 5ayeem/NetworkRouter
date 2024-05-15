//
//  URLParameterEncoder.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol URLParameterEncoder {
    
    func encode(urlRequest: inout URLRequest, with parameters: Encodable) throws
}

public struct DefaultURLParameterEncoder: URLParameterEncoder {
    
    public func encode(
        urlRequest: inout URLRequest,
        with parameters: Encodable
    ) throws {
        guard let url = urlRequest.url else {
            throw EncodingError.missingURL
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw EncodingError.invalidURL
        }
        guard let parameters = try? parameters.toDictionary() else {
            throw EncodingError.encodingFailed
        }
        guard !parameters.isEmpty else {
            throw EncodingError.noParameters
        }
        
        let queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        }
        
        urlComponents.queryItems = queryItems
        urlRequest.url = urlComponents.url
    }
}
