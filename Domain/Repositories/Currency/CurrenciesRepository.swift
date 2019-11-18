//
//  CurrenciesRepository.swift
//  Domain
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import RxSwift

public enum CurrencyType {
    case BRL
    case EUR
    case GBP
    case JPY
}

public protocol CurrenciesRepository {
    func retrieveCurrencies(for currencies: [CurrencyType]) -> Single<[Currency]>
}

public extension CurrenciesRepository {
    func retrieveCurrencies(for currencies: [CurrencyType] = [.BRL, .EUR, .GBP, .JPY]) -> Single<[Currency]> {
        return retrieveCurrencies(for: currencies)
    }
}
