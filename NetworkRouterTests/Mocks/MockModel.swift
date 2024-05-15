//
//  MockModel.swift
//  NetworkRouterTests
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation

struct MockModel: Hashable, Codable {
    
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}
