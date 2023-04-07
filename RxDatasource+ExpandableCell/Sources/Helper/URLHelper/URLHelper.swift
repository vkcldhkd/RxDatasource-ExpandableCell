//
//  URLHelper.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import Foundation

struct URLHelper { }

extension URLHelper {
    static func createPageAndLimitParam(
        page: Int,
        limit: Int
    ) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
    }
    
    static func createAbsolutePath(
        baseURL: String,
        queryItems: [URLQueryItem]?
    ) -> String {
        return URLHelper.createPath(
            baseURL: baseURL,
            queryItems: queryItems
        ).absoluteString
    }
    
    static func createPath(
        baseURL: String,
        queryItems: [URLQueryItem]?
    ) -> URL {
        var components = URLComponents(string: baseURL)
        let totalQueryItems = (components?.queryItems ?? []) + (queryItems ?? [])
        components?.queryItems = totalQueryItems
        guard let url = components?.url else { return URL(string: baseURL)! }
        return url
    }
    
    static func createEncodedURL(url : String?) -> URL? {
        guard let url = url,
              url.count > 0,
              let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let returnURL = URL(string: encodedURL) else {
            print("url error!! \(url ?? "")")
            return nil
        }
        
        return returnURL
    }
}
