//
//  APIEndpoint.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Foundation

struct APIEndpoints {
    
    static func counties() -> HTTPRequest {
        return HTTPRequest(path: "/all")
    }
    
    static func county(by name: String) -> HTTPRequest {
        return HTTPRequest(path: "/name/\(name)")
    }
}
