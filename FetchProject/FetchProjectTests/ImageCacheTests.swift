//
//  ImageCacheTests.swift
//  FetchProjectTests
//
//  Created by Soft Liampisan on 13/4/2568 BE.
//

import XCTest
@testable import FetchProject
import UIKit

final class ImageCacheTests: XCTestCase {
    var imageCache: ImageCache!
    let testImageURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!
    
    override func setUp() {
        super.setUp()
        imageCache = ImageCache()
        imageCache.clearCache()
    }

    override func tearDown() {
        imageCache.clearCache()
        imageCache = nil
        super.tearDown()
    }

    func testDownloadAndCacheImage() async {
        //Download image for the first time (should fetch from network)
        let image = await imageCache.getImage(for: testImageURL)
        XCTAssertNotNil(image, "Image should be downloaded successfully")

        //Check if the image is cached on disk
        let filename = imageCache.hashedFileName(for: testImageURL)
        let filePath = imageCache.cacheDirectory.appendingPathComponent(filename)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath.path), "Image should be cached on disk")

        //Fetch again (should load from disk, not network)
        let cachedImage = await imageCache.getImage(for: testImageURL)
        XCTAssertNotNil(cachedImage, "Image should be loaded from cache")
    }

    func testImageCacheStoresValidJPEG() async {
        //Save a known image to cache manually
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
