//
//  StationDetails.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
struct StationDetails {

    @ObservableState
    struct State: Equatable, Identifiable {

        var id: String {
            station.id
        }

        var station: Station
    }

    // MARK: - Navigation State

    @CasePathable
    enum Action {

        // MARK: ViewLifecycle

        case onAppear

        // Go To Station Details
        case onTap

        case play
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
