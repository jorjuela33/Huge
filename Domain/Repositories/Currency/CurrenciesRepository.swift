//
//  CurrenciesRepository.swift
//  Domain
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import RxSwift

public enum CurrencyType: String {
    case BRL
    case GBP
    case JPY
    case USD
}

public protocol CurrenciesRepository {
    func retrieveCurrencies(for currencies: [CurrencyType]) -> Single<[Currency]>
}

public extension CurrenciesRepository {
    func retrieveCurrencies(for currencies: [CurrencyType] = [.BRL, .GBP, .JPY, .USD]) -> Single<[Currency]> {
        return retrieveCurrencies(for: currencies)
    }
}
