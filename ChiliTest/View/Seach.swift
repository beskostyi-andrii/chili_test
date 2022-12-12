//
//  Seach.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation
import SwiftUI
import SwiftyGif

struct Search: View {
    @StateObject private var viewModel: SearchVM = .init()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    Text(item.url.lastPathComponent).lineLimit(1)
                }
                
                if viewModel.canLoadMore {
                    ProgressView()
                        .onAppear { viewModel.loadMore() }
                }
            }
            .listStyle(.plain)
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}
