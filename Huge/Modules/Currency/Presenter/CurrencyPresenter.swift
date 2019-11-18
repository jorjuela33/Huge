//
//  CurrencyPresenter.swift
//  Huge
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Domain
import RxCocoa
import RxSwift

class CurrencyPresenter {
    private let disposeBag = DisposeBag()
    private let currenciesRepository: CurrenciesRepository
    private let wireframe: CurrencyWireframeInterface?

    struct Input {
        let convert: Driver<Void>
    }

    struct Output {
        let error: Driver<Message>
        let currencies: Driver<Any>
        let state: Driver<ActivityState>
    }

    // MARK: Initializers

    init(currenciesRepository: CurrenciesRepository, wireframe: CurrencyWireframeInterface) {
        self.currenciesRepository = currenciesRepository
        self.wireframe = wireframe
    }

    // MARK: Instance methods

    func transform(_ input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        currenciesRepository.retrieveCurrencies()
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .subscribe(onNext: { currencies in

            })
            .disposed(by: disposeBag)

        return Output(error: errorTracker.map(ErrorBuilder.create), currencies: Driver.empty(), state: activityIndicator.asDriver())
    }
}
