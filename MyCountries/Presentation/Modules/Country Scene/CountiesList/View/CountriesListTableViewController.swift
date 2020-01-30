//
//  CountriesListTableViewController.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import UIKit

final class CountriesListTableViewController: UITableViewController {
        
    var viewModel: CountriesListViewModel?
    var items: [CountriesListItemViewModel] = [] {
        didSet { reload() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = nil
    }
    
    func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CountriesListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.value.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountriesListItemCell.reuseIdentifier, for: indexPath) as? CountriesListItemCell else {
            fatalError("Cannot dequeue reusable cell \(CountriesListItemCell.self) with reuseIdentifier: \(CountriesListItemCell.reuseIdentifier)")
        }
        
        cell.configure(with: (viewModel?.items.value[indexPath.row])!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelect(item: items[indexPath.row])
    }
}
