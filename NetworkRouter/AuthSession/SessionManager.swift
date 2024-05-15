//
//  SessionManager.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation
//import KeychainSwift

protocol SessionManager {
    func getToken() -> String?
    func store(token: String)
    func deleteToken()
}

class DefaultSessionManager: SessionManager {
    
//    private let keychain = KeychainSwift()
    private let tokenKey = "AuthToken"
    
    // MARK: - Token Operations
    
    func getToken() -> String? {
//        return keychain.get(tokenKey)
        return nil
    }
    
    func store(token: String) {
//        keychain.set(token, forKey: tokenKey)
    }
    
    func deleteToken() {
//        keychain.delete(tokenKey)
    }
}

