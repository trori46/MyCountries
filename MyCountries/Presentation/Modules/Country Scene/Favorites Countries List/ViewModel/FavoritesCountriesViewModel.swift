//
//  FavoritesCountriesViewModel.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 31.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//
import Foundation
import RxSwift
import UIKit

protocol FavouritesCountriesListViewModelInput {
    func viewDidLoad()
    func didSelect(item: CountriesListItemViewModel)
}

protocol FavoritesCountriesListViewModel: CountriesListViewModelOutput, FavouritesCountriesListViewModelInput {}

final class DefaultFavoritesCountriesListViewModel: FavoritesCountriesListViewModel {
    
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
        let favorites = UserDefaults.standard.favorites
        
        loadingType.value = .fullScreen
        _ = countriesUseCase.countries()
            .observeOn(MainScheduler.instance)
            .map { $0.map(DefaultCountriesListItemViewModel.init) }
            .do(onSuccess: { [weak self] (a) in
                self?.items.value = a
                self?.selectFavorites(favorites: favorites ?? [])
                self?.loadingType.value = .none
                
                }, onError: { [weak self] in
                    self?.loadingType.value = .none
                    self?.error.value = $0.localizedDescription
            })
            .subscribe()
        
        observer = UserDefaults.standard.observe(\.favorites!, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            guard let favorites = change.newValue else { return }
            self?.selectFavorites(favorites: favorites)
        })
    }
    
    func selectFavorites(favorites: [String]) {
        let array = items.value
        array.forEach { $0.deselectFavorite() }
        
        favorites.forEach { (name) in
            
            array.first(where: { $0.name == name })?.selectFavorite()
            items.value = array.filter { $0.isFavorite  }
            
        }
    }
    
    func didSelect(item: CountriesListItemViewModel) {
        route.value = .showCountryDetail(name: item.name)
    }
}
