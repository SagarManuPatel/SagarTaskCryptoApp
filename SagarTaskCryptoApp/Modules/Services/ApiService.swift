//
//  ApiService.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import Combine
import Foundation

class ApiService {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    /// Generic function to fetch data from an API and decode it into the specified type.
    /// - Parameters:
    ///   - endpoint: The API endpoint to fetch data from (relative to the base URL).
    ///   - type: The type of the expected response (must conform to Decodable).
    /// - Returns: A publisher that outputs the decoded object or an error.
    func fetch<T: Decodable>(endpoint: String, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: type, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
