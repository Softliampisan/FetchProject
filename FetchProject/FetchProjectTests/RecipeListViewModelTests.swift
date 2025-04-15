//
//  RecipeListViewModelTests.swift
//  FetchProjectTests
//
//  Created by Soft Liampisan on 10/4/2568 BE.
//

import XCTest
@testable import FetchProject

final class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = RecipeListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    //Test for successful recipe
    func testFetchRecipesSuccess() async throws {
        let testURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        let recipes = try await viewModel.fetchRecipes(from: testURL)
        XCTAssertFalse(recipes.isEmpty, "Expected non-empty recipe list")
    }

    //Test for empty recipe
    func testFetchEmptyRecipes() async throws {
        let testURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        let recipes = try await viewModel.fetchRecipes(from: testURL)
        XCTAssertTrue(recipes.isEmpty, "Expected empty recipe list")
    }

    //Test for malformed recipe data
    func testFetchMalformedRecipes() async {
        let testURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        do {
            _ = try await viewModel.fetchRecipes(from: testURL)
            XCTFail("Expected decoding to fail for malformed data")
        } catch {
            XCTAssertTrue(error is DecodingError || error is URLError, "Expected a decoding error")
        }
    }

}
