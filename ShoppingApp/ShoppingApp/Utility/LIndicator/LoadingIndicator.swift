//
//  LoadingIndicator.swift
//  ShoppingApp
//
//  Created by Ankita Kotadiya on 20/10/24.
//

import Foundation
import UIKit

final class LoadingIndicator {
    static let shared = LoadingIndicator()
    private var indicator: UIActivityIndicatorView?
    
    private init() {}
    
    func startAnimating(on view: UIView) {
        
        if indicator == nil {
            let indicatorView = UIActivityIndicatorView(style: .medium)
            indicatorView.color = .black
            indicatorView.hidesWhenStopped = true
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(indicatorView)
            NSLayoutConstraint.activate([
                indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
            self.indicator = indicatorView
        }
        
        indicator?.startAnimating()
    }
    
    func stopAnimating() {
        indicator?.stopAnimating()
        indicator?.removeFromSuperview()
        indicator = nil
    }
}
