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
            if viewModel.recipes.isEmpty {
                Text("No recipes available.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.recipes, id: \.uuid) { recipe in
                    HStack {
                        //Display the small photo on the left side
                        if let photoURL = recipe.photo_url_small,
                           let url = URL(string: photoURL) {
                            CachedImageView(url: url, imageCache: imageCache)
                        }
                        
                        //Display the name and cuisine on the right side
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
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
        }
        .task {
            await viewModel.getRecipeData()
        }
    }
}

#Preview {
    ContentView()
}
