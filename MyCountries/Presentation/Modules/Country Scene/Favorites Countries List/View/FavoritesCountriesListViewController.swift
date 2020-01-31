//
//  FavoritesCountriesListViewController.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 31.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import UIKit

final class FavoritesCountriesListViewController: UIViewController, Alertable, StoryboardInstantiable {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyDataLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var viewModel: FavoritesCountriesListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Countries", comment: "")
        emptyDataLabel.text = NSLocalizedString("Search results", comment: "")
        tabBarItem.title = NSLocalizedString("Countries", comment: "")
        tabBarItem.image = UIImage(named: "star")
                
        bind(to: viewModel)
        //viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: FavoritesCountriesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.reload() }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.loadingType.observe(on: self) { [weak self] _ in self?.updateViewsVisibility() }
        viewModel.route.observe(on: self) { [weak self] in self?.handle($0) }
    }
    
    func showError(_ error: String) {
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
        // updateQueriesSuggestionsVisibility()
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

extension FavoritesCountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension FavoritesCountriesListViewController {
    func handle(_ route: CountriesListViewModelRoute) {
        switch route {
        case .initial: break
        case .showCountryDetail(let name):
            let controller = assembly.ui.country(by: name)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
