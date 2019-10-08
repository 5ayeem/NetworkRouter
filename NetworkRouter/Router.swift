//
//  EndPointType.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    associatedtype ParsedType
    func request(_ route: EndPoint, completion: @escaping (Result<ParsedType>) -> Void)
    func cancel()
}

open class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    private let headers = NetworkManager.shared.defaultHeader
    
    public init() {
        
    }
    
    public func request(_ route: EndPoint, completion: @escaping (Result<EndPoint.ParsedType>) -> Void) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request) { (data, response, error) in
                self.handle(route, data, response, error, completion: completion)
            }
        } catch {
            self.handle(route, nil, nil, error, completion: completion)
        }
        self.task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    func handle(_ route: EndPoint,
                _ data: Data?,
                _ response: URLResponse?,
                _ error: Error?,
                completion: @escaping (Result<ParsedType>) -> Void) {
        if error != nil {
            let error = RequestError(message: NetworkResponse.noNetwork.rawValue, errorCode: nil)
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        if let response = response as? HTTPURLResponse {
            let result = ResponseHandler.handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    let error = RequestError(message: NetworkResponse.noData.rawValue, errorCode: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                do {
                    let apiResponse = try route.parse(data: responseData)
                    DispatchQueue.main.async {
                        completion(.success(apiResponse))
                    }
                } catch {
                    let error = RequestError(message: NetworkResponse.unableToDecode.rawValue, errorCode: nil)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } else {
            let error = RequestError(message: NetworkResponse.failed.rawValue, errorCode: nil)
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        // Method
        request.httpMethod = route.httpMethod.rawValue
        // Header
        headers?.forEach { request.allHTTPHeaderFields?[$0.key] = $0.value }
        // Task
        do {
            switch route.task {
            case .request:
                break
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}

