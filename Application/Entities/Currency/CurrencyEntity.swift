//
//  CurrencyEntity.swift
//  Application
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Domain

struct CurrencyEntity {
    let symbol: String
    let value: Double

    // MARK: Initializers

    public init(symbol: String, value: Double) {
        self.symbol = symbol
        self.value = value
    }
}

extension CurrencyEntity: DomainTypeConvertible {

    // MARK: DomainTypeConvertible

    func asDomain() -> Currency {
        return Currency(symbol: symbol, value: value)
    }
}
