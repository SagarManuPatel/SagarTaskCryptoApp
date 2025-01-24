//
//  CacheManager.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let fileName = "cryptoApp_cache.json"
    
    private var cacheURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(fileName)
    }

    func saveToCache(_ coins: [CryptoCoin]) {
        do {
            let data = try JSONEncoder().encode(coins)
            try data.write(to: cacheURL, options: .atomic)
            print("Cache saved successfully.")
        } catch {
            print("Failed to save cache: \(error)")
        }
    }

    func loadFromCache() -> [CryptoCoin]? {
        do {
            let data = try Data(contentsOf: cacheURL)
            let coins = try JSONDecoder().decode([CryptoCoin].self, from: data)
            return coins
        } catch {
            print("Failed to load cache: \(error)")
            return nil
        }
    }
}
