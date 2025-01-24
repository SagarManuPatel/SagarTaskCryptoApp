//
//  MockCacheManager.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import XCTest
@testable import SagarTaskCryptoApp

final class MockCacheManager: CacheManager {
    var cachedCoins: [CryptoCoin] = []

    override func saveToCache(_ coins: [CryptoCoin]) {
        cachedCoins = coins
    }

    override func loadFromCache() -> [CryptoCoin]? {
        return cachedCoins
    }
}
