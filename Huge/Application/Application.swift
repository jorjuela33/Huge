//
//  Application.swift
//  Huge
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Application
import UIKit.UIWindow

class Application {
    static let shared = Application()

    // MARK: Instance methods

    func configureMainInterface(in window: UIWindow) {
        let repositoryProvider = RepositoryProvider()
        let navigationController = NavigationController()
        window.rootViewController = navigationController

        let currencyWireframe = CurrencyWireframe(navigationController: navigationController, repositoryProvider: repositoryProvider)
        currencyWireframe.toCurrencies()
        window.makeKeyAndVisible()
    }
}
