//
//  NetworkResponse.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation

public enum NetworkResponse: Error, Equatable {
    
    case success
    case authenticationError(_ statusCode: Int)
    case badRequest(_ statusCode: Int)
    case forbidden(_ statusCode: Int)
    case notFound(_ statusCode: Int)
    case serverError(_ statusCode: Int)
    case failed
    case noData
    case unableToDecode
    case unableToConstructRequest
    case noNetwork
    
    public var defaultMessage: String {
        switch self {
        case .success:
            return ""
        case .authenticationError:
            return "Authentication failed. Please log in again."
        case .badRequest:
            return "Invalid request. Please check your input and try again."
        case .forbidden:
            return "You don't have permission to access this resource."
        case .notFound:
            return "The requested resource could not be found."
        case .serverError:
            return "An unexpected server error occurred. Please try again later."
        case .failed:
            return "Failed to complete the network request. Please try again later."
        case .noData:
            return "No data received from the server."
        case .unableToDecode:
            return "Failed to decode the server response."
        case .unableToConstructRequest:
            return "Failed to encode paramaters for network request"
        case .noNetwork:
            return "No network connection. Please check your internet connection."
        }
    }
}
