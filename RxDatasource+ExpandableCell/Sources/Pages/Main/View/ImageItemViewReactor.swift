//
//  ImageItemViewReactor.swift
//  RxDatasource+ExpandableCell
//
//  Created by 성 현 on 2023/04/07.
//

import ReactorKit
import RxSwift

final class ImageItemViewReactor: Reactor {
    enum Action {
        case updateExpandedState
    }
    
    enum Mutation {
        case setExpandedState(Bool)
    }
    
    struct State {
        var model: ImageListItem
        var isExpanded: Bool
    }
    
    let initialState: State
    
    init(model: ImageListItem) {
        defer { _ = self.state }
        self.initialState = State(
            model: model,
            isExpanded: false
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateExpandedState:
            let setExpandedState = Observable<Mutation>.just(.setExpandedState(!self.currentState.isExpanded))
            return .concat([setExpandedState])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setExpandedState(isExpanded):
            var newState = state
            newState.isExpanded = isExpanded
            return newState
        }
    }
}
