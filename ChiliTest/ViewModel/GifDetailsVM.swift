//
//  GifDetailsVM.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 13.12.2022.
//

import Foundation
import Combine
import os

struct GifDetailItem: Identifiable {
    enum ItemType {
        case text, url(URL)
    }
    
    var id: String = UUID().uuidString
    let title: String
    let value: String
    let type: ItemType
}

protocol iGifDetailsVM {
    var gif: Gif { get }
    var isLoading: Bool { get set }
    var detailItems: [GifDetailItem] { get set }
    var apiClient: APIClient { get }
}

class GifDetailsVM: ObservableObject {
    let gif: Gif
    
    @Published var isLoading = false
    @Published var detailItems: [GifDetailItem] = .init()
    
    @Dependency private(set) var apiClient: APIClient
    
    private var fetchDetailsCancellable: Cancellable?
    
    init(gif: Gif) {
        self.gif = gif
    }
    
    func fetchDetails() {
        guard !isLoading else { return }
        
        isLoading = true
        fetchDetailsCancellable = apiClient.gifDetails(id: gif.id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    os_log("Failure %@: %@", type: .error, #function, error.errorDescription ?? error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                self?.sink(received: response)
            })
    }
}

private extension GifDetailsVM {
    func sink(received response: ResponseModels.GifDetailsResponse) {
        detailItems.removeAll()
        
        let details = Mapper.gifDetails(from: response.data)
        detailItems.append(GifDetailItem(title: "Title", value: details.title, type: .text))
        
        if let altText = details.altText {
            detailItems.append(GifDetailItem(title: "Subtitle", value: altText, type: .text))
        }
        
        detailItems.append(GifDetailItem(title: "Username", value: details.username, type: .text))
        detailItems.append(GifDetailItem(title: "Rating", value: details.rating, type: .text))
        
        if let url = details.source {
            detailItems.append(GifDetailItem(title: "Source", value: url.absoluteString, type: .url(url)))
        }
    }
}
