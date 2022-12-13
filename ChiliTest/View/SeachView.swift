//
//  SearchView.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchVM = .init()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        GifDetailsView(gif: item)
                    } label: {
                        ListItem(gif: item)
                    }
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
    
    private struct ListItem: View {
        let gif: Gif
        
        var body: some View {
            HStack {
                AnimatedImage(url: gif.preview)
                    .indicator(SDWebImageActivityIndicator.medium)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .scaledToFill()
                
                Text(gif.id).lineLimit(1)
            }
        }
    }
}
