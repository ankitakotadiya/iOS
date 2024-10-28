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
    func fetchImage(with url: URL) async -> ImageFetchResult
}

class ImageFetcher: ImageFetching {
    static let shared = ImageFetcher()
    private let imageCache = NSCache<NSURL, NSData>()
    let urlSession: URLSession
    let fileStore: FileStoreManager
    
    init(urlSession: URLSession = .shared, fileStore: FileStoreManager = FileStoreManager()) {
        self.urlSession = urlSession
        self.fileStore = fileStore
    }
    
    func fetchImage(with url: URL, completion: @escaping (ImageFetchResult) -> Void) {
        // Check if the image is cached
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            completion(.success(cachedImage as Data))
            return
        }
        
        // If not cached, download it
        let task = urlSession.dataTask(with: url) { data, response, error in
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
    
    func fetchImage(with url: URL) async -> ImageFetchResult {
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            return .success(cachedImage as Data)
        } else if let fileStoreData = fileStore.getImageData(with: url.deletingLastPathComponent().lastPathComponent) {
            return .success(fileStoreData)
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            self.imageCache.setObject(data as NSData, forKey: url as NSURL)
            fileStore.saveImageToDisk(for: data, identifier: url.deletingLastPathComponent().lastPathComponent)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    private func saveImageToDisk(data: Data, with identifier: String) {
        
    }
}
