//
//  CryptoListViewModelTests.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import XCTest
import Combine
@testable import SagarTaskCryptoApp

final class CryptoListViewModelTests: XCTestCase {
    private var viewModel: CryptoListViewModel!
    private var mockCryptoService: MockCryptoService!
    private var mockCacheManager: MockCacheManager!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockCryptoService = MockCryptoService(apiService: ApiService(baseURL: ""))
        mockCacheManager = MockCacheManager()
        viewModel = CryptoListViewModel(service: mockCryptoService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockCryptoService = nil
        mockCacheManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchCoinsSuccess() {
        // Arrange
        let mockCoins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "crypto", is_active: true, is_new: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "crypto", is_active: true, is_new: true)
        ]
        mockCryptoService.coinsToReturn = mockCoins

        let expectation = XCTestExpectation(description: "Coins fetched successfully")

        // Act
        viewModel.$allCoins
            .dropFirst()
            .sink { coins in
                XCTAssertEqual(coins.count, 2)
                XCTAssertEqual(coins.first?.name, "Bitcoin")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.fetchCoins()

        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    func testFilterAndSearch() {
        // Arrange
        viewModel.allCoins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "crypto", is_active: true, is_new: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "crypto", is_active: true, is_new: true)
        ]
        viewModel.searchText = "Bitcoin"

        // Act
        let filteredCoins = viewModel.filteredCoins

        // Assert
        XCTAssertEqual(filteredCoins.count, 1)
        XCTAssertEqual(filteredCoins.first?.name, "Bitcoin")
    }
}

