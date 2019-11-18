//
//  RepositoryProvider.swift
//  Application
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Domain

public final class RepositoryProvider {
    private let connection: Connection

    // MARK: Initializers

    public init() {
        self.connection = PersistentConnection(server: Server.production, eventMonitors: [LoggingEventMonitor()])
    }
}

extension RepositoryProvider: Domain.RepositoryProvider {

    // MARK: RepositoryProvider

    public func makeCurrenciesRepository() -> Domain.CurrenciesRepository {
        let authToken = AccessToken(tokenString: "8aa5b7d43de6b7bc8f04532ab36b103a")
        let network = NetworkManager(connection: connection).authenticate(authToken)
        return CurrenciesRepository(network: network)
    }
}
