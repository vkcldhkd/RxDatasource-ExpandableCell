//
//  ImageItemView.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import UIKit
import RxSwift
import ReactorKit
import RxKingfisher


final class ImageItemView: BaseView {
    // MARK: - Constants
    typealias Reactor = ImageItemViewReactor
    
    // MARK: - UI
    private lazy var containerView = UIStackView().then {
        $0.axis = .vertical
        $0.addArrangedSubview(self.imageView)
        $0.addArrangedSubview(self.bottomContainerView)
    }
    let imageView: UIImageView = UIImageView()
    lazy var bottomContainerView: UIView = UIView().then {
        $0.isHidden = true
        $0.addSubview(self.authorLabel)
        $0.addSubview(self.sizeLabel)
        $0.backgroundColor = UIColor.black
    }
    let authorLabel: UILabel = UILabel().then {
        $0.textColor = .white
    }
    let sizeLabel: UILabel = UILabel().then {
        $0.textColor = .white
    }
    
    init() {
        super.init(frame: .zero)
        self.setupUI()
        self.setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageItemView {
    // MARK: - setupUI
    func setupUI() {
        self.addSubview(self.containerView)
    }
    
    func setupConstraints() {
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        self.bottomContainerView.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        self.authorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        self.sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.authorLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(12)
        }
    }
}

extension ImageItemView: ReactorKit.View {
    func bind(reactor: Reactor){
        // MARK: - Action
        
        // MARK: - State
        reactor.state.map { $0.model.downloadURL }
            .distinctUntilChanged()
            .compactMap { URLHelper.createEncodedURL(url: $0) }
            .bind(to: self.imageView.kf.rx.image())
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.model.author }
            .distinctUntilChanged()
            .bind(to: self.authorLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        
        Observable.combineLatest(
            reactor.state.map { $0.model.width }
                .distinctUntilChanged(),
            reactor.state.map { $0.model.height }
                .distinctUntilChanged()
        )
        .map { "\($0.0 ?? 0) : \($0.1 ?? 0)" }
        .distinctUntilChanged()
        .bind(to: self.sizeLabel.rx.text)
        .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isExpanded }
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: self.bottomContainerView.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
}
