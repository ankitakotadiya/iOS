//
//  ImageDescriptor.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 19/10/24.
//

import Foundation
import UIKit

struct ImageConfiguration<ImageSource> {
    var source: ImageSource
    var properties: UIImageView.ImageViewProperties
    var imageDownloader: ImageFetching
    
    init(source: ImageSource, properties: UIImageView.ImageViewProperties = UIImageView.ImageViewProperties(), imageDownloader: ImageFetching = ImageFetcher.shared) {
        self.source = source
        self.properties = properties
        self.imageDownloader = imageDownloader
    }
}

extension UIImageView {
    struct ImageViewProperties {
        var contentMode: UIView.ContentMode
        var backgroundColor: UIColor
        var tintColor: UIColor
        var accessibilityIdentifier: String?
        
        init(contentMode: UIView.ContentMode = .scaleAspectFit, backgroundColor: UIColor = .clear, tintColor: UIColor = .clear, accessibilityIdentifier: String? = nil) {
            self.contentMode = contentMode
            self.backgroundColor = backgroundColor
            self.tintColor = tintColor
            self.accessibilityIdentifier = accessibilityIdentifier
        }
    }
}

extension UIImageView {
    func setImage(from url: URL, _properties: ImageViewProperties = ImageViewProperties()) {
        let imageConfiguration: ImageConfiguration = ImageConfiguration<URL>(source: url, properties: _properties)
        apply(imageConfiguration)
    }
    
    func setImage(from image: UIImage, _properties: ImageViewProperties = ImageViewProperties()) {
        let imageConfiguration: ImageConfiguration = ImageConfiguration<UIImage>(source: image, properties: _properties)
        apply(imageConfiguration)
    }
    
    private func applyProperties(from properties: ImageViewProperties) {
        contentMode = properties.contentMode
        backgroundColor = properties.backgroundColor
        tintColor = properties.tintColor
        accessibilityIdentifier = properties.accessibilityIdentifier
    }
    
    private func apply(_ imageConfigure: ImageConfiguration<UIImage>) {
        applyProperties(from: imageConfigure.properties)
        image = imageConfigure.source
    }
    
    private func apply(
        _ imageConfigure: ImageConfiguration<URL>,
        loading loadingImage: UIImage? = nil,
        failure failureImage: UIImage? = nil
    ) {
        // Apply the loading image first (if provided)
        applyProperties(from: imageConfigure.properties)
        if let loadingImage = loadingImage {
            self.image = loadingImage
        }
        
        let imageURL = imageConfigure.source
        
        // Fetch the image using the ImageFetcher
        imageConfigure.imageDownloader.fetchImage(with: imageURL) { [weak self] result in
            guard let _self = self else {
                return
            }
            DispatchQueue.main.async {
                _self.handleImageFetchResult(result, failureImage: failureImage)
            }
        }
    }
    
    private func handleImageFetchResult(_ result: ImageFetchResult, failureImage: UIImage?) {
        switch result {
        case .success(let imageData):
            if let downloadedImage = UIImage(data: imageData) {
                self.image = downloadedImage
            } else if let failureImage = failureImage {
                self.image = failureImage
            }
        case .failure:
            if let failureImage = failureImage {
                self.image = failureImage
            }
        }
    }
}


