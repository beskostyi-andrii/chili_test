//
//  URLLinks.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation

extension URL {
    static private let baseURL = Constants.baseURL
}

// MARK: - API Endpoints

extension URL {
    static var gifs: URL {
        URL(string: "\(baseURL)/gifs")!
    }
    
    static var search: URL {
        gifs.appendingPathComponent("search")
    }
}
