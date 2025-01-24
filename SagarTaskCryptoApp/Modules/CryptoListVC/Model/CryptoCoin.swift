//
//  CryptoCoin.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

struct CryptoCoin: Codable {
    let name: String?
    let symbol: String?
    let type: String?
    let is_active: Bool?
    let is_new: Bool?
    var iconName: String?
    
    mutating func setIconName(_ iconName: String) {
        self.iconName = iconName
    }
}
