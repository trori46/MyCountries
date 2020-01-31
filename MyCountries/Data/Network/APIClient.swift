//
//  APIClient.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import RxSwift
import Alamofire

typealias Parameters = Alamofire.Parameters
typealias HTTPMethod = Alamofire.HTTPMethod
typealias HTTPHeaders = Alamofire.HTTPHeaders
typealias ParameterEncoding = Alamofire.ParameterEncoding

protocol APIClient {
    
    func data(_ endpoint: HTTPRequest) -> Single<Data>
}
