//
//  ImageService.swift
//  NetworkRouter
//
//  Created by Sayeem Hussain on 15/05/2024.
//  Copyright © 2024 sayeem. All rights reserved.
//

import UIKit

enum ImageServiceError: Error {
    
    case invalidURL
    case failed
    case corruptData
}

protocol ImageService {
    func downloadImage(from urlString: String) async throws -> UIImage
}

class DefaultImageService: ImageService {
    
    private let urlSession: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 100 * 1024 * 1024,
            diskPath: "imageCache"
        )
        self.urlSession = URLSession(configuration: config)
    }
    
    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageServiceError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        // Check if the response is cached
        if let cachedResponse = urlSession.configuration.urlCache?.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            return image
        }
        
        // If not cached, fetch the image
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let image = UIImage(data: data) else {
                throw ImageServiceError.corruptData
            }
            
            // Cache the response
            let cachedResponse = CachedURLResponse(response: response, data: data)
            urlSession.configuration.urlCache?.storeCachedResponse(cachedResponse, for: request)
            
            return image
        } catch {
            throw ImageServiceError.failed
        }
    }
}
