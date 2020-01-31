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
    let name: String
    let capital: String
    let region: String
    let subregion: String
    let population: String
    let area: String
    let currencies: String
    
    init(_ country: Country.Details) {
        self.name = NSLocalizedString("The name of country: ", comment: "") + "\(country.name)"
        self.capital = NSLocalizedString("The capital: ", comment: "") + "\(country.capital)"
        self.region = NSLocalizedString("Region: ", comment: "") + "\(country.region)"
        self.subregion = NSLocalizedString("Subregion: ", comment: "") + "\(country.subregion)"
        self.population = NSLocalizedString("Population: ", comment: "") + "\(country.population)"
        self.area = NSLocalizedString("Area: ", comment: "") + "\(country.area)"
        self.currencies = NSLocalizedString("Currencies: ", comment: "") + country.currencies.joined(separator: ", ")
    }
}
