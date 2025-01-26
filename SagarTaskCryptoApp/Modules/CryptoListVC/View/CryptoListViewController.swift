//
//  ViewController.swift
//  SagarTaskCryptoApp
//
//  Created by Sagar Patel on 24/01/25.
//

import UIKit
import Combine

class CryptoListViewController: UIViewController {
    
    private var viewModel: CryptoListViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.register(CryptoCell.self, forCellReuseIdentifier: "CryptoCell")
        return tv
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private let filterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let activeButton = CustomFilterButton(title: "Active Coins")
    let inactiveButton = CustomFilterButton(title: "Inactive Coins")
    let onlyTokensButton = CustomFilterButton(title: "Only Tokens")
    let onlyCoinsButton = CustomFilterButton(title: "Only Coins")
    let newCoinsButton = CustomFilterButton(title: "New Coins")
    private let filterSegmentControl = UISegmentedControl(items: ["Active", "Type", "New"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CryptoListViewModel()
        setupUI()
        bindViewModel()
        viewModel.fetchCoinsOrLoadFromCache()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        //add cutomviews to container view
        view.addSubview(tableView)
        view.addSubview(filterView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: filterView.topAnchor),
            
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 90),
        ])
        
        setupFilterView()
        addDoneButtonOnKeyboard()
    }
    
    private func setupFilterView() {
        view.addSubview(filterView)
        
        // Add actions for buttons
        activeButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        inactiveButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        onlyTokensButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        onlyCoinsButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        newCoinsButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        // Create two stack views for buttons
        let topStackView = UIStackView(arrangedSubviews: [activeButton, inactiveButton, onlyTokensButton])
        let bottomStackView = UIStackView(arrangedSubviews: [onlyCoinsButton, newCoinsButton])
        
        [topStackView, bottomStackView].forEach { stack in
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.spacing = 8
            stack.translatesAutoresizingMaskIntoConstraints = false
            filterView.addSubview(stack)
        }
        
        // Layout constraints for stack views
        NSLayoutConstraint.activate([
            // Top Stack View
            topStackView.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 8),
            topStackView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 16),
            topStackView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -16),
            
            // Bottom Stack View
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 8),
            bottomStackView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -16),
            bottomStackView.bottomAnchor.constraint(equalTo: filterView.bottomAnchor, constant: -8),
        ])
    }

    // Action for filter button toggling
    @objc private func filterButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ? .systemBlue : .systemGray4
        
        // Update filters in ViewModel
        switch sender.title(for: .normal) {
        case "Active Coins":
            if sender.isSelected {
                // Deselect "Inactive Coins" if "Active Coins" is selected
                inactiveButton.isSelected = false
                inactiveButton.backgroundColor = .systemGray4
            }
            sender.backgroundColor = sender.isSelected ? .systemBlue : .systemGray4
            viewModel.selectedFilters.isActive = sender.isSelected ? true : nil
        case "Inactive Coins":
            if sender.isSelected {
                // Deselect "Active Coins" if "Inactive Coins" is selected
                activeButton.isSelected = false
                activeButton.backgroundColor = .systemGray4
            }
            sender.backgroundColor = sender.isSelected ? .systemBlue : .systemGray4
            viewModel.selectedFilters.isActive = sender.isSelected ? false : nil
        case "Only Tokens":
            if sender.isSelected {
                // Deselect "Only Coins" if "Only Tokens" is selected
                onlyCoinsButton.isSelected = false
                onlyCoinsButton.backgroundColor = .systemGray4
            }
            sender.backgroundColor = sender.isSelected ? .systemBlue : .systemGray4
            viewModel.selectedFilters.type = sender.isSelected ? "token" : nil
        case "Only Coins":
            if sender.isSelected {
                // Deselect "Only Tokens" if "Only Coins" is selected
                onlyTokensButton.isSelected = false
                onlyTokensButton.backgroundColor = .systemGray4
            }
            sender.backgroundColor = sender.isSelected ? .systemBlue : .systemGray4
            viewModel.selectedFilters.type = sender.isSelected ? "coin" : nil
        case "New Coins":
            viewModel.selectedFilters.isNew = sender.isSelected ? true : nil
        default:
            break
        }
    }
    
    private func bindViewModel() {
        // Observe filteredCoins to reload the table view
        viewModel.$filteredCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Observe SearchBar input
        searchBar.textDidChangePublisher
            .assign(to: &viewModel.$searchText)
    }
    
}

//MARK: - search bar deleagte
extension CryptoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}

//MARK: - Tableview Methods
extension CryptoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoCell else {
            return UITableViewCell()
        }
        let coin = viewModel.filteredCoins[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: coin)
        return cell
    }
}

//MARK: - Add Done Button to the Keyboard
extension CryptoListViewController {
    func addDoneButtonOnKeyboard() {
        // Create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create a Done button
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        // Add the Done button to the toolbar
        toolbar.setItems([doneButton], animated: false)
        
        // Set the toolbar as the inputAccessoryView for the search bar's text field
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.inputAccessoryView = toolbar
        }
    }
    
    // Action for Done button
    @objc func doneButtonTapped() {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }
}

