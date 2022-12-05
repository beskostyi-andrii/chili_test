//
//  ResponseModels.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation

enum ResponseModels {
    struct Gif: Codable {
        let id: String
        let url: String
    }
}
