//
//  ImageListResponse.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import Foundation

//typealias ImageListResponse = [ImageListItem]

// MARK: - ImageListResponse
struct ImageListItem: Codable, Equatable {
    let id: String?
    let author: String?
    let width, height: Int?
    let url, downloadURL: String?

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}

