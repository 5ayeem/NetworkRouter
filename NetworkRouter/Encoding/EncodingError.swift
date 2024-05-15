//
//  EncodingError.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation

public enum EncodingError: String, Error {
    
    case noParameters = "No parameters to encode."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
    case invalidURL = "URL is invalid."
}
