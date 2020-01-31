//
//  CountryDetailsItemViewModel.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Foundation

protocol CountryDetailsItemViewModelOutput {
    var name: String { get }
    var capital: String { get }
    var region: String { get }
    var subregion: String { get }
    var population: String { get }
    var area: String { get }
    var currencies: String { get }
}

protocol CountryDetailsItemViewModel: CountryDetailsItemViewModelOutput {}

final class DefaultCountryDetailsItemViewModel: CountryDetailsItemViewModel {
    // MARK: - OUTPUT
    let name: String
    let capital: String
    let region: String
    let subregion: String
    let population: String
    let area: String
    let currencies: String
    
    init(_ country: Country.Details) {
        self.name = country.name
        self.capital = country.capital
        self.region = country.region
        self.subregion = country.subregion
        self.population = "\(country.population)"
        self.area = "\(country.area)"
        self.currencies = country.currencies.joined(separator: ", ")
    }
}
