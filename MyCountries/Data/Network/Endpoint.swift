//
//  Endpoint.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Alamofire

struct Endpoint {
    
    public var path: String
    public var method: HTTPMethod
    public var parameters: Parameters?
    public var encoding: ParameterEncoding
        
    init(path: String,
         method: HTTPMethod = .get,
         parameters: Parameters? = nil,
         encoding: ParameterEncoding = URLEncoding.default) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
    }
}
