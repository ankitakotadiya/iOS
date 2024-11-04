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
    func fetchImage(with url: URL) async -> ImageFetchResult
}

class ImageFetcher: ImageFetching {
    static let shared = ImageFetcher()
    private let imageCache = NSCache<NSURL, NSData>()
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchImage(with url: URL) async -> ImageFetchResult {
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            return .success(cachedImage as Data)
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            self.imageCache.setObject(data as NSData, forKey: url as NSURL)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
