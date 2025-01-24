//
//  CryptoService.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import Combine

class CryptoService {
    private let apiService: ApiService
        
        init(apiService: ApiService) {
            self.apiService = apiService
        }
        
        func fetchCryptoCoins() -> AnyPublisher<[CryptoCoin], Error> {
            apiService.fetch(endpoint: "", type: [CryptoCoin].self)
        }
}
