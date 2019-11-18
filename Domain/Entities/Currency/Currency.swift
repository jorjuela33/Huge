//
//  Currency.swift
//  Domain
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Foundation

public struct Currency {
    public let type: CurrencyType
    public let value: Double

    // MARK: Initializers

    public init(type: CurrencyType, value: Double) {
        self.type = type
        self.value = value
    }
}

extension Currency: Equatable {

    // MARK: Equatable

    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.type.rawValue == rhs.type.rawValue && lhs.value == rhs.value
    }
}
