//
//  CountriesServiceImpl.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import RxSwift
import Alamofire

protocol CountriesUseCase {
    
    func countries() -> Single<Countries>
    func country(by name: String) -> Single<Country.Details>
}

final class DefaultCountriesUseCase {
    
    let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
}

extension DefaultCountriesUseCase: CountriesUseCase {
    
    func countries() -> Single<Countries> {
        client.data(APIEndpoints.counties())
            .map { try JSONDecoder().decode(Countries.self, from: $0) }
    }
    
    func country(by name: String) -> Single<Country.Details> {
        client.data(APIEndpoints.county(by: name))
            .map { try JSONDecoder().decode([Country.Details].self, from: $0) }
            .map {
                print($0)
                return $0.first! }
    }
}
