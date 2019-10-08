//
//  Result.swift
//  StarRounder
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public struct RequestError: Error {
    let message: String
    let code: Int?
    
    init(message: String) {
        self.message = message
        self.code = nil
    }
    
    init(message: String, errorCode: Int? = nil) {
        self.message = message
        self.code = errorCode
    }
}
