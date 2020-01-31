//
//  Country.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Foundation

typealias Countries = [Country]

struct Country: Decodable {
    let name: String
    let capital: String
    let region: String
}
