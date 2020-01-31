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
    var isFavorite: Bool = false {
        didSet {
            favoritesButton.tintColor = isFavorite ? .yellow : .gray
        }
    }
    
    func configure(with viewModel: CountriesListItemViewModel) {
        nameLabel.text = viewModel.name
        capitalLabel.text = viewModel.capital
        regionLabel.text = viewModel.region
        isFavorite = viewModel.isFavorite
        favoritesButton.setImage(UIImage(named: "star"), for: .normal)
    }
    
    @IBAction func favorite(_ sender: Any) {
        guard let name = nameLabel.text else { return }
        var array = UserDefaults.standard.favorites
        
        if array?.contains(name) ?? false {
            array = array?.filter { $0 != name }
        } else {
            if array == nil {
                array = [name]
            } else {
                array?.append(name)
            }
        }
        
        UserDefaults.standard.set(array, forKey: "favorites")
        
    
    }
    
    enum State {
        case none, typed
    }
}

extension UserDefaults {
    @objc dynamic var favorites: [String]? {
        return array(forKey: "favorites") as? [String]
    }
}
