//
//  CachedImageView.swift
//  FetchProject
//
//  Created by Soft Liampisan on 14/4/2568 BE.
//

import Foundation
import SwiftUI

struct CachedImageView: View {
    let url: URL
    let imageCache: ImageCache
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
            } else {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .task {
                        await loadImage()
                    }
            }
        }
    }

    private func loadImage() async {
        if let cached = await imageCache.getImage(for: url) {
            image = cached
        }
    }
}
