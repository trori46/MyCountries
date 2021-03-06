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
    
    func root() -> UIViewController
    func countries() -> UIViewController
    func country(by: String) -> UIViewController
}

extension DependencyContainer: UIContainer {
    
    func root() -> UIViewController {
        return try! resolve() as UITabBarController
    }
    
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
        
        container.register { () -> UITabBarController in
            let controller = UITabBarController()
            
            let controllers = [
                try container.resolve() as CountriesListViewController,
                try container.resolve() as FavoritesCountriesListViewController
            ]
            
            controller.viewControllers = controllers.map {
                let controller = UINavigationController(rootViewController: $0)
                controller.tabBarItem.title = $0.tabBarItem.title
                return controller
            }
            
            controller.selectedIndex = 0
            
            return controller
        }
        
        container.register { () -> CountriesListViewController in
            let viewModel = DefaultCountriesListViewModel(countriesUseCase: try container.resolve())
            let controller = UIStoryboard.countries.instantiateViewController() as CountriesListViewController
            controller.viewModel = viewModel
            controller.title = NSLocalizedString("Countries", comment: "")
            
            controller.tabBarItem.title = controller.navigationItem.title
            controller.tabBarItem.image = #imageLiteral(resourceName: "Countries")
            
            return controller
        }
        
        container.register { () -> FavoritesCountriesListViewController in
            let viewModel = DefaultFavoritesCountriesListViewModel(countriesUseCase: try container.resolve())
            let controller = UIStoryboard.countries.instantiateViewController() as FavoritesCountriesListViewController
            controller.viewModel = viewModel
            controller.title = NSLocalizedString("Favorites", comment: "")
            controller.tabBarItem.title = controller.navigationItem.title
            controller.tabBarItem.image = #imageLiteral(resourceName: "Favorites")
            
            return controller
        }
        
        container.register { (name: String) -> CountryDetailsViewController in
            let viewModel = DefaultCountryDetailsViewModel(name: name, countriesUseCase: try container.resolve())
            let controller = UIStoryboard.countryDetails.instantiateViewController() as CountryDetailsViewController
            controller.title = NSLocalizedString("Details", comment: "")
            
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
