//
//  CountriesListItemCell.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import UIKit

final class CountriesListItemCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    
    static let reuseIdentifier = String(describing: CountriesListItemCell.self)
    static let height = CGFloat(130)
    
    func configure(with viewModel: CountriesListItemViewModel) {
        nameLabel.text = viewModel.name
        capitalLabel.text = viewModel.capital
        regionLabel.text = viewModel.region
    }
}
