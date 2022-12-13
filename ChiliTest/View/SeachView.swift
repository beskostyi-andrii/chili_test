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
    @State private var selectedGif: Gif?
    
    var body: some View {
        NavigationView {
            contentBody
                .sheet(item: $selectedGif) { gif in
                    GifDetailsView(gif: gif)
                }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Start typing here...")
    }
    
    private var contentBody: some View {
        List {
            ForEach(viewModel.items) { item in
                Button {
                    selectedGif = item
                } label: {
                    ListItem(gif: item)
                }
            }
            
            if viewModel.canLoadMore {
                bottomProgressView
            }
        }
        .listStyle(.plain)
        .overlay {
            if !viewModel.isPaginate && viewModel.isLoading {
                ProgressView()
            }
        }
    }
    
    private var bottomProgressView: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .onAppear { viewModel.loadMore() }
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
