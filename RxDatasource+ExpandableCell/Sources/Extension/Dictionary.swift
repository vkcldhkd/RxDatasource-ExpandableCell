//
//  Dictionary.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//
import Foundation

extension Dictionary {
    func toData() -> Data?{
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}



