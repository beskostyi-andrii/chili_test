//
//  GifDetailsView.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 13.12.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct GifDetailsView: View {
    @StateObject var viewModel: GifDetailsVM
    
    @Environment(\.dismiss) var dismiss
    
    init(gif: Gif) {
        _viewModel = StateObject(wrappedValue: GifDetailsVM(gif: gif))
    }
    
    var body: some View {
        NavigationView {
            contentBody
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        closeButton
                    }
                }
                .onAppear { viewModel.fetchDetails() }
        }
    }
    
    private var contentBody: some View {
        List {
            gifView
            ForEach(viewModel.detailItems) {
                DetailItemView(item: $0)
            }
        }
        .listStyle(.grouped)
    }
    
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Close")
        }

    }
    
    private var gifView: some View {
        Section("Original") {
            AnimatedImage(url: viewModel.gif.original)
                .resizable()
                .indicator(SDWebImageActivityIndicator.medium)
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private struct DetailItemView: View {
        let item: GifDetailItem
        
        var body: some View {
            Section(item.title) {
                HStack {
                    Text(item.value)
                    Spacer()
                    if case let .url(url) = item.type {
                        Button {
                            UIApplication.shared.open(url)
                        } label: {
                            Image(systemName: "link.circle.fill")
                        }
                    }
                }
            }
        }
    }
}

struct GifDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GifDetailsView(gif: mocGif)
    }
}
