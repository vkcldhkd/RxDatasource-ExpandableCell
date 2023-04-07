//
//  ImageListSection.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import RxDataSources

enum ImageListSection {
    case list([ImageListSectionItem])
}

extension ImageListSection: SectionModelType {
    var items: [ImageListSectionItem] {
        switch self {
        case let .list(items): return items
        }
    }
    
    init(original: ImageListSection, items: [ImageListSectionItem]) {
        switch original {
        case .list: self = .list(items)
        }
    }
}

enum ImageListSectionItem {
    case empty
    case item(ImageItemViewReactor)
}
