//
//  MockURLSession.swift
//  NetworkRouterTests
//
//  Created by Sayeem Hussain on 10/8/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation
@testable import NetworkRouter

class MockURLSession: URLSessionProtocol {
    
    var queue: DispatchQueue?
    
    func givenQueue() {
        queue = DispatchQueue.main
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTaskProtocol {
        let task = MockURLSessionDataTask(
            url: request.url,
            completion: completionHandler
        )
        completionHandler(nil, nil, nil)
        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    let url: URL?
    let completion: CompletionHandler
    var resumeCalled = false
    var cancelCalled = false
    
    init(url: URL?, completion: @escaping CompletionHandler) {
        self.url = url
        self.completion = completion
    }
    
    func resume() {
        resumeCalled = true
    }
    
    func cancel() {
        cancelCalled = true
    }
}
