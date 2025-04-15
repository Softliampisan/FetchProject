//
//  ImageCache.swift
//  FetchProject
//
//  Created by Soft Liampisan on 10/4/2568 BE.
//

import Foundation
import UIKit
import CryptoKit

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
        let filename = hashedFileName(for: url)
        let filePath = cacheDirectory.appendingPathComponent(filename)

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

    func hashedFileName(for url: URL) -> String {
        let hashed = SHA256.hash(data: Data(url.absoluteString.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
}
