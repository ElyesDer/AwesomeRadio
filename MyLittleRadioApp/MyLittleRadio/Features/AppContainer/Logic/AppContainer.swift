//
//  AppContainer.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import ComposableArchitecture

// Handle Player and Global State
@Reducer
struct AppContainer {

    enum Tab {
        case stations, settings
    }

    @ObservableState
    struct State: Equatable {
        // Player should be SharedState
        var currentTab: Tab = .stations
        var stations: StationsFeature.State = .init()
    }

    @CasePathable
    enum Action {
        case stations(StationsFeature.Action)
        case selectTab(Tab)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectTab(tab):
                state.currentTab = tab
                return .none

            case .stations:
                return .none

            }
        }

        Scope(
            state: \.stations,
            action: \.stations
        ) {
            StationsFeature()
        }
    }
}
