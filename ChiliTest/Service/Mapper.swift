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
    
    static func gifDetails(from gifDetailsResponse: ResponseModels.GifDetails) -> GifDetails {
        GifDetails(id: gifDetailsResponse.id,
                   title: gifDetailsResponse.title,
                   altText: gifDetailsResponse.altText,
                   username: gifDetailsResponse.username,
                   source: URL(string: gifDetailsResponse.source ?? ""),
                   rating: gifDetailsResponse.rating,
                   importDatetime: gifDetailsResponse.importDatetime)
    }
}
