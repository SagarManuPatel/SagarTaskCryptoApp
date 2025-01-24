//
//  CryptoListViewModel.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import Foundation
import Combine

class CryptoListViewModel {
    @Published var allCoins: [CryptoCoin] = [] // Full list of coins
    @Published var filteredCoins: [CryptoCoin] = [] // Filtered coins
    @Published var searchText: String = "" // Search input
    @Published var selectedFilters: (isActive: Bool?, type: String?, isNew: Bool?) = (nil, nil, nil) // Active filters
    
    private var cancellables = Set<AnyCancellable>()
    private let service: CryptoService
    
    init(service: CryptoService = CryptoService(apiService: ApiService(baseURL: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"))) {
        self.service = service
        setupBindings()
    }
    
    func fetchCoinsOrLoadFromCache() {
        NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                if isConnected {
                    print("Internet is connected")
                    self?.fetchCoins()
                } else {
                    print("Internet is disconnected")
                    self?.loadCachedData()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchCoins() {
        service.fetchCryptoCoins()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching coins: \(error)")
                }
            }, receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.allCoins = self?.allCoins.map { coin in
                    var updatedCoin = coin
                    updatedCoin.setIconName(coin.type == "token" ? "token" : "bitcoin")
                    return updatedCoin
                } ?? []
                CacheManager.shared.saveToCache(coins)
            })
            .store(in: &cancellables)
    }
    
    private func loadCachedData() {
        if let cachedCoins = CacheManager.shared.loadFromCache() {
            self.allCoins = cachedCoins
            print("Loaded cached data")
        } else {
            print("No cached data available")
        }
    }
    
    private func setupBindings() {
        // Update filteredCoins when any of the inputs change
        Publishers.CombineLatest3($allCoins, $searchText, $selectedFilters)
            .map { coins, searchText, filters in
                self.filterAndSearch(coins: coins, searchText: searchText, filters: filters)
            }
            .assign(to: &$filteredCoins)
    }
    
    private func filterAndSearch(coins: [CryptoCoin], searchText: String, filters: (isActive: Bool?, type: String?, isNew: Bool?)) -> [CryptoCoin] {
        return coins.filter { coin in
            let matchesSearch = searchText.isEmpty || coin.name?.lowercased().contains(searchText.lowercased()) ?? false || coin.symbol?.lowercased().contains(searchText.lowercased()) ?? false
            let matchesActive = filters.isActive == nil || coin.is_active == filters.isActive
            let matchesType = filters.type == nil || coin.type == filters.type
            let matchesNew = filters.isNew == nil || coin.is_new == filters.isNew
            return matchesSearch && matchesActive && matchesType && matchesNew
        }
    }
    
}
