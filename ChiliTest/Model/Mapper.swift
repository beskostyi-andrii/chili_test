//
//  Mapper.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 12.12.2022.
//

import Foundation

enum Mapper {
    static func gif(from gifResponse: ResponseModels.Gif) -> Gif {
        Gif(id: gifResponse.id, original: URL(string: gifResponse.images.original.url)!, preview: URL(string: gifResponse.images.previewGif.url)!)
    }
}
