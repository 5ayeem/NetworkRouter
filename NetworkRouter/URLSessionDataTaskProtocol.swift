//
//  URLSessionDataTaskProtocol.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation

public typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

public protocol URLSessionProtocol {
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTaskProtocol
}

public protocol URLSessionDataTaskProtocol {
    
    func resume()
    func cancel()
}

extension URLSession: URLSessionProtocol {
    
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTaskProtocol {
        return dataTask(
            with: request,
            completionHandler: completionHandler
        ) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
