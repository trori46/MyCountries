//
//  ServicesContainer.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Dip

protocol ServicesContainer {
    
    func service<T>(_ type: T.Type) -> T
}

extension DependencyContainer: ServicesContainer {
    
    func service<T>(_ type: T.Type) -> T {
        return try! resolve()
    }
}

extension DependencyContainer {
    
    static func services() -> DependencyContainer {
        let container = DependencyContainer()
        
        container.register(.singleton) { () -> CountriesUseCase in
            let service = DefaultCountriesUseCase(client: try container.resolve())
            return service
        }
        return container
    }
}
