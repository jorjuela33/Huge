//
//  Currency.swift
//  Domain
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Foundation

public struct Currency {
    public let symbol: String
    public let value: Double

    // MARK: Initializers

    public init(symbol: String, value: Double) {
        self.symbol = symbol
        self.value = value
    }
}

extension Currency: Equatable {

    // MARK: Equatable

    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.symbol == rhs.symbol && lhs.value == rhs.value
    }
}
