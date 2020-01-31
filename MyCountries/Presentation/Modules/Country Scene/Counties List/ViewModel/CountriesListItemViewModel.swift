//
//  CountriesListItemViewModel.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Foundation

protocol CountriesListItemViewModelOutput {
    var name: String { get }
    var capital: String { get }
    var region: String { get }
    var isFavorite: Bool { get set }
    func deselectFavorite()
    func selectFavorite()
}

protocol CountriesListItemViewModel: CountriesListItemViewModelOutput {}

final class DefaultCountriesListItemViewModel: CountriesListItemViewModel {

    // MARK: - OUTPUT
    let name: String
    let capital: String
    let region: String
    var isFavorite: Bool = false

    func deselectFavorite() {
        isFavorite = false
    }
    
    func selectFavorite() {
        isFavorite = true
    }
    
    init(_ country: Country) {
        self.name = country.name
        self.capital = country.capital
        self.region = country.region
    }
}
