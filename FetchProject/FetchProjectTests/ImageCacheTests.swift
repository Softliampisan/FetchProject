//
//  ImageCacheTests.swift
//  FetchProjectTests
//
//  Created by Soft Liampisan on 13/4/2568 BE.
//

//import XCTest
//
//final class ImageCacheTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}

import XCTest
@testable import FetchProject
import UIKit

final class ImageCacheTests: XCTestCase {
    var imageCache: ImageCache!
    let testImageURL = URL(string: "https://via.placeholder.com/150")!

    override func setUp() {
        super.setUp()
        imageCache = ImageCache()
    }

    override func tearDown() {
        imageCache = nil
        super.tearDown()
    }

    func testDownloadAndCacheImage() async {
        // Step 1: Download image for the first time (should fetch from network)
        let image = await imageCache.getImage(for: testImageURL)
        XCTAssertNotNil(image, "Image should be downloaded successfully")

        // Step 2: Delete the file manually and try fetching again
        let filePath = imageCache.cacheDirectory.appendingPathComponent(testImageURL.lastPathComponent)
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath.path), "Image should be cached on disk")

        // Step 3: Fetch again (should load from disk, not network)
        let cachedImage = await imageCache.getImage(for: testImageURL)
        XCTAssertNotNil(cachedImage, "Image should be loaded from cache")
    }

    func testImageCacheStoresValidJPEG() async {
        // Save a known image to cache manually
        guard let dummyImage = UIImage(systemName: "photo") else {
            XCTFail("Failed to create dummy image")
            return
        }

        let filePath = imageCache.cacheDirectory.appendingPathComponent(testImageURL.lastPathComponent)
        if let data = dummyImage.jpegData(compressionQuality: 0.8) {
            try? data.write(to: filePath)
        }

        let cached = await imageCache.getImage(for: testImageURL)
        XCTAssertNotNil(cached, "Should retrieve the manually cached image")
    }
}
