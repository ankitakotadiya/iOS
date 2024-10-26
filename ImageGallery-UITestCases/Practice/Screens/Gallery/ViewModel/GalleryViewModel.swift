//
//  GalleryViewModel.swift
//  Practice
//
//  Created by Ankita Kotadiya on 26/10/24.
//

import Foundation
import Combine

final class GalleryViewModel {
    
    @Published var gallery: [Gallery] = []
    var descriptions: [String] = ["A serene sunset over the mountains across the sky.", "A bustling city street at night, illuminated by colorful neon signs.", "A tranquil beach scene with soft waves gently lapping at the shore. The golden sand stretches endlessly, dotted with seashells and footprints. In the distance, a lone sailboat glides peacefully across the horizon.", "A close-up of a dewdrop on a leaf, reflecting the morning sun and showcasing nature’s delicate beauty.", "An enchanting forest path lined with towering trees and vibrant wildflowers. Sunlight filters through the leaves, creating a magical atmosphere."]
}
