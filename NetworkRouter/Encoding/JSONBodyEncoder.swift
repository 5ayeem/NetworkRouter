//
//  ParameterEncoding.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public protocol JSONBodyEncoder {
    
    func encode(urlRequest: inout URLRequest, with model: Encodable) throws
}

public struct DefaultJSONBodyEncoder: JSONBodyEncoder {
    
    public func encode(
        urlRequest: inout URLRequest,
        with model: any Encodable
    ) throws {
        do {
            urlRequest.httpBody = try JSONEncoder().encode(model)
        } catch {
            throw EncodingError.encodingFailed
        }
    }
}
