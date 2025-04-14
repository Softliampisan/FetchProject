//
//  ContentView.swift
//  FetchProject
//
//  Created by Soft Liampisan on 10/4/2568 BE.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    private let imageCache = ImageCache() 
    
    var body: some View {
        VStack {
            Text("Recipes")
                .font(.headline)
                .padding()

            List(viewModel.recipes, id: \.uuid) { recipe in
                HStack {
                    // Display the small photo on the left side
                    if let photoURL = recipe.photo_url_small,
                       let url = URL(string: photoURL) {
                        // Fetch image from cache or network
                        AsyncImage(url: url, transaction: .init(animation: .default)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 70, height: 70)
                            case .success(let image):
                                image.resizable()
                                     .scaledToFit()
                                     .frame(width: 70, height: 70)
                            case .failure:
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    // Display the name and cuisine on the right side
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.headline)
//                            .lineLimit(1)
                        Text(recipe.cuisine)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        
                        //Show the source if available
                        if let sourceURL = recipe.source_url, let url = URL(string: sourceURL) {
                            Link("Source", destination: url)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }

                        //Show youtube if available
                        if let youtubeURL = recipe.youtube_url, let url = URL(string: youtubeURL) {
                            Link("Watch on YouTube", destination: url)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.leading, 10)
                }
                .padding(.vertical, 5)
            }
            .refreshable {
                await viewModel.getRecipeData()
            }
        }
        .task {
            await viewModel.getRecipeData()
        }
    }
}

#Preview {
    ContentView()
}
