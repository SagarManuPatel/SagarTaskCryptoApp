//
//  UISearchBar+Combine.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import Combine
import UIKit

extension UISearchBar {
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: self.searchTextField)
            .map { ($0.object as? UISearchTextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
