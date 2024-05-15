//
//  NetworkResponseHandler.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation

class NetworkResponseHandler {
    
    class func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Any, NetworkResponse> {
        switch response.statusCode {
        case 200...299:
            return .success(())
        case 400:
            return .failure(NetworkResponse.badRequest(response.statusCode))
        case 401:
            return .failure(NetworkResponse.authenticationError(response.statusCode))
        case 403:
            return .failure(NetworkResponse.forbidden(response.statusCode))
        case 404:
            return .failure(NetworkResponse.notFound(response.statusCode))
        case 500...599:
            return .failure(NetworkResponse.serverError(response.statusCode))
        default:
            return .failure(NetworkResponse.failed)
        }
    }
}
