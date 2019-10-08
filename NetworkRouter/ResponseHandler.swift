//
//  ResponseHandler.swift
//  StarRounder
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case noNetwork = "Please check your network connection."
}

public class ResponseHandler {
    
    class func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Any> {
        switch response.statusCode {
        case 200...299:
            return .success(Void())
        case 401...500:
            let error = RequestError(message: NetworkResponse.authenticationError.rawValue,
                                      errorCode: response.statusCode)
            return .failure(error)
        case 501...599:
            let error = RequestError(message: NetworkResponse.badRequest.rawValue,
                                      errorCode: response.statusCode)
            return .failure(error)
        case 600:
            let error = RequestError(message: NetworkResponse.outdated.rawValue,
                                      errorCode: response.statusCode)
            return .failure(error)
        default:
            let error = RequestError(message: NetworkResponse.failed.rawValue,
                                      errorCode: response.statusCode)
            return .failure(error)
        }
    }
    
}
