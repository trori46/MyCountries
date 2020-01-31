//
//  CountryDetailsViewController.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import UIKit

final class CountryDetailsViewController: UIViewController, Alertable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var subregionLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var currenciesLabel: UILabel!
    
    var viewModel: CountryDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: CountryDetailsViewModel) {
        viewModel.item.observe(on: self) { [weak self] in self?.reload(with: $0) }
        viewModel.error.observe(on: self) { [weak self] in self?.configure($0) }
    }
    
    func reload(with viewModel: CountryDetailsItemViewModel?) {
        guard let item = viewModel else { return }
        nameLabel.text = item.name
        capitalLabel.text = item.capital
        regionLabel.text = item.region
        subregionLabel.text = item.subregion
        populationLabel.text = item.population
        areaLabel.text = item.area
        currenciesLabel.text = item.currencies
    }
    
    func configure(_ error: String) {
         guard !error.isEmpty else { return }
         showAlert(title: NSLocalizedString("Error", comment: ""), message: error)
     }
}
