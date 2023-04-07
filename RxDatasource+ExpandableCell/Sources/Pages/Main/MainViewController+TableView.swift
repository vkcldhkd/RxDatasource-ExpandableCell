//
//  MainViewController+TableView.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import RxSwift
extension MainViewController {
    // MARK: BindTableView
    func bindTableView(reactor: Reactor){
        // MARK: - Action
        self.tableView.rx.itemSelected(dataSource: self.dataSource)
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] item in
                switch item {
                case let .item(cellReacotr):
                    self?.tableView.beginUpdates()
                    cellReacotr.action.onNext(.updateExpandedState)
                    self?.tableView.endUpdates()
                default: return
                }
            })
            .disposed(by: self.disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.section }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}
