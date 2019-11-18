//
//  CurrencyWireframe.swift
//  Huge
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Domain
import UIKit

protocol CurrencyWireframeInterface {
    func toCurrencies()
}

struct CurrencyWireframe {
    private let navigationController: NavigationController
    private let repositoryProvider: RepositoryProvider
    private let storyBoard: UIStoryboard

    // MARK: Initializers

     init(
        navigationController: NavigationController,
        repositoryProvider: RepositoryProvider,
        storyBoard: UIStoryboard = UIStoryboard(storyboardName: .main)
        ) {

        self.navigationController = navigationController
        self.repositoryProvider = repositoryProvider
        self.storyBoard = storyBoard
    }
}

extension CurrencyWireframe: CurrencyWireframeInterface {

    // MARK: CurrencyWireframeInterface

    func toCurrencies() {
        let presenter = CurrencyPresenter(currenciesRepository: repositoryProvider.makeCurrenciesRepository(), wireframe: self)
        let viewController: CurrencyViewController = storyBoard.instantiateViewController()

        viewController.presenter = presenter
        navigationController.pushViewController(viewController, animated: false)
    }
}
