//
//  CountriesListViewController.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import UIKit

final class CountriesListViewController: UIViewController, Alertable, StoryboardInstantiable {
    
    @IBOutlet weak var countriesListContainer: UIView!
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    var viewModel: CountriesListViewModel!
    var countriesTableViewController: CountriesListTableViewController?
    private var searchController = UISearchController(searchResultsController: nil)
    
        static func create(with viewModel: CountriesListViewModel) -> CountriesListViewController {
            let view = CountriesListViewController.instantiateViewController()
            view.viewModel = viewModel
            return view
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Countries", comment: "")
        emptyDataLabel.text = NSLocalizedString("Search results", comment: "")
        
        setupSearchController()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: CountriesListTableViewController.self),
            let destinationVC = segue.destination as? CountriesListTableViewController {
            countriesTableViewController = destinationVC
            countriesTableViewController?.viewModel = viewModel
        }
    }
    
    private func bind(to viewModel: CountriesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] in self?.countriesTableViewController?.items = $0 }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.loadingType.observe(on: self) { [weak self] _ in self?.updateViewsVisibility() }
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
    }
    
    private func updateViewsVisibility() {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        countriesListContainer.isHidden = true
        
        switch viewModel.loadingType.value {
        case .none: updateCountriesListVisibility()
        case .fullScreen: loadingView.isHidden = false
        }
       // updateQueriesSuggestionsVisibility()
    }
    
    private func updateCountriesListVisibility() {
        guard !viewModel.isEmpty else {
            emptyDataLabel.isHidden = false
            return
        }
        countriesListContainer.isHidden = false
    }
    
//    private func updateQueriesSuggestionsVisibility() {
//        guard searchController.searchBar.isFirstResponder else {
//            viewModel.closeQueriesSuggestions()
//            return
//        }
//        viewModel.showQueriesSuggestions()
//    }
}

extension CountriesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        //countriesTableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        //viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //viewModel.didCancelSearch()
    }
}

extension CountriesListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        //updateQueriesSuggestionsVisibility()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        // updateQueriesSuggestionsVisibility()
    }
    
    public func didDismissSearchController(_ searchController: UISearchController) {
        //updateQueriesSuggestionsVisibility()
    }
}

// MARK: - Setup Search Controller

extension CountriesListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search Movies", comment: "")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
}
