//
//  ImageCache.swift
//  FetchProject
//
//  Created by Soft Liampisan on 10/4/2568 BE.
//

import Foundation
import UIKit

class ImageCache {
    let cacheDirectory: URL
    private let fileManager = FileManager.default

    init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("ImageCache")

        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func getImage(for url: URL) async -> UIImage? {
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        if fileManager.fileExists(atPath: filePath.path) {
            return UIImage(contentsOfFile: filePath.path)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                try? data.write(to: filePath)
                return image
            }
        } catch {
            print("Image download failed: \(error)")
        }

        return nil
    }
}
