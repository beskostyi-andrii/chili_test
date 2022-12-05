//
//  ApiError.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown
    case invalidBody
    case statusCode(Int)
    case apiError(code: Int, reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .invalidBody:
            return "Invalid body"
        case .statusCode(let code):
            return "Status code: \(code)"
        case .apiError(let code, let reason):
            return "Code: \(code), reason: \(reason)"
        }
    }
}
