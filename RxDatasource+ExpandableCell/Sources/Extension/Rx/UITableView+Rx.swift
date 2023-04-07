//
//  UITableView+Rx.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UITableView {
    func itemSelected<S>(
        dataSource: TableViewSectionedDataSource<S>
    ) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}
