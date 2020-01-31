//
//  UIContainer.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import UIKit
import Dip

protocol UIContainer {

    func countries() -> UIViewController
    func country(by: String) -> UIViewController

}

extension DependencyContainer: UIContainer {
    
    func countries() -> UIViewController {
        return try! resolve() as CountriesListViewController
    }
    
    func country(by name: String) -> UIViewController {
        return try! resolve(arguments: name) as CountryDetailsViewController
    }
}

extension DependencyContainer {
    
    static func ui() -> DependencyContainer {
        let container = DependencyContainer()
        
        container.register { () -> CountriesListViewController in
            let viewModel = DefaultCountriesListViewModel(countriesUseCase: try container.resolve())
            let controller = UIStoryboard.countries.instantiateViewController() as CountriesListViewController
            controller.viewModel = viewModel
            
            return controller
        }
        
        container.register { (name: String) -> CountryDetailsViewController in
            let viewModel = DefaultCountryDetailsViewModel(name: name, countriesUseCase: try container.resolve())
                   let controller = UIStoryboard.countryDetails.instantiateViewController() as CountryDetailsViewController
                   controller.viewModel = viewModel
                   
                   return controller
               }
        
        return container
    }
}

extension UIStoryboard {
    
    static let countries = UIStoryboard(name: "CountriesList", bundle: nil)
    static let countryDetails = UIStoryboard(name: "CountryDetails", bundle: nil)
}

extension UIStoryboard {
    
    func instantiateViewController<ViewController: UIViewController>(withIdentifier identifier: String = .init(describing: ViewController.self)) -> ViewController {
        guard let controller = instantiateViewController(withIdentifier: identifier) as? ViewController else {
            fatalError("Could not find \(ViewController.self) in \(self)")
        }
        
        return controller
    }
}
