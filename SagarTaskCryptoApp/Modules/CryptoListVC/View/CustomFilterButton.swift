//
//  CustomFilterButton.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import UIKit

class CustomFilterButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemGray
        layer.cornerRadius = 8
        clipsToBounds = true
        setTitleColor(.black, for: .selected)
        backgroundColor = .systemGray4
    }
}
