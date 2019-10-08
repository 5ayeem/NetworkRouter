//
//  NetworkMananger.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 7/21/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation

public class NetworkManager {
    public static let shared = NetworkManager()
    
    public var defaultBaseURL: String?
    public var defaultHeader: [String: String]?
        
    public func setDefault(baseURL: String, header: [String: String]?) {
        defaultBaseURL = baseURL
        defaultHeader = header
    }
}
