//
//  CurrenciesRepository.swift
//  Application
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Domain
import RxSwift

class CurrenciesRepository: Repository {
    private let network: Network

    // MARK: Initializaters

    init(network: Network) {
        self.network = network
    }
}

extension CurrenciesRepository: Domain.CurrenciesRepository {

    // MARK: CurrenciesRepository

    func retrieveCurrencies(for currencies: [CurrencyType]) -> Single<[Currency]> {
        return Single.create(subscribe: { observer in
            self.beginLoading()
            let connectionRequestRegistration = self.network.retrieveCurrencies(for: currencies.map({ $0.rawValue }), withCallback: { result in
                switch result {
                case let .failure(error):
                    self.endLoadingStateWithState(.error)
                    observer(.error(error))

                case let .success(currencies):
                    self.endLoadingStateWithState(.contentLoaded)
                    observer(.success(currencies.mapToDomain()))
                }
            })
            return Disposables.create {
                self.network.cancelConnectionRequest(withRegistration: connectionRequestRegistration)
            }
        })
    }
}
