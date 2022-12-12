//
//  GifView.swift
//  ChiliTest
//
//  Created by Andrii Beskostyi on 05.12.2022.
//

import SwiftUI
import SwiftyGif


struct SUIGifView: UIViewRepresentable {
    let source: URL
    
    func makeUIView(context: Context) -> some UIView {
        let uiImageView = UIImageView()
        uiImageView.setGifFromURL(source)
        return uiImageView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
