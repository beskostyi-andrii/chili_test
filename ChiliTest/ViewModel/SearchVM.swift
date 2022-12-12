//
//  SearchVM.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation
import Combine
import os

protocol iSearchVM {
    var isPaginate: Bool { get set }
    var searchText: String { get set }
    var pagination: Pagination { get }
    var items: [Gif] { get set }
    var error: Error? { get set }
    var apiClient: APIClient { get }
}

class SearchVM: iSearchVM, ObservableObject {
    @Published var searchText: String = ""
    @Published var items: [Gif] = []
    @Published var error: Error?
    
    @Published var isPaginate = false
    
    @Dependency private(set) var apiClient: APIClient
    
    private(set) var pagination: Pagination = .init(limit: Constants.itemsLimit)
    
    private var searchTextCancellable: Cancellable?
    private var searchCancellable: Cancellable?
    
    init() {
        searchTextCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { self.search(query: $0, paginate: false) }
    }
    
    func reset() {
        pagination = .init(limit: Constants.itemsLimit)
    }
    
    func loadMore() {
        guard !isPaginate else { return }
        guard items.count < pagination.total else { return }
        
        isPaginate = true
        search(query: searchText, paginate: true)
    }
}

private extension SearchVM {
    private func search(query: String, paginate: Bool) {
        searchCancellable?.cancel()
        
        let params = RequestQuery.SearchGifInterval(q: query, limit: pagination.limit, offset: pagination.offset)
        searchCancellable = apiClient.search(params)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isPaginate = false
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    os_log("Failure %@: %@", type: .error, #function, error.errorDescription ?? error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                self?.sink(received: response)
            })
    }
    
    private func sink(received response: ResponseModels.SearchResponse) {
        updatePagination(with: response.pagination)
        consumeItems(from: response)
    }
    
    private func updatePagination(with responsePagination: ResponseModels.Pagination) {
        pagination.offset = responsePagination.count
        pagination.total = responsePagination.totalCount
    }
    
    private func consumeItems(from response: ResponseModels.SearchResponse) {
        let newElements = response.data.map { Mapper.gif(from: $0) }
        if response.pagination.offset == 0 {
            self.items = newElements
        } else {
            self.items.append(contentsOf: newElements)
        }
    }
}
