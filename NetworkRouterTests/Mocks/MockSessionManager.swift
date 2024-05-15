//
//  MockSessionManager.swift
//  NetworkRouterTests
//
//  Created by Sayeem Hussain on 10/8/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import Foundation
@testable import NetworkRouter

class MockSessionManager: SessionManager {
    func getToken() -> String? {
        return nil
    }
    
    func store(token: String) {
        
    }
    
    func deleteToken() {
        
    }
}
