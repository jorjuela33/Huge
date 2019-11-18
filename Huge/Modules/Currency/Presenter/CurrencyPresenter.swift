//
//  CurrencyPresenter.swift
//  Huge
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Charts
import Domain
import RxCocoa
import RxSwift

class CurrencyPresenter {
    private let currenciesRepository: CurrenciesRepository
    private let disposeBag = DisposeBag()
    private let wireframe: CurrencyWireframeInterface?

    struct Input {
        let convert: Driver<Void>
        let value: Driver<Double>
    }

    struct Output {
        let currencies: Driver<[BarChartDataEntry]>
        let error: Driver<Message>
        let symbols: Driver<[String]>
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
        let currenciesSubject = PublishSubject<[BarChartDataEntry]>()
        let symbols = PublishSubject<[String]>()

        input.convert.withLatestFrom(input.value).flatMapLatest { value in
            self.currenciesRepository.retrieveCurrencies()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .do(onNext: { currencies in
                    symbols.onNext(currencies.map({ $0.type == .USD ? "EUR" : $0.type.rawValue }))
                })
                .map({ currencies -> [BarChartDataEntry] in
                    var entries: [BarChartDataEntry] = []
                    for (index, currency) in currencies.enumerated() {
                        if currency.type == .USD {
                            entries.append(BarChartDataEntry(x: Double(index), y: value / currency.value))
                        } else {
                            entries.append(BarChartDataEntry(x: Double(index), y: currency.value * value))
                        }
                    }

                    return entries
                })
                .asDriverOnErrorJustComplete()
        }
        .drive(onNext: currenciesSubject.onNext)
        .disposed(by: disposeBag)

        return Output(
            currencies: currenciesSubject.asDriverOnErrorJustComplete(),
            error: errorTracker.map(ErrorBuilder.create),
            symbols: symbols.asDriverOnErrorJustComplete(),
            state: activityIndicator.asDriver()
        )
    }
}
