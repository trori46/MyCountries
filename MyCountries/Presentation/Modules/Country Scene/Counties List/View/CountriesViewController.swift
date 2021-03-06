//
//  CountriesListViewController.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import UIKit

final class CountriesListViewController: UIViewController, Alertable {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    var viewModel: CountriesListViewModel!
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyDataLabel.text = NSLocalizedString("Search results", comment: "")
        tableView.tableFooterView = .init(frame: .zero)
        
        setupSearchController()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: CountriesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.reload() }
        viewModel.error.observe(on: self) { [weak self] in self?.configure($0) }
        viewModel.loadingType.observe(on: self) { [weak self] _ in self?.updateViewsVisibility() }
        viewModel.route.observe(on: self) { [weak self] in self?.handle($0) }
    }
    
    func configure(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
    }
    
    private func updateViewsVisibility() {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        
        switch viewModel.loadingType.value {
        case .none: updateCountriesListVisibility()
        case .fullScreen: loadingView.isHidden = false
        }
    }
    
    private func updateCountriesListVisibility() {
        guard !viewModel.isEmpty else {
            emptyDataLabel.isHidden = false
            return
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
}

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountriesListItemCell.reuseIdentifier, for: indexPath) as? CountriesListItemCell else {
            fatalError("Cannot dequeue reusable cell \(CountriesListItemCell.self) with reuseIdentifier: \(CountriesListItemCell.reuseIdentifier)")
        }
        
        cell.configure(with: (viewModel?.items.value[indexPath.row])!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelect(item: viewModel.items.value[indexPath.row])
    }
}

extension CountriesListViewController {
    func handle(_ route: CountriesListViewModelRoute) {
        switch route {
        case .initial: break
        case .showCountryDetail(let name):
            let controller = assembly.ui.country(by: name)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension CountriesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

// MARK: - Setup Search Controller

extension CountriesListViewController {
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search Country", comment: "")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
}
