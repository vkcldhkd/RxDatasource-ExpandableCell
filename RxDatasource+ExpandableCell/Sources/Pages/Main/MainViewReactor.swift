//
//  MainViewReactor.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import ReactorKit
import RxSwift

final class MainViewReactor: Reactor {
    enum Action {
        case load
        case refresh
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setRefreshing(Bool)
        case setImageListResponse([ImageListItem]?)
    }
    
    struct State {
        var isLoading: Bool
        var isRefreshing: Bool
        var section: [ImageListSection]
    }
    
    let initialState: State
    
    init() {
        defer { _ = self.state }
        self.initialState = State(
            isLoading: false,
            isRefreshing: false,
            section: []
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setImageListResponse = ImageService.getImageList().map { Mutation.setImageListResponse($0) }
            return .concat([startLoading, setImageListResponse, endLoading])
            
        case .refresh:
            let startLoading = Observable<Mutation>.just(.setRefreshing(true))
            let endLoading = Observable<Mutation>.just(.setRefreshing(false))
            let setImageListResponse = ImageService.getImageList().map { Mutation.setImageListResponse($0) }
            return .concat([startLoading, setImageListResponse, endLoading])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            return newState

        case let .setRefreshing(isRefreshing):
            var newState = state
            newState.isRefreshing = isRefreshing
            return newState
            
        case let .setImageListResponse(response):
            var newState = state
            let sectionItems = self.createSectionItems(items: response)
            newState.section = [.list(sectionItems)]
            return newState

        }
    }
}

private extension MainViewReactor {
    func createSectionItems(
        items: [ImageListItem]?
    ) -> [ImageListSectionItem] {
        guard let items = items else { return [.empty] }
        return items
            .map { ImageItemViewReactor(model: $0) }
            .map { ImageListSectionItem.item($0) }
    }
}
