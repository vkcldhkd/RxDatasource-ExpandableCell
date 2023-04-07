//
//  MainViewController.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import UIKit
import RxSwift
import RxDataSources
import ReactorKit
import ReusableKit
import Then
import SnapKit

final class MainViewController: UIViewController {
    // MARK: - Constants
    typealias Reactor = MainViewReactor
    fileprivate struct Reusable {
        static let itemCell = ReusableCell<ImageItemCell>()
    }
    
    // MARK: - UI
    lazy var activityIndicatorView = UIActivityIndicatorView().then{
        if #available(iOS 13.0, *) {
            $0.style = .medium
            $0.color = UIColor.gray
        } else {
            $0.style = .gray
        }
    }
    let refreshControl = RefreshControl()
    lazy var tableView = UITableView().then {
        $0.refreshControl = self.refreshControl
        $0.register(Reusable.itemCell)
    }
    
    // MARK: - Rx
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    let dataSource: RxTableViewSectionedReloadDataSource<ImageListSection>
    private static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<ImageListSection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                switch sectionItem {
                case let .item(cellReactor):
                    let cell = tableView.dequeue(Reusable.itemCell, for: indexPath)
                    cell.itemView.reactor = cellReactor
                    return cell
                    
                case .empty:
                    return UITableViewCell()
                }
            }
        )
    }
    
    init() {
        defer {
            self.reactor = Reactor()
            self.reactor?.action.onNext(.load)
        }
        self.dataSource = type(of: self).dataSourceFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupConstraints()
    }
}

private extension MainViewController {
    // MARK: - setupUI
    func setupUI() {
        defer { self.view.addSubview(self.activityIndicatorView) }
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - setupConstraints
    func setupConstraints() {
        defer {
            self.activityIndicatorView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
}

extension MainViewController: ReactorKit.View {
    func bind(reactor: Reactor){
        // MARK: - Action
        
        // MARK: - Bind
        self.bindCommon(reactor: reactor)
        self.bindTableView(reactor: reactor)
    }
}
