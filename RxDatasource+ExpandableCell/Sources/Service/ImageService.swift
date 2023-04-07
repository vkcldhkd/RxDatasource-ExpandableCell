//
//  ImageService.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import RxSwift
import Codextended

struct ImageService {
    static func getImageList(
        page: Int = 1,
        limit: Int = 20
    ) -> Observable<[ImageListItem]?> {
        let base: String = "https://picsum.photos/v2/list"
        let appendQueryItems = URLHelper.createPageAndLimitParam(page: page, limit: limit)
        let path: String = URLHelper.createAbsolutePath(baseURL: base, queryItems: appendQueryItems)
        
        return NetworkManager.request(method: .get, requestURL: path)
            .map { response -> [ImageListItem]? in
                guard let response = response else { return nil }
                guard let dict = response.values.first as? [[String: Any]] else { return nil }
                return dict
                    .compactMap { $0.toData() }
                    .compactMap { try? $0.decoded() as ImageListItem }
            }
    }
}
