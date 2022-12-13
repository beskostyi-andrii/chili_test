//
//  GifDetailItem.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 13.12.2022.
//

import Foundation

struct GifDetailItem: Identifiable {
    enum ItemType {
        case text, url(URL)
    }
    
    var id: String = UUID().uuidString
    let title: String
    let value: String
    let type: ItemType
}
