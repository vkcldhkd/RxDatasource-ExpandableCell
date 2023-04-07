//
//  ImageItemCell.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import UIKit

final class ImageItemCell: BaseTableViewCell {

    // MARK: - UI
    let itemView = ImageItemView()
    
    // MARK: - Initializing
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraints()
    }
}

extension ImageItemCell {
    // MARK: - setupUI
    func setupUI() {
        self.contentView.addSubview(self.itemView)
    }
    
    func setupConstraints() {
        self.itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


