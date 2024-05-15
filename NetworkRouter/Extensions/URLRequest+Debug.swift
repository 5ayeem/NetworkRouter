//
//  URLRequest+Debug.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    func debugConsolePrint() {
        let degugString = """
        \(self.httpMethod!) \(self.url!)
        Headers:
        \(self.allHTTPHeaderFields!)
        Body:
        \(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
        """
        print(degugString)
    }
}
