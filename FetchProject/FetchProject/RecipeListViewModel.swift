//
//  RecipeListViewModel.swift
//  FetchProject
//
//  Created by Soft Liampisan on 10/4/2568 BE.
//
//
//import Foundation
//
//class RecipeListViewModel: ObservableObject {
//    @Published var recipes: [RecipeModel] = []
//    private let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
//    
//    // Fetch the recipe data
//    func getRecipeData() async {
//        do {
//            guard let url = URL(string: url) else {
//                throw URLError(.badURL)
//            }
//
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let recipeList = try JSONDecoder().decode(RecipeList.self, from: data)
//            
//            // Update the recipes array and the UI
//            await MainActor.run {
//                self.recipes = recipeList.recipes
//            }
//        } catch {
//            print("Error fetching recipes: \(error)")
//        }
//    }
//    
//    // MARK: - Reusable fetch for testing
//    func fetchRecipes(from urlString: String) async throws -> [RecipeModel] {
//        guard let url = URL(string: urlString) else {
//            throw URLError(.badURL)
//        }
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoded = try JSONDecoder().decode(RecipeList.self, from: data)
//        return decoded.recipes
//    }
//}
//
import Foundation

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    private let recipeListURLString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    //Fetch the recipe data
    func getRecipeData() async {
        do {
            guard let url = URL(string: recipeListURLString) else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let recipeList = try decodeRecipes(from: data)

            await MainActor.run {
                self.recipes = recipeList
            }
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }

    // MARK: - Reusable fetch for testing
    func fetchRecipes(from urlString: String) async throws -> [RecipeModel] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try decodeRecipes(from: data)
    }

    private func decodeRecipes(from data: Data) throws -> [RecipeModel] {
        let decoded = try JSONDecoder().decode(RecipeList.self, from: data)
        return decoded.recipes
    }
}
