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
        let url: String
    }
    
    struct Pagination: Codable {
        let totalCount: Int
        let count: Int
        let offset: Int
    }
}
