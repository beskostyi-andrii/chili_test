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
    var items: [Gif] { get set }
    var isLoading: Bool { get set }
    var isPaginate: Bool { get set }
    var canLoadMore: Bool { get }
    var searchText: String { get set }
    var pagination: Pagination { get }
    var error: Error? { get set }
    var apiClient: APIClient { get }
}

class SearchVM: iSearchVM, ObservableObject {
    @Published var items: [Gif] = []
    @Published var isLoading: Bool = false
    @Published var isPaginate = false
    @Published var canLoadMore: Bool = false
    @Published var searchText: String = ""
    @Published var error: Error?
    
    @Dependency private(set) var apiClient: APIClient
    
    private(set) var pagination: Pagination = .init(limit: Constants.itemsLimit)
    
    private var searchTextCancellable: Cancellable?
    private var searchCancellable: Cancellable?
    
    init() {
        searchTextCancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.reset()
                self?.search(query: $0)
            }
    }
    
    func reset() {
        pagination = .init(limit: Constants.itemsLimit)
        search(query: searchText)
    }
    
    func loadMore() {
        guard !isPaginate else { return }
        guard canLoadMore else { return }
        
        isPaginate = true
        search(query: searchText)
    }
}

private extension SearchVM {
    func search(query: String) {
        searchCancellable?.cancel()
        isLoading = true
        
        let params = RequestQuery.SearchGifInterval(q: query, limit: pagination.limit, offset: pagination.offset)
        searchCancellable = apiClient.search(params)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isPaginate = false
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
    
    func sink(received response: ResponseModels.SearchResponse) {
        updatePagination(with: response.pagination)
        consumeItems(from: response)
    }
    
    func updatePagination(with responsePagination: ResponseModels.Pagination) {
        pagination.offset += responsePagination.count
        pagination.total = responsePagination.totalCount
        canLoadMore = pagination.total > items.count
    }
    
    func consumeItems(from response: ResponseModels.SearchResponse) {
        let newElements = response.data.map { Mapper.gif(from: $0) }
        if response.pagination.offset == 0 {
            self.items = newElements
        } else {
            self.items.append(contentsOf: newElements)
        }
    }
}
