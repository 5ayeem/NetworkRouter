//
//  URLRequestEncoding.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation

public enum URLRequestEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    public func encode(
        urlRequest: inout URLRequest,
        urlParameters: Encodable?,
        bodyParameters: Encodable?
    ) throws {
        switch self {
        case .urlEncoding:
            guard let urlParameters = urlParameters else {
                return
            }
            try DefaultURLParameterEncoder().encode(
                urlRequest: &urlRequest,
                with: urlParameters
            )
        case .jsonEncoding:
            guard let bodyParameters = bodyParameters else {
                return
            }
            try DefaultJSONBodyEncoder().encode(
                urlRequest: &urlRequest,
                with: bodyParameters
            )
        case .urlAndJsonEncoding:
            guard let bodyParameters = bodyParameters,
                  let urlParameters = urlParameters else {
                return
            }
            try DefaultURLParameterEncoder().encode(
                urlRequest: &urlRequest,
                with: urlParameters
            )
            try DefaultJSONBodyEncoder().encode(
                urlRequest: &urlRequest,
                with: bodyParameters
            )
        }
    }
}
