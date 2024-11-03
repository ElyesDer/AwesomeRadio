//
//  Filters.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Filters {

    @ObservableState
    struct State: Equatable {
        var filters: [StationFilter]
        var selectedFilter: StationFilter?
    }

    @CasePathable
    enum Action {

        // MARK: Action Gesture
        case onTap(StationFilter)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .onTap(tappedFilter):
                if state.selectedFilter == tappedFilter {
                    state.selectedFilter = nil
                } else {
                    state.selectedFilter = tappedFilter
                }
                return .none
            }
        }
    }
}
