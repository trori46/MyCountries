//
//  APIClientImpl.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Alamofire
import RxSwift

protocol ErrorHandler {
    
    static func handle(error: Error)
}

final class APIClientImpl {
    
    private let manager: Alamofire.SessionManager
    private var headers : HTTPHeaders = [
      "X-RapidAPI-Key" : Configurations.apiKey,
      "X-RapidAPI-Host" : "restcountries-v1.p.rapidapi.com"
    ]
    
    let baseURL: URL
    
    init(baseURL: URL) {
        self.manager = Alamofire.SessionManager.default
        self.baseURL = baseURL
    }
    
    var errorHandler: ErrorHandler.Type?
}

extension APIClientImpl: APIClient {
    
    func data(_ endpoint: HTTPRequest) -> Single<Data> {
        let request = manager.request(
            baseURL.appendingPathComponent(endpoint.path),
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: headers)
        print(request.debugDescription)
        return response(from: request)
    }
    
    private func response(from request: DataRequest) -> Single<Data> {
        
        return Single<Data>.create { observer in
            request.validate().responseData { response in
                switch response.result {
                case let .success(value):
                    observer(.success(value))
                case let .failure(error):
                    observer(.error(error))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
            .do(onError: { [weak self] in self?.errorHandler?.handle(error: $0) })
    }
}

