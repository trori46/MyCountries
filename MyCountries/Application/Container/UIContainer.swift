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

}

extension DependencyContainer: UIContainer {
    
    func countries() -> UIViewController {
        return try! resolve() as CountriesListViewController
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
        
        return container
    }
}

extension UIStoryboard {
    
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let countries = UIStoryboard(name: "Countries", bundle: nil)

}

extension UIStoryboard {
    
    func instantiateViewController<ViewController: UIViewController>(withIdentifier identifier: String = .init(describing: ViewController.self)) -> ViewController {
        guard let controller = instantiateViewController(withIdentifier: identifier) as? ViewController else {
            fatalError("Could not find \(ViewController.self) in \(self)")
        }
        
        return controller
    }
}
