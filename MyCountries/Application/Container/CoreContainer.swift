//
//  CoreContainer.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Dip

protocol CoreContainer {
    
    func apiClient() -> APIClient
}

extension DependencyContainer: CoreContainer {
    
    func apiClient() -> APIClient {
        return try! resolve()
    }
}

extension DependencyContainer {
    
    static func core() -> DependencyContainer {
        let container = DependencyContainer()
        
        container.register(.singleton) { () -> APIClient in
            
            let client = APIClientImpl(baseURL: URL(string: "https://restcountries-v1.p.rapidapi.com")!)
            
            return client
        }
        
        return container
    }
}
