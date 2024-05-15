//
//  Router.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public typealias NetworkCompletion<T> = (Result<T, NetworkResponse>) -> Void

public protocol NetworkRouter: AnyObject {
    
    @discardableResult
    func request<T: Decodable>(_ route: Request, completion: @escaping NetworkCompletion<T>) -> URLSessionDataTaskProtocol?
    func cancel()
}

class Router: NetworkRouter {
    
    // MARK: - Properties
    
    let session: URLSessionProtocol
    var task: URLSessionDataTaskProtocol?
    let responseQueue: DispatchQueue
    let networkConfigurations: NetworkConfigurations
    let authManager: SessionManager
    
    // MARK: - Initializers
    
    public init(
        session: URLSessionProtocol,
        responseQueue: DispatchQueue,
        networkConfigurations: NetworkConfigurations,
        authManager: SessionManager
    ) {
        self.session = session
        self.responseQueue = responseQueue
        self.networkConfigurations = networkConfigurations
        self.authManager = authManager
    }
    
    // MARK: - Methods
    
    @discardableResult
    public func request<T: Decodable>(_ route: Request, completion: @escaping NetworkCompletion<T>) -> URLSessionDataTaskProtocol? {
        do {
            let request = try buildRequest(from: route)
            task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                self.handleResponse(for: route, data: data, response: response, error: error, completion: completion)
            }
            task?.resume()
            return task
        } catch {
            completion(.failure(NetworkResponse.unableToConstructRequest))
            return nil
        }
    }
    
    public func cancel() {
        task?.cancel()
    }
    
    // MARK: - Helpers
    
    func handleResponse<T: Decodable>(
        for route: Request,
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping NetworkCompletion<T>
    ) {
        // Handle error
        if let _ = error {
            responseQueue.async {
                completion(.failure(NetworkResponse.noNetwork))
            }
            return
        }
        
        // Handle no HTTPURLResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            responseQueue.async {
                completion(.failure(NetworkResponse.failed))
            }
            return
        }
        
        // Handle HTTP status codes
        switch NetworkResponseHandler.handleNetworkResponse(httpResponse) {
        case .success:
            guard let responseData = data else {
                responseQueue.async {
                    completion(.failure(NetworkResponse.noData))
                }
                return
            }
            // Decode response data
            do {
                let model = try JSONDecoder().decode(route.resultType, from: responseData)
                responseQueue.async {
                    completion(.success(model as! T))
                }
            } catch {
                responseQueue.async {
                    completion(.failure(NetworkResponse.unableToDecode))
                }
            }
        case .failure(let error):
            responseQueue.async {
                completion(.failure(error))
            }
        }
    }
    
    func buildRequest(from route: Request) throws -> URLRequest {
        // Create Request
        var request = URLRequest(
            url: networkConfigurations.baseURL.appendingPathComponent(route.path),
            cachePolicy: networkConfigurations.cachePolicy,
            timeoutInterval: networkConfigurations.timeoutInterval
        )
        
        // Set httpMethod
        request.httpMethod = route.httpMethod.rawValue
        
        // Set default headers
        networkConfigurations.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set auth headers
        addAuthorizationHeader(networkConfigurations.headers, request: &request)
        
        // Add additional headers
        route.additionalHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Encode parameters
        switch route.task {
        case .request:
            break
        case .requestWith(let urlParameters, let bodyParameters, let encoder):
            try encoder.encode(
                urlRequest: &request,
                urlParameters: urlParameters,
                bodyParameters: bodyParameters
            )
        }
        return request
    }
    
    private func addAuthorizationHeader(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let token = authManager.getToken() else {
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
