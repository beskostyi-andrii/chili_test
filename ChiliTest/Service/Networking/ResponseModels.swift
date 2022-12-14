//
//  ResponseModels.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation

enum ResponseModels {
    
    struct SearchResponse: Codable {
        let data: [Gif]
        let pagination: Pagination
    }
    
    struct Gif: Codable {
        let id: String
        let images: Images
    }
    
    struct Images: Codable {
        let previewGif: GifImages
        let original: GifImages
    }
    
    struct GifImages: Codable {
        let url: String
    }
    
    struct Pagination: Codable {
        let totalCount: Int
        let count: Int
        let offset: Int
    }
    
    struct GifDetailsResponse: Codable {
        let data: GifDetails
    }
    
    struct GifDetails: Codable {
        let id: String
        let title: String
        let altText: String?
        let username: String
        let source: String?
        let rating: String
    }
}
