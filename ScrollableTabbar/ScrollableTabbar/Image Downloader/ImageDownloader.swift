//
//  ImageDownloader.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation

import UIKit

enum ImageFetchResult {
    case success(Data)
    case failure(Error)
}

protocol ImageFetching: AnyObject {
    func fetchImage(with url: URL, completion: @escaping (ImageFetchResult) -> Void)
}

class ImageFetcher: ImageFetching {
    static let shared = ImageFetcher()
    private let imageCache = NSCache<NSURL, NSData>()
    
    private init() {}
    
    func fetchImage(with url: URL, completion: @escaping (ImageFetchResult) -> Void) {
        // Check if the image is cached
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            completion(.success(cachedImage as Data))
            return
        }
        
        // If not cached, download it
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "ImageFetchingError", code: -1, userInfo: nil)))
                return
            }
            
            // Cache the downloaded image
            self.imageCache.setObject(data as NSData, forKey: url as NSURL)
            completion(.success(data))
        }
        task.resume()
    }
}
