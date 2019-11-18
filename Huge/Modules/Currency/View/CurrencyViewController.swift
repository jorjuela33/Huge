//
//  CurrencyViewController.swift
//  Huge
//
//  Created by Jorge Orjuela on 11/18/19.
//  Copyright © 2019 Jorge Orjuela. All rights reserved.
//

import Charts
import RxCocoa
import RxSwift
import UIKit

class CurrencyViewController: ViewController {

    @IBOutlet var chartView: BarChartView!
    @IBOutlet var valueTextField: UITextField!

    private let disposeBag = DisposeBag()
    private let convertBarButtonItem = UIBarButtonItem(title: "Convert", style: .plain, target: nil, action: nil)
    private lazy var loadingIndicator: LoadingIndicator = {
         return LoadingIndicator.show(in: self.view)
     }()

    var presenter: CurrencyPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        bindPresenter()
        configure()
    }

    // MARK: Private methods

    private func bindPresenter() {
        let convert = convertBarButtonItem.rx.tap.asDriver().do(onNext: { [weak self] in self?.view.endEditing(true)})
        let value = valueTextField.rx.text.orEmpty.map({ Double($0) ?? 0 }).asDriverOnErrorJustComplete()
        let input = CurrencyPresenter.Input(convert: convert, value: value)
        let output = presenter?.transform(input)

        output?.error.drive(rx.message).disposed(by: disposeBag)
        output?.state.drive(loadingIndicator.rx.state).disposed(by: disposeBag)
        output?.symbols.drive(onNext: { [weak self] symbols in
            self?.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: symbols)
        })
        .disposed(by: disposeBag)
        
        output?.currencies.drive(onNext: { [weak self] chartEntries in
            let chartDataSet = BarChartDataSet(entries: chartEntries, label: "Currencies")
            self?.chartView.animate(yAxisDuration: 1.5)
            self?.chartView.data = BarChartData(dataSet: chartDataSet)
        })
        .disposed(by: disposeBag)
    }

    private func configure() {
        navigationItem.rightBarButtonItem = convertBarButtonItem
        chartView.drawValueAboveBarEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.delegate = self
        chartView.highlightPerTapEnabled = true
        chartView.noDataText = "No currencies."
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
    }
}

extension CurrencyViewController: ChartViewDelegate {}
