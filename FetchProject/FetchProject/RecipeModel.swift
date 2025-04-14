//
//  RecipeModel.swift
//  FetchProject
//
//  Created by Soft Liampisan on 10/4/2568 BE.
//

import Foundation

class RecipeModel: Codable {
    var cuisine: String
    var name: String
    var photo_url_large: String?
    var photo_url_small: String?
    var uuid: String
    var source_url: String?
    var youtube_url: String?
}

struct RecipeList: Codable {
    var recipes: [RecipeModel]

    static func parseJSON(_ data: Data) -> RecipeList? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(RecipeList.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
