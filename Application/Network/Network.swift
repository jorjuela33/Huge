//
//  Network.swift
//  Application
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Domain

typealias RetrieveCallback<T> = (Result<T, Error>) -> Void
typealias VoidCallback = (Result<Void, Error>) -> Void

struct CurrenciesResponse: Codable {
    let success: Bool
    let date: String
    let rates: [String: Double]
    let timestamp: TimeInterval
}

protocol Network {
    func authenticate(_ authToken: AccessToken) -> Self
    func cancelConnectionRequest(withRegistration registration: ConnectionRequestRegistration)
    func header(forKey key: String) -> String?
    func retrieveCurrencies(
        for currencies: [String],
        withCallback callback: @escaping RetrieveCallback<[CurrencyEntity]>
    ) -> ConnectionRequestRegistration

    func setHeader(_ value: String, forKey key: String)
}

final class NetworkManager: Network {
    private var apiKey = ""
    private let connection: Connection
    private let connectionTree = ConnectionTree()
    private static let queue = DispatchQueue(label: "com.network.queue")

    // MARK: Initializers

    init(connection: Connection) {
        self.connection = connection
    }

    // MARK: Network

    /// sets the authentication token.
    func authenticate(_ authToken: AccessToken) -> NetworkManager {
        let networkManager = NetworkManager(connection: connection)
        networkManager.apiKey = authToken.tokenString
        return networkManager
    }

    /// cancels the request associated to the registration
    func cancelConnectionRequest(withRegistration registration: ConnectionRequestRegistration) {
        connectionTree.removeConnectionRequest(withRegistration: registration)
    }

    /// return the value associated to the given header
    func header(forKey key: String) -> String? {
        return connection.header(forKey: key)
    }

    /// retrieves all the currencies for the given symbols
    func retrieveCurrencies(
        for currencies: [String],
        withCallback callback: @escaping RetrieveCallback<[CurrencyEntity]>
    ) -> ConnectionRequestRegistration {

        let parameters: [String: Any] =  ["access_key": apiKey, "symbols": currencies.joined(separator: ",")]
        let connectionRequest = connection.get("latest", parameters: parameters).response({ (result: Result<CurrenciesResponse, Error>) in
            switch result {
            case let .failure(error):
                callback(.failure(error))
                
            case let .success(response):
                guard response.success else {
                    let error = HGError(key: "NetworkManager.retrieveCurrencies", currentValue: response, reason: "Something Went Wrong")
                    callback(.failure(error))
                    return
                }

                let currencies = response.rates.map({ CurrencyEntity(symbol: $0.key, value: $0.value) })
                callback(.success(currencies))
            }
        })
        .validate()
        enqueueConnectionRequest(connectionRequest)
        return connectionRequest.identifier
    }

    /// sets the header for all the requests
    func setHeader(_ value: String, forKey key: String) {
        connection.setHeader(value, forKey: key)
    }

    // MARK: Private methods

    private func enqueueConnectionRequest(_ connectionRequest: ConnectionRequest) {
        connectionRequest.completionCallback = { [weak self] in
            self?.cancelConnectionRequest(withRegistration: connectionRequest.identifier)
        }

        NetworkManager.queue.async {
            self.connectionTree.addConnectionRequest(connectionRequest)
        }
    }
}
