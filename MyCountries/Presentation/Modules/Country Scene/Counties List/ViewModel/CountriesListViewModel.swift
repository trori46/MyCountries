//
//  CountriesViewModel.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

enum CountriesListViewModelLoading {
    case none
    case fullScreen
    // case nextPage
}

protocol CountriesListViewModelOutput {
    var items: Observable<[CountriesListItemViewModel]> { get }
    var loadingType: Observable<CountriesListViewModelLoading> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
}

protocol CountriesListViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelect(item: CountriesListItemViewModel)
}

protocol CountriesListViewModel: CountriesListViewModelOutput, CountriesListViewModelInput {}

final class DefaultCountriesListViewModel: CountriesListViewModel {
    func viewDidLoad() {
        loadingType.value = .fullScreen
        _ = countriesUseCase.countries()
            .observeOn(MainScheduler.instance)
            .map { $0.map(DefaultCountriesListItemViewModel.init) }
            .do(onSuccess: { [weak self] (a) in
                print(a)
                self?.items.value = a
                self?.loadingType.value = .none
                
                }, onError: { [weak self] _ in
                    self?.error.value = "sfdfs"
            })
            .subscribe()
    }
    
    var items: Observable<[CountriesListItemViewModel]> = Observable([])
    let loadingType: Observable<CountriesListViewModelLoading> = Observable(.none)
    var isEmpty: Bool { return items.value.isEmpty }
    let error: Observable<String> = Observable("")
    
    private let countriesUseCase: CountriesUseCase
    
    init(countriesUseCase: CountriesUseCase) {
        self.countriesUseCase = countriesUseCase
    }
    
    func didSearch(query: String) {
        
    }
    
    func didCancelSearch() {
        
    }
    
    func showQueriesSuggestions() {
        
    }
    
    func closeQueriesSuggestions() {
        
    }
    
    func didSelect(item: CountriesListItemViewModel) {
        
    }
}
