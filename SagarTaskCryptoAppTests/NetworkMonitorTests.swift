//
//  NetworkMonitorTests.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import XCTest
import Network
@testable import SagarTaskCryptoApp
import Combine

final class NetworkMonitorTests: XCTestCase {
    
    func testNetworkStatus() {
        let monitor = NetworkMonitor.shared
        let expectation = XCTestExpectation(description: "Network status changes observed")

        var cancellables = Set<AnyCancellable>() // Declare as mutable
        monitor.$isConnected
            .dropFirst()
            .sink { isConnected in
                XCTAssertTrue(isConnected)
                expectation.fulfill()
            }
            .store(in: &cancellables) // Store in the mutable set

        monitor.isConnected = true
        wait(for: [expectation], timeout: 1.0)
    }
}
