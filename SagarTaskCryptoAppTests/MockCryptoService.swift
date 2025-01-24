//
//  MockCryptoService.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import XCTest
import Combine
@testable import SagarTaskCryptoApp

final class MockCryptoService: CryptoService {
    var coinsToReturn: [CryptoCoin] = []
    var shouldReturnError = false

    override func fetchCryptoCoins() -> AnyPublisher<[CryptoCoin], Error> {
        if shouldReturnError {
            return Fail(error: URLError(.notConnectedToInternet))
                .eraseToAnyPublisher()
        } else {
            return Just(coinsToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
