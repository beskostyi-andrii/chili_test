//
//  RequestQuery.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 12.12.2022.
//

import Foundation

enum RequestQuery {
    struct SearchGifInterval: Encodable {
        let q: String
        let limit: Int
        let offset: Int
    }
}
