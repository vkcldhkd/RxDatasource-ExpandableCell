//
//  MainViewController+Common.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//
import RxSwift

extension MainViewController {
    // MARK: BindCommon
    func bindCommon(reactor: Reactor){
        // MARK: - Action
        self.refreshControl.rx.controlEvent(.valueChanged)
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: self.activityIndicatorView.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
    }
}
