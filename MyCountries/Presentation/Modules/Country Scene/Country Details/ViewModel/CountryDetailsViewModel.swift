//
//  CountryDetailsViewModel.swift
//  MyCountries
//
//  Created by Viktoria Rohozhyna on 30.01.2020.
//  Copyright © 2020 Viktoria Rohozhyna. All rights reserved.
//

import Foundation

protocol CountryDetailsViewModelOutput {
    
    var item: Observable<CountryDetailsItemViewModel?> { get }
    var loadingType: Observable<CountriesListViewModelLoading> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var name: String { get }
}

protocol CountryDetailsViewModelInput {
    func viewDidLoad()
}

protocol CountryDetailsViewModel: CountryDetailsViewModelOutput, CountryDetailsViewModelInput { }

final class DefaultCountryDetailsViewModel: CountryDetailsViewModel {
    
    var item: Observable<CountryDetailsItemViewModel?> = Observable(nil)
    let loadingType: Observable<CountriesListViewModelLoading> = Observable(.none)
    var isEmpty: Bool { return item.value == nil }
    let error: Observable<String> = Observable("")
    var name: String
    
    private let countriesUseCase: CountriesUseCase
    
    init(name: String, countriesUseCase: CountriesUseCase) {
        self.countriesUseCase = countriesUseCase
        self.name = name
    }
    
    func viewDidLoad() {
        updateData()
    }
    
    func updateData() {
        loadingType.value = .fullScreen

        _ = countriesUseCase.country(by: name)
            .map(DefaultCountryDetailsItemViewModel.init)
            .do(onSuccess: { [weak self] in
                self?.loadingType.value = .none
                self?.item.value = $0
            }, onError: { [weak self] in
                self?.loadingType.value = .none
                self?.error.value = $0.localizedDescription
            })
        .subscribe()
    }
}
