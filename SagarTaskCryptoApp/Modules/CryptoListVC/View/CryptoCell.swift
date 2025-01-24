//
//  CryptoCell.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import UIKit

class CryptoCell: UITableViewCell {
    // MARK: - UI Components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let newLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "newLogo")
        return imageView
    }()

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Configure container view
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)

        // Configure labels
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .label

        symbolLabel.font = UIFont.systemFont(ofSize: 14)
        symbolLabel.textColor = .secondaryLabel
        
        typeLabel.font = UIFont.systemFont(ofSize: 12)
        typeLabel.textColor = .secondaryLabel

        // Add labels to the container
        containerView.addSubview(nameLabel)
        containerView.addSubview(symbolLabel)
        containerView.addSubview(typeLabel)
        containerView.addSubview(logoImageView)
        containerView.addSubview(newLogoImageView)
    }

    // MARK: - Constraints
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: logoImageView.trailingAnchor, constant: -8),

            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            symbolLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -8),
            
            // Type label
            typeLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            typeLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -8),
            typeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            logoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            logoImageView.heightAnchor.constraint(equalToConstant: 32),
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            
            newLogoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            newLogoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            newLogoImageView.heightAnchor.constraint(equalToConstant: 20),
            newLogoImageView.widthAnchor.constraint(equalToConstant: 20),
            
        ])
    }

    // MARK: - Configure Cell
    func configure(with coin: CryptoCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = "Symbol: \(coin.symbol ?? "")"
        typeLabel.text = "Type: \(coin.type ?? "")"
        
        logoImageView.image = UIImage(named: coin.iconName ?? "")
        
        newLogoImageView.isHidden = !(coin.is_new ?? true)

        if !(coin.is_active ?? true) {
            // Apply disabled styling for inactive coins
            containerView.backgroundColor = UIColor.systemGray6
            nameLabel.textColor = UIColor.systemGray
            symbolLabel.textColor = UIColor.systemGray
            logoImageView.adjustSaturationForImageView(saturation: 0.0)
        } else {
            // Apply default styling
            containerView.backgroundColor = UIColor.systemBackground
            nameLabel.textColor = .label
            symbolLabel.textColor = .secondaryLabel
            logoImageView.adjustSaturationForImageView(saturation: 1.0)
        }
    }
}
