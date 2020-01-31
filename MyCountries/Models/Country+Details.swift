//
//  Country+Details.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 31.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

extension Country {
    
    struct Details: Decodable {
        let name: String
        let capital: String
        let region: String
        let subregion: String
        let population: Double
        let area: Int
        let currencies: [String]
    }
}
