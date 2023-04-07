//
//  NetworkManager.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//


import Alamofire
import Foundation
import RxAlamofire
import RxSwift


struct NetworkManager {
    static let shared: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource =  Constant.TIMEOUT_SECONDS
        configuration.timeoutIntervalForRequest = Constant.TIMEOUT_SECONDS
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
}


extension NetworkManager {
    static func request(
        method: HTTPMethod = .post,
        param: Parameters? = nil,
        requestURL: String
    ) -> Observable<[String: Any]?> {
        
        return NetworkManager.shared.rx
            .request(method, requestURL.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), parameters: param, encoding: JSONEncoding.default, headers: [:])
            .debug()
            .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .retry(3)
            .responseJSON()
            .map{ json -> [String: Any]? in
                print("\(#function) ")
                print("\n")
                print("TIME: \(Date())")
                print("PATH: \(requestURL)")
                print("PARAM: \(param ?? [:])")
                print("METHOD: \(method.rawValue)")
                print("STATUS CODE : \(json.response?.statusCode ?? 0 )")
                print("-----------------------------------------------------\n")
                
                switch json.result{
                case let .success(successJson):
                    print("\(#function) response \(successJson)")
                    if let resultJson = successJson as? [String: Any] {
                        return resultJson
                    } else {
                        return ["response": successJson]
                    }
                    
                case let .failure(error):
                    print("\(#function) requestURL \(requestURL)")
                    print("\(#function) error \(error)")
                    print("\(#function) json \(json)")
                    return ["error": error.localizedDescription]
                }
        }
    }
}

extension NetworkManager {
    static func checkParam(
        params: [String: Any?]
    ) -> [String: Any] {
        return params.filter { $0.value != nil } as [String : Any]
    }
}
