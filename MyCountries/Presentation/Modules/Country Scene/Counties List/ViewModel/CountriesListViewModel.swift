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


enum CountriesListViewModelRoute {
    case initial
    case showCountryDetail(name: String)
}

enum CountriesListViewModelLoading {
    case none
    case fullScreen
    // case nextPage
}

protocol CountriesListViewModelOutput {
    var route: Observable<CountriesListViewModelRoute> { get }
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
    
    let route: Observable<CountriesListViewModelRoute> = Observable(.initial)
    var items: Observable<[CountriesListItemViewModel]> = Observable([])
    let loadingType: Observable<CountriesListViewModelLoading> = Observable(.none)
    var isEmpty: Bool { return items.value.isEmpty }
    let error: Observable<String> = Observable("")
    
    var observer: NSKeyValueObservation?
    
    private let countriesUseCase: CountriesUseCase
    
    init(countriesUseCase: CountriesUseCase) {
        self.countriesUseCase = countriesUseCase
    }
    
    func viewDidLoad() {
        updateDate()
    }
    
    func updateDate() {
        loadingType.value = .fullScreen
        _ = countriesUseCase.countries()
            .observeOn(MainScheduler.instance)
            .map { $0.map(DefaultCountriesListItemViewModel.init) }
            .do(onSuccess: { [weak self] (a) in
                print(a)
                self?.items.value = a
                self?.loadingType.value = .none
                
                }, onError: { [weak self] in
                    self?.loadingType.value = .none
                    self?.error.value = $0.localizedDescription
            })
            .subscribe()
        
        observer = UserDefaults.standard.observe(\.favorites!, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            guard let array = self?.items.value else { return }
            array.forEach { $0.deselectFavorite() }
            
            change.newValue?.forEach { (name) in
                
                array.first(where: { $0.name == name })?.selectFavorite()
                self?.items.value = array
            }
        })
    }
    
    func selectFavorites(favorites: [String]) {
           let array = items.value
           array.forEach { $0.deselectFavorite() }
           
           favorites.forEach { (name) in
               
               array.first(where: { $0.name == name })?.selectFavorite()
               self.items.value = array
           }
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
        route.value = .showCountryDetail(name: item.name)
    }
}
