//
//  Gif.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation

struct Gif: Identifiable {
    let id: String
    let original: URL
    let preview: URL
}

let mocGif = Gif(id: "13CoXDiaCcCoyk",
                 original: URL(string: "https://media0.giphy.com/media/13CoXDiaCcCoyk/giphy.gif?cid=329921cftl07ncektex5b5nbrjlgs7zwuw5qk9tm7ihm1tsg&rid=giphy.gif&ct=g")!,
                 preview: URL(string: "https://media0.giphy.com/media/13CoXDiaCcCoyk/giphy-preview.gif?cid=329921cftl07ncektex5b5nbrjlgs7zwuw5qk9tm7ihm1tsg&rid=giphy-preview.gif&ct=g")!)
