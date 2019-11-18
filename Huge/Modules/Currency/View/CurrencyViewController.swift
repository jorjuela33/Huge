//
//  CurrencyViewController.swift
//  Huge
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CurrencyViewController: ViewController {
    private let disposeBag = DisposeBag()
    private lazy var loadingIndicator: LoadingIndicator = {
         return LoadingIndicator.show(in: self.view)
     }()

    var presenter: CurrencyPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        bindPresenter()
    }

    // MARK: Private methods

    private func bindPresenter() {
        let input = CurrencyPresenter.Input(convert: Driver.empty())
        let output = presenter?.transform(input)

        output?.error.drive(rx.message).disposed(by: disposeBag)
        output?.state.drive(loadingIndicator.rx.state).disposed(by: disposeBag)
    }
}
